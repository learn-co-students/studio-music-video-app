//
//  PlaylistViewController.swift
//  Jamdemic
//
//  Created by Matt Amerige on 8/12/16.
//  Copyright © 2016 crocodile. All rights reserved.
//

import UIKit
import Firebase
import Alamofire
import SwiftyJSON
import NVActivityIndicatorView
import SCLAlertView
import QuartzCore



class PlaylistViewController: UIViewController {
    
    @IBOutlet weak var playlistTableview: UITableView!
    var playlistData: [PlaylistDetailInfo] = []
    var artistThumbnails: [String : UIImage] = [:]
    var videoIDs: [String] = []
    
  @IBOutlet weak var newSearchButton: UIButton!
    
  @IBOutlet weak var savePlaylistButton: UIButton!
   
    let photoQueue = NSOperationQueue()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        GIDSignIn.sharedInstance().uiDelegate = self
        
        playlistTableview.delegate = self
        playlistTableview.dataSource = self
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(savePlaylist), name: Notifications.userDidLogIn, object: nil)
        
        videoIDs = playlistData.map{ $0.videoID }
        
    
       
    }
    

    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showVideoFromPlayButton" {
            let destinationVC = segue.destinationViewController as! VideoPlayerViewController
            
            destinationVC.videoIDs = self.videoIDs
        }
        else if segue.identifier == "showVideoFromCell" {
            let destinationVC = segue.destinationViewController as! VideoPlayerViewController
            destinationVC.videoIDs = self.videoIDs
            if sender is UITableViewCell {
                let cell = sender as! UITableViewCell
                if let row = self.playlistTableview.indexPathForCell(cell)?.row {
                    destinationVC.currentVideoIndex = row
                    print("Showing video for row: \(row)")
                }
            }
        }
    }
    
    @IBAction func newSearchButtonTapped(sender: UIButton) {
       
        NSNotificationCenter.defaultCenter().postNotificationName(Notifications.newSearch, object: nil)
        self.navigationController?.popToRootViewControllerAnimated(true)
   
        
        
    }
    
}

//MARK: Tableview Methods
extension PlaylistViewController: UITableViewDelegate, UITableViewDataSource {
    
  
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return playlistData.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("videoCell", forIndexPath: indexPath) as! PlaylistTableViewCell
        
        let playlistItem = playlistData[indexPath.row]
        cell.artistSongTitleLabel.text = "\(playlistItem.name) - \(playlistItem.songTitle)"
        cell.artistSongTitleLabel.textColor = UIColor.blackColor()
    
       
        
        cell.thumbnailImageView.image = nil
        cell.thumbnailImageView.backgroundColor = UIColor.darkGrayColor()
        
        if let artistThumbnailImage = artistThumbnails[playlistItem.videoID] {
            // Artist thumbnail is cached
            cell.thumbnailImageView.image = artistThumbnailImage
            
           
        }
        else {
            // not cached, load image from the url on the photo queue
            photoQueue.addOperationWithBlock({
                
                guard let imageURL = NSURL(string: playlistItem.thumnailURLString) else { fatalError("Unable to create image URL") }
                
                guard let imageData = NSData(contentsOfURL: imageURL) else {
                    print("Unable to create image data from URL.")
                    return
                }
                
                NSOperationQueue.mainQueue().addOperationWithBlock({ 
                    guard let thumbnailImage = UIImage(data: imageData) else { fatalError("Unable to create UIImage from data") }
                    
                    // Check to see if the cell is still loaded
                    if tableView.cellForRowAtIndexPath(indexPath) != nil {
                        cell.thumbnailImageView.image = thumbnailImage
                    }
                    self.artistThumbnails[playlistItem.videoID] = thumbnailImage
                    
                })
            })
        }
        
        return cell
    }
}

extension PlaylistViewController: GIDSignInUIDelegate {
    
    func googleSignInWithYoutubeScope() {
        let youtubeScope = "https://www.googleapis.com/auth/youtube"
        GIDSignIn.sharedInstance().scopes.append(youtubeScope)
        GIDSignIn.sharedInstance().signIn()
        
        
    }
}

//MARK: Saving Playlists
extension PlaylistViewController {
    
    @IBAction func savePlaylistButtonTapped(sender: UIButton) {
        
        let hasYoutubeAuth = NSUserDefaults.standardUserDefaults().boolForKey("YoutubeAuthScope")
        
        if !hasYoutubeAuth {
            presentPermissionsDialog()
        }
        else {
            googleSignInWithYoutubeScope()
        }
    }
    
    func presentPermissionsDialog() {
        
        let alertAppearance = SCLAlertView.SCLAppearance(kTextFont: UIFont(name: "Avenir Next", size: 14)!, kButtonFont: UIFont(name: "Avenir Next", size: 14)!,showCloseButton: false)
        let alert = SCLAlertView(appearance: alertAppearance)
        alert.addButton("Cancel") { }
        alert.addButton("Allow") { 
            self.googleSignInWithYoutubeScope()
            NSUserDefaults.standardUserDefaults().setBool(true, forKey: "YoutubeAuthScope")
        }
        
        alert.showInfo("", subTitle: "Allow Studio to save playlists to your Youtube account?")
    }
    
