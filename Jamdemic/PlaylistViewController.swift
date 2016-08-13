//
//  PlaylistViewController.swift
//  Jamdemic
//
//  Created by Matt Amerige on 8/12/16.
//  Copyright © 2016 crocodile. All rights reserved.
//

import UIKit

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
        "4AhkPaHUh0A",
        "b6uXy1KHjbk",
        "6qO7v7oMDhw",
        "Gj8BkwPPEFE"
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        playlistTableview.delegate = self
        playlistTableview.dataSource = self
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showVideoFromPlayButton" {
            let destinationVC = segue.destinationViewController as! VideoPlayerViewController
            destinationVC.videoIDs = testVideoIDs
        }
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
