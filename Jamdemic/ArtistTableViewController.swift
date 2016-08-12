//
//  ArtistTableViewController.swift
//  Jamdemic
//
//  Created by Ismael Barry on 8/10/16.
//  Copyright © 2016 crocodile. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ArtistTableViewController: UITableViewController {
    
    var genreQueryString = ""
    
    var artists : [Artist] = []
    
    var userSelectedArtists : [Artist] = []
    
    @IBOutlet weak var nextButton: UIBarButtonItem!
    
    // Counter to keep track of how many artist buttons a user has selected.
    var artistButtonPressedNumber = 0
    
    override func viewDidLoad() {
       
        super.viewDidLoad()
        
        changeNavigationFontElements()
        
        print(genreQueryString)
        
        SpotifyAPIOAuthClient.verifyAccessToken({ (token) in
            self.spotifyAPICallForGenres(withToken: token)
            }) { (error) in
                
        }

    }
    
    func spotifyAPICallForGenres(withToken token: String) {
        
        let baseURLString = "https://api.spotify.com/v1/recommendations?"
        
        // The genreQueryString from the GenreViewController is used as a query paramter to Spotify so we can get a list of artists back.
        let genreParameterDictionary = ["seed_genres" : self.genreQueryString]
        
        let authorizationDictionary = ["Authorization" : "Bearer \(token)"]
        
        Alamofire.request(.GET, baseURLString, parameters: genreParameterDictionary, encoding: ParameterEncoding.URL, headers: authorizationDictionary).validate().responseJSON { (response) in
            
            guard let responseValue = response.response?.statusCode else { fatalError("Error converting response value.") }
            
            if responseValue == 200 {
                
                let responseValue = response.result.value
                
                guard let unwrappedResponseValue = responseValue else { fatalError("Error unwrapping JSON response.") }
                
                let json = JSON(unwrappedResponseValue)
                
                let tracks = json["tracks"].arrayValue
                
                for i in tracks {
                    
                    let artistsNames = i["artists"][0]["name"].stringValue
                    
                    // Returns the each Spotify Artist with their respective spotifyID.
                    let artistSpotifyID = i["artists"][0]["uri"].stringValue
                    
                    // Since each spotifyID has a specific format, we can seperate the ID number.
                    let separatedSpotifyID = artistSpotifyID.componentsSeparatedByString("spotify:artist:")[1]
                    
                    // Sets each artists that is returned back to the Artist Object we created.
                    let eachArtist = Artist(name: artistsNames, spotifyID: separatedSpotifyID)
                    
                    // Adds each artist that is returned to an array of artists that will then be used to populate the table view.
                    self.artists.append(eachArtist)
                    
                    eachArtist.description()
                }
                
                // After populating the table view, jump back on to the mainthread to reload the table view.
                NSOperationQueue.mainQueue().addOperationWithBlock({ 
                    
                    self.tableView.reloadData()
                    
                })
                
            } else {
                
                print("Error Code: \(responseValue)")
            }
        }
    }
    
    // MARK: - Table view data source

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        // Displays every artists that is returned from the API call.
        return self.artists.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("artistCell", forIndexPath: indexPath)
        
        cell.textLabel?.text = self.artists[indexPath.row].name
        
        return cell
        
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if self.artistButtonPressedNumber < 5 {
        
            self.artistButtonPressedNumber = self.artistButtonPressedNumber + 1
        
            print(self.artistButtonPressedNumber)
        
            // For each artist that the user chooses in a cell, they are added to a new array of Artists that will then be used in another API to Spotify.
            let selectedArtist = self.artists[indexPath.row]
            self.userSelectedArtists.append(selectedArtist)
        
            for artist in userSelectedArtists {
            
                print("The selected artist(s) name: \(artist.name) -- SpotifyID: \(artist.spotifyID)\n")
            }
           
            // If the user chooses more than five artists, they are presented with an alert view and no more genres are added to the selectedArtist array.
        } else {
            
            let notificationAlert : UIAlertController = UIAlertController(title: "Uh oh, maximum number of artists selected.", message: "", preferredStyle: UIAlertControllerStyle.Alert)
            notificationAlert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            
            self.presentViewController(notificationAlert, animated: true, completion: nil)
        
        }
    }
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "showMoodSegue" {
            
            let destinationVC = segue.destinationViewController as! MoodViewController
            
            // Pass on the genre query string to further customize our final API call to Spotify.
            destinationVC.genreQueryString = self.genreQueryString
            
            // Pass on the Artists array to further customize our final API call to Spotify.
            destinationVC.userSelectedArtists = self.userSelectedArtists
        }
    }
    
    // MARK: - UI Element changes:
    
    func changeNavigationFontElements() {
        
        self.navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont(name: "Avenir Next", size: 18)!]
        self.nextButton.setTitleTextAttributes([NSFontAttributeName: UIFont(name: "Avenir Next", size: 16)!], forState: UIControlState.Normal)
        let backButton = UIBarButtonItem(title: "Artists", style: UIBarButtonItemStyle.Plain, target: self, action: nil)
        backButton.setTitleTextAttributes([NSFontAttributeName: UIFont(name: "Avenir Next", size: 16)!], forState: UIControlState.Normal)
        navigationItem.backBarButtonItem = backButton
    }
}