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
        GIDSignIn.sharedInstance()?.signIn()
        //signInSilently()
        

        
        registerNotifications()
    }
    
    func registerNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(networkUnavailable), name: NSNotification.Name(rawValue: Notifications.networkUnavailable), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(networkAvailable), name: NSNotification.Name(rawValue: Notifications.networkAvailable), object: nil)
    }
    
    @objc func networkUnavailable() {
        self.notification.notificationLabelBackgroundColor = UIColor.red
        
        let notificationFont = UIFont.systemFont(ofSize: 15)
        
        self.notification.notificationLabelFont = notificationFont
        self.notification.displayNotificationWithMessage(message: "No Internet Connection") {}
    }
    
    @objc func networkAvailable() {
        self.notification.dismissNotificationWithCompletion { 
            let connectedNotification = CWStatusBarNotification()
            connectedNotification.notificationLabelBackgroundColor = UIColor.green
            connectedNotification.notificationLabelTextColor = UIColor.black
            let notificationFont = UIFont.systemFont(ofSize: 15)
            connectedNotification.notificationLabelFont = notificationFont
            connectedNotification.displayNotificationWithMessage(message: "Connected!", forDuration: 2.0)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        checkCurrentUser()
    }

    
    

    func checkCurrentUser() {
        
        if Auth.auth().currentUser == nil {
            // take user to login screen
            performSegue(withIdentifier: Constants.Segues.ShowLogin, sender: nil)
        }

    }
    
    


}
