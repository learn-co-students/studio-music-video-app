//
//  HomeViewController.swift
//  Jamdemic
//
//  Created by Ugowe on 8/12/16.
//  Copyright © 2016 crocodile. All rights reserved.
//

import UIKit
import Firebase

class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        GIDSignIn.sharedInstance().signInSilently()
    }
    
    override func viewDidAppear(animated: Bool) {
        checkCurrentUser()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    

    func checkCurrentUser() {
        
        if FIRAuth.auth()?.currentUser == nil {
            // take user to login screen
            performSegueWithIdentifier(Constants.Segues.ShowLogin, sender: nil)
        }

    }
    
    
    @IBAction func didTapSignOut(sender: AnyObject) {
        try! FIRAuth.auth()!.signOut()
        checkCurrentUser()
        GIDSignIn.sharedInstance().signOut()
        let firebaseAuth = FIRAuth.auth()
        do {
            try firebaseAuth?.signOut()
            AppState.sharedInstance.signedIn = false
//            self.dismissViewControllerAnimated(true, completion: nil)
        } catch let signOutError as NSError {
            print ("Error signing out: \(signOutError)")
        }
    }

}
