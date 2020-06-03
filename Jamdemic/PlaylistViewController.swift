//
//  PlaylistViewController.swift
//  Jamdemic
//
//  Created by Matt Amerige on 8/12/16.
//  Copyright © 2016 crocodile. All rights reserved.


import UIKit
import Firebase
import Alamofire
import SwiftyJSON
import NVActivityIndicatorView
import SCLAlertView
import QuartzCore



class PlaylistViewController: UIViewController {

   // GIDSignInDelegate
    
    @IBOutlet weak var playlistTableview: UITableView!
    var playlistData: [PlaylistDetailInfo] = []
    var artistThumbnails: [String : UIImage] = [:]
    var videoIDs: [String] = []
    
  @IBOutlet weak var newSearchButton: UIButton!
    
  @IBOutlet weak var savePlaylistButton: UIButton!
   
    let photoQueue = OperationQueue()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        GIDSignIn.sharedInstance()?.delegate = self
        //delegate = self
       // uiDelegate = self
        
        playlistTableview.delegate = self
        playlistTableview.dataSource = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(savePlaylist), name: NSNotification.Name(rawValue: Notifications.userDidLogIn), object: nil)
        
        videoIDs = playlistData.map{ $0.videoID }
        
    
       
    }
    

    
    
    func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showVideoFromPlayButton" {
            let destinationVC = segue.destination as! VideoPlayerViewController
            
            destinationVC.videoIDs = self.videoIDs
        }
        else if segue.identifier == "showVideoFromCell" {
            let destinationVC = segue.destination as! VideoPlayerViewController
            destinationVC.videoIDs = self.videoIDs
            if sender is UITableViewCell {
                let cell = sender as! UITableViewCell
                if let row = self.playlistTableview.indexPath(for: cell)?.row {
                    destinationVC.currentVideoIndex = row
                    print("Showing video for row: \(row)")
                }
            }
        }
    }
    
    @IBAction func newSearchButtonTapped(sender: UIButton) {
       
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: Notifications.newSearch), object: nil)
        self.navigationController?.popToRootViewController(animated: true)
   
        
        
    }
    
}

//MARK: Tableview Methods
extension PlaylistViewController: UITableViewDelegate, UITableViewDataSource {
  
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return playlistData.count
    }
    
    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "videoCell", for: indexPath as IndexPath) as! PlaylistTableViewCell
        
        let playlistItem = playlistData[indexPath.row]
        cell.artistSongTitleLabel.text = "\(playlistItem.name) - \(playlistItem.songTitle)"
        cell.artistSongTitleLabel.textColor = UIColor.black
    
       
        
        cell.thumbnailImageView.image = nil
        cell.thumbnailImageView.backgroundColor = UIColor.darkGray
        
        if let artistThumbnailImage = artistThumbnails[playlistItem.videoID] {
            // Artist thumbnail is cached
            cell.thumbnailImageView.image = artistThumbnailImage
            
           
        }
        else {
            // not cached, load image from the url on the photo queue
            photoQueue.addOperation({
                
                guard let imageURL = NSURL(string: playlistItem.thumnailURLString) else { fatalError("Unable to create image URL") }
                
                guard let imageData = NSData(contentsOf: imageURL as URL) else {
                    print("Unable to create image data from URL.")
                    return
                }
                
                OperationQueue.main.addOperation({
                    guard let thumbnailImage = UIImage(data: imageData as Data) else { fatalError("Unable to create UIImage from data") }
                    
                    // Check to see if the cell is still loaded
                    if tableView.cellForRow(at: indexPath) != nil {
                        cell.thumbnailImageView.image = thumbnailImage
                    }
                    self.artistThumbnails[playlistItem.videoID] = thumbnailImage
                    
                })
            })
        }
        
        return cell
    }
}

extension PlaylistViewController: GIDSignInDelegate {
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        print("sign in")
    }
    
    
    func googleSignInWithYoutubeScope() {
        let youtubeScope = "https://www.googleapis.com/auth/youtube"
        GIDSignIn.sharedInstance().scopes.append(youtubeScope)
        GIDSignIn.sharedInstance().signIn()
        
        
    }
}

//MARK: Saving Playlists
extension PlaylistViewController {
    
    @IBAction func savePlaylistButtonTapped(sender: UIButton) {
        
        let hasYoutubeAuth = UserDefaults.standard.bool(forKey: "YoutubeAuthScope")
        
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
            UserDefaults.standard.set(true, forKey: "YoutubeAuthScope")
        }
        
