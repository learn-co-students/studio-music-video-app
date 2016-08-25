//
//  SpotifyAPIOAuthClient.swift
//  Jamdemic
//
//  Created by Matt Amerige on 8/8/16.
//  Copyright © 2016 crocodile. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import Firebase

struct SpotifyAPIOAuthClient {
    
    static let encodedRedirectURI = "jamdemicApp%3A%2F%2F"
    
    enum URLRouter {
        static let token = "https://accounts.spotify.com/api/token"
        static let oauth = "https://accounts.spotify.com/authorize?client_id=\(Secrets.clientID)&response_type=code&redirect_uri=\(SpotifyAPIOAuthClient.encodedRedirectURI)"
    }
    
    /**
     Sends a **POST** request to https://accounts.spotify.com/api/token for an access token and refresh token
     
     - note: We should not need to use this method in the actual production flow. I wrote it just to easily generate an access/refresh token.
     All requests to update an expired access token should use the refreshSpotifyAccessToken method below.
     
     - parameters:
     - url: URL received in the callback after authorization. Should include the code to make an access token request.
     */
    private static func startSpotifyAccessTokenRequest(withURL url: NSURL) {
        print("starting request..")
        
        // Setting up all the info we need to make the post request..
        guard let code = url.getQueryItemValue(named: "code") else { fatalError("Unable to parse url") }
        print("code: \(code)")
        
        // Encoding the clientID:Secret string into base 64 as specified by the spotify docs.
        // more info: https://developer.spotify.com/web-api/authorization-guide/#authorization-code-flow
        let combinedString = Secrets.clientID + ":" + Secrets.clientSecret
        guard let combinedEncodedString = combinedString.base64EncodedString else { fatalError("unable to encode string") }
        
        let parameters = [
            "grant_type" : "authorization_code",
            "code" : code,
            "redirect_uri" : SpotifyAPIOAuthClient.encodedRedirectURI
        ]
        
        // Authorization: Basic <base64 encoded client_id:client_secret>
        let headers = [
            "Authorization" : "Basic \(combinedEncodedString)"
        ]
        
        
        Alamofire.request(.POST, SpotifyAPIOAuthClient.URLRouter.token, parameters: parameters, encoding: .URL, headers: headers).responseJSON { (response) in
            print(response.result.value)
        }
        
    }
    
    
    /**
     Refreshes an expired access token by sending a **POST** request to https://accounts.spotify.com/api/token along with a valid refresh token
     */
    private static func refreshSpotifyAccessToken(completed: (String?) -> ()) {
        
        let parameters = [
            "grant_type" : "refresh_token",
            "refresh_token" : Secrets.spotifyRefreshToken
        ]
        guard let combinedEncodedString = (Secrets.clientID + ":" + Secrets.clientSecret).base64EncodedString else {
            print("unable to base64 encode string")
            completed(nil)
            return
        }
        let headers = [
            "Authorization" : "Basic \(combinedEncodedString)"
        ]
        
        Alamofire.request(.POST, SpotifyAPIOAuthClient.URLRouter.token, parameters: parameters, encoding: .URL, headers: headers).responseJSON { (response) in
            print("New access token info: \(response.result.value)")
            
            if let value = response.result.value {
                let json = JSON(value)
                
                guard let token = json["access_token"].string else {
                    fatalError("Unable to unwrap access token")
                }
                
                SpotifyAPIOAuthClient.saveTokenToFirebase(token)
                
                completed(token)
            }
            else {
                print("Unable to unwrap value from JSON response")
                completed(nil)
            }
        }
    }
    
    /** Saves the specified token to Firebase */
    private static func saveTokenToFirebase(token: String) {
        let databaseReference = FIRDatabase.database().referenceWithPath("/private_tokens").child("spotify_access_token")
        databaseReference.setValue(token) { (error, reference) in
            if error == nil {
                print("successfully saved token to Firebase at reference: \(reference)")
            }
            else {
                print("Error saving token to Firebase: \(error?.localizedDescription)")
            }
        }
    }
    
