//
//  Feed.swift
//  WESST
//
//  Created by Nathan Tannar on 2016-06-19.
//  Copyright © 2016 NathanTannar. All rights reserved.
//

import UIKit
import Parse
import ParseUI

final class Post {
    
    static var new = Post()
    static var post = Post()
    
    var image: UIImage?
    var info: String?
    var user: PFUser?
    var replies: Int?
    var createdAt: NSDate?
    var comments: [String]?
    var commentsDate: [NSDate]?
    var commentsUsers: [PFUser]?
    var hasImage: Bool?
    
    func clear() {
        Post.new.info = ""
        Post.new.comments?.removeAll()
        Post.new.commentsDate?.removeAll()
        Post.new.commentsUsers?.removeAll()
        Post.new.replies = 0
        Post.new.hasImage = false
        Post.new.user = nil
    }
    
    func createPost() {
        if Post.new.info != "" {
            let newPost = PFObject(className: "Posts")
            newPost["info"] = Post.new.info
            newPost["comments"] = []
            newPost["commentsDate"] = []
            newPost["commentsUsers"] = []
            newPost["replies"] = 0
            newPost["user"] = PFUser.currentUser()
            if Post.new.hasImage == true {
                if Post.new.image!.size.width > 280 {
                    Post.new.image = Images.resizeImage(Post.new.image!, width: 280, height: 280)!
                }
                let pictureFile = PFFile(name: "picture.jpg", data: UIImageJPEGRepresentation(Post.new.image!, 0.6)!)
                pictureFile!.saveInBackgroundWithBlock { (succeeded: Bool, error: NSError?) -> Void in
                    if error == nil {
                        newPost["hasImage"] = true
                        newPost["image"] = pictureFile
                        newPost.saveInBackgroundWithBlock({ (success: Bool, error: NSError?) in
                            if error == nil {
                                Post.new.clear()
                            }
                        })
                    }
                }
            } else {
                newPost["hasImage"] = false
                newPost.saveInBackgroundWithBlock({ (success: Bool, error: NSError?) in
                    if error == nil {
                        Post.new.clear()
                    }
                })
            }
            
            
        }
    }
}
