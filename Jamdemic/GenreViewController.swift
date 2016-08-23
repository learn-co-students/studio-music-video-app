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
import SCLAlertView
import Firebase

class GenreViewController: UIViewController {

    let notification = CWStatusBarNotification()
    
    let genreInfo = [
        GenreInfo(displayTitle: "Alternative", spotifyTitle: "alternative", selectedImage: UIImage(named: "alternative-selected")!, deselectedImage: UIImage(named: "alternative-unselected")!),
        GenreInfo(displayTitle: "Rock", spotifyTitle: "rock", selectedImage: UIImage(named: "rock-selected")!, deselectedImage: UIImage(named: "rock-unselected")!),
        GenreInfo(displayTitle: "Pop", spotifyTitle: "pop", selectedImage: UIImage(named: "pop-selected")!, deselectedImage: UIImage(named: "pop-unselected")!),
        GenreInfo(displayTitle: "Jazz", spotifyTitle: "jazz", selectedImage: UIImage(named: "jazz-selected")!, deselectedImage: UIImage(named: "jazz-unselected")!),
        GenreInfo(displayTitle: "Metal", spotifyTitle: "metal", selectedImage: UIImage(named: "metal-selected")!, deselectedImage: UIImage(named: "metal-unselected")!),
        GenreInfo(displayTitle: "Reggae", spotifyTitle: "reggae", selectedImage: UIImage(named: "reggae-selected")!, deselectedImage: UIImage(named: "reggae-unselected")!),
        GenreInfo(displayTitle: "Country", spotifyTitle: "country", selectedImage: UIImage(named: "country-selected")!, deselectedImage: UIImage(named: "country-unselected")!),
        GenreInfo(displayTitle: "EDM/Dance", spotifyTitle: "dance", selectedImage: UIImage(named: "edm-dance-selected")!, deselectedImage: UIImage(named: "edm-dance-unselected")!),
        GenreInfo(displayTitle: "Hip-Hop", spotifyTitle: "hip-hop", selectedImage: UIImage(named: "hip-hop-selected")!, deselectedImage: UIImage(named: "hip-hop-unselected")!),
        GenreInfo(displayTitle: "K-pop", spotifyTitle: "k-pop", selectedImage: UIImage(named: "k-pop-selected")!, deselectedImage: UIImage(named: "k-pop-unselected")!),
        GenreInfo(displayTitle: "Christian", spotifyTitle: "gospel", selectedImage: UIImage(named: "christian-selected")!, deselectedImage: UIImage(named: "christian-unselected")!),
        GenreInfo(displayTitle: "Funk", spotifyTitle: "funk", selectedImage: UIImage(named: "funk-selected")!, deselectedImage: UIImage(named: "funk-unselected")!),
        GenreInfo(displayTitle: "Punk", spotifyTitle: "punk", selectedImage: UIImage(named: "punk-selected")!, deselectedImage: UIImage(named: "punk-unselected")!),
        GenreInfo(displayTitle: "Blues", spotifyTitle: "blues", selectedImage: UIImage(named: "blues-selected")!, deselectedImage: UIImage(named: "blues-unselected")!),
        GenreInfo(displayTitle: "Classical", spotifyTitle: "classical", selectedImage: UIImage(named: "classical-selected")!, deselectedImage: UIImage(named: "classical-unselected")!),
        GenreInfo(displayTitle: "RnB", spotifyTitle: "r-n-b", selectedImage: UIImage(named: "rnb-selected")!, deselectedImage: UIImage(named: "rnb-unselected")!),
        GenreInfo(displayTitle: "Indie", spotifyTitle: "indie", selectedImage: UIImage(named: "indie-selected")!, deselectedImage: UIImage(named: "indie-unselected")!),
        GenreInfo(displayTitle: "Soul", spotifyTitle: "soul", selectedImage: UIImage(named: "soul-selected")!, deselectedImage: UIImage(named: "soul-unselected")!)
    ]
    
    
    let genreTitles = [
        "Alternative", "Rock", "Pop",
        "Jazz", "Metal", "Reggae",
        "Country", "EDM/Dance", "Hip-Hop",
        "K-pop", "Christian", "Funk",
        "Punk", "Blues", "Classical",
        "RnB", "Indie", "Soul"
    ]
    
    let genreDictionary = [
    "K-pop": "k-pop", "Christian": "gospel", "Classical": "classical",
    "RnB": "r-n-b", "Hip-Hop": "hip-hop", "Indie": "indie",
    "Reggae": "reggae", "Metal": "metal", "Blues": "blues",
    "Rock": "rock", "Alternative": "alternative", "Punk": "punk",
    "EDM/Dance": "dance", "Country": "country", "Funk": "funk",
    "Jazz": "jazz", "Soul": "soul", "Pop": "pop"]
    
    var selectedGenres: [String] = []
    
    // String that holds the genre selections from the user. This string is used as the a parameter value to query the Spotify API.
    var genreQueryString = ""
    
    // Counter to keep track of how many genre buttons a user has selected.
    var numberOfSelectedGenres = 0
    
