//
//  SchoolCell.swift
//  WESST
//
//  Created by Nathan Tannar on 2016-06-12.
//  Copyright © 2016 NathanTannar. All rights reserved.
//

import UIKit
import Parse

class ConferencesTableViewController: UITableViewController {
    
    let conferences = ["Western Engineering Competition", "Executives Meeting", "Retreat & Olympics"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if PFUser.currentUser() == nil {
            Utilities.loginUser(self)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidAppear(animated: Bool) {
        self.tableView.reloadData()
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return conferences.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("conference", forIndexPath: indexPath) as! ConferenceCell
        
        cell.name.text = conferences[indexPath.row]
        cell.banner.image = UIImage(named: "esss_and_wesst copy.png")
        
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let indexPath = self.tableView.indexPathForSelectedRow
        let obj = conferences[indexPath!.row]
        let detailVC = segue.destinationViewController as! ConferenceViewController
        detailVC.conference = obj
    }
    
    
}
