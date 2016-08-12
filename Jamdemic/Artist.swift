//
//  Artist.swift
//  Jamdemic
//
//  Created by Ismael Barry on 8/10/16.
//  Copyright © 2016 crocodile. All rights reserved.
//

import Foundation

class Artist {
    
    let name : String
    
    let spotifyID : String
    
    init(name : String, spotifyID : String) {
        
        self.name = name
        
        self.spotifyID = spotifyID
        
    }
    
    func description() {
        
        print("Artist name: \(self.name) -- SpotifyID: \(self.spotifyID)\n")
        
    }
}