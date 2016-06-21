//
//  FeedViewController.swift
//  WESST
//
//  Created by Nathan Tannar on 2016-06-12.
//  Copyright © 2016 NathanTannar. All rights reserved.
//

import UIKit
import Former
import Parse
import ParseUI
import Agrume

class FeedViewController: FormViewController {
    
    var allPosts = [PFObject]?()
    var editorViewable = Bool()
    
    // MARK: Public
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if PFUser.currentUser() == nil {
            Utilities.loginUser(self)
        }
        Profile.sharedInstance.user = PFUser.currentUser()
        Profile.sharedInstance.loadUser()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Post", style: .Plain, target: self, action: #selector(postButtonPressed))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Refresh", style: .Plain, target: self, action: #selector(refreshButtonPressed))
        self.navigationController?.navigationBarHidden = false;
        Post.new.clear()
        editorViewable = false
        configure()
    }
    
    
    
    func postButtonPressed(sender: UIBarButtonItem) {
        
        let infoRow = TextViewRowFormer<FormTextViewCell>() { [weak self] in
            $0.textView.textColor = .formerSubColor()
            $0.textView.font = .systemFontOfSize(15)
            $0.textView.inputAccessoryView = self?.formerInputAccessoryView
            }.configure {
                $0.placeholder = "What's new?"
                $0.text = Post.new.info
            }.onTextChanged {
                Post.new.info = $0
        }
        
        let newPostSection = SectionFormer(rowFormer: infoRow, imageRow).set(headerViewFormer: createHeader("Create Post"))
        
        
        if !editorViewable {
            
            editorViewable = true
            
            former.insert(sectionFormer: newPostSection, toSection: 0)
                .onCellSelected { [weak self] _ in
                    self?.formerInputAccessoryView.update()
            }
            
            former.reload()
            
            
        } else if Post.new.info != ""{
            Post.new.createPost()
            Post.new.clear()
            former.removeAllUpdate(.Top)
            configure()
        }
    }
    
    func refreshButtonPressed(sender: UIBarButtonItem) {
        editorViewable = false
        former.removeAllUpdate(.Fade)
        former.reload()
        configure()
        Post.new.clear()
    }
    
    // MARK: Private
    
    private lazy var formerInputAccessoryView: FormerInputAccessoryView = FormerInputAccessoryView(former: self.former)
    
    private lazy var imageRow: LabelRowFormer<ProfileImageCell> = {
        LabelRowFormer<ProfileImageCell>(instantiateType: .Nib(nibName: "ProfileImageCell")) {
            $0.iconView.image = Post.new.image
            }.configure {
                $0.text = "Add image to post"
                $0.rowHeight = 60
            }.onSelected { [weak self] _ in
                self?.former.deselect(true)
                self?.presentImagePicker()
        }
    }()
    
    private lazy var zeroRow: LabelRowFormer<ImageCell> = {
        LabelRowFormer<ImageCell>(instantiateType: .Nib(nibName: "ImageCell")) {
            $0.displayImage.image = Post.new.image
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
        title = "Activity Feed"
        tableView.contentInset.top = 0
        tableView.contentInset.bottom = 100
        
        let postsSection = SectionFormer(rowFormer: zeroRow).set(footerViewFormer: createFooter("Developed by Nathan Tannar"))
        
        let loadingSection = SectionFormer(rowFormer: zeroRow).set(footerViewFormer: createFooter("Loading Feed"))
    
        former.append(sectionFormer: loadingSection)
            .onCellSelected { [weak self] _ in
                self?.formerInputAccessoryView.update()
        }
        
        former.reload()

        
        var postRow = [CustomRowFormer<PostCell>]()
        var postImageRow = [LabelRowFormer<ImageCell>]()
        var dividerRow = [CustomRowFormer<DividerCell>]()
        
        let query = PFQuery(className:  "Posts")
        query.limit = 100
        query.orderByDescending("updatedAt")
        query.findObjectsInBackgroundWithBlock { (posts: [PFObject]?, error: NSError?) in
            if error == nil {
                if let posts = posts {
                    var index = 0
                    var indexPhoto = 0
                    
                    for post in posts {
                        let hasImage = post["hasImage"] as? Bool
                        
                        dividerRow.append(CustomRowFormer<DividerCell>(instantiateType: .Nib(nibName: "DividerCell")) {_ in
                            }.configure {
                            $0.rowHeight = 8
                        })
                    
                        postRow.append(CustomRowFormer<PostCell>(instantiateType: .Nib(nibName: "PostCell")) {
                            var username = ""
                            var school = ""
                            let userQuery = PFUser.query()
                            do {
                                let user = try userQuery?.findObjects()
                               
                                username = user![0].valueForKey("fullname")! as! String
                                school = user![0].valueForKey("school")! as! String
                                
                            } catch _ {
                                print("Error in finding User")
                            }
                            
                            $0.username.text = username
                            $0.info.font = .systemFontOfSize(16)
                            $0.info.text = post["info"] as? String
                            $0.school.text =  school
                            var interval = NSDate().minutesAfterDate(post.createdAt)
                            
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
                                interval = NSDate().hoursAfterDate(post.createdAt)
                                if interval < 24 {
                                    if interval <= 1 {
                                        dateString = "1 hour ago"
                                    }
                                    else {
                                        dateString = "\(interval) hours ago"
                                    }
                                }
                                else {
                                    interval = NSDate().daysAfterDate(post.createdAt)
                                    if interval <= 1 {
                                        dateString = "1 day ago"
                                    }
                                    else {
                                        dateString = "\(interval) days ago"
                                    }
                                }
                            }
                            $0.date.text = dateString
                            
                            if post["replies"] as? Int == 1 {
                                $0.replies.text = "1 reply"
                                
                            } else {
                                $0.replies.text = "\(post["replies"]) replies"
                            }
                            
                            }.configure {
                                $0.rowHeight = UITableViewAutomaticDimension
                            }.onSelected {_ in
                                
                                // Present DetailViewController
                                print("selected")
                                let detailVC = PostDetailViewController()
                                detailVC.post = post
                                self.navigationController?.pushViewController(detailVC, animated: true)
 

                                
                        })
                        
                        if  hasImage == true {
                            let insertIndex = index
                            let imageToBeLoaded = post["image"] as? PFFile
                            if imageToBeLoaded != nil {
                                imageToBeLoaded!.getDataInBackgroundWithBlock {(imageData: NSData?, error: NSError?) -> Void in
                                    if error == nil {
                                        if let imageData = imageData {
                                            postImageRow.append(LabelRowFormer<ImageCell>(instantiateType: .Nib(nibName: "ImageCell")) {
                                                $0.displayImage.image = UIImage(data:imageData)!
                                                }.configure {
                                                    $0.rowHeight = 200
                                                }.onSelected({ (cell: LabelRowFormer<ImageCell>) in
                                                    let agrume = Agrume(image: cell.cell.displayImage.image!)
                                                    agrume.showFrom(self)
                                                }))
                                            self.former.insert(rowFormer: postImageRow[indexPhoto], below: postRow[insertIndex])
                                            //postsSection.append(rowFormer: postImageRow[indexPhoto])
                                            indexPhoto += 1
                                            self.former.reload()
                                        }
                                    }
                                }
                            }
                        }
                        
                        //end creating rows
                        
                        postsSection.append(rowFormer: postRow[index])
                        postsSection.append(rowFormer: dividerRow[index])
                        index += 1
                        

                    }
                }
            } else {
                print("An error occured")
                print(error.debugDescription)
            }
            self.former.insertUpdate(sectionFormer: postsSection, below: loadingSection, rowAnimation: .Fade)
            self.former.remove(sectionFormer: loadingSection)
            self.former.reload()
        }
        
    }

    private func presentImagePicker() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .PhotoLibrary
        picker.allowsEditing = false
        presentViewController(picker, animated: true, completion: nil)
    }
    
}


extension FeedViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        
        picker.dismissViewControllerAnimated(true, completion: nil)
        Post.new.image = image
        Post.new.hasImage = true
        imageRow.cellUpdate {
            $0.iconView.image = image
        }
    }
}