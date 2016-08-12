//
//  VideoModel.swift
//  Jamdemic
//
//  Created by Erica on 8/11/16.
//  Copyright © 2016 crocodile. All rights reserved.
//

import UIKit
import Alamofire



protocol VideoModelDelegate {
    func VideosAreReady()
}

class VideoModel: NSObject {
    
    
    private var API_KEY: String = "AIzaSyDEsBB01SSKFvf9Ypx5wehcQ3V1PTTH3Uk"
    
    
    private var urlString: String = "https://www.googleapis.com/youtube/v3/videos"
    
    private let channeId: String = "UC2pmfLm7iq6Ov1UwYrWYkZA"
    
    private let playlistId = "PL9tY0BWXOZFvUX2cP4Dp_Ks7ZV8QNvymr"
    
    var listOfVideos = [Videos]()
    
    var delegate: VideoModelDelegate!
    
    
    
    func getVideos() {
        
        Alamofire.request(.GET, urlString, parameters: ["key":API_KEY,"maxResults":"10", "playlisId": playlistId, "part":"snippet"],encoding: ParameterEncoding.URL, headers: nil).responseJSON {(response) in
            
            if let jsonResult = response.result.value {
                var videosArray = [Videos]()
                
                for video in jsonResult["items"] as! NSArray{
                    
                    let videoList = Videos()
                    
                    
                    videoList.videoTitle = video.valueForKeyPath("snippet.title") as! String
                    videoList.videoID = video.valueForKeyPath("snippet.resourceId.videoId") as! String
                    videoList.videoDescription = video.valueForKeyPath("snippet.description") as! String
                    
                    videosArray.append(videoList)
                }
                self.listOfVideos = videosArray
                if self.delegate != nil {
                    self.delegate.VideosAreReady()
        
                    
                }
               
            }
            
            
           
        }
        
        
    }
    
    

}
