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

class PlaylistViewController: UIViewController {
    
    @IBOutlet weak var playlistTableview: UITableView!
    
    let testData = [
        PlaylistTestData(name: "Calvin Harris", songName: "This Is What You Came For (Official Video) ft. Rihanna", image: UIImage(named: "hqdefault-0.jpg")!),
        PlaylistTestData(name: "Major Lazer", songName: "Cold Water (feat. Justin Bieber & MØ)", image: UIImage(named: "hqdefault-1.jpg")!),
        PlaylistTestData(name: "Andra", songName: "Why", image: UIImage(named: "hqdefault-3.jpg")!),
        PlaylistTestData(name: "Justin Bieber", songName: "Sorry", image: UIImage(named: "hqdefault-4.jpg")!),
        PlaylistTestData(name: "Fifth Harmony", songName: "Work from Home ft. Ty Dolla $ign", image: UIImage(named: "hqdefault-5.jpg")!),
        PlaylistTestData(name: "The Chainsmokers", songName: "Closer (Lyric) ft. Halsey", image: UIImage(named: "hqdefault-6.jpg")!),
        PlaylistTestData(name: "Katy Perry", songName: "Rise", image: UIImage(named: "hqdefault-7.jpg")!),
        PlaylistTestData(name: "Shawn Mendes", songName: "Treat You Better", image: UIImage(named: "hqdefault-8.jpg")!),
        PlaylistTestData(name: "Rihanna ft. Drake", songName: "Work", image: UIImage(named: "hqdefault-9.jpg")!)
    ]
    
    let testVideoIDs = [
        "kOkQ4T5WO9E",
        "a59gmGkq_pw",
        "rhcc1KQlCS4",
        "fRh_vgS2dFE",
        "5GL9JoH4Sws",
        "PT2_F-1esPk",
        "hdw1uKiTI5c",
        "lY2yjAdbvdQ",
        "HL1UzIK-flA"
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self
        googleSignInWithYoutubeScope()
        
        playlistTableview.delegate = self
        playlistTableview.dataSource = self
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showVideoFromPlayButton" {
            let destinationVC = segue.destinationViewController as! VideoPlayerViewController
            destinationVC.videoIDs = testVideoIDs
        }
        else if segue.identifier == "showVideoFromCell" {
            let destinationVC = segue.destinationViewController as! VideoPlayerViewController
            destinationVC.videoIDs = testVideoIDs
            if sender is UITableViewCell {
                let cell = sender as! UITableViewCell
                if let row = self.playlistTableview.indexPathForCell(cell)?.row {
                    destinationVC.currentVideoIndex = row
                    print("Showing video for row: \(row)")
                }
            }
        }
    }
    
        // For Testing only
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        
        //        if FIRAuth.auth()?.currentUser == nil {
        //            let storyboard = UIStoryboard(name: "GoogleSignIn", bundle: nil)
        //            let signInVC = storyboard.instantiateViewControllerWithIdentifier("SignInViewController") as! SignInViewController
        //            self.presentViewController(signInVC, animated: true, completion: nil)
        //        }
    }
}

//MARK: Tableview Methods
extension PlaylistViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return testData.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("videoCell", forIndexPath: indexPath) as! PlaylistTableViewCell
        
        let testInfo = testData[indexPath.row]
        
        cell.thumbnailImageView.image = testInfo.thumbnailImage
        cell.artistSongTitleLabel.text = "\(testInfo.artistName) - \(testInfo.songName)"
        
        return cell
    }
}

extension PlaylistViewController: GIDSignInDelegate, GIDSignInUIDelegate {
    
    func signIn(signIn: GIDSignIn!, didSignInForUser user: GIDGoogleUser!, withError error: NSError!) {
        if error == nil {
            print("Successfully signed in")
            print("Current scopes: \(GIDSignIn.sharedInstance().scopes)")
            print("Access token for youtube: \(GIDSignIn.sharedInstance().currentUser.authentication.accessToken)")
        }
    }
    
    func googleSignInWithYoutubeScope() {
        let driveScope = "https://www.googleapis.com/auth/youtube"
        GIDSignIn.sharedInstance().scopes.append(driveScope)
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

            savePlaylist()
        }
    }
    
    func presentPermissionsDialog() {
        let alertcontroller = UIAlertController(title: "Allow Jamdemic to save playlists to your Youtube account?", message: nil, preferredStyle: .Alert)
        
        let allowAction = UIAlertAction(title: "Allow", style: .Default, handler: { action in
            self.googleSignInWithYoutubeScope()
            NSUserDefaults.standardUserDefaults().setBool(true, forKey: "YoutubeAuthScope")
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        alertcontroller.addAction(allowAction)
        alertcontroller.addAction(cancelAction)
        self.presentViewController(alertcontroller, animated: true, completion: nil)
    }
    
    func savePlaylist() {
        // Should make a call to the YoutubeAPIClient to save the playlist to the current user's account
        GIDSignIn.sharedInstance().currentUser.authentication.getTokensWithHandler { (authObject, error) in
            if error == nil {
                PlaylistViewController.createPlaylistWithTitle("My Title", token: authObject.accessToken, completion: { (playlistID) in
                    
                })
            }
        }
        
    }
}

//WARNING: This should be done in the YoutubeAPIClient when that is completed
//MARK: Youtube API Calls --
extension PlaylistViewController {
    
    class func createPlaylistWithTitle(title: String, token: String, completion: String? -> Void) {
        
        let key = "AIzaSyDEsBB01SSKFvf9Ypx5wehcQ3V1PTTH3Uk"
        let baseURLString = "https://www.googleapis.com/youtube/v3/playlists?part=snippet&fields=id%2Csnippet&key=\(key)"
        
        
        let parameters = [
            "snippet" : ["title" : title]
        ]
        
        let headers = [
             "Authorization" : "Bearer \(token)",
        ]

        print("Access token for youtube: \(GIDSignIn.sharedInstance().currentUser.authentication.accessToken)")
       
        Alamofire.request(.POST, baseURLString, parameters: parameters, encoding: .JSON, headers: headers).responseJSON { (response) in
            print(response)
        }
        
    }
    
    class func insertVideoWithID(videoID: String, intoPlaylist playlistID: String, completion: Void -> Void) {
        
    }
}


