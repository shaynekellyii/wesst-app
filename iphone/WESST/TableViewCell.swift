//
//  TableViewCell.swift
//  YikYak
//
//  Created by Shrikar Archak on 12/29/14.
//  Copyright (c) 2014 Shrikar Archak. All rights reserved.
//

import UIKit
import ParseUI

class TableViewCell: PFTableViewCell {

    @IBOutlet var trendText: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var replies: UILabel!
    
    @IBOutlet var hashtag: UILabel!
    @IBOutlet var colorDivider: UILabel!
    @IBOutlet var username: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
