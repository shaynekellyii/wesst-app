//
//  Comment.swift
//  WESST
//
//  Created by Nathan Tannar on 2016-06-20.
//  Copyright © 2016 NathanTannar. All rights reserved.
//

import UIKit
import Parse
import ParseUI

final class Comment {
    
    static var new = Comment()
    
    var post: PFObject?
    var user: PFUser?
    var comment: String?
    var commentDate: NSDate?
    
    func clear() {
        Comment.new.post = nil
        Comment.new.user = nil
        Comment.new.comment = ""
    }
    
    func postComment() {
        if (comment != "" && comment != nil) {
            print(post)
            post?.addObject(comment!, forKey: "comments")
            post?.addObject(NSDate(), forKey: "commentsDate")
            post?.addObject(PFUser.currentUser()!, forKey: "commentsUser")
            post?.incrementKey("replies")
            post?.saveInBackground()
            
            comment = ""
        }
    }

}