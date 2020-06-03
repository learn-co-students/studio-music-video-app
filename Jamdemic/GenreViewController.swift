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
        print(":HELLO")
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.allowsMultipleSelection = true
        
        self.nextButton.isEnabled = false
        self.collectionView.contentInset = UIEdgeInsets(top: self.cellSpacing, left: self.cellSpacing, bottom: self.cellSpacing, right: self.cellSpacing)
        // Listen for new searches
        
        registerNotifications()
        
        NotificationCenter.default.addObserver(self, selector: #selector(clearSelection), name: NSNotification.Name(rawValue: Notifications.newSearch), object: nil)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        checkCurrentUser()
    }
    
    func displayMaxGenreSelectedAlert() {
        
        let alertAppearance = SCLAlertView.SCLAppearance(kTextFont: UIFont(name: "Avenir Next", size: 14)!, kButtonFont: UIFont(name: "Avenir Next", size: 14)!)
        
        let alert = SCLAlertView(appearance: alertAppearance)
        
        alert.showWarning("", subTitle: "Maximum number of genres selected")
    }
    
    // MARK: - Navigation:
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "showArtistSegue" {
            
            let destinationTVC = segue.destination as! ArtistViewController
            
            // Passes the genreValues string to the ArtistsTableViewController to do the API call to Spotify in the viewDidLoad method.
            destinationTVC.genreQueryString = queryStringForSelectedGenres()
        }
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
        self.nextButton.isEnabled = self.selectedGenres.count > 0 ? true : false
    }
    
        // MARK: - Clearing Selection
    @objc func clearSelection() {
    //        self.selectedGenres.removeAll()
    //        self.genreQueryString = ""
    //        self.numberOfSelectedGenres = 0
            // Do anything else to reset the selection
            // ...
        }
}

// MARK: Collection View
extension GenreViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "genreCell", for: indexPath as IndexPath) as! GenreCollectionViewCell
        
        let cellInfo = genreInfo[indexPath.row]
        
        cell.displayImageView.image = cellInfo.displayImage
        
        return cell
    }
    
    private func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return calculcateCellSize()
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return self.cellSpacing
    }
    
    private func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return self.cellSpacing
    }
    
    func calculcateCellSize() -> CGSize {
        let cellWidthAndHeight = (self.collectionView.bounds.size.width - (self.cellSpacing * self.totalSpacing) / self.numberOfColumns)
        //- (self.cellSpacing * self.totalSpacing))
        return CGSize(width: cellWidthAndHeight, height: cellWidthAndHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.genreInfo.count
    }
    
    private func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        if self.numberOfSelectedGenres == 5 {
            self.displayMaxGenreSelectedAlert()
            return false
        }
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Cell # \(indexPath.row) selected")
        
        let genre = genreInfo[indexPath.row]
        genre.isSelected = true
        
        selectedGenres.append(genre.spotifyTitle)
        
        self.numberOfSelectedGenres += 1
        
        if self.numberOfSelectedGenres == 5 {
            displayMaxGenreSelectedAlert()
        }
        
        let cell = collectionView.cellForItem(at: indexPath as IndexPath) as! GenreCollectionViewCell
        cell.displayImageView.image = genre.displayImage
        
        self.toggleNextButton()
        
        print(selectedGenres)
    }
    
    private func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath) {
        print("Cell # \(indexPath.row) deselected")
        
        self.numberOfSelectedGenres -= 1
        
        let genre = genreInfo[indexPath.row]
        genre.isSelected = false
        
        // remove from selected genres
        if let indexToRemove = selectedGenres.firstIndex(of: genre.spotifyTitle) {
            selectedGenres.remove(at: indexToRemove)
        }
        
        let cell = collectionView.cellForItem(at: indexPath as IndexPath) as! GenreCollectionViewCell
        cell.displayImageView.image = genre.displayImage
        
        print(selectedGenres)
        
        self.toggleNextButton()
    }
    
}

//MARK: Sign in
extension GenreViewController {
    
    func checkCurrentUser() {
        
        // If it's the user's first time using the app, present the home page
        
        let isFirstTime = UserDefaults.standard.bool(forKey: "ViewedStartPage")
        
        if !isFirstTime {
            performSegue(withIdentifier: Constants.Segues.ShowLogin, sender: nil)
        }
    }
}

//MARK: Network
extension GenreViewController {
    
    func registerNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(networkUnavailable), name: NSNotification.Name(rawValue: Notifications.networkUnavailable), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(networkAvailable), name: NSNotification.Name(rawValue: Notifications.networkAvailable), object: nil)
    }
    
    @objc func networkUnavailable() {
        self.notification.notificationLabelBackgroundColor = UIColor.red
        
        let notificationFont = UIFont.systemFont(ofSize: 15)
        
        self.notification.notificationLabelFont = notificationFont
        self.notification.displayNotificationWithMessage(message: "No Internet Connection") {}
    }
    
    @objc func networkAvailable() {
        self.notification.dismissNotificationWithCompletion {
            let connectedNotification = CWStatusBarNotification()
            connectedNotification.notificationLabelBackgroundColor = UIColor.green
            connectedNotification.notificationLabelTextColor = UIColor.black
            let notificationFont = UIFont.systemFont(ofSize: 15)
            connectedNotification.notificationLabelFont = notificationFont
            connectedNotification.displayNotificationWithMessage(message: "Connected!", forDuration: 2.0)
        }
    }
}

