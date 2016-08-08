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
        SpotifyAPIOAuthClient.refreshSpotifyAccessToken { (token) in
            
        }
    }

}

