//
//  GenreInfo.swift
//  Jamdemic
//
//  Created by Matt Amerige on 8/19/16.
//  Copyright © 2016 crocodile. All rights reserved.
//

import Foundation

class GenreInfo {
    
    let displayTitle: String
    let spotifyTitle: String
    
    var isSelected: Bool = false
    
    let selectedImage: UIImage
    let deselectedImage: UIImage
    
    var displayImage: UIImage {
        return isSelected ? selectedImage : deselectedImage
    }
    
    init(displayTitle: String, spotifyTitle: String, selectedImage: UIImage, deselectedImage: UIImage) {
        self.displayTitle = displayTitle
        self.spotifyTitle = spotifyTitle
        self.selectedImage = selectedImage
        self.deselectedImage = deselectedImage
    }
    
}