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
    
    static var finalQueryDictionary : [String : String] = [:]
    
    var genreQueryString = ""
    
    var userSelectedArtists : [Artist] = []
    
    var testUserArtistString = ""
    
    // Counter to keep track of how many mood buttons a user has selected.
    var moodButtonPressedNumber = 0
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        changeNavigationFontElements()
        
        print(genreQueryString)
        
        for artist in userSelectedArtists {
        
            print("Selected: \(artist.name)\n")
        }
        
        self.testUserArtistString = self.spotifyArtistArrayToString()
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
    
    func storeDifferentMoods(moods : String) {
        
        switch moods {
            
        case "Acoustic":
            self.moodParameterDictionary["min_acousticness"] = 0.7
            print("Your music mood(s) are: \(self.moodParameterDictionary)")
            
        case "Most Played":
            self.moodParameterDictionary["min_popularity"] = 70
            print("Your music mood(s) are: \(self.moodParameterDictionary)")
            
        case "Live":
            self.moodParameterDictionary["min_liveness"] = 0.7
            print("Your music mood(s) are: \(self.moodParameterDictionary)")
            
        case "Slow Dance":
            self.moodParameterDictionary["min_danceability"] = 0.7
            self.moodParameterDictionary["max_energy"] = 0.4
            print("Your music mood(s) are: \(self.moodParameterDictionary)")
            
        case "Energetic":
            self.moodParameterDictionary["min_danceability"] = 0.7
            self.moodParameterDictionary["max_energy"] = 0.7
            print("Your music mood(s) are: \(self.moodParameterDictionary)")
            
        case "Instrumental":
            self.moodParameterDictionary["min_instrumentalness"] = 0.6
            print("Your music mood(s) are: \(self.moodParameterDictionary)")
            
        case "Happy":
            self.moodParameterDictionary["min_valence"] = 0.7
            print("Your music mood(s) are: \(self.moodParameterDictionary)")
            
        case "Chill":
            self.moodParameterDictionary["min_energy"] = 0.6
            self.moodParameterDictionary["min_valence"] = 0.7
            self.moodParameterDictionary["max_danceability"] = 0.5
            print("Your music mood(s) are: \(self.moodParameterDictionary)")
            
        case "Sad":
            self.moodParameterDictionary["max_valence"] = 0.4
            self.moodParameterDictionary["max_energy"] = 0.4
            print("Your music mood(s) are: \(self.moodParameterDictionary)")
            
        case "Rage":
            self.moodParameterDictionary["max_valence"] = 0.4
            self.moodParameterDictionary["min_energy"] = 0.7
            print("Your music mood(s) are: \(self.moodParameterDictionary)")
            
        case "Smooth":
            self.moodParameterDictionary["min_energy"] = 0.5
            self.moodParameterDictionary["min_valence"] = 0.5
            print("Your music mood(s) are: \(self.moodParameterDictionary)")
            
        case "Reflective":
            self.moodParameterDictionary["min_liveness"] = 0.7
            self.moodParameterDictionary["min_valence"] = 0.6
            self.moodParameterDictionary["max_energy"] = 0.5
            print("Your music mood(s) are: \(self.moodParameterDictionary)")
            
        case "Awake":
            self.moodParameterDictionary["max_energy"] = 0.5
            self.moodParameterDictionary["min_valence"] = 0.7
            print("Your music mood(s) are: \(self.moodParameterDictionary)")
            
        case "Motivational":
            self.moodParameterDictionary["min_valence"] = 0.7
            print("Your music mood(s) are: \(self.moodParameterDictionary)")
            
        case "Chaotic":
            self.moodParameterDictionary["min_valence"] = 0.4
            self.moodParameterDictionary["min_energy"] = 0.7
            print("Your music mood(s) are: \(self.moodParameterDictionary)")
            
        case "Sleepy":
            //self.moodParameterDictionary["max_tempo"] = 0.5
            self.moodParameterDictionary["max_energy"] = 0.5
            print("Your music mood(s) are: \(self.moodParameterDictionary)")
            
        default:
            print("Not a valid Mood.")
        }
    }
    
    @IBAction func moodButtonDidTouchUpInside(sender: UIButton) {
    
        guard let unwrappedMoodTitle = sender.titleLabel?.text else { fatalError("Error unwrapping moode button title.") }
        
        if self.moodButtonPressedNumber < 3 {
            
            self.storeDifferentMoods(unwrappedMoodTitle)
        
        // If the user chooses more than three moods, they are presented with an alert view and no more genres are added to the genreValues string.
        } else {
            
            let notificationAlert : UIAlertController = UIAlertController(title: "Uh oh, maximum number of moods selected.", message: "", preferredStyle: UIAlertControllerStyle.Alert)
            
            notificationAlert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            
            self.presentViewController(notificationAlert, animated: true, completion: nil)
        }
    }

    @IBAction func generatePlaylist(sender: AnyObject) {
        
        // Before hitting Spotify API, we check if the access token is valid. If it is not, we get a new one before the API call.
        SpotifyAPIOAuthClient.verifyAccessToken({ (token) in
            
            SpotifyAPIClient.generateArtistsAndSongs(withUserSelectedArtists: self.testUserArtistString, withGenre: self.genreQueryString, withMood: self.moodParameterDictionary, withToken: token, completion: { (json) in
              
                guard let unwrappedJSON = json else { fatalError("Error unwrapping JSON object in MoodTableViewController.") }
                
                let tracks = unwrappedJSON["tracks"].arrayValue
                
                for i in tracks {
                    
                    let artistsNames = i["artists"][0]["name"].stringValue
                    
                    let trackNames = i["name"].stringValue
                    
                    MoodViewController.finalQueryDictionary[artistsNames] = trackNames
                }
                var finalQueryDictionary = MoodViewController.finalQueryDictionary
                
                print("\nThe final query dictionary is: \(MoodViewController.finalQueryDictionary)\n")
                
                for (artist, song) in MoodViewController.finalQueryDictionary {
                    let searchText = artist + " " + song
                    SearchModel.getSearches(0, searchText: searchText, completion: { (infoDictionary) in
                        
                    })
                    
                }
                
                
                
                
                
//              let searchText =  getStringOfArtistAndSongs()
                
            
                
                
                
            })
            
            // If the Spotify API is unavailable, the user is presented with an alert view.
        }) { (error) in
                
            print("Error verifying access token.")
            
            let notificationAlert : UIAlertController = UIAlertController(title: "Uh oh, problem loading artists.", message: "", preferredStyle: UIAlertControllerStyle.Alert)
            
            notificationAlert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler: nil))
            
            self.presentViewController(notificationAlert, animated: true, completion: nil)
        }
    }
    
    func getStringOfArtistAndSongs(){
        var arrayContainer: [String] = []
        
        for artist in MoodViewController.finalQueryDictionary.keys.sort(){
            
            
            let pair = "\(artist) - \(MoodViewController.finalQueryDictionary[artist]!)"
            arrayContainer.append(pair)
            
            
            
            
        }
        
        for artistSong in arrayContainer{
            // let searchPairArtistSong = artistSong
            print(artistSong)
            
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