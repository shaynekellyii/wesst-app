//
//  SchoolCell.swift
//  WESST
//
//  Created by Nathan Tannar on 2016-06-12.
//  Copyright © 2016 NathanTannar. All rights reserved.
//

import UIKit

class SchoolCell: UITableViewCell {
    
    @IBOutlet var name: UILabel!
    @IBOutlet var banner: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