    func savePlaylist() {
        
        let alertAppearance = SCLAlertView.SCLAppearance(kTextFont: UIFont(name: "Avenir Next", size: 14)!, kButtonFont: UIFont(name: "Avenir Next", size: 14)!, showCloseButton: false)
        let alert = SCLAlertView(appearance: alertAppearance)
        let title = alert.addTextField("Enter a title")
        alert.addButton("Cancel") { }
        alert.addButton("Save") {
            print("saving...")
            if let text = title.text {
                self.savePlaylistWithTitle(text)
            }
        }
        alert.showNotice("Save Playlist", subTitle: "")
    }
    
    func savePlaylistWithTitle(title: String) {
        
        startLoadingAnimation()
        // Should make a call to the YoutubeAPIClient to save the playlist to the current user's account
        GIDSignIn.sharedInstance().currentUser.authentication.getTokensWithHandler { (authObject, error) in
            if error == nil {
                PlaylistViewController.createPlaylistWithTitle(title, token: authObject.accessToken, completion: { (playlistID, playlistError) in
                    print(playlistID)
                    
                    if let playlistError = playlistError {
                        self.stopActivityAnimating()
                        self.displayErrorMessage(forError: playlistError)
                    }
                    else {
                        guard let playlistID = playlistID else { fatalError("Unable to unwrap playlist ID") }
                        
                        self.addVideosToPlaylist(playlistID)
                    }
                })
            }
        }
    }
    
    func addVideosToPlaylist(playlistID: String) {
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), {
            
            let requestGroup = dispatch_group_create()
            
            self.videoIDs.forEach({ (videoID) in
                // in microseconds (1 millionth of a second) interval. 170,000 microseconds is the smallest interval where all videos will be saved.
                usleep(170000)
                print("Request entering group")
                dispatch_group_enter(requestGroup)
                PlaylistViewController.insertVideoWithID(videoID, intoPlaylist: playlistID, completion: { error in
                    
                    dispatch_group_leave(requestGroup)
                    print("Request leaving group")
                })
            })
            dispatch_group_wait(requestGroup, DISPATCH_TIME_FOREVER)
            dispatch_async(dispatch_get_main_queue(), { 
                print("All videos saved to youtube!")
                self.stopActivityAnimating()
                self.displayFinishedAlert()
            })
        })
    }
    
    func displayFinishedAlert() {
        
        let alertAppearance = SCLAlertView.SCLAppearance(kTextFont: UIFont(name: "Avenir Next", size: 14)!, kButtonFont: UIFont(name: "Avenir Next", size: 14)!, showCloseButton: false)
        let alert = SCLAlertView(appearance: alertAppearance)
        alert.addButton("Okay") {}
        
        alert.showInfo("", subTitle: "Playlist saved to Youtube")
        
//        let alertController = UIAlertController(title: "Playlist Saved to Youtube", message: nil, preferredStyle: .Alert)
//        let okayAction = UIAlertAction(title: "Okay", style: .Default, handler: nil)
//        alertController.addAction(okayAction)
//        presentViewController(alertController, animated: true, completion: nil)
        
    }
}

//WARNING: This should be done in the YoutubeAPIClient when that is completed
//MARK: Youtube API Calls --
extension PlaylistViewController {
    
    class func createPlaylistWithTitle(title: String, token: String, completion: (String?, NSError?) -> Void) {
        
        let urlString = "https://www.googleapis.com/youtube/v3/playlists?part=snippet&fields=id%2Csnippet&key=\(Secrets.youtubeAPIKey)"
        
        
        let parameters = [
            "snippet" : ["title" : title]
        ]
        
        let headers = [
            "Authorization" : "Bearer \(token)",
            ]
        
        Alamofire.request(.POST, urlString, parameters: parameters, encoding: .JSON, headers: headers).validate().responseJSON { (response) in
            
            switch response.result {
            case .Success:
                guard let value = response.result.value else { fatalError("Unable to unwrap playlist post request value") }
                let json = JSON(value)
                let playlistID = json["id"].string
                completion(playlistID, nil)
            case .Failure(let error):
                print(error)
                print(error.localizedDescription)
                completion(nil, error)
            }
        }
        
        
    }
    
    class func insertVideoWithID(videoID: String, intoPlaylist playlistID: String, completion: NSError? -> Void) {
        
        let urlString = "https://www.googleapis.com/youtube/v3/playlistItems?part=snippet&key=\(Secrets.youtubeAPIKey)"
        
        let parameters = [
            "snippet" : ["playlistId" : playlistID,
                "resourceId" : ["videoId" : videoID,
                    "kind" : "youtube#video"]]
        ]
        
        let headers = [
            "Authorization" : "Bearer \(GIDSignIn.sharedInstance().currentUser.authentication.accessToken)"
        ]
        
        Alamofire.request(.POST, urlString, parameters: parameters, encoding: .JSON, headers: headers).validate().responseJSON { (response) in
            switch response.result {
            case .Success:
                print("Video Saved!")
                completion(nil)
            case .Failure(let error):
                print(error)
                completion(error)
            }
        }
    }
}


extension PlaylistViewController: NVActivityIndicatorViewable {
     func startLoadingAnimation() {
        startActivityAnimating(message: "Saving...", type: .LineScalePulseOutRapid)
    }
}

//MARK: Error messages
extension PlaylistViewController {
    
    func displayErrorMessage(forError error: NSError) {
        if error.code == NSURLErrorNotConnectedToInternet {
            SCLAlertView().showError("Oh no!", subTitle: error.localizedDescription)
        }
        else {
            SCLAlertView().showError("Oh no!", subTitle: "Something went wrong!")
        }
    }
    
}


