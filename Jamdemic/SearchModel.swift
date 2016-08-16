//
//  SearchModel.swift
//  Jamdemic
//
//  Created by Erica on 8/11/16.
//  Copyright © 2016 crocodile. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON




protocol SearchModelDelegate {
    func dataAreReady()
}

class SearchModel: NSObject {
    
    private static var API_KEY: String = "AIzaSyByDaCLrNfiaF7a6i03JZZREtRcz9bHhBI"
    
    
    private static var urlString: String = "https://www.googleapis.com/youtube/v3/search"
    
    //   private let channeId: String = "UC2pmfLm7iq6Ov1UwYrWYkZA"
    
    
    var searchArray = [Search]()
    
    //var type = ["channel", "video"]
    
    var delegate: SearchModelDelegate!
    
    
    
    class func getSearches(index: Int, searchText: String, completion: [String : String] -> Void) {
        
        Alamofire.request(.GET, SearchModel.urlString, parameters: ["key":SearchModel.API_KEY,"q": searchText, "type":"video", "part":"snippet"],encoding: ParameterEncoding.URL, headers: nil).responseJSON {(response) in
            
            if let jsonResult = response.result.value {
                
                let json = JSON(jsonResult)
                //  print(json)
                
                let searchVideoId = (json["items"][0]["id"]["videoId"].stringValue)
                let videoTitle = (json["items"][0]["snippet"]["title"].stringValue)
                let thumbnailUrl = (json["items"][0]["snippet"]["thumbnails"]["default"]["url"].stringValue)
                
                let resultsDictionary = [
                    "videoID" : searchVideoId,
                    "videoTitle" : videoTitle,
                    "thumbnailURLString" : thumbnailUrl
                ]
                
                var searchResultId:[String] = []
                searchResultId.append(searchVideoId)
                
                print (searchResultId)
                print(videoTitle)
                print(thumbnailUrl)
                
                if completion != nil {
                completion(resultsDictionary)
                    
                }else {
                    print("Error")
                }
                
                
                
            }
            
            
            
            
        }
        
        
        
    }
    
    
    
    
}

