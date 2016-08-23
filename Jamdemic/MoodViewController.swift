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
        MoodInfo(type: .Acoustic, selectedImage: UIImage(named: "acoustic-selected")!, deselectedImage: UIImage(named: "acoustic-unselected")!),
        MoodInfo(type: .Trendy, selectedImage: UIImage(named: "trendy-selected")!, deselectedImage: UIImage(named: "trendy-unselected")!),
        MoodInfo(type: .Live, selectedImage: UIImage(named: "live-selected")!, deselectedImage: UIImage(named: "live-unselected")!),
        MoodInfo(type: .SlowDance, selectedImage: UIImage(named: "slow-dance-selected")!, deselectedImage: UIImage(named: "slow-dance-unselected")!),
        MoodInfo(type: .Energetic, selectedImage: UIImage(named: "energetic-selected")!, deselectedImage: UIImage(named: "energetic-unselected")!),
        MoodInfo(type: .Instrumental, selectedImage: UIImage(named: "instrumental-selected")!, deselectedImage: UIImage(named: "instrumental-unselected")!),
        MoodInfo(type: .Happy, selectedImage: UIImage(named: "happy-selected")!, deselectedImage: UIImage(named: "happy-unselected")!),
        MoodInfo(type: .Chill, selectedImage: UIImage(named: "chill-selected")!, deselectedImage: UIImage(named: "chill-unselected")!),
        MoodInfo(type: .Sad, selectedImage: UIImage(named: "sad-selected")!, deselectedImage: UIImage(named: "sad-unselected")!),
        MoodInfo(type: .Rage, selectedImage: UIImage(named: "rage-selected")!, deselectedImage: UIImage(named: "rage-unselected")!),
        MoodInfo(type: .Smooth, selectedImage: UIImage(named: "smooth-selected")!, deselectedImage: UIImage(named: "smooth-unselected")!),
        MoodInfo(type: .Reflective, selectedImage: UIImage(named: "reflective-selected")!, deselectedImage: UIImage(named: "reflective-unselected")!),
        MoodInfo(type: .Awake, selectedImage: UIImage(named: "awake-selected")!, deselectedImage: UIImage(named: "awake-unselected")!),
        MoodInfo(type: .Motivational, selectedImage: UIImage(named: "motivational-selected")!, deselectedImage: UIImage(named: "motivational-unselected")!),
        MoodInfo(type: .Chaotic, selectedImage: UIImage(named: "chaotic-selected")!, deselectedImage: UIImage(named: "chaotic-unselected")!),
        MoodInfo(type: .Sleepy, selectedImage: UIImage(named: "sleepy-selected")!, deselectedImage: UIImage(named: "sleepy-unselected")!),
        MoodInfo(type: .Active, selectedImage: UIImage(named: "active-selected")!, deselectedImage: UIImage(named: "active-unselected")!),
        MoodInfo(type: .Focused, selectedImage: UIImage(named: "focused-selected")!, deselectedImage: UIImage(named: "focused-unselected")!)
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
    
    let numberOfColumns: CGFloat = 3.0
    let cellSpacing: CGFloat = 5.0
    var totalSpacing: CGFloat {
        return numberOfColumns + 1
    }
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        print(genreQueryString)
        
        for artist in userSelectedArtists {
        
            print("Selected: \(artist.name)\n")
        }
        
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.allowsMultipleSelection = false
        
        self.testUserArtistString = self.spotifyArtistArrayToString()
        
        self.collectionView.contentInset = UIEdgeInsets(top: self.cellSpacing, left: self.cellSpacing, bottom: self.cellSpacing, right: self.cellSpacing)
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
                    
                    if self.finalQueryDictionary.isEmpty {
                        print("No results for the specified parameters")
                        self.displayNoTracksAlert()
                    }
                    else {
                        self.crossReferenceYoutubeSearch()
                    }
                    
                    
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
        
        let alertAppearance = SCLAlertView.SCLAppearance(kTitleFont: UIFont(name: "Avenir Next", size: 20)!,
                                                         kTextFont: UIFont(name: "Avenir Next", size: 14)!,
                                                         kButtonFont: UIFont(name: "Avenir Next", size: 14)!)
        
        let alert = SCLAlertView(appearance: alertAppearance)
        
        if error.code == NSURLErrorNotConnectedToInternet {
            alert.showError("Oh no!", subTitle: error.localizedDescription)
        }
        else {
            alert.showError("Oh no!", subTitle: "Something went wrong!")
        }
    }
    
    func displayNoTracksAlert() {
        let alertAppearance = SCLAlertView.SCLAppearance(kTitleFont: UIFont(name: "Avenir Next", size: 20)!,
                                                         kTextFont: UIFont(name: "Avenir Next", size: 14)!,
                                                         kButtonFont: UIFont(name: "Avenir Next", size: 14)!)
        
        let alert = SCLAlertView(appearance: alertAppearance)
        
        alert.showWarning("Oh no!", subTitle: "There aren't any tracks that meet these filters. Trying choosing a different mood or genre.")
        self.stopActivityAnimating()
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
        let cellWidthAndHeight = (self.collectionView.bounds.size.width - (self.cellSpacing * self.totalSpacing)) / self.numberOfColumns
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





