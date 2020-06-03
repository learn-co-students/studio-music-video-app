//
//  Extensions.swift
//  GitHubOAuth
//
//  Created by Joel Bell on 7/31/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import Foundation

extension NSURL {
    
    func getQueryItemValue(named name: String) -> String? {
        
        let components = NSURLComponents(url: self as URL, resolvingAgainstBaseURL: false)
        let query = components?.queryItems
        return query?.filter({$0.name == name}).first?.value
        
    }
    
}


extension String {
    var base64EncodedString: String? {
        let utf8Data = self.data(using: .utf8)
        let encodedString = utf8Data?.base64EncodedString(options: .init(rawValue: 0))
        return encodedString
    }
}

extension Array {
    
    func contains<T>(obj: T) -> Bool where T : Equatable {
        return self.filter({ $0 as? T == obj}).count > 0
    }
}

extension UIColor {
    class func mainAppColor() -> UIColor {
        return UIColor(red: 250/255, green: 37/255, blue: 82/255, alpha: 1)
    }
    
}

extension UIFont {
    
    class func navigationBarTitleFont() -> UIFont {
        return UIFont(name: "Avenir Next", size: 20)!
    }
    
    class func navigationItemFont() -> UIFont {
        return UIFont(name: "Avenir Next", size: 16)!
    }

    class func bodyFont() -> UIFont {
        return UIFont(name: "Avenir Next", size: 14)!
    }
}
