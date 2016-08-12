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
    
   private var API_KEY: String = "AIzaSyByDaCLrNfiaF7a6i03JZZREtRcz9bHhBI"

    
    private var urlString: String = "https://www.googleapis.com/youtube/v3/search"
    
   
    
     private let channeId: String = "UC2pmfLm7iq6Ov1UwYrWYkZA"
    
    var searchArray = [Search]()
    
    //var type = ["channel", "video"]
    
    var delegate: SearchModelDelegate!
    
    
    
    func getSearches(index: Int, searchText: String) {
        
        Alamofire.request(.GET, urlString, parameters: ["key":API_KEY,"q": searchText, "type":"video", "part":"snippet"],encoding: ParameterEncoding.URL, headers: nil).responseJSON {(response) in
            
            if let jsonResult = response.result.value {
                
                let json = JSON(jsonResult)
                print(json)
                
//                var searchResult = [Search]()
                
//                for searchObj in (jsonResult["items"] as? NSArray)! {
//                    
//                    let search = Search()
//                
//                        
//                    search.searchchannelTitle = searchObj.valueForKeyPath("id.channelId.title") as! String
//                       search.searchvideoChannelID = searchObj.valueForKeyPath("snippet.channelId") as! String
//                     search.searchvideoId = searchObj.valueForKeyPath("id.videoId") as! String
//                    
//                    searchResult.append(searchObj as! Search)
//                   
//                    
//                }
//                self.searchArray = searchResult
//                if self.delegate != nil {
//                    self.delegate.dataAreReady()
//                print(self.searchArray)
//              
//                }
        
            }
            
            
            
        }
    

}

}

