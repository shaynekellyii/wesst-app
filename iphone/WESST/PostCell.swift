//
//  ImageCell.swift
//  WESST
//
//  Created by Nathan Tannar on 2016-06-18.
//  Copyright © 2016 NathanTannar. All rights reserved.
//

import UIKit
import Former

final class PostCell: UITableViewCell, LabelFormableRow {
    
    // MARK: Public
    
    @IBOutlet var username: UILabel!
    @IBOutlet var info: UILabel!
    @IBOutlet var school: UILabel!
    @IBOutlet var date: UILabel!
    @IBOutlet var replies: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setHighlighted(highlighted: Bool, animated: Bool) {
        
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
    }
    
    func formTextLabel() -> UILabel? {
        return nil
    }
    
    func formSubTextLabel() -> UILabel? {
        return nil
    }
    
    func updateWithRowFormer(rowFormer: RowFormer) {}
    
    // MARK: Private
    
    private var iconViewColor: UIColor?
    
}