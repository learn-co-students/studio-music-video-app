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
import NVActivityIndicatorView
import SCLAlertView

class MoodViewController: UIViewController, NVActivityIndicatorViewable {

    
    let moods = [
        MoodInfo(type: .Acoustic, selectedImage: UIImage(named: "Acoustic")!, deselectedImage: UIImage(named: "Acoustic-Highlighted")!),
        MoodInfo(type: .MostPlayed, selectedImage: UIImage(named: "Acoustic")!, deselectedImage: UIImage(named: "Acoustic-Highlighted")!),
        MoodInfo(type: .Live, selectedImage: UIImage(named: "Acoustic")!, deselectedImage: UIImage(named: "Acoustic-Highlighted")!),
        MoodInfo(type: .SlowDance, selectedImage: UIImage(named: "Acoustic")!, deselectedImage: UIImage(named: "Acoustic-Highlighted")!),
        MoodInfo(type: .Energetic, selectedImage: UIImage(named: "Acoustic")!, deselectedImage: UIImage(named: "Acoustic-Highlighted")!),
        MoodInfo(type: .Instrumental, selectedImage: UIImage(named: "Acoustic")!, deselectedImage: UIImage(named: "Acoustic-Highlighted")!),
        MoodInfo(type: .Happy, selectedImage: UIImage(named: "Acoustic")!, deselectedImage: UIImage(named: "Acoustic-Highlighted")!),
        MoodInfo(type: .Chill, selectedImage: UIImage(named: "Acoustic")!, deselectedImage: UIImage(named: "Acoustic-Highlighted")!),
        MoodInfo(type: .Sad, selectedImage: UIImage(named: "Acoustic")!, deselectedImage: UIImage(named: "Acoustic-Highlighted")!),
        MoodInfo(type: .Rage, selectedImage: UIImage(named: "Acoustic")!, deselectedImage: UIImage(named: "Acoustic-Highlighted")!),
        MoodInfo(type: .Smooth, selectedImage: UIImage(named: "Acoustic")!, deselectedImage: UIImage(named: "Acoustic-Highlighted")!),
        MoodInfo(type: .Reflective, selectedImage: UIImage(named: "Acoustic")!, deselectedImage: UIImage(named: "Acoustic-Highlighted")!),
        MoodInfo(type: .Awake, selectedImage: UIImage(named: "Acoustic")!, deselectedImage: UIImage(named: "Acoustic-Highlighted")!),
        MoodInfo(type: .Motivational, selectedImage: UIImage(named: "Acoustic")!, deselectedImage: UIImage(named: "Acoustic-Highlighted")!),
        MoodInfo(type: .Chaotic, selectedImage: UIImage(named: "Acoustic")!, deselectedImage: UIImage(named: "Acoustic-Highlighted")!),
        MoodInfo(type: .Sleepy, selectedImage: UIImage(named: "Acoustic")!, deselectedImage: UIImage(named: "Acoustic-Highlighted")!),
    ]
    
    var selectedMoods: [MoodInfo] = []
    
    // The value of the Mood dictionary is AnyObject because track tuneability can either than Float or Int. The value CANNOT be passed in as a string. Also, Alamofire's parameter input accepts a dication of ["String" : "AnyObject"]
    var moodParameterDictionary : [String : AnyObject] = [:]
    
    var finalQueryDictionary : [String : String] = [:]
    
    var genreQueryString = ""
    
    var userSelectedArtists : [Artist] = []
    
    var testUserArtistString = ""
    
    var playlistDetailInfoArray : [PlaylistDetailInfo] = []
    
    // Counter to keep track of how many mood buttons a user has selected.
    var numberOfSelectedMoods = 0
    
    let maxMoodsAllowed = 1
    
    let cellSpacing: CGFloat = 1.0
    let numberOfColumns: CGFloat = 3.0
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        changeNavigationFontElements()
        
        print(genreQueryString)
        
        for artist in userSelectedArtists {
        
            print("Selected: \(artist.name)\n")
        }
        
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.allowsMultipleSelection = false
        
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
        
        if self.numberOfSelectedMoods < 3 {
            
            self.storeDifferentMoods(unwrappedMoodTitle)
        
        // If the user chooses more than three moods, they are presented with an alert view and no more genres are added to the genreValues string.
        } else {
            
            let notificationAlert : UIAlertController = UIAlertController(title: "Uh oh, maximum number of moods selected.", message: "", preferredStyle: UIAlertControllerStyle.Alert)
            
            notificationAlert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            
            self.presentViewController(notificationAlert, animated: true, completion: nil)
        }
    }

    @IBAction func generatePlaylist(sender: AnyObject) {
        
        startActivityAnimating(message: "Loading...", type: .LineScalePulseOutRapid)
        
        // Before hitting Spotify API, we check if the access token is valid. If it is not, we get a new one before the API call.
        SpotifyAPIOAuthClient.verifyAccessToken({ (token) in
            
            let moodParamater = self.flattenSelectedMoods()
            
            SpotifyAPIClient.generateArtistsAndSongs(withUserSelectedArtists: self.testUserArtistString, withGenre: self.genreQueryString, withMood: moodParamater, withToken: token, completion: { (json, error) in
                if let error = error {
                    // display error message
                    self.displayErrorMessage(forError: error)
                }
                else {
                    guard let unwrappedJSON = json else { fatalError("Error unwrapping JSON object in MoodTableViewController.") }
                    
                    let tracks = unwrappedJSON["tracks"].arrayValue
                    
                    for i in tracks {
                        
                        let artistsNames = i["artists"][0]["name"].stringValue
                        
                        let trackNames = i["name"].stringValue
                        
                        self.finalQueryDictionary[artistsNames] = trackNames
                    }
                    self.crossReferenceYoutubeSearch()
                }
              
            })
            
            // If the Spotify API is unavailable, the user is presented with an alert view.
        }) { (error) in
            self.stopActivityAnimating()
            self.displayErrorMessage(forError: error)
        }
    }
    
    func crossReferenceYoutubeSearch() {
        
        // Setting an asynchronous queue with a high priority.
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), {
            
            // Create an asynchronous request group because we multiple requests to make to each artist and song to search youtube.
            let requestGroup = dispatch_group_create()
            
            for (artist, song) in self.finalQueryDictionary {
                
                let searchText = artist + "-" + song
                
                // Is a tally holder that adds up all of the request groups. We do this before the Youtube API call.
                dispatch_group_enter(requestGroup)
                
                SearchModel.getSearches(0, searchText: searchText, completion: { (infoDictionary) in
                    
                    guard let videoID = infoDictionary["videoID"] else { fatalError("Error unwrapping videoID from infoDictionary.") }
                    
                    guard let thumbnailURLString = infoDictionary["thumbnailURLString"] else { fatalError("Error unwrapping thumbnailURLString from infoDictionary.") }
                    
                    let playlistItemInfo = PlaylistDetailInfo(name: artist, songTitle: song, videoID: videoID, thumbnailURLString: thumbnailURLString)
                    
                    self.playlistDetailInfoArray.append(playlistItemInfo)
                    
                    // When we are done with every request for artist and song, the dispatch group leaves.
                    dispatch_group_leave(requestGroup)
                })
            }
            
            // Wait for all request groups to finish before proceeding.
            dispatch_group_wait(requestGroup, DISPATCH_TIME_FOREVER)
            
            dispatch_async(dispatch_get_main_queue(), {
                
                self.stopActivityAnimating()
                for playlistItem in self.playlistDetailInfoArray {
                    print("\(playlistItem.name) - \(playlistItem.songTitle)\n\(playlistItem.videoID)\n\(playlistItem.thumnailURLString)")
                }
                self.stopActivityAnimating()
                // TODO: manual segue to next view controller.
                self.performSegueWithIdentifier("showPlaylist", sender: nil)
            })
        })
    }
    
    // MARK: Segues
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showPlaylist" {
            let destinationVC = segue.destinationViewController as! PlaylistViewController
            destinationVC.playlistData = playlistDetailInfoArray
        }
    }
    
    func displayErrorMessage(forError error: NSError) {
        if error.code == NSURLErrorNotConnectedToInternet {
            SCLAlertView().showError("Oh no!", subTitle: error.localizedDescription)
        }
        else {
            SCLAlertView().showError("Oh no!", subTitle: "Something went wrong!")
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
    
    func flattenSelectedMoods() -> [String : AnyObject] {
        
        var flattenedMoods: [String : AnyObject] = [:]
        
        for mood in selectedMoods {
            let moodAttributes = mood.attributes
            for (key, value) in moodAttributes {
                flattenedMoods[key] = value
            }
        }
        return flattenedMoods
    }
}

//MARK: - CollectionView
extension MoodViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return calculcateCellSize()
        
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return self.cellSpacing
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return self.cellSpacing
    }
    
    func calculcateCellSize() -> CGSize {
        let cellWidthAndHeight = (self.collectionView.bounds.size.width - (self.cellSpacing * self.numberOfColumns)) / self.numberOfColumns
        return CGSize(width: cellWidthAndHeight, height: cellWidthAndHeight)
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        if self.selectedMoods.count >= self.maxMoodsAllowed {
            // display alert saying max moods already selected
            return
        }
        
        var mood = moods[indexPath.row]
        mood.isSelected = true
        
        self.selectedMoods.append(mood)
        
        setCellDisplayImageForIndexPath(indexPath, mood: mood)
        print(selectedMoods)

    }
    
    func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath) {
        
        var mood = moods[indexPath.row]
         mood.isSelected = false
        let indexToRemove = selectedMoods.indexOf { $0.type == mood.type }
        
        if let indexToRemove = indexToRemove {
            selectedMoods.removeAtIndex(indexToRemove)
        }
        
       
        
        setCellDisplayImageForIndexPath(indexPath, mood: mood)
    }
    
    func setCellDisplayImageForIndexPath(indexPath: NSIndexPath, mood: MoodInfo) {
        let cell = collectionView.cellForItemAtIndexPath(indexPath) as! MoodCollectionViewCell
        cell.displayImageView.image = mood.displayImage
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.moods.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("moodCell", forIndexPath: indexPath) as! MoodCollectionViewCell
        
         cell.displayImageView.image = moods[indexPath.row].displayImage
        
        return cell
    }
    
}





