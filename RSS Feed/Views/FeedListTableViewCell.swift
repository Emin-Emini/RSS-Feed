//
//  FeedListTableViewCell.swift
//  RSS Feed
//
//  Created by Emin Emini on 5.6.21.
//

import UIKit

class FeedListTableViewCell: UITableViewCell {

    //MARK: Outlets
    @IBOutlet weak var feedTitle: UILabel!
    @IBOutlet weak var feedImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
