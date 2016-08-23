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
class SignInViewController: UIViewController, GIDSignInUIDelegate, GIDSignInDelegate {
    
    @IBOutlet weak var anonymousLoginButton: UIButton!

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        makeAnonymousButtonBorder()
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().delegate = self
        
        // Register for notifications
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(userDidSignIn), name: Notifications.userDidLogIn, object: nil)
        
        // Uncomment to automatically sign in the user.
        //GIDSignIn.sharedInstance().signInSilently()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        // Keeps track of the authentication status
        FIRAuth.auth()?.addAuthStateDidChangeListener({ (auth: FIRAuth, user: FIRUser?) in
            if let user = user {
                print(user)
                Helper.helper.switchToNavigationViewController()
            } else {
                print("Unauthorized")
            }
        })

    }
    
    // The sign-in flow has finished and was successful if |error| is |nil|.
    func signIn(signIn: GIDSignIn!, didSignInForUser user: GIDGoogleUser!, withError error: NSError!) {
        if let error = error {
            print(error.localizedDescription)
            return
        }
        print(user.authentication)
        Helper.helper.loginWithGoogle(user.authentication)
    }
    
    
    func userDidSignIn() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    func makeAnonymousButtonBorder() {
        anonymousLoginButton.layer.borderWidth = 1.0
        anonymousLoginButton.layer.borderColor = UIColor.whiteColor().CGColor
    }
    
    
    @IBAction func anonymousLoginDidTapped(sender: AnyObject) {
        Helper.helper.anonymousLogin()
    }
    
    
    @IBAction func googleSignInDidTapped(sender: AnyObject) {
        GIDSignIn.sharedInstance().signIn()
    }

    
    
}