    let numberOfColumns: CGFloat = 3.0
    let cellSpacing: CGFloat = 5.0
    var totalSpacing: CGFloat {
       return numberOfColumns + 1
    }
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    @IBOutlet weak var nextButton: UIBarButtonItem!

    override func viewDidLoad() {
        
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.allowsMultipleSelection = true
        
        self.nextButton.enabled = false
        self.collectionView.contentInset = UIEdgeInsets(top: self.cellSpacing, left: self.cellSpacing, bottom: self.cellSpacing, right: self.cellSpacing)
        // Listen for new searches
        
        registerNotifications()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(clearSelection), name: Notifications.newSearch, object: nil)
        
    }
    
    override func viewDidAppear(animated: Bool) {
        checkCurrentUser()
    }
    
    func displayMaxGenreSelectedAlert() {
        
        let alertAppearance = SCLAlertView.SCLAppearance(kTextFont: UIFont(name: "Avenir Next", size: 14)!, kButtonFont: UIFont(name: "Avenir Next", size: 14)!)
        
        let alert = SCLAlertView(appearance: alertAppearance)
        
        alert.showWarning("", subTitle: "Maximum number of genres selected")
    }
    
    // MARK: - Navigation:
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "showArtistSegue" {
            
            let destinationTVC = segue.destinationViewController as! ArtistViewController
            
            // Passes the genreValues string to the ArtistsTableViewController to do the API call to Spotify in the viewDidLoad method.
            destinationTVC.genreQueryString = queryStringForSelectedGenres()
        }
    }
    
    // MARK: - Clearing Selection
    func clearSelection() {
//        self.selectedGenres.removeAll()
//        self.genreQueryString = ""
//        self.numberOfSelectedGenres = 0
        // Do anything else to reset the selection
        // ...
    }
    
    func queryStringForSelectedGenres() -> String {
        var queryString: String = ""
        for genre in selectedGenres {
            queryString += "\(genre),"
        }
        print(queryString)
        return queryString
    }
    
    func toggleNextButton() {
       self.nextButton.enabled = self.selectedGenres.count > 0 ? true : false
    }
}

// MARK: Collection View
extension GenreViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
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
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.genreInfo.count
    }
    
    func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        if self.numberOfSelectedGenres == 5 {
            self.displayMaxGenreSelectedAlert()
            return false
        }
        return true
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        print("Cell # \(indexPath.row) selected")
        
        var genre = genreInfo[indexPath.row]
        genre.isSelected = true
        
        selectedGenres.append(genre.spotifyTitle)
        
        self.numberOfSelectedGenres += 1
        
        if self.numberOfSelectedGenres > 0 {
            self.nextButton.enabled = true
        }
        
        let cell = collectionView.cellForItemAtIndexPath(indexPath) as! GenreCollectionViewCell
        cell.displayImageView.image = genre.displayImage
        
        self.toggleNextButton()
        
        print(selectedGenres)
    }

    func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath) {
        print("Cell # \(indexPath.row) deselected")
        
        self.numberOfSelectedGenres -= 1
        
        var genre = genreInfo[indexPath.row]
        genre.isSelected = false
        
        // remove from selected genres
        if let indexToRemove = selectedGenres.indexOf(genre.spotifyTitle) {
            selectedGenres.removeAtIndex(indexToRemove)
        }
        
        let cell = collectionView.cellForItemAtIndexPath(indexPath) as! GenreCollectionViewCell
        cell.displayImageView.image = genre.displayImage
    
        print(selectedGenres)
        
        self.toggleNextButton()
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("genreCell", forIndexPath: indexPath) as! GenreCollectionViewCell
        
        let cellInfo = genreInfo[indexPath.row]
        
        cell.displayImageView.image = cellInfo.displayImage
    
        return cell
    }
    
}

//MARK: Sign in
extension GenreViewController {
    
    func checkCurrentUser() {
        
        if FIRAuth.auth()?.currentUser == nil {
            // take user to login screen
            performSegueWithIdentifier(Constants.Segues.ShowLogin, sender: nil)
        }
    }
}

//MARK: Network
extension GenreViewController {
    
    func registerNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(networkUnavailable), name: Notifications.networkUnavailable, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(networkAvailable), name: Notifications.networkAvailable, object: nil)
    }
    
    func networkUnavailable() {
        self.notification.notificationLabelBackgroundColor = UIColor.redColor()
        
        let notificationFont = UIFont.systemFontOfSize(15)
        
        self.notification.notificationLabelFont = notificationFont
        self.notification.displayNotificationWithMessage("No Internet Connection") {}
    }
    
    func networkAvailable() {
        self.notification.dismissNotificationWithCompletion {
            let connectedNotification = CWStatusBarNotification()
            connectedNotification.notificationLabelBackgroundColor = UIColor.greenColor()
            connectedNotification.notificationLabelTextColor = UIColor.blackColor()
            let notificationFont = UIFont.systemFontOfSize(15)
            connectedNotification.notificationLabelFont = notificationFont
            connectedNotification.displayNotificationWithMessage("Connected!", forDuration: 2.0)
        }
    }
}
