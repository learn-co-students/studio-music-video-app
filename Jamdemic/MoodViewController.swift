//
//  MoodViewController.swift
//  Jamdemic
//
//  Created by Ismael Barry on 8/10/16.
//  Copyright © 2016 crocodile. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class MoodViewController: UIViewController {

    // The value of the Mood dictionary is AnyObject because track tuneability can either than Float or Int. The value CANNOT be passed in as a string. Also, Alamofire's parameter input accepts a dication of ["String" : "AnyObject"]
    var moodParameterDictionary : [String : AnyObject] = [:]
    
    var finalQueryDictionary : [String : String] = [:]
    
    var genreQueryString = ""
    
    var userSelectedArtists : [Artist] = []
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        changeNavigationFontElements()
        
        print(genreQueryString)
        
        for artist in userSelectedArtists {
        
            print("Selected: \(artist.name)\n\n")
        }
    }
    
    @IBAction func moodButtonDidTouchUpInside(sender: UIButton) {
    
        guard let unwrappedMoodTitle = sender.titleLabel?.text else { fatalError("Error unwrapping mood button title.") }
        
        switch unwrappedMoodTitle {
        
        case "Acoustic":
            self.moodParameterDictionary["min_acousticness"] = 0.5
            print("Your music mood(s) are: \(self.moodParameterDictionary)")
            
        default:
            print("Not a valid Mood.")
        }
    }

    @IBAction func generatePlaylist(sender: AnyObject) {
        
        SpotifyAPIOAuthClient.verifyAccessToken({ (token) in
            self.spotifyAPICallForMood(withToken: token)
            }) { (error) in
                
        }
        
    }
    
    func spotifyArtistArrayToString() -> String {
        
        var eachArtistString = ""
        
        for (index, eachArtist) in userSelectedArtists.enumerate() {
            
            eachArtistString += "\(eachArtist.spotifyID)"
            
            if index != userSelectedArtists.count - 1 {
                
                eachArtistString += ","
            }
        }
        return eachArtistString
    }
    
    func spotifyAPICallForMood(withToken token: String) {
        
        let baseURLString = "https://api.spotify.com/v1/recommendations?"
        
        let authorizationDictionary = ["Authorization" : "Bearer \(token)"]
        
        let artist = spotifyArtistArrayToString()
        
        var parameterDictionary: [String : AnyObject] = [
            "seed_genres":self.genreQueryString,
            "seed_artist":artist,
            "limit": 50
        ]
        
        for (key, value) in moodParameterDictionary {
            
            parameterDictionary[key] = value
        }
        
        print("\nParameter Dictionary: \(parameterDictionary)\n\n")
        
        print("\nMood Dictionary: \(moodParameterDictionary)\n\n")
        
        Alamofire.request(.GET, baseURLString, parameters: parameterDictionary, encoding: ParameterEncoding.URL, headers: authorizationDictionary).responseJSON { (response) in
            
            guard let unwrappedResponseValue = response.result.value else { fatalError("Error unwrapping response value.") }
            
            let json = JSON(unwrappedResponseValue)
            
            let tracks = json["tracks"].arrayValue
            
            for i in tracks {
                
                let artistsNames = i["artists"][0]["name"].stringValue
                
                let trackNames = i["name"].stringValue
                
                self.finalQueryDictionary[artistsNames] = trackNames
                
                //print("\n\nArtist from Mood: \(artistsNames) ---- Track from Mood: \(trackNames)\n\n\n")
            }
            //print("\nThe full JSON response is: \(json)\n")
            print("\nThe final query dictionary is: \(self.finalQueryDictionary)\n")
        }
    }
    
    // MARK: - UI Element changes:
    
    func changeNavigationFontElements() {
        
        self.navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont(name: "Avenir Next", size: 18)!]
        self.navigationController?.navigationBar.backItem?.backBarButtonItem?.setTitleTextAttributes([NSFontAttributeName: UIFont(name: "Avenir Next", size: 16)!], forState: UIControlState.Normal)
        let backButton = UIBarButtonItem(title: "Moods", style: UIBarButtonItemStyle.Plain, target: self, action: nil)
        backButton.setTitleTextAttributes([NSFontAttributeName: UIFont(name: "Avenir Next", size: 16)!], forState: UIControlState.Normal)
        navigationItem.backBarButtonItem = backButton
    }
}