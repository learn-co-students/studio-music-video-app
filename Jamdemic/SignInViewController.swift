//
//  SignInViewController.swift
//  Jamdemic
//
//  Created by Ugowe on 8/11/16.
//  Copyright © 2016 crocodile. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import GoogleSignIn

@objc(SignInViewController)
class SignInViewController: UIViewController, GIDSignInUIDelegate {
    
    @IBOutlet weak var anonymousLoginButton: UIButton!
    var backgroundPlayer : BackgroundVideo? // Declare an instance of BackgroundVideo called backgroundPlayer
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        GIDSignIn.sharedInstance().uiDelegate = self
        
        
        setUpBackgroundVideo()
        
        // Register for notifications
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(userDidSignIn), name: Notifications.userDidLogIn, object: nil)
        
        NSUserDefaults.standardUserDefaults().setBool(true, forKey: "ViewedStartPage")
    }
    
    
    func userDidSignIn() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func anonymousLoginDidTapped(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func googleSignInDidTapped(sender: AnyObject) {
        GIDSignIn.sharedInstance().signIn()
    }
    
    func setUpBackgroundVideo() {
        backgroundPlayer = BackgroundVideo(onViewController: self, withVideoURL: "SpinningRecord.mp4") // Passing self and video name with extension
        backgroundPlayer?.setUpBackground()
        // Do any additional setup after loading the view, typically from a nib.
    }
}
