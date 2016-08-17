//
//  GenreViewController.swift
//  Jamdemic
//
//  Created by Ismael Barry on 8/10/16.
//  Copyright © 2016 crocodile. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class GenreViewController: UIViewController {
    
    // Dictionary that holds the query parameters for Spotify. The is key is "seed_genres". The value is the "genreQueryString" string.
    var genreParameterDictionary : [String : String] = [:]
    
    // String that holds the genre selections from the user. This string is used as the a parameter value to query the Spotify API.
    var genreQueryString = ""
    
    // Counter to keep track of how many genre buttons a user has selected.
    var genreButtonPressedNumber = 0
    
    @IBOutlet weak var nextButton: UIBarButtonItem!

    override func viewDidLoad() {
        
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        changeNagivationFontElements()
        //print(genreQueryString)
        
        self.nextButton.enabled = false
    }
    
    func storeDifferentGenres(genres : String) {
        
        switch genres {
            
        case "Alternative":
            self.genreQueryString = "\(self.genreQueryString)alternative,"
            self.genreParameterDictionary["seed_genres"] = self.genreQueryString
            print("Your music genre(s) are: \(self.genreParameterDictionary)")
            
        case "Rock":
            self.genreQueryString = "\(self.genreQueryString)rock,"
            self.genreParameterDictionary["seed_genres"] = self.genreQueryString
            print("Your music genre(s) are: \(self.genreParameterDictionary)")
            
        case "Pop":
            self.genreQueryString = "\(self.genreQueryString)pop,"
            self.genreParameterDictionary["seed_genres"] = self.genreQueryString
            print("Your music genre(s) are: \(self.genreParameterDictionary)")
            
        case "Jazz":
            self.genreQueryString = "\(self.genreQueryString)jazz,"
            self.genreParameterDictionary["seed_genres"] = self.genreQueryString
            print("Your music genre(s) are: \(self.genreParameterDictionary)")
            
        case "Metal":
            self.genreQueryString = "\(self.genreQueryString)metal,"
            self.genreParameterDictionary["seed_genres"] = self.genreQueryString
            print("Your music genre(s) are: \(self.genreParameterDictionary)")
            
        case "Reggae":
            self.genreQueryString = "\(self.genreQueryString)reggae,"
            self.genreParameterDictionary["seed_genres"] = self.genreQueryString
            print("Your music genre(s) are: \(self.genreParameterDictionary)")
            
        case "Country":
            self.genreQueryString = "\(self.genreQueryString)country,"
            self.genreParameterDictionary["seed_genres"] = self.genreQueryString
            print("Your music genre(s) are: \(self.genreParameterDictionary)")
            
        case "EDM/Dance":
            self.genreQueryString = "\(self.genreQueryString)dance,"
            self.genreParameterDictionary["seed_genres"] = self.genreQueryString
            print("Your music genre(s) are: \(self.genreParameterDictionary)")
            
        case "Hip-Hop":
            self.genreQueryString = "\(self.genreQueryString)hip-hop,"
            self.genreParameterDictionary["seed_genres"] = self.genreQueryString
            print("Your music genre(s) are: \(self.genreParameterDictionary)")
            
        case "K-pop":
            self.genreQueryString = "\(self.genreQueryString)k-pop,"
            self.genreParameterDictionary["seed_genres"] = self.genreQueryString
            print("Your music genre(s) are: \(self.genreParameterDictionary)")
            
        case "Christian":
            self.genreQueryString = "\(self.genreQueryString)gospel,"
            self.genreParameterDictionary["seed_genres"] = self.genreQueryString
            print("Your music genre(s) are: \(self.genreParameterDictionary)")
            
        case "Funk":
            self.genreQueryString = "\(self.genreQueryString)funk,"
            self.genreParameterDictionary["seed_genres"] = self.genreQueryString
            print("Your music genre(s) are: \(self.genreParameterDictionary)")
            
        case "Punk":
            self.genreQueryString = "\(self.genreQueryString)punk,"
            self.genreParameterDictionary["seed_genres"] = self.genreQueryString
            print("Your music genre(s) are: \(self.genreParameterDictionary)")
            
        case "Blues":
            self.genreQueryString = "\(self.genreQueryString)blues,"
            self.genreParameterDictionary["seed_genres"] = self.genreQueryString
            print("Your music genre(s) are: \(self.genreParameterDictionary)")
            
        case "Classical":
            self.genreQueryString = "\(self.genreQueryString)classical,"
            self.genreParameterDictionary["seed_genres"] = self.genreQueryString
            print("Your music genre(s) are: \(self.genreParameterDictionary)")
            
        case "RnB":
            self.genreQueryString = "\(self.genreQueryString)r-n-b,"
            self.genreParameterDictionary["seed_genres"] = self.genreQueryString
            print("Your music genre(s) are: \(self.genreParameterDictionary)")
            
        case "Indie":
            self.genreQueryString = "\(self.genreQueryString)indie,"
            self.genreParameterDictionary["seed_genres"] = self.genreQueryString
            print("Your music genre(s) are: \(self.genreParameterDictionary)")
            
        case "Soul":
            self.genreQueryString = "\(self.genreQueryString)soul,"
            self.genreParameterDictionary["seed_genres"] = self.genreQueryString
            print("Your music genre(s) are: \(self.genreParameterDictionary)")
            
        default:
            print("Not a valid genre.")
        }
    }
    
    @IBAction func genreButtonDidTouchUpInside(sender: UIButton) {
        
        guard let unwrappedGenreTitle = sender.titleLabel?.text else { fatalError("Error unwrapping genre button title.") }
        
        // If the user chooses atleast one genre, then the can move forward to the ArtistViewController.
        if self.genreButtonPressedNumber < 1 {
            
            self.nextButton.enabled = true
        
        }
        
        // As long as the user chooses at most 5 genres, we add each genre to the genreValues string and that string is added to the genreParameterDictionary's values.
        if self.genreButtonPressedNumber < 5 {
         
            self.genreButtonPressedNumber = self.genreButtonPressedNumber + 1
            
            self.storeDifferentGenres(unwrappedGenreTitle)
        
        // If the user chooses more than five genres, they are presented with an alert view and no more genres are added to the genreValues string.
        } else {
            
            let notificationAlert : UIAlertController = UIAlertController(title: "Uh oh, maximum number of genres selected.", message: "", preferredStyle: UIAlertControllerStyle.Alert)
            
            notificationAlert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            
            self.presentViewController(notificationAlert, animated: true, completion: nil)
        }
    }
    
    // MARK: - Navigation:
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "showArtistSegue" {
            
            let destinationTVC = segue.destinationViewController as! ArtistTableViewController
            
            // Passes the genreValues string to the ArtistsTableViewController to do the API call to Spotify in the viewDidLoad method.
            destinationTVC.genreQueryString = self.genreQueryString
        }
    }
    
    // MARK: - UI Element changes:
    
    func changeNagivationFontElements() {
        
        self.navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont(name: "Avenir Next", size: 18)!]
        
        self.nextButton.setTitleTextAttributes([NSFontAttributeName: UIFont(name: "Avenir Next", size: 16)!], forState: UIControlState.Normal)
        
        let backButton = UIBarButtonItem(title: "Genres", style: UIBarButtonItemStyle.Plain, target: self, action: nil)
        
        backButton.setTitleTextAttributes([NSFontAttributeName: UIFont(name: "Avenir Next", size: 16)!], forState: UIControlState.Normal)
        
        navigationItem.backBarButtonItem = backButton
    }
}