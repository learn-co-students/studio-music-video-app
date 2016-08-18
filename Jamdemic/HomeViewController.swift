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

    let notification = CWStatusBarNotification()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        GIDSignIn.sharedInstance().signInSilently()
        
        registerNotifications()
    }
    
    func registerNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(networkUnavailable), name: Notifications.networkUnavailable, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(networkAvailable), name: Notifications.networkAvailable, object: nil)
    }
    
    func networkUnavailable() {
        self.notification.notificationLabelBackgroundColor = UIColor.redColor()
        
        let notificationFont = UIFont.systemFontOfSize(15)
        
        self.notification.notificationLabelFont = notificationFont
        self.notification.displayNotificationWithMessage("No Internet Connection") {}
    }
    
    func networkAvailable() {
        self.notification.dismissNotificationWithCompletion { 
            let connectedNotification = CWStatusBarNotification()
            connectedNotification.notificationLabelBackgroundColor = UIColor.greenColor()
            connectedNotification.notificationLabelTextColor = UIColor.blackColor()
             let notificationFont = UIFont.systemFontOfSize(15)
            connectedNotification.notificationLabelFont = notificationFont
            connectedNotification.displayNotificationWithMessage("Connected!", forDuration: 2.0)
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        checkCurrentUser()
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
