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
    
    
    
    private func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
      
        
        FirebaseApp.configure()
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        GIDSignIn.sharedInstance().delegate = self
        
        setupReachability()
        
        AppAppearance.setAppAppearance()
        
        return true
        
  
    }
    
    @available(iOS 9.0, *)
    func application(_ application: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any])
     -> Bool {
        
        return GIDSignIn.sharedInstance().handle(url)
//                                                    sourceApplication: options[UIApplicationOpenURLOptionsSourceApplicationKey] as? String,
//                                                    annotation: options[UIApplicationOpenURLOptionsAnnotationKey])
//return GIDSignIn.sharedInstance().handle(url, sourceApplication:options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String
//                            annotation: [:])
    }

    
    private func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }
    
    private func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    private func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }
    
    private func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        postAlertForInitialNetworkStatus()
    }
    
    private func applicationWillTerminate(application: UIApplication) {
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
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            print(error.localizedDescription)
            return
    }
    
        guard let authentication = user.authentication else { return }
        guard let accessToken = authentication.accessToken else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                                  accessToken: accessToken )
        
        Auth.auth().signIn(with: credential) { (user, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            print("Successfully signed in")
    
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: Notifications.userDidLogIn), object: nil)
            
        }

    }
}


// MARK: Reachability
extension AppDelegate {
    
    func setupReachability() {
        // Allocate a reachability object
        self.reach = Reachability.forInternetConnection()
        
        // Tell the reachability that we DON'T want to be reachable on 3G/EDGE/CDMA
        self.reach!.reachableOnWWAN = false
        
        // Here we set up a NSNotification observer. The Reachability that caused the notification
        // is passed in the object parameter
        NotificationCenter.default.addObserver(self,
                                                         selector: #selector(reachabilityChanged),
                                                         name: NSNotification.Name.reachabilityChanged,
                                                         object: nil)
    
        
        self.reach!.startNotifier()
        
        postAlertForInitialNetworkStatus()
    }
    
    @objc func reachabilityChanged() {
        if self.reach!.isReachableViaWiFi() || self.reach!.isReachableViaWWAN() {
            print("Service avalaible!!!")
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: Notifications.networkAvailable), object: nil)
        } else {
            print("No service avalaible!!!")
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: Notifications.networkUnavailable), object: nil)
        }
    }
    
    func postAlertForInitialNetworkStatus() {
        if !isReachable() {
            print("No service avalaible!!!")
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: Notifications.networkUnavailable), object: nil)
        }
        else {
            print("Service avalaible!!!")
        }
    }
    
    func isReachable() -> Bool {
        if self.reach!.isReachableViaWWAN() || self.reach!.isReachableViaWiFi() {
            return true
        }
        return false
    }
    
}


