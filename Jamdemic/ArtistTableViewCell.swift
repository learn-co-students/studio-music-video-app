//
//  ArtistTableViewCell.swift
//  Jamdemic
//
//  Created by Ismael Barry on 8/16/16.
//  Copyright © 2016 crocodile. All rights reserved.
//

import UIKit

class ArtistTableViewCell: UITableViewCell {

    @IBOutlet weak var albumArtImageView: UIImageView!
    
    @IBOutlet weak var artistNameLabel: UILabel!

    @IBOutlet weak var musicGenreForArtist: UILabel!
    
    @IBOutlet weak var likeIndicatorLabel: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
