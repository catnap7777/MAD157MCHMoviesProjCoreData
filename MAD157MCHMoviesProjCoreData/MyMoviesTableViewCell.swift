//
//  MyMoviesTableViewCell.swift
//  MAD157MCHMoviesProj
//
//  Created by Karen Mathes on 9/25/20.
//  Copyright © 2020 TygerMatrix Software. All rights reserved.
//

import UIKit

//.. Custom cell that's used for the list of my movies that come back from the PLIST of saved movies
class MyMoviesTableViewCell: UITableViewCell {

    @IBOutlet var myMovieName: UILabel!
    @IBOutlet var myMovieYear: UILabel!
    @IBOutlet var myMovieType: UILabel!
    @IBOutlet var myMovieImage: UIImageView!
    @IBOutlet var myMovieComments: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
