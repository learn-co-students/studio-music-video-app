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
    
    override func viewWillAppear(animated: Bool) {
        checkCurrentUser()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    

    func checkCurrentUser() {
        
        if FIRAuth.auth()?.currentUser == nil {
            // show a login screen
            performSegueWithIdentifier("showLogin", sender: nil)
        }
    }

}
