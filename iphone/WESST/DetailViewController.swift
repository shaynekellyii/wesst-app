//
//  DetailViewController.swift
//  YikYak
//
//  Created by Shrikar Archak on 1/6/15.
//  Copyright (c) 2015 Shrikar Archak. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class DetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextViewDelegate {

    var post: PFObject?
    var comments: [String]?
    var commentsDate: [NSDate]?
    var commentsUser: [PFUser]?
    
    
    @IBOutlet var trendLabel: UITextView!
    @IBOutlet var username: UILabel!
    @IBOutlet var postDate: UILabel!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var comment: UITextField!
    @IBOutlet var replyButton: UIButton!
    @IBOutlet var school: UILabel!
    
    
    @IBAction func done(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    @IBAction func addComment(sender: AnyObject) {
        if (comment.text! != "") {
            post?.addObject(comment.text!, forKey: "comments")
            post?.addObject(NSDate(), forKey: "commentsDate")
            post?.addObject(PFUser.currentUser()!, forKey: "commentsUser")
            post?.incrementKey("replies")
            post?.saveInBackground()
            
            comments?.insert(comment.text!, atIndex: 0)
            commentsDate?.insert(NSDate(), atIndex: 0)
            commentsUser?.insert(PFUser.currentUser()!, atIndex: 0)
            comment.text = ""
            
            self.comment.resignFirstResponder()
            self.tableView.reloadData()
        }
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.comment.resignFirstResponder()
        return true
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        /* Setup the photo
        imageView.layer.cornerRadius = imageView.frame.size.width / 2
        imageView.layer.masksToBounds = true
        let userImageFile = post?.valueForKey("postUserImage") as! PFFile
        userImageFile.getDataInBackgroundWithBlock {
            (imageData: NSData?, error: NSError?) -> Void in
            if error == nil {
                if let imageData = imageData {
                    self.imageView.image = UIImage(data: imageData)
                }
            }
        }
        */
               
        
        /* Setup the datasource delegate */
        tableView.delegate = self
        tableView.dataSource = self
        
        /* Setup the contentInsets */
        self.tableView.estimatedRowHeight = 70
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.trendLabel.sizeToFit()
        
        self.edgesForExtendedLayout = UIRectEdge.None
        /* Make sure the content doesn't go below tabbar/navbar */
        self.extendedLayoutIncludesOpaqueBars = true
        
        self.automaticallyAdjustsScrollViewInsets = false

        
        if(post?.objectForKey("comments") != nil) {
            comments = post?.objectForKey("comments") as? [String]
            commentsUser = post?.objectForKey("commentsUser") as? [PFUser]
            commentsDate = post?.objectForKey("commentsDate") as? [NSDate]
            comments = comments?.reverse()
            commentsDate = commentsDate?.reverse()
            commentsUser = commentsUser?.reverse()
        }
        self.trendLabel.text = post?.objectForKey("info") as? String
        
        //self.username.text = "\(trend!.objectForKey("user")!)"
        //self.school.text = "\(trend!.objectForKey("school")!)"
        
        let date = post?.createdAt
        var interval = NSDate().minutesAfterDate(date)
        var dateString = ""
        if interval < 60 {
            if interval <= 1 {
                dateString = "Now"
            }
            else {
                dateString = "\(interval) minutes ago"
            }
        }
        else {
            interval = NSDate().hoursAfterDate(date)
            if interval < 24 {
                if interval <= 1 {
                    dateString = "1 hour ago"
                }
                else {
                    dateString = "\(interval) hours ago"
                }
            }
            else {
                interval = NSDate().daysAfterDate(date)
                if interval <= 1 {
                    dateString = "1 day ago"
                }
                else {
                    dateString = "\(interval) days ago"
                }
            }
        }
        self.postDate.text = dateString
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let count = comments?.count {
            return count
        }
        return 0
    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("commentCell", forIndexPath: indexPath) as! CommentTableViewCell
        
        //cell.username.text = commentsUser![indexPath.row]
        cell.comment.text = comments![indexPath.row]
        
        let date = commentsDate![indexPath.row]
        var interval = NSDate().minutesAfterDate(date)
        
        var dateString = ""
        if interval < 60 {
            if interval == 0 {
                dateString = "Now"
            }
            else if interval <= 1 {
                dateString = "1 minutes ago"
            }
            else {
                dateString = "\(interval) minutes ago"
            }
        }
        else {
            interval = NSDate().hoursAfterDate(date)
            if interval < 24 {
                if interval <= 1 {
                    dateString = "1 hour ago"
                }
                else {
                    dateString = "\(interval) hours ago"
                }
            }
            else {
                interval = NSDate().daysAfterDate(date)
                if interval <= 1 {
                    dateString = "1 day ago"
                }
                else {
                    dateString = "\(interval) days ago"
                }
            }
        }
        
        cell.commentDate.text = dateString
        return cell
    }
    
}
