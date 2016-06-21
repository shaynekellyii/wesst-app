//
//  CommentTableViewCell.swift
//  MainStream
//
//  Created by Nathan Tannar on 2016-03-31.
//  Copyright © 2016 Shrikar Archak. All rights reserved.
//

import UIKit

class CommentTableViewCell: UITableViewCell {

    @IBOutlet var username: UILabel!
    @IBOutlet var comment: UILabel!
    @IBOutlet var commentDate: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
