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
        
        let components = NSURLComponents(URL: self, resolvingAgainstBaseURL: false)
        let query = components?.queryItems
        return query?.filter({$0.name == name}).first?.value
        
    }
    
}


extension String {
    var base64EncodedString: String? {
        let utf8Data = self.dataUsingEncoding(NSUTF8StringEncoding)
        let encodedString = utf8Data?.base64EncodedStringWithOptions(NSDataBase64EncodingOptions(rawValue: 0))
        return encodedString
    }
}

extension Array {
    
    func contains<T where T : Equatable>(obj: T) -> Bool {
        return self.filter({ $0 as? T == obj}).count > 0
    }
    
}