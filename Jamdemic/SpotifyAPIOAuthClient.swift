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
    static func startSpotifyAccessTokenRequest(withURL url: NSURL) {
        print("starting request..")
        
        // Setting up all the info we need to make the post request..
        guard let code = url.getQueryItemValue(named: "code") else { fatalError("Unable to parse url") }
        print("code: \(code)")
        
        // Encoding the clientID:Secret string into base 64 as specified by the spotify docs.
        // more info: https://developer.spotify.com/web-api/authorization-guide/#authorization-code-flow
        let combinedString = Secrets.clientID + ":" + Secrets.clientSecret
        let utf8String = combinedString.dataUsingEncoding(NSUTF8StringEncoding)
        guard let encodedString = utf8String?.base64EncodedStringWithOptions(NSDataBase64EncodingOptions(rawValue: 0)) else { fatalError("Unable to encode string") }
        
        let parameters = [
            "grant_type" : "authorization_code",
            "code" : code,
            "redirect_uri" : SpotifyAPIOAuthClient.encodedRedirectURI
        ]
        
        // Authorization: Basic <base64 encoded client_id:client_secret>
        let headers = [
            "Authorization" : "Basic \(encodedString)"
        ]
    
        
        Alamofire.request(.POST, SpotifyAPIOAuthClient.URLRouter.token, parameters: parameters, encoding: .URL, headers: headers).responseJSON { (response) in
            print(response.result.value)
        }
        
    }
    
    
    /**
     Refreshes an expired access token by sending a **POST** request to https://accounts.spotify.com/api/token along with a valid refresh token
    */
    static func refreshSpotifyAccessToken() {
        let parameters = [
            "grant_type" : "refresh_token",
            "refresh_token" : Secrets.spotifyRefreshToken
        ]
        guard let combinedEncodedString = (Secrets.clientID + ":" + Secrets.clientSecret).base64EncodedString else {
            print("unable to base64 encode string")
            return
        }
        let headers = [
            "Authorization" : "Basic \(combinedEncodedString)"
        ]
    }
    
    
    
}








