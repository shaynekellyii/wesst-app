//
//  SchoolCell.swift
//  WESST
//
//  Created by Nathan Tannar on 2016-06-12.
//  Copyright © 2016 NathanTannar. All rights reserved.
//

import UIKit
import Parse

class SchoolsTableViewController: UITableViewController {
    
    let schools = ["University of Victoria", "UBC Vancouver", "UBC Okanagan", "SFU Burnaby", "SFU Surrey", "BCIT", "UNBC", "University of Calgary", "University of Alberta", "University of Saskatchewan", "University of Regina", "University of Manitoba"]
    
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
        return schools.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("school", forIndexPath: indexPath) as! SchoolCell
        
        cell.name.text = schools[indexPath.row]
        cell.banner.image = UIImage(named: "esss_and_wesst copy.png")
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let indexPath = self.tableView.indexPathForSelectedRow
        let obj = schools[indexPath!.row]
        let schoolVC = SchoolViewController()
        schoolVC.schoolName = obj
        self.navigationController?.pushViewController(schoolVC, animated: true)
    }
}
