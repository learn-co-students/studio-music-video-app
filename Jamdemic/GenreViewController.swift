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

class GenreViewController: UIViewController {

    
    let genreInfo = [
        GenreInfo(displayTitle: "Alternative", spotifyTitle: "alternative", selectedImage: UIImage(named: "Acoustic")!, deselectedImage: UIImage(named: "Acoustic-Highlighted")!),
        GenreInfo(displayTitle: "Rock", spotifyTitle: "rock", selectedImage: UIImage(named: "Acoustic")!, deselectedImage: UIImage(named: "Acoustic-Highlighted")!),
        GenreInfo(displayTitle: "Pop", spotifyTitle: "pop", selectedImage: UIImage(named: "Acoustic")!, deselectedImage: UIImage(named: "Acoustic-Highlighted")!),
        GenreInfo(displayTitle: "Jazz", spotifyTitle: "jazz", selectedImage: UIImage(named: "Acoustic")!, deselectedImage: UIImage(named: "Acoustic-Highlighted")!),
        GenreInfo(displayTitle: "Metal", spotifyTitle: "metal", selectedImage: UIImage(named: "Acoustic")!, deselectedImage: UIImage(named: "Acoustic-Highlighted")!),
        GenreInfo(displayTitle: "Reggae", spotifyTitle: "reggae", selectedImage: UIImage(named: "Acoustic")!, deselectedImage: UIImage(named: "Acoustic-Highlighted")!),
        GenreInfo(displayTitle: "Country", spotifyTitle: "country", selectedImage: UIImage(named: "Acoustic")!, deselectedImage: UIImage(named: "Acoustic-Highlighted")!),
        GenreInfo(displayTitle: "EDM/Dance", spotifyTitle: "dance", selectedImage: UIImage(named: "Acoustic")!, deselectedImage: UIImage(named: "Acoustic-Highlighted")!),
        GenreInfo(displayTitle: "Hip-Hop", spotifyTitle: "hip-hop", selectedImage: UIImage(named: "Acoustic")!, deselectedImage: UIImage(named: "Acoustic-Highlighted")!),
        GenreInfo(displayTitle: "K-pop", spotifyTitle: "k-pop", selectedImage: UIImage(named: "Acoustic")!, deselectedImage: UIImage(named: "Acoustic-Highlighted")!),
        GenreInfo(displayTitle: "Christian", spotifyTitle: "gospel", selectedImage: UIImage(named: "Acoustic")!, deselectedImage: UIImage(named: "Acoustic-Highlighted")!),
        GenreInfo(displayTitle: "Funk", spotifyTitle: "funk", selectedImage: UIImage(named: "Acoustic")!, deselectedImage: UIImage(named: "Acoustic-Highlighted")!),
        GenreInfo(displayTitle: "Punk", spotifyTitle: "punk", selectedImage: UIImage(named: "Acoustic")!, deselectedImage: UIImage(named: "Acoustic-Highlighted")!),
        GenreInfo(displayTitle: "Blues", spotifyTitle: "blues", selectedImage: UIImage(named: "Acoustic")!, deselectedImage: UIImage(named: "Acoustic-Highlighted")!),
        GenreInfo(displayTitle: "Classical", spotifyTitle: "classical", selectedImage: UIImage(named: "Acoustic")!, deselectedImage: UIImage(named: "Acoustic-Highlighted")!),
        GenreInfo(displayTitle: "RnB", spotifyTitle: "r-n-b", selectedImage: UIImage(named: "Acoustic")!, deselectedImage: UIImage(named: "Acoustic-Highlighted")!),
        GenreInfo(displayTitle: "Indie", spotifyTitle: "indie", selectedImage: UIImage(named: "Acoustic")!, deselectedImage: UIImage(named: "Acoustic-Highlighted")!),
        GenreInfo(displayTitle: "Soul", spotifyTitle: "soul", selectedImage: UIImage(named: "Acoustic")!, deselectedImage: UIImage(named: "Acoustic-Highlighted")!)
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
    let cellSpacing: CGFloat = 1.0
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    @IBOutlet weak var nextButton: UIBarButtonItem!

    override func viewDidLoad() {
        
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        changeNagivationFontElements()
        //print(genreQueryString)
        
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.allowsMultipleSelection = true
        
        self.nextButton.enabled = false
        
        // Listen for new searches
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(clearSelection), name: Notifications.newSearch, object: nil)
        
    }
    
    func displayMaxGenreSelectedAlert() {
        
        let notificationAlert : UIAlertController = UIAlertController(title: "Uh oh, maximum number of genres selected.", message: "", preferredStyle: UIAlertControllerStyle.Alert)
        
        notificationAlert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
        
        self.presentViewController(notificationAlert, animated: true, completion: nil)

    }
    
    // MARK: - Navigation:
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "showArtistSegue" {
            
            let destinationTVC = segue.destinationViewController as! ArtistTableViewController
            
            // Passes the genreValues string to the ArtistsTableViewController to do the API call to Spotify in the viewDidLoad method.
            destinationTVC.genreQueryString = queryStringForSelectedGenres()
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
        let cellWidthAndHeight = (self.collectionView.bounds.size.width - (self.cellSpacing * self.numberOfColumns)) / self.numberOfColumns
        print(cellWidthAndHeight)
        return CGSize(width: cellWidthAndHeight, height: cellWidthAndHeight)
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.genreInfo.count
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        print("Cell # \(indexPath.row) selected")
        
        var genre = genreInfo[indexPath.row]
        genre.isSelected = true
        
        selectedGenres.append(genre.spotifyTitle)
        
        if self.numberOfSelectedGenres == 5 {
            self.displayMaxGenreSelectedAlert()
            return
        }
        
        self.numberOfSelectedGenres += 1
        
        if self.numberOfSelectedGenres > 0 {
            self.nextButton.enabled = true
        }
        
        let cell = collectionView.cellForItemAtIndexPath(indexPath) as! GenreCollectionViewCell
        cell.displayImageView.image = genre.displayImage
        
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
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("genreCell", forIndexPath: indexPath) as! GenreCollectionViewCell
        
        let cellInfo = genreInfo[indexPath.row]
        
        cell.displayImageView.image = cellInfo.displayImage
    
        return cell
    }
    
}
