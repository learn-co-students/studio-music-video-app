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
    static func refreshSpotifyAccessToken(completed: (String?) -> ()) {
        
        // Ideally the access token will be updated on Firebase and will not be hardcoded into the Secrets file, so this is temporary for now
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
     
     This should be your first point of access token retrieval. If the current access token returned in the completion block
     has expired use the refreshSpotifyAccessToken method for a new token.
     
     - parameters:
     - completion: A completion block that passes back the access token stored on Firebase
     */
    static func loadSpotifyAccessToken(completion: (String?)->() ) {
        let tokenReference = FIRDatabase.database().referenceWithPath("/private_tokens/spotify_access_token")
        tokenReference.observeEventType(.Value) { (snapshot: FIRDataSnapshot) in
            let token = snapshot.value as? String
            print("Retrived token from Firebase: \(token)")
            // Observers need to be removed, otherwise they continue to sync data
            tokenReference.removeAllObservers()
            completion(token)
        }
    }
}








