//
//  ConferenceViewController.swift
//  WESST
//
//  Created by Nathan Tannar on 2016-06-13.
//  Copyright © 2016 NathanTannar. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class ConferenceViewController: UIViewController {
    
    var conference: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = conference
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    
    
}

