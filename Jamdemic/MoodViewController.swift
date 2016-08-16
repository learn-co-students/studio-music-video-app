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
    
    var testUserArtistString = ""
    
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
        
        // Before hitting Spotify API, we check if the access token is valid. If it is not, we get a new one before the API call.
        SpotifyAPIOAuthClient.verifyAccessToken({ (token) in
            
            SpotifyAPIClient.generateArtistsAndSongs(withUserSelectedArtists: self.testUserArtistString, withGenre: self.genreQueryString, withMood: self.moodParameterDictionary, withToken: token, completion: { (json) in
              
                guard let unwrappedJSON = json else { fatalError("Error unwrapping JSON object in MoodTableViewController.") }
                
                let tracks = unwrappedJSON["tracks"].arrayValue
                
                for i in tracks {
                    
                    let artistsNames = i["artists"][0]["name"].stringValue
                    
                    let trackNames = i["name"].stringValue
                    
                    self.finalQueryDictionary[artistsNames] = trackNames
                }
                var finalQueryDictionary = self.finalQueryDictionary
                print("\nThe final query dictionary is: \(self.finalQueryDictionary)\n")
                func getStringOfArtistAndSongs(){
                    var arrayContainer: [String] = []
                    
                    for artist in finalQueryDictionary.keys.sort(){
                        
                        
                        let pair = "\(artist) - \(finalQueryDictionary[artist]!)"
                        arrayContainer.append(pair)
                        
                        
                        
                        
                    }
                    
                    for artistSong in arrayContainer{
                       // let searchPairArtistSong = artistSong
                        print(artistSong)
                    
                    }
                    
                }
                
              let searchText =  getStringOfArtistAndSongs()
                
            
                
                
                
            })
            
            // If the Spotify API is unavailable, the user is presented with an alert view.
        }) { (error) in
                
            print("Error verifying access token.")
            
            let notificationAlert : UIAlertController = UIAlertController(title: "Uh oh, problem loading artists.", message: "", preferredStyle: UIAlertControllerStyle.Alert)
            notificationAlert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler: nil))
            
            self.presentViewController(notificationAlert, animated: true, completion: nil)
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