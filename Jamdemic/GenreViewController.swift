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
    
    var genreParameterDictionary : [String : String] = [:]
    var genreValues = ""
    var genreButtonPressedNumber = 0
    
    @IBOutlet weak var continueButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.getAuth()
        print(genreValues)
        
        self.continueButton.enabled = false
        self.continueButton.highlighted = false
        self.continueButton.selected = false
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Step 1: Your application requests authorization:
    func getAuth() {
        
        let oauth = "https://accounts.spotify.com/authorize/?"
        
        let clientID = "dd263eba46444e3a969ddc3b98acb57b"
        
        let responseType = "code"
        
        let redirectURI = "my-jamdemic-app%3A%2F%2Fcallback"
        
        let urlString = "\(oauth)client_id=\(clientID)&response_type=\(responseType)&redirect_uri\(redirectURI)"
        
        Alamofire.request(.GET, urlString).response { (request, response, data, error) in
            
            guard let unwrappedResponse = response else { fatalError("Problem with response unwrap.") }
            
            if unwrappedResponse.statusCode == 200 {
                print("Success")
            } else {
                print("Error")
            }
        }
    }
    
    @IBAction func generatePlaylistButtonDidTouchUpInside(sender: AnyObject) {
        
        let baseURLString = "https://api.spotify.com/v1/recommendations?"
        
        let authorizationDictionary = ["Authorization": "Bearer BQDHmpL5yp3h5y5W3K3n_IHIr0iR-bH3-wMorZkQqs3tMqkdPohn_Eff3AUUvGDlk4lOzlRhVFUqMFmHpkapAAHcl-D-QqwDjMvoxXTpWFaTSJVXy7XVCgaUfWVhQd4uzIbZqGWAEw"]
        
        Alamofire.request(.GET, baseURLString, parameters: self.genreParameterDictionary, encoding: ParameterEncoding.URL, headers: authorizationDictionary).validate().responseJSON { (response) in
            
            guard let responseValue = response.response?.statusCode else { fatalError("Error converting response value.") }
            
            if responseValue == 200 {
                
                let responseValue = response.result.value
                
                guard let unwrappedResponseValue = responseValue else { fatalError("Error unwrapping JSON response.") }
                
                let json = JSON(unwrappedResponseValue)
                
                let tracks = json["tracks"].arrayValue
                
                for i in tracks {
                    
                    let artistsNames = i["artists"][0]["name"].stringValue
                    let artistSpotifyID = i["artists"][0]["uri"].stringValue
                    print("\n\nArtist Name: \(artistsNames) - Spotify ID: \(artistSpotifyID)\n\n")
                    
                }
                /*
                 // Print out all artist names from response:
                 for artistNames in tracks {
                 
                 print(artistNames["artists"][0]["name"].stringValue)
                 
                 }
                 
                 // Print out all artist spotify ID from response:
                 for artistSpotifyID in tracks {
                 
                 print(artistSpotifyID["artists"][0]["uri"].stringValue)
                 
                 }
                 */
                
                /*
                 // Print our a seperate track:
                 let artistName = json["tracks"][0]["artists"][0]["name"].stringValue
                 print(artistName)
                 
                 // Print out a seperate artists spotify ID:
                 let artistSpotifyID = json["tracks"][0]["artists"][0]["uri"].stringValue
                 print(artistSpotifyID)
                 
                 // Print our the entire JSON response:
                 print(json)
                 */
                
            } else {
                
                print("Error Code: \(responseValue)")
            }
        }
    }
    
    @IBAction func genreButtonDidTouchUpInside(sender: UIButton) {
        
        if self.genreButtonPressedNumber < 1 {
            
            self.continueButton.enabled = true
            self.continueButton.highlighted = true
            self.continueButton.selected = true
            
        }
        
        if self.genreButtonPressedNumber < 5 {
            
            self.genreButtonPressedNumber = self.genreButtonPressedNumber + 1
            print(self.genreButtonPressedNumber)
            
            guard let unwrappedGenreTitle = sender.titleLabel?.text else { fatalError("Error unwrapping button title.") }
            
            switch unwrappedGenreTitle {
                
            case "Alternative":
                self.genreValues = "\(self.genreValues)alternative,"
                //self.genreParameterDictionary["genre"] = unwrappedGenreTitle
                //print(genreParameterDictionary)
                //print(self.genreValues)
                self.genreParameterDictionary["seed_genres"] = self.genreValues
            case "Rock":
                self.genreValues = "\(self.genreValues)rock,"
                //print(self.genreValues)
                self.genreParameterDictionary["seed_genres"] = self.genreValues
                print(genreParameterDictionary)
            case "Pop":
                self.genreValues = "\(self.genreValues)pop,"
                //print(self.genreValues)
                self.genreParameterDictionary["seed_genres"] = self.genreValues
                print(genreParameterDictionary)
            case "Jazz":
                self.genreValues = "\(self.genreValues)jazz,"
                //print(self.genreValues)
                self.genreParameterDictionary["seed_genres"] = self.genreValues
                print(genreParameterDictionary)
            case "Metal":
                self.genreValues = "\(self.genreValues)metal,"
                //print(self.genreValues)
                self.genreParameterDictionary["seed_genres"] = self.genreValues
                print(genreParameterDictionary)
            case "Reggae":
                self.genreValues = "\(self.genreValues)reggae,"
                //print(self.genreValues)
                self.genreParameterDictionary["seed_genres"] = self.genreValues
                print(genreParameterDictionary)
            case "Country":
                self.genreValues = "\(self.genreValues)country,"
                //print(self.genreValues)
                self.genreParameterDictionary["seed_genres"] = self.genreValues
                print(genreParameterDictionary)
            case "EDM/Dance":
                self.genreValues = "\(self.genreValues)dance,"
                //print(self.genreValues)
                self.genreParameterDictionary["seed_genres"] = self.genreValues
                print(genreParameterDictionary)
            case "Hip-Hop":
                self.genreValues = "\(self.genreValues)hip-hop,"
                //print(self.genreValues)
                self.genreParameterDictionary["seed_genres"] = self.genreValues
                print(genreParameterDictionary)
            case "K-pop":
                self.genreValues = "\(self.genreValues)k-pop,"
                //print(self.genreValues)
                self.genreParameterDictionary["seed_genres"] = self.genreValues
                print(genreParameterDictionary)
            case "Christian":
                self.genreValues = "\(self.genreValues)gospel,"
                //print(self.genreValues)
                self.genreParameterDictionary["seed_genres"] = self.genreValues
                print(genreParameterDictionary)
            case "Funk":
                self.genreValues = "\(self.genreValues)funk,"
                //print(self.genreValues)
                self.genreParameterDictionary["seed_genres"] = self.genreValues
                print(genreParameterDictionary)
            case "Punk":
                self.genreValues = "\(self.genreValues)punk,"
                //print(self.genreValues)
                self.genreParameterDictionary["seed_genres"] = self.genreValues
                print(genreParameterDictionary)
            case "Blues":
                self.genreValues = "\(self.genreValues)blues,"
                //print(self.genreValues)
                self.genreParameterDictionary["seed_genres"] = self.genreValues
                print(genreParameterDictionary)
            case "Classical":
                self.genreValues = "\(self.genreValues)classical,"
                //print(self.genreValues)
                self.genreParameterDictionary["seed_genres"] = self.genreValues
                print(genreParameterDictionary)
            case "RnB":
                self.genreValues = "\(self.genreValues)r-n-b,"
                //print(self.genreValues)
                self.genreParameterDictionary["seed_genres"] = self.genreValues
                print(genreParameterDictionary)
            case "Indie":
                self.genreValues = "\(self.genreValues)indie,"
                //print(self.genreValues)
                self.genreParameterDictionary["seed_genres"] = self.genreValues
                print(genreParameterDictionary)
            case "Soul":
                self.genreValues = "\(self.genreValues)soul,"
                //print(self.genreValues)
                self.genreParameterDictionary["seed_genres"] = self.genreValues
                print(genreParameterDictionary)
            default:
                print("Not a valid genre.")
            }
            
        } else {
            
            let notificationAlert : UIAlertController = UIAlertController(title: "Uh oh, maximum number of genres selected.", message: "", preferredStyle: UIAlertControllerStyle.Alert)
            notificationAlert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            
            self.presentViewController(notificationAlert, animated: true, completion: nil)
        }
    }
    
  

}
