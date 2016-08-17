//
//  Artist.swift
//  Jamdemic
//
//  Created by Ismael Barry on 8/10/16.
//  Copyright © 2016 crocodile. All rights reserved.
//

import Foundation

// Artist Class that defines parameters coming back from Spotify API.
class Artist {
    
    // Name of artist that we get from Spotify API.
    let name : String
    
    // SpotifyID of artist that we get from Spotify API.
    let spotifyID : String
    
    // Album artwork of artist that we get from Spotify API.
    let artistAlbumArtwork : String
    
    // Picture of artist that we get from Spotify API.
    let artistArtworkURLString : String
    
    init(name : String, spotifyID : String, artistAlbumArtwork : String, artistArtworkURLString : String) {
        
        self.name = name
        
        self.spotifyID = spotifyID
        
        self.artistAlbumArtwork = artistAlbumArtwork
        
        self.artistArtworkURLString = artistArtworkURLString
    }
    
    func description() {
        
        print("Artist name: \(self.name) -- SpotifyID: \(self.spotifyID)\n")
    }
}