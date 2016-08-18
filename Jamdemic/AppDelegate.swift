//
//  AppDelegate.swift
//  Jamdemic
//
//  Created by Matt Amerige on 8/4/16.
//  Copyright © 2016 crocodile. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    var reach: Reachability?
    
    
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        
        FIRApp.configure()
        GIDSignIn.sharedInstance().clientID = FIRApp.defaultApp()?.options.clientID
        GIDSignIn.sharedInstance().delegate = self
        
        setupReachability()
        
        return true
        
  
    }
    
    func application(application: UIApplication,
                     openURL url: NSURL, options: [String: AnyObject]) -> Bool {
        
        return GIDSignIn.sharedInstance().handleURL(url,
                                                    sourceApplication: options[UIApplicationOpenURLOptionsSourceApplicationKey] as? String,
                                                    annotation: options[UIApplicationOpenURLOptionsAnnotationKey])
    }
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    /**
     Uncomment the below method to generate an access token for the first time
     */
    //    func application(app: UIApplication, openURL url: NSURL, options: [String : AnyObject]) -> Bool {
    //
    //        guard let sourceBundleID = options[UIApplicationOpenURLOptionsSourceApplicationKey] as? String else { return false }
    //
    //        NSNotificationCenter.defaultCenter().postNotificationName("codeReceived", object: url)
    //        return sourceBundleID == "com.apple.SafariViewService"
    //    }
    
    

    
}

//MARK: Login
extension AppDelegate: GIDSignInDelegate {
    
    func signIn(signIn: GIDSignIn!, didSignInForUser user: GIDGoogleUser!, withError error: NSError!) {
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
    
            NSNotificationCenter.defaultCenter().postNotificationName(Notifications.userDidLogIn, object: nil)
            
        }

    }
}


// MARK: Reachability
extension AppDelegate {
    
    func setupReachability() {
        // Allocate a reachability object
        self.reach = Reachability.reachabilityForInternetConnection()
        
        // Tell the reachability that we DON'T want to be reachable on 3G/EDGE/CDMA
        self.reach!.reachableOnWWAN = false
        
        // Here we set up a NSNotification observer. The Reachability that caused the notification
        // is passed in the object parameter
        NSNotificationCenter.defaultCenter().addObserver(self,
                                                         selector: #selector(reachabilityChanged),
                                                         name: kReachabilityChangedNotification,
                                                         object: nil)
        
        self.reach!.startNotifier()
    }
    
    func reachabilityChanged() {
        if self.reach!.isReachableViaWiFi() || self.reach!.isReachableViaWWAN() {
            print("Service avalaible!!!")
            NSNotificationCenter.defaultCenter().postNotificationName(Notifications.networkAvailable, object: nil)
        } else {
            print("No service avalaible!!!")
            NSNotificationCenter.defaultCenter().postNotificationName(Notifications.networkUnavailable, object: nil)
        }
    }
    
    func isReachable() -> Bool {
        if self.reach!.isReachableViaWWAN() || self.reach!.isReachableViaWiFi() {
            return true
        }
        return false
    }
    
}


