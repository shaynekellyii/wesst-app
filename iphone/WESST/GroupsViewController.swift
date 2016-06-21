//
//  GroupViewController.swift
//  SwiftParseChat
//
//  Created by Jesse Hu on 2/20/15.
//  Copyright (c) 2015 Jesse Hu. All rights reserved.
//

import UIKit
import Parse

class GroupsViewController: UITableViewController, UIAlertViewDelegate {
    
    var groups: [PFObject]! = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl!.attributedTitle = NSAttributedString(string: "Pull to refresh")
        self.refreshControl!.addTarget(self, action: #selector(GroupsViewController.loadGroups), forControlEvents: .ValueChanged)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if PFUser.currentUser() != nil {
            self.loadGroups()
        }
        else {
            Utilities.loginUser(self)
        }
    }
    
    func loadGroups() {
        let query = PFQuery(className: PF_GROUPS_CLASS_NAME)
        query.findObjectsInBackgroundWithBlock { (objects: [PFObject]?, error: NSError?)
            -> Void in
            if error == nil {
                self.groups.removeAll()
                self.groups.appendContentsOf(objects as [PFObject]!)
                self.tableView.reloadData()
            } else {
                print("Network error")
                print(error)
            }
            self.refreshControl!.endRefreshing()
        }
    }
    
    @IBAction func newButtonPressed(sender: UIBarButtonItem) {
        self.actionNew()
    }
    
    func actionNew() {
        let alert = UIAlertView(title: "Please enter a name for your group", message: "", delegate: self, cancelButtonTitle: "Cancel", otherButtonTitles: "OK")
        alert.alertViewStyle = UIAlertViewStyle.PlainTextInput
        alert.show()
    }
    
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        if buttonIndex != alertView.cancelButtonIndex {
            let textField = alertView.textFieldAtIndex(0);
            if let text = textField!.text {
                if text.length > 0 {
                    let object = PFObject(className: PF_GROUPS_CLASS_NAME)
                    object[PF_GROUPS_NAME] = text
                    object.saveInBackgroundWithBlock({ (success: Bool, error: NSError?) -> Void in
                        if success {
                            self.loadGroups()
                        } else {
                            print("Network error")
                            print(error)
                        }
                    })
                }
            }
        }
    }
    
    // MARK: - TableView Data Source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.groups.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell")! as UITableViewCell
        
        let group = self.groups[indexPath.row]
        cell.textLabel?.text = group[PF_GROUPS_NAME] as? String
        
        let query = PFQuery(className: PF_CHAT_CLASS_NAME)
        query.whereKey(PF_CHAT_GROUPID, equalTo: group.objectId!)
        query.orderByDescending(PF_CHAT_CREATEDAT)
        query.limit = 1000
        query.findObjectsInBackgroundWithBlock { (objects: [PFObject]?, error: NSError?) -> Void in
            if let chat = objects![0] as? PFObject {
                let date = NSDate()
                let seconds = date.timeIntervalSinceDate(chat.createdAt!)
                let elapsed = Utilities.timeElapsed(seconds);
                let countString = (objects!.count > 1) ? "\(objects!.count) messages" : "\(objects!.count) message"
                cell.detailTextLabel?.text = "\(countString) \(elapsed)"
            } else {
                cell.detailTextLabel?.text = "0 messages"
            }
            cell.detailTextLabel?.textColor = UIColor.lightGrayColor()
        }
        
        return cell
    }
    
    // MARK: - TableView Delegate
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let group = self.groups[indexPath.row]
        let groupId = group.objectId! as String
        
        Messages.createMessageItem(PFUser.currentUser()!, groupId: groupId, description: group[PF_GROUPS_NAME] as! String)
        
        self.performSegueWithIdentifier("groupChatSegue", sender: groupId)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "groupChatSegue" {
            let chatVC = segue.destinationViewController as! ChatViewController
            chatVC.hidesBottomBarWhenPushed = true
            let groupId = sender as! String
            chatVC.groupId = groupId
        }
    }
}

extension String {
    var length: Int {
        return (self as NSString).length
    }
}