//
//  PlaylistTestData.swift
//  Jamdemic
//
//  Created by Matt Amerige on 8/13/16.
//  Copyright © 2016 crocodile. All rights reserved.
//

import Foundation

class PlaylistTestData {
    let artistName: String
    let songName: String
    let thumbnailImage: UIImage
    
    init(name: String, songName: String, image: UIImage) {
        self.artistName = name
        self.songName = songName
        self.thumbnailImage = image
    }
}