    /**
     Loads the current Spotify access token from the Firebase Database.
     
     If the current access token returned in the completion block
     has expired use the refreshSpotifyAccessToken method for a new token.
     
     - parameters:
     - completion: A completion block that passes back the access token stored on Firebase
     */
    private static func loadSpotifyAccessToken(completion: (String?)->() ) {
        let tokenReference = FIRDatabase.database().referenceWithPath("/private_tokens/spotify_access_token")
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        if !appDelegate.isReachable() {
            completion(nil)
        }
        else {
            tokenReference.observeEventType(.Value) { (snapshot: FIRDataSnapshot) in
                let token = snapshot.value as? String
                print("Retrived token from Firebase: \(token)")
                // Observers need to be removed, otherwise they continue to sync data
                tokenReference.removeAllObservers()
                completion(token)
            }
        }
    }

    
    /**
     Verifies the validity of the current access token hosted on Firebase
     
     - important: Use this function before making any API calls to Spotify to ensure you have a valid access token.
     */
    static func verifyAccessToken( success: String -> Void, failure: NSError -> Void) {
        
        // Block to make a limited request to the Spotify API using the current access token loaded from Firebase
        let oauthTestTask: (oauthSuccess: String -> Void, oauthfailure: NSError -> Void) -> Void = {oauthSuccess, oauthFailure in
            SpotifyAPIOAuthClient.loadSpotifyAccessToken({ (token) in
                guard let token = token else {
                    print("Unable to unwrap token")
                    let error = NSError(domain: "CannotLoadFirebaseToken", code: 1984, userInfo: nil)
                    oauthFailure(error)
                    return
                }
                
                SpotifyAPIOAuthClient.tryAccessToken(token, completion: { (error) in
                    if let error = error {
                        oauthFailure(error)
                    }
                    else {
                        oauthSuccess(token)
                    }
                })
            })
        }
        
        SpotifyAPIOAuthClient.retry(
            3, task: oauthTestTask,
            success: { token in
                print("Access token validation successful")
                success(token)
            },
            failure: { error in
                print("Failed to validate access token. Error: \(error.localizedDescription)")
                failure(error)
        })
    }
    
    private static func tryAccessToken(token: String, completion:(NSError?) -> () ) {
        // Set up the parameters to get a list of categories. Limit set to 1 since we want a small request to test the token
        let parameters = ["limit": 1]
        let headers = ["Authorization" : "Bearer \(token)"]
        let baseURL = "https://api.spotify.com/v1/browse/categories"
        
        Alamofire.request(.GET, baseURL, parameters: parameters, encoding: .URL, headers: headers).validate().responseJSON(completionHandler: { (response) in
            switch response.result {
            case .Success:
                completion(nil)
            case .Failure(let error):
                // TODO: Test for the invalid token error
                // Refresh the token and report the failure
                SpotifyAPIOAuthClient.refreshSpotifyAccessToken({ (_) in
                    completion(error)
                })
            }
        })
    }
    
    /**
     Performs a task the specified number of times
     
     - parameter numberOfTimes: The number of times the task should be tried in the event of failure.
     - parameter task: A function whose only parameters are two closures -- one for success and one for failure. The success closure accepts a string and returns nothing. The failure closure accepts an NSError object and returns nothing.
    */
    private static func retry(numberOfTimes: Int, task: (success: String -> Void, failure: NSError -> Void) -> Void, success: String -> Void, failure: NSError -> Void) {
        task(success: { token in
                success(token)
            },
             failure: { error in
                // do we have retries left? if yes, call retry again
                // if not, report error
                if numberOfTimes > 1 {
                    self.retry(numberOfTimes - 1, task: task, success: success, failure: failure)
                } else {
                    failure(error)
                }
        })
    }
}


