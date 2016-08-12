//
//  SignInViewController.swift
//  Jamdemic
//
//  Created by Ugowe on 8/11/16.
//  Copyright © 2016 crocodile. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn

@objc(SignInViewController)
class SignInViewController: UIViewController, GIDSignInDelegate, GIDSignInUIDelegate {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var googleSignInButton: GIDSignInButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().delegate = self
        
        // Uncomment to automatically sign in the user.
        //GIDSignIn.sharedInstance().signInSilently()
        
        // TODO(developer) Configure the sign-in button look/feel
        
        // If the user is an authenticated Firebase user, then sign them in
        if let user = FIRAuth.auth()?.currentUser {
            self.signedIn(user)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func signIn(signIn: GIDSignIn!, didSignInForUser user: GIDGoogleUser!, withError error: NSError?) {
        
        if let error = error {
            print(error.localizedDescription)
            return
        }
        
        let authentication = user.authentication
        let credential = FIRGoogleAuthProvider.credentialWithIDToken(authentication.idToken,
                                                                     accessToken: authentication.accessToken)
        
        FIRAuth.auth()?.signInWithCredential(credential) { (user, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            print("Successfully signed in")
            self.setDisplayName(user!)
        }
    }
    
    @IBAction func didTapCreateAccount(sender: AnyObject) {
        
        // Create a new user
        let email = emailTextField.text
        let password = passwordTextField.text
        
        FIRAuth.auth()?.createUserWithEmail(email!, password: password!, completion: { (user, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            self.setDisplayName(user!)
        })
        
    }
    
    
    @IBAction func didTapSignIn(sender: AnyObject) {
        // Sign In with credentials.
        let email = emailTextField.text
        let password = passwordTextField.text
        
        FIRAuth.auth()?.signInWithEmail(email!, password: password!, completion: { (user, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            self.setDisplayName(user!)
            
        })
    }
    
    
    @IBAction func didRequestPasswordReset(sender: AnyObject) {
        let prompt = UIAlertController.init(title: nil, message: "Bitch, Insert New Email:", preferredStyle: UIAlertControllerStyle.Alert)
        let cancelAction = UIAlertAction.init(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil)
        let okAction = UIAlertAction.init(title: "OK", style: UIAlertActionStyle.Default) { (action) in
            let userInput = prompt.textFields![0].text
            if (userInput!.isEmpty) {
                return
            }
            FIRAuth.auth()?.sendPasswordResetWithEmail(userInput!, completion: { (error) in
                if let error = error {
                    print(error.localizedDescription)
                    return
                }
            })
        }
        prompt.addTextFieldWithConfigurationHandler(nil)
        prompt.addAction(cancelAction)
        prompt.addAction(okAction)
        presentViewController(prompt, animated: true, completion: nil)
    }
    
    func setDisplayName(user: FIRUser?) {
        
        // Info on FIRUserProfileChangeRequest http://bit.ly/2bgRkjX
        let changeRequest = user?.profileChangeRequest()
        changeRequest?.displayName = user?.email!.componentsSeparatedByString("@")[0]
        changeRequest?.commitChangesWithCompletion(){ (error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            self.signedIn(FIRAuth.auth()?.currentUser)
        }
    }
    
    func signedIn(user: FIRUser?) {
        MeasurementHelper.sendLoginEvent()
        
        AppState.sharedInstance.displayName = user?.displayName ?? user?.email
        AppState.sharedInstance.photoUrl = user?.photoURL
        AppState.sharedInstance.signedIn = true
        NSNotificationCenter.defaultCenter().postNotificationName(Constants.NotificationKeys.SignedIn, object: nil, userInfo: nil)
        performSegueWithIdentifier(Constants.Segues.SignInToInitialView, sender: nil)
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}
