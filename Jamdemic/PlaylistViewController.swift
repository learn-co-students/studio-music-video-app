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
    
    let testArtistSongDictionary = [
        "Calvin Harris" : "This Is What You Came For (Official Video) ft. Rihanna",
        "Major Lazer" : "Cold Water (feat. Justin Bieber & MØ)",
        "Andra" : "Why",
        "Justin Bieber" : "Sorry",
        "Fifth Harmony" : "Work from Home ft. Ty Dolla $ign",
        "The Chainsmokers" : "Closer (Lyric) ft. Halsey",
        "Katy Perry" : "Rise",
        "Shawn Mendes" : "Treat You Better",
        "Rihanna ft. Drake" : "Work"
    ]
    
    let thumbnails = [
        UIImage(named: "hqdefault-0.jpg"),
        UIImage(named: "hqdefault-1.jpg"),
        UIImage(named: "hqdefault-3.jpg"),
        UIImage(named: "hqdefault-4.jpg"),
        UIImage(named: "hqdefault-5.jpg"),
        UIImage(named: "hqdefault-6.jpg"),
        UIImage(named: "hqdefault-7.jpg"),
        UIImage(named: "hqdefault-8.jpg"),
        UIImage(named: "hqdefault-9.jpg"),
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        playlistTableview.delegate = self
        playlistTableview.dataSource = self
    }

}

//MARK: Tableview Methods
extension PlaylistViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return testArtistSongDictionary.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("videoCell", forIndexPath: indexPath) as! PlaylistTableViewCell
        
        let artistName = Array(testArtistSongDictionary.keys)[indexPath.row]
        
        cell.thumbnailImageView.image = thumbnails[indexPath.row]
        if let title = testArtistSongDictionary[artistName] {
            cell.artistSongTitleLabel.text = "\(artistName) - \(title)"
        }
        
        return cell
    }
    
}
