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
    
    // Used as a unique identifier for KVO on the moviePlayer.contentURL
    private static var myContext = 0
    
    var videoIDs: [String] = []
    var currentVideoIndex = 0
    
    var videoPlayerViewController: XCDYouTubeVideoPlayerViewController!
    
    deinit {
        self.videoPlayerViewController.removeObserver(self, forKeyPath: "moviePlayer.contentURL", context: &VideoPlayerViewController.myContext)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: MPMoviePlayerPlaybackDidFinishNotification, object: self.videoPlayerViewController.moviePlayer)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        playVideos()
    }
    
    func playVideos() {
        videoPlayerViewController = XCDYouTubeVideoPlayerViewController(videoIdentifier: videoIDs[currentVideoIndex])
        videoPlayerViewController.presentInView(self.view)
        registerNotifications()
        self.videoPlayerViewController.addObserver(self, forKeyPath: "moviePlayer.contentURL", options: [], context: &VideoPlayerViewController.myContext)
        videoPlayerViewController.moviePlayer.play()
    }
    
    func moviePlayerPlaybackDidFinish(notification: NSNotification) {
        print("Playing number \(currentVideoIndex)")
        if hasNextVideo() {
            self.videoPlayerViewController.videoIdentifier = nextVideoIdentifier()
        }
    }
    
    func registerNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self,
                                                         selector: #selector(moviePlayerPlaybackDidFinish),
                                                         name: MPMoviePlayerPlaybackDidFinishNotification,
                                                         object: self.videoPlayerViewController.moviePlayer)
    }
    

    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if context == &VideoPlayerViewController.myContext {
            self.videoPlayerViewController.moviePlayer.play()
        }
        else {
            super.observeValueForKeyPath(keyPath, ofObject: object, change: change, context: context)
        }
    }
    
    func hasNextVideo() -> Bool {
        currentVideoIndex += 1
        return currentVideoIndex < videoIDs.count
    }
    
    func nextVideoIdentifier() -> String {
        return videoIDs[currentVideoIndex]
    }

    
}



