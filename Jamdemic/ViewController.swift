//
//  ViewController.swift
//  Jamdemic
//
//  Created by Matt Amerige on 8/4/16.
//  Copyright © 2016 crocodile. All rights reserved.
//

import UIKit
import SafariServices

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
//        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(handleCallback), name: Notifications.receivedSpotifyCode, object: nil)
        
    }
    
    override func viewDidAppear(animated: Bool) {
//        guard let url = NSURL(string: SpotifyAPIOAuthClient.URLRouter.oauth) else { fatalError("Unable to create url") }
//        
//        let safariVC = SFSafariViewController(URL: url)
//        presentViewController(safariVC, animated: true, completion: nil)
  
    }
    
//    func handleCallback(notification: NSNotification) {
//        guard let url = notification.object as? NSURL else { fatalError("unable to unwrap notification object") }
//        // Start request for token using the code
//        SpotifyAPIOAuthClient.startSpotifyAccessTokenRequest(withURL: url)
//    }


}

