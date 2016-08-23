//
//  AppAppearance.swift
//  Jamdemic
//
//  Created by Matt Amerige on 8/22/16.
//  Copyright © 2016 crocodile. All rights reserved.
//

import Foundation

class AppAppearance {
    
    class func setAppAppearance() {
        AppAppearance.setNavigationBarAppearance()
        AppAppearance.setBarButtonItemAppearance()
    }
    
    class func setNavigationBarAppearance() {
        UINavigationBar.appearance().titleTextAttributes = [NSFontAttributeName : UIFont.navigationBarTitleFont()]
        UINavigationBar.appearance().tintColor = UIColor.mainAppColor()
    }
    
    class func setBarButtonItemAppearance() {
        UIBarButtonItem.appearance().setTitleTextAttributes(
            [NSFontAttributeName: UIFont.navigationItemFont(),
            NSForegroundColorAttributeName: UIColor.mainAppColor()],forState: .Normal)
        
        UIBarButtonItem.appearance().setTitleTextAttributes([NSFontAttributeName: UIFont.navigationItemFont(),
            NSForegroundColorAttributeName: UIColor.lightGrayColor()], forState: .Disabled)
        
    }
    
    
}