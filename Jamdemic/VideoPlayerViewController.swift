//
//  VideoPlayerViewController.swift
//  Jamdemic
//
//  Created by Matt Amerige on 8/13/16.
//  Copyright © 2016 crocodile. All rights reserved.
//

import Foundation
import XCDYouTubeKit

class VideoPlayerViewController: UIViewController {
    
    var videoIDs: [String] = []
    
    var videoPlayerViewController: XCDYouTubeVideoPlayerViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        playVideos()
    }
    
    func playVideos() {
        self.videoPlayerViewController = XCDYouTubeVideoPlayerViewController(videoIdentifier: videoIDs[0])
        
        
        // non full screen
        videoPlayerViewController.presentInView(self.view)
        videoPlayerViewController.moviePlayer.play()
    }
    
    
}