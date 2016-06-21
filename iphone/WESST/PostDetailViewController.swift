//
//  PostDetailViewController.swift
//  WESST
//
//  Created by Nathan Tannar on 2016-06-19.
//  Copyright © 2016 NathanTannar. All rights reserved.
//

import UIKit
import Parse
import ParseUI
import Former
import Agrume

class PostDetailViewController: FormViewController {
    
    var post: PFObject?
    var comments: [String]?
    var commentsDate: [NSDate]?
    var commentsUser: [PFUser]?
    var postUser: PFObject?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Post Comment", style: .Plain, target: self, action: #selector(addComment))
        
        if(post?.objectForKey("comments") != nil) {
            comments = post?.objectForKey("comments") as? [String]
            commentsUser = post?.objectForKey("commentsUser") as? [PFUser]
            commentsDate = post?.objectForKey("commentsDate") as? [NSDate]
        }
        
        let userQuery = PFUser.query()
        do {
            postUser = try userQuery?.findObjects().first
            
        } catch _ {
            print("Error in finding User")
        }
        
        configure()
    }
    
    func addComment(sender: UIBarButtonItem) {
        if Comment.new.comment != "" {
            Comment.new.postComment()
            Comment.new.clear()
            former.removeAllUpdate(.Top)
            configure()
        }
    }
    
    // MARK: Private
    
    private lazy var formerInputAccessoryView: FormerInputAccessoryView = FormerInputAccessoryView(former: self.former)
    
    private lazy var zeroRow: LabelRowFormer<ImageCell> = {
        LabelRowFormer<ImageCell>(instantiateType: .Nib(nibName: "ImageCell")) {_ in
            }.configure {
                $0.rowHeight = 0
        }
    }()
    
    let createHeader: (String -> ViewFormer) = { text in
        return LabelViewFormer<FormLabelHeaderView>()
            .configure {
                $0.viewHeight = 40
                $0.text = text
        }
    }
    
    let createFooter: (String -> ViewFormer) = { text in
        return LabelViewFormer<FormLabelFooterView>()
            .configure {
                $0.text = text
                $0.viewHeight = 40
        }
    }
    
    private func configure() {
        title = ""
        tableView.contentInset.top = 0
        tableView.contentInset.bottom = 20
        
        let zeroSection = SectionFormer(rowFormer: zeroRow)
        
        former.append(sectionFormer: zeroSection)
        
        let imageToBeLoaded = postUser!["picture"] as? PFFile
        if imageToBeLoaded != nil {
            imageToBeLoaded!.getDataInBackgroundWithBlock {(imageData: NSData?, error: NSError?) -> Void in
                if error == nil {
                    if let imageData = imageData {
                        
                        let detailPostRow = CustomRowFormer<DetailPostCell>(instantiateType: .Nib(nibName: "DetailPostCell")) {
                            $0.username.text = self.postUser!["fullname"] as? String
                            $0.info.font = .systemFontOfSize(16)
                            $0.info.text = self.post!["info"] as? String
                            $0.school.text =  self.postUser!["school"] as? String
                            $0.iconView.image = UIImage(data: imageData)
                            $0.iconView.layer.borderWidth = 1
                            $0.iconView.layer.masksToBounds = false
                            $0.iconView.layer.borderColor = UIColor.whiteColor().CGColor
                            $0.iconView.clipsToBounds = true
                            $0.iconView.layer.borderWidth = 2
                            $0.iconView.layer.borderColor = UIColor(red: 153.0/255, green:62.0/255.0, blue:123.0/255, alpha: 1).CGColor
                            $0.iconView.layer.cornerRadius = $0.iconView.frame.height/2                            
                            
                            var interval = NSDate().minutesAfterDate(self.post!.createdAt)
                            
                            var dateString = ""
                            if interval < 60 {
                                if interval <= 1 {
                                    dateString = "1 minute ago"
                                }
                                else {
                                    dateString = "\(interval) minutes ago"
                                }
                            }
                            else {
                                interval = NSDate().hoursAfterDate(self.post!.createdAt)
                                if interval < 24 {
                                    if interval <= 1 {
                                        dateString = "1 hour ago"
                                    }
                                    else {
                                        dateString = "\(interval) hours ago"
                                    }
                                }
                                else {
                                    interval = NSDate().daysAfterDate(self.post!.createdAt)
                                    if interval <= 1 {
                                        dateString = "1 day ago"
                                    }
                                    else {
                                        dateString = "\(interval) days ago"
                                    }
                                }
                            }
                            $0.date.text = dateString
                            
                            }.configure {
                                $0.rowHeight = UITableViewAutomaticDimension
                        }
                        let postSection = SectionFormer(rowFormer: detailPostRow)
                        self.former.append(sectionFormer: postSection)
                        
                        if  self.post!["hasImage"] as? Bool == true {
                            let imageToBeLoaded = self.post!["image"] as? PFFile
                            if imageToBeLoaded != nil {
                                imageToBeLoaded!.getDataInBackgroundWithBlock {(imageData: NSData?, error: NSError?) -> Void in
                                    if error == nil {
                                        if let imageData = imageData {
                                            var postImageRow = [LabelRowFormer<ImageCell>(instantiateType: .Nib(nibName: "ImageCell")) {
                                                $0.displayImage.image = UIImage(data:imageData)!
                                                }.configure {
                                                    $0.rowHeight = 200
                                                }.onSelected({ (cell: LabelRowFormer<ImageCell>) in
                                                    let agrume = Agrume(image: cell.cell.displayImage.image!)
                                                    agrume.showFrom(self)
                                                })]
                                            self.former.insert(rowFormer: postImageRow[0], below: detailPostRow)
                                            self.former.reload()

                                        }
                                    }
                                }
                            }
                        }
                        
                        print(self.comments!)
                        var commentRows = [CustomRowFormer<DynamicHeightCell>]()
                        var index = 0
                        for comment in self.comments! {
                            commentRows.append(CustomRowFormer<DynamicHeightCell>(instantiateType: .Nib(nibName: "DynamicHeightCell")) {
                                var username = ""
                                let userQuery = PFUser.query()
                                do {
                                    let user = try userQuery?.findObjects()
                                    
                                    username = user![0].valueForKey("fullname")! as! String
                                    
                                } catch _ {
                                    print("Error in finding User")
                                }
                                
                                
                                $0.title = username
                                var interval = NSDate().minutesAfterDate(self.commentsDate![index - 1])
                                
                                var dateString = ""
                                if interval < 60 {
                                    if interval <= 1 {
                                        dateString = "1 minute ago"
                                    }
                                    else {
                                        dateString = "\(interval) minutes ago"
                                    }
                                }
                                else {
                                    interval = NSDate().hoursAfterDate(self.commentsDate![index])
                                    if interval < 24 {
                                        if interval <= 1 {
                                            dateString = "1 hour ago"
                                        }
                                        else {
                                            dateString = "\(interval) hours ago"
                                        }
                                    }
                                    else {
                                        interval = NSDate().daysAfterDate(self.commentsDate![index])
                                        if interval <= 1 {
                                            dateString = "1 day ago"
                                        }
                                        else {
                                            dateString = "\(interval) days ago"
                                        }
                                    }
                                }
                                $0.date = dateString
                                $0.body = comment
                                }.configure {
                                    $0.rowHeight = UITableViewAutomaticDimension
                                })
                            
                            index += 1
                            
                        }
                        print(index)
                        if index != 0 {
                            self.former.append(sectionFormer: SectionFormer(rowFormers: commentRows).set(headerViewFormer: self.createHeader("Comments")))
                            //self.former.insertUpdate(sectionFormer: SectionFormer(rowFormers: commentRows).set(headerViewFormer: self.createHeader("Comments")), below: postSection, rowAnimation: .Fade)
                            self.former.reload()
                        }

                        let commentRow = TextViewRowFormer<FormTextViewCell>() { [weak self] in
                            Comment.new.post = self!.post
                            $0.textView.textColor = .formerSubColor()
                            $0.textView.font = .systemFontOfSize(15)
                            $0.textView.inputAccessoryView = self?.formerInputAccessoryView
                            }.configure {
                                $0.placeholder = "Add a comment"
                                $0.text = Comment.new.comment
                                $0.rowHeight = 75
                            }.onTextChanged {
                                Comment.new.comment = $0
                        }
                        if index != 0 {
                            self.former.append(sectionFormer: SectionFormer(rowFormer: commentRow))
                            self.former.reload()
                        } else {
                            self.former.append(sectionFormer: SectionFormer(rowFormer: commentRow).set(headerViewFormer: self.createHeader("Comments")))
                            self.former.reload()
                        }
                        }
                    }
                }
        } else {
            self.former.append(sectionFormer: zeroSection.set(footerViewFormer: createFooter("Error Loading Post")))
        }
        
        former.reload()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        Comment.new.clear()
    }
}