        alert.showInfo("", subTitle: "Allow Studio to save playlists to your Youtube account?")
    }
    
    @objc func savePlaylist() {
        
        let alertAppearance = SCLAlertView.SCLAppearance(kTextFont: UIFont(name: "Avenir Next", size: 14)!, kButtonFont: UIFont(name: "Avenir Next", size: 14)!, showCloseButton: false)
        let alert = SCLAlertView(appearance: alertAppearance)
        let title = alert.addTextField("Enter a title")
        alert.addButton("Cancel") { }
        alert.addButton("Save") {
            print("saving...")
            if let text = title.text {
                self.savePlaylistWithTitle(title: text)
            }
        }
        alert.showNotice("Save Playlist", subTitle: "")
    }
    
    func savePlaylistWithTitle(title: String) {
        
        startLoadingAnimation()
        // Should make a call to the YoutubeAPIClient to save the playlist to the current user's account
       
        GIDSignIn.sharedInstance().currentUser.authentication.getTokensWithHandler { (authObject, error) in
            guard let authObject = authObject?.accessToken else { return }
            if error == nil {
                PlaylistViewController.createPlaylistWithTitle(title: title, token: authObject , completion: { (playlistID, playlistError) in
                    print(playlistID)
                    
                    if let playlistError = playlistError {
                        self.stopAnimating()
                        self.displayErrorMessage(forError: playlistError)
                    }
                    else {
                        guard let playlistID = playlistID else { fatalError("Unable to unwrap playlist ID") }
                        
                        self.addVideosToPlaylist(playlistID: playlistID)
                    }
                })
            }
        }
    }
    
    func addVideosToPlaylist(playlistID: String) {
        
       // dispatch_async(dispatch_get_global_queue(DispatchQueue.GlobalQueuePriority.high, 0), {
        DispatchQueue.global(qos: .background).async {
            let requestGroup = DispatchGroup()
            
            self.videoIDs.forEach({ (videoID) in
                // in microseconds (1 millionth of a second) interval. 170,000 microseconds is the smallest interval where all videos will be saved.
                usleep(170000)
                print("Request entering group")
                requestGroup.enter()
                PlaylistViewController.insertVideoWithID(videoID: videoID, intoPlaylist: playlistID, completion: { error in
                    
                    requestGroup.leave()
                    print("Request leaving group")
                })
            })
            requestGroup.wait(timeout: .distantFuture)
            DispatchQueue.main.async {
                print("All videos saved to youtube!")
                self.stopAnimating()
                self.displayFinishedAlert()
            }
        }
    }
    
    func displayFinishedAlert() {
        
        let alertAppearance = SCLAlertView.SCLAppearance(kTextFont: UIFont(name: "Avenir Next", size: 14)!, kButtonFont: UIFont(name: "Avenir Next", size: 14)!, showCloseButton: false)
        let alert = SCLAlertView(appearance: alertAppearance)
        alert.addButton("Okay") {}
        
        alert.showInfo("", subTitle: "Playlist saved to Youtube")
                
    }
}

//WARNING: This should be done in the YoutubeAPIClient when that is completed
//MARK: Youtube API Calls --
extension PlaylistViewController {
    
    class func createPlaylistWithTitle(title: String, token: String, completion: @escaping (String?, NSError?) -> Void) {
        
        let urlString = "https://www.googleapis.com/youtube/v3/playlists?part=snippet&fields=id%2Csnippet&key=\(Secrets.youtubeAPIKey)"
        
        
        let parameters = [
            "snippet" : ["title" : title]
        ]
        
        let headers = [
            "Authorization" : "Bearer \(token)",
            ]
        //.JSON
        Alamofire.request(urlString, method: .post, parameters: parameters, encoding: URLEncoding(destination: .queryString), headers: headers).validate().responseJSON { (response) in
            
            switch response.result {
            case .success:
                guard let value = response.result.value else { fatalError("Unable to unwrap playlist post request value") }
                let json = JSON(value)
                let playlistID = json["id"].string
                completion(playlistID, nil)
            case .failure(let error):
                print(error)
                print(error.localizedDescription)
                completion(nil, error as NSError)
            }
        }
        
        
    }
    
    class func insertVideoWithID(videoID: String, intoPlaylist playlistID: String, completion: @escaping (NSError?) -> Void) {
        
        let urlString = "https://www.googleapis.com/youtube/v3/playlistItems?part=snippet&key=\(Secrets.youtubeAPIKey)"
        
        let parameters = [
            "snippet" : ["playlistId" : playlistID,
                "resourceId" : ["videoId" : videoID,
                    "kind" : "youtube#video"]]
        ]
        
        let headers = [
            "Authorization" : "Bearer \(String(describing: GIDSignIn.sharedInstance().currentUser.authentication.accessToken))"
        ]
        
        Alamofire.request(urlString, method: .post, parameters: parameters, encoding: URLEncoding(destination: .queryString), headers: headers).validate().responseJSON { (response) in
            switch response.result {
            case .success(let success):
                print("Video Saved!\(success)")
                completion(nil)
            case .failure(let error):
                print(error)
                completion(error as NSError)
            }
        }
    }
}


extension PlaylistViewController: NVActivityIndicatorViewable {
     func startLoadingAnimation() {
        startAnimating(message: "Saving...", type: .lineScalePulseOutRapid)
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


