//
//  Helper.swift
//  Jamdemic
//
//  Created by Ugowe on 8/19/16.
//  Copyright © 2016 crocodile. All rights reserved.
//

import Foundation
import FirebaseAuth
import UIKit
import GoogleSignIn
import FirebaseDatabase

class Helper {
    static let helper = Helper()
    
    func anonymousLogin() {
        print("Anonymous Login Did Tapped")
        //Switch view by setting navigation controller as root view controller
        
        FIRAuth.auth()?.signInAnonymouslyWithCompletion({ (anonymousUser:FIRUser?, error: NSError?) in
            if error == nil {
                print("UserID: \(anonymousUser!.uid)")
                
                
                let newUser = FIRDatabase.database().reference().child("users").child(anonymousUser!.uid)
                newUser.setValue(["displayname" : "Anonymous", "id" : "\(anonymousUser!.uid)", "profileUrl": ""])
                
                self.switchToNavigationViewController()
                
                
                self.switchToNavigationViewController()
            } else {
                print(error?.localizedDescription)
                return
            }
        })
    }
    
    func loginWithGoogle(authentication: GIDAuthentication) {
        
        let credential = FIRGoogleAuthProvider.credentialWithIDToken(authentication.idToken,
                                                                     accessToken: authentication.accessToken)
        
        FIRAuth.auth()?.signInWithCredential(credential, completion: { (user: FIRUser?, error: NSError?) in
            if let error = error {
                print(error.localizedDescription)
                return
            } else {
                print(user?.email)
                print(user?.displayName)
                print(user?.photoURL)
                
                let newUser = FIRDatabase.database().reference().child("users").child(user!.uid)
                newUser.setValue(["displayname" : "\(user!.displayName)", "id" : "\(user!.uid)", "profileUrl": "\(user!.photoURL!)"])
                
                self.switchToNavigationViewController()
            }
        })
    }
    
    func switchToNavigationViewController() {
        let storyboard = UIStoryboard(name: "GoogleSignIn", bundle: nil)
        let navVC = storyboard.instantiateViewControllerWithIdentifier("GenreStoryBoard") 
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.window?.rootViewController = navVC
    }
    
    
    
}
