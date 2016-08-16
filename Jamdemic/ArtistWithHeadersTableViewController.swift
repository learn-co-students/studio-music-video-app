//
//  ArtistWithHeadersTableViewController.swift
//  Jamdemic
//
//  Created by Ismael Barry on 8/16/16.
//  Copyright © 2016 crocodile. All rights reserved.
//

// THIS FILE HAS THE ARTISTTABLEVIEWCONTROLLER WITH CUSTOM HEADERS FOR THE ALPHABETICALLY ORGANIZED ARTISTS.

//import UIKit
//import Alamofire
//import SwiftyJSON
//
//class ArtistTableViewController: UITableViewController {
//    
//    // Required for Alphabetical Header Sections:
//    var letters : [Character] = []
//    var lettersAndArtists : [Character : [Artist]] = [:]
//    
//    var genreQueryString = ""
//    
//    var artists : [Artist] = []
//    
//    var userSelectedArtists : [Artist] = []
//    
//    var albumArtWorkURLString : [String] = []
//    
//    @IBOutlet weak var nextButton: UIBarButtonItem!
//    
//    // Counter to keep track of how many artist buttons a user has selected.
//    var artistButtonPressedNumber = 0
//    
//    override func viewDidLoad() {
//        
//        super.viewDidLoad()
//        
//        changeNavigationFontElements()
//        
//        print(genreQueryString)
//        
//        // Before hitting Spotify API, we check if the access token is valid. If it is not, we get a new one before the API call.
//        SpotifyAPIOAuthClient.verifyAccessToken({ (token) in
//            
//            SpotifyAPIClient.generateArtists(withGenres: self.genreQueryString, withToken: token, completion: { (json) in
//                
//                guard let unwrappedJSON = json else { fatalError("Error unwrapping JSON object in ArtistTableViewController.") }
//                
//                let tracks = unwrappedJSON["tracks"].arrayValue
//                
//                for i in tracks {
//                    
//                    let albumImageURL = i["album"]["images"][0]["url"].stringValue
//                    
//                    let artistsNames = i["artists"][0]["name"].stringValue
//                    
//                    // Returns the each Spotify Artist with their respective spotifyID.
//                    let artistSpotifyID = i["artists"][0]["uri"].stringValue
//                    
//                    // Since each spotifyID has a specific format, we can seperate the ID number.
//                    let separatedSpotifyID = artistSpotifyID.componentsSeparatedByString("spotify:artist:")[1]
//                    
//                    // Sets each artists that is returned back to the Artist Object we created.
//                    let eachArtist = Artist(name: artistsNames, spotifyID: separatedSpotifyID, artistAlbumArtwork: albumImageURL)
//                    
//                    // Adds each artist that is returned to an array of artists that will then be used to populate the table view.
//                    self.artists.append(eachArtist)
//                    
//                    eachArtist.description()
//                }
//                
//                // Sorts the aray alphabetically by name AFTER each artist is added to the array.
//                self.artists = self.artists.sort { $0.name < $1.name }
//                
//                self.customHeaderViewLetters()
//                
//                // After populating the table view, jump back on to the mainthread to reload the table view.
//                NSOperationQueue.mainQueue().addOperationWithBlock({
//                    
//                    self.tableView.reloadData()
//                    
//                })
//            })
//            
//            // If the Spotify API is unavailable, the user is presented with an alert view.
//        }) { (error) in
//            
//            print("Error verifying access token in ArtistViewController.")
//            
//            let notificationAlert : UIAlertController = UIAlertController(title: "Uh oh, problem loading artists.", message: "", preferredStyle: UIAlertControllerStyle.Alert)
//            notificationAlert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler: nil))
//            
//            self.presentViewController(notificationAlert, animated: true, completion: nil)
//        }
//    }
//    
//    // Creates a Dictionary where the key is the first letter of an artist and its value is an array of artist(s) who fall under that letter.
//    func customHeaderViewLetters() {
//        
//        self.letters = self.artists.map({ (artist) -> Character in
//            let artistName = (artist.name)
//            return artistName[artistName.startIndex]
//        })
//        
//        self.letters = self.letters.reduce([], combine: { (list, name) -> [Character] in
//            if !list.contains(name) {
//                return list + [name]
//            }
//            return list
//        })
//        
//        for entry in self.artists {
//            let eachArtist = entry
//            if self.lettersAndArtists[eachArtist.name[(eachArtist.name).startIndex]] == nil {
//                self.lettersAndArtists[eachArtist.name[(eachArtist.name).startIndex]] = [Artist]()
//            }
//            self.lettersAndArtists[eachArtist.name[(eachArtist.name).startIndex]]!.append(eachArtist)
//            
//            //            let artistName = (entry.name)
//            //            if self.lettersAndArtists[artistName[artistName.startIndex]] == nil {
//            //                self.lettersAndArtists[artistName[artistName.startIndex]] = [String]()
//            //            }
//            //            self.lettersAndArtists[artistName[artistName.startIndex]]!.append(artistName)
//        }
//        print(self.lettersAndArtists)
//        
//    }
//    
//    // MARK: - Table view data source:
//    
//    // Required for Alphabetical Header Sections:
//    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        
//        // Required for Alphabetical Header Sections:
//        guard let artistArray = self.lettersAndArtists[self.letters[section]] else { fatalError("Error unwrapping array count in numberOfRowsInSection") }
//        
//        return artistArray.count
//    }
//    
//    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//        
//        // Required for Alphabetical Header Sections:
//        let cell = tableView.dequeueReusableCellWithIdentifier("artistCell", forIndexPath: indexPath)
//        
//        var lettersArray = Array(self.lettersAndArtists.keys)
//        
//        lettersArray =  lettersArray.sort { $0 < $1 }
//        
//        guard let eachArtist = self.lettersAndArtists[lettersArray[indexPath.section]] else { fatalError("Error unwrapping each artist in cellForRowAtIndexPath.") }
//        
//        cell.textLabel?.text = eachArtist[indexPath.row].name
//        
//        return cell
//
//    }
//    
//    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        
//        if self.artistButtonPressedNumber < 5 {
//            
//            self.artistButtonPressedNumber = self.artistButtonPressedNumber + 1
//            
//            print(self.artistButtonPressedNumber)
//            
//            var lettersArray = Array(self.lettersAndArtists.keys)
//            
//            lettersArray =  lettersArray.sort { $0 < $1 }
//            
//            guard let selectedArtist = self.lettersAndArtists[lettersArray[indexPath.section]] else { fatalError("Error unwrapping each artist in didSelectRowAtIndexPath.") }
//            
//            self.userSelectedArtists.append(selectedArtist[indexPath.row])
//            
//            for artist in userSelectedArtists {
//                
//                print("The selected artist(s) name: \(artist.name) -- SpotifyID: \(artist.spotifyID)\n")
//            }
//            
//            // If the user chooses more than five artists, they are presented with an alert view and no more genres are added to the selectedArtist array.
//        } else {
//            
//            let notificationAlert : UIAlertController = UIAlertController(title: "Uh oh, maximum number of artists selected.", message: "", preferredStyle: UIAlertControllerStyle.Alert)
//            
//            notificationAlert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
//            
//            self.presentViewController(notificationAlert, animated: true, completion: nil)
//        }
//    }
//    
//    // MARK: - Navigation:
//    
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        
//        if segue.identifier == "showMoodSegue" {
//            
//            let destinationVC = segue.destinationViewController as! MoodViewController
//            
//            // Pass on the genre query string to further customize our final API call to Spotify.
//            destinationVC.genreQueryString = self.genreQueryString
//            
//            // Pass on the Artists array to further customize our final API call to Spotify.
//            destinationVC.userSelectedArtists = self.userSelectedArtists
//        }
//    }
//    
//    // MARK: - UI Element changes:
//    
//    func changeNavigationFontElements() {
//        
//        self.navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont(name: "Avenir Next", size: 18)!]
//        
//        self.nextButton.setTitleTextAttributes([NSFontAttributeName: UIFont(name: "Avenir Next", size: 16)!], forState: UIControlState.Normal)
//        
//        let backButton = UIBarButtonItem(title: "Artists", style: UIBarButtonItemStyle.Plain, target: self, action: nil)
//        
//        backButton.setTitleTextAttributes([NSFontAttributeName: UIFont(name: "Avenir Next", size: 16)!], forState: UIControlState.Normal)
//        
//        navigationItem.backBarButtonItem = backButton
//    }
//}
