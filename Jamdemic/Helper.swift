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
        
        Auth.auth().signInAnonymously(completion: { (anonymousUser, error) in
            //(anonymousUser:User?, error: NSError?) in
            if error == nil {
                print("UserID: \(anonymousUser!.user.uid)")
                
                
                let newUser = Database.database().reference().child("users").child(anonymousUser!.user.uid)
                newUser.setValue(["displayname" : "Anonymous", "id" : "\(anonymousUser!.user.uid)", "profileUrl": ""])
                
                self.switchToNavigationViewController()
                
                
                self.switchToNavigationViewController()
            } else {
                print(error?.localizedDescription)
                return
            }
        })
    }
    
    func loginWithGoogle(authentication: GIDAuthentication) {
        
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                                     accessToken: authentication.accessToken)
        
        Auth.auth().signIn(with: credential, completion:{ (user , error) in
            //{ (user: User?, error: NSError?) in
            if let error = error {
                print(error.localizedDescription)
                return
            } else {
                print(user?.user.email! )
                print(user?.user.displayName!)
                print(user?.user.photoURL!)
                
                let newUser = Database.database().reference().child("users").child((user?.user.uid)!)
                newUser.setValue(["displayname" : "\(user!.user.displayName)", "id" : "\(user!.user.uid)", "profileUrl": "\(user!.user.photoURL!)"])
                
                self.switchToNavigationViewController()
            }
        })
    }
    
    func switchToNavigationViewController() {
        let storyboard = UIStoryboard(name: "GoogleSignIn", bundle: nil)
        let navVC = storyboard.instantiateViewController(withIdentifier: "GenreStoryBoard")
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = navVC
    }
    
    
    
}
