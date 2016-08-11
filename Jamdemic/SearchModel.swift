//
//  SearchModel.swift
//  Jamdemic
//
//  Created by Erica on 8/11/16.
//  Copyright © 2016 crocodile. All rights reserved.
//

import UIKit
import Alamofire

class SearchModel: NSObject {
    
    private var API_KEY: String = "AIzaSyBNoNJfjXpt3yI4hvmRANPeExGU9CSUV6A"

    
    private var urlString: String = "https://www.googleapis.com/youtube/v3/search?part=id&channelId=UCU4qlPNKbtQxH3KEiy4_aIA&type=video&key=AIzaSyBNoNJfjXpt3yI4hvmRANPeExGU9CSUV6A"
    
     private let channeId: String = "UCU4qlPNKbtQxH3KEiy4_aIA"
    
    var searchArray = [Search]()
    
    
    
    func getSearches(index: Int, searchText: String) {
        
        Alamofire.request(.GET, urlString, parameters: ["key":API_KEY,"q": searchText, "type":"video", "part":"id"],encoding: ParameterEncoding.URL, headers: nil).responseJSON {(response) in
            
            if let jsonResult = response.result.value {
                var searchResult = [Search]()
                
                for searchObj in jsonResult["items"] as! NSArray {
                    
                    let search = Search()
                
                        
                       search.searchchannelTitle = searchObj.valueForKeyPath("id.channelId") as! String
                       search.searchvideoChannelID = searchObj.valueForKeyPath("id.channelId") as! String
                       search.searchvideoId = searchObj.valueForKeyPath("id.videoId") as! String
                    
                    searchResult.append(searchObj as! Search)
                    
                }
                self.searchArray = searchResult
            }
            
            
            
        }
    

}

}