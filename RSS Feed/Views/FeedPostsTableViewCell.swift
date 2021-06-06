//
//  FeedTableViewCell.swift
//  RSS Feed
//
//  Created by Emin Emini on 5.6.21.
//

import UIKit

class FeedPostsTableViewCell: UITableViewCell {

    //MARK: Outlets
    @IBOutlet weak var feedImage: UIImageView!
    @IBOutlet weak var feedTitle: UILabel!
    @IBOutlet weak var feedDescription: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
