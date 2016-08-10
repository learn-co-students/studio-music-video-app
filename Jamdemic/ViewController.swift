//
//  ViewController.swift
//  Jamdemic
//
//  Created by Matt Amerige on 8/4/16.
//  Copyright © 2016 crocodile. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        SpotifyAPIOAuthClient.verifyAccessToken { (token) in
            print("yay I have a token: \(token)")
        }
        
        
    }

}

