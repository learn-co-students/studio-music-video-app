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
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.font : UIFont.navigationBarTitleFont()]
        UINavigationBar.appearance().tintColor = UIColor.mainAppColor()
    }
    
    class func setBarButtonItemAppearance() {
        UIBarButtonItem.appearance().setTitleTextAttributes(
            [NSAttributedString.Key.font: UIFont.navigationItemFont(),
             NSAttributedString.Key.foregroundColor: UIColor.mainAppColor()],for: .normal)
        
        UIBarButtonItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font: UIFont.navigationItemFont(),
                                                             NSAttributedString.Key.foregroundColor: UIColor.lightGray], for: .disabled)
        
    }
    
    
}
