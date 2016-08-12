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
        } else {
            // take use to initial logged-in screen
//            performSegueWithIdentifier(Constants.Segues.SignInToInitialView, sender: nil)
            presentViewController((InitialLoggedInViewController as? UIViewController), animated: true, completion: nil)
            
        }
    }
    
    
    @IBAction func didTapSignOut(sender: AnyObject) {
        try! FIRAuth.auth()!.signOut()
    }

}
