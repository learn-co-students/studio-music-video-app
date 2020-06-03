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
class SignInViewController: UIViewController, GIDSignInDelegate {
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        print("log in")
    }
    
    
    
    @IBOutlet weak var anonymousLoginButton: UIButton!
    
    
    var backgroundPlayer : BackgroundVideo? // Declare an instance of BackgroundVideo called backgroundPlayer
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        UIApplication.shared.statusBarStyle = .lightContent
        
        GIDSignIn.sharedInstance().delegate = self
        
        
        setUpBackgroundVideo()
        
        // Register for notifications
        NotificationCenter.default.addObserver(self, selector: #selector(userDidSignIn), name: NSNotification.Name(rawValue: Notifications.userDidLogIn), object: nil)
        
        UserDefaults.standard.set(true, forKey: "ViewedStartPage")
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.default
    }
    
    @objc func userDidSignIn() {
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func anonymousLoginDidTapped(sender: AnyObject) {
       self.dismiss(animated: true, completion: nil)
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
