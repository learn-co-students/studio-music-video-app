//
//  PlaylistDetailInfo.swift
//  Jamdemic
//
//  Created by Ismael Barry on 8/17/16.
//  Copyright © 2016 crocodile. All rights reserved.
//

import Foundation

// PlaylistDetailInfo Class that defines parameters going to the PlalistViewController.
class PlaylistDetailInfo {
    
    // Name of artist that we get from Spotify API.
    let name : String
    
    // Name of song title that we get from Spotify API.
    let songTitle : String
    
    // Name of Youtube ID That we get from Youtube API.
    let videoID : String
    
    // Name of thumbnailURLString that we get from Youtube API.
    let thumnailURLString : String
    
    init(name : String, songTitle : String, videoID : String, thumbnailURLString : String) {
        
        self.name = name
        
        self.songTitle = songTitle
        
        self.videoID = videoID
        
        self.thumnailURLString = thumbnailURLString
    }
}