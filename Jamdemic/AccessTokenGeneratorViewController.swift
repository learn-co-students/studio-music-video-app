//
//  AccessTokenGeneratorViewController.swift
//  Jamdemic
//
//  Created by Matt Amerige on 8/8/16.
//  Copyright © 2016 crocodile. All rights reserved.
//

import UIKit
import SafariServices

/**
 Use this class to generate an access token for the first time
 */
class AccessTokenGeneratorViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleCallback), name: NSNotification.Name(rawValue: Notifications.receivedSpotifyCode), object: nil)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        guard let url = NSURL(string: SpotifyAPIOAuthClient.URLRouter.oauth) else { fatalError("Unable to create url") }
        
        let safariVC = SFSafariViewController(url: url as URL)
        present(safariVC, animated: true, completion: nil)
        
    }
    
    @objc func handleCallback(notification: NSNotification) {
        self.presentedViewController?.dismiss(animated: true, completion: nil)
//        guard let url = notification.object as? NSURL else { fatalError("unable to unwrap notification object") }
        // Start request for token using the code. This is set to private for normal use so no one accidentally calls it.
//        SpotifyAPIOAuthClient.startSpotifyAccessTokenRequest(withURL: url)
    }
}
