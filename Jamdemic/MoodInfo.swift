//
//  MoodInfo.swift
//  Jamdemic
//
//  Created by Matt Amerige on 8/19/16.
//  Copyright © 2016 crocodile. All rights reserved.
//

import Foundation

enum MoodType {
    case Acoustic, Trendy, Live, SlowDance, Energetic, Instrumental, Happy, Chill, Sad, Rage, Smooth, Reflective, Awake, Motivational, Chaotic, Sleepy, Active, Focused
}

class MoodInfo {
    
    let type: MoodType
    //AnyObject
    var attributes: [String : Any] {
        return attributesForMoodType()
    }
    
    var isSelected: Bool = false
    
    let selectedImage: UIImage
    let deselectedImage: UIImage
    
    var displayImage: UIImage {
        return isSelected ? selectedImage : deselectedImage
    }

    
    init(type: MoodType, selectedImage: UIImage, deselectedImage: UIImage) {
        self.type = type
        self.selectedImage = selectedImage
        self.deselectedImage = deselectedImage
    }
    
    func attributesForMoodType() -> [String : Any] {
        
        var attributes: [String : Any] = [:]
        
        switch self.type {
        case .Acoustic:
            attributes["min_acousticness"] = 0.7
            
        case .Trendy:
            attributes["min_popularity"] = 70
            
        case .Live:
            attributes["min_liveness"] = 0.7
            
        case .SlowDance:
            attributes["min_danceability"] = 0.7
            attributes["max_energy"] = 0.4
            
        case .Energetic:
            attributes["min_danceability"] = 0.7
            
        case .Instrumental:
            attributes["min_instrumentalness"] = 0.6
            
        case .Happy:
            attributes["min_valence"] = 0.7
            
        case .Chill:
            attributes["min_energy"] = 0.6
            attributes["min_valence"] = 0.7
            attributes["max_danceability"] = 0.5
            
        case .Sad:
            attributes["max_valence"] = 0.4
            attributes["max_energy"] = 0.4
            
        case .Rage:
            attributes["max_valence"] = 0.4
            attributes["min_energy"] = 0.7
            
        case .Smooth:
            attributes["min_energy"] = 0.5
            attributes["min_valence"] = 0.5
            
        case .Reflective:
            attributes["min_liveness"] = 0.7
            attributes["min_valence"] = 0.6
            attributes["max_energy"] = 0.5
            
        case .Awake:
            attributes["max_energy"] = 0.5
            attributes["min_valence"] = 0.7
            
        case .Motivational:
            attributes["min_valence"] = 0.7
            
        case .Chaotic:
            attributes["min_valence"] = 0.4
            attributes["min_energy"] = 0.7
            
        case .Sleepy:
            attributes["max_tempo"] = 0.5
            attributes["max_energy"] = 0.5
            
        case .Active:
            attributes["min_energy"] = 0.7
            attributes["min_danceability"] = 0.7
            
        case .Focused:
            attributes["max_speechiness"] = 0.55
            
        }
        return attributes
    }
   
}
