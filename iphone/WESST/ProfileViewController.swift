//
//  ProfileViewController.swift
//  SwiftParseChat
//
//  Created by Jesse Hu on 2/20/15.
//  Copyright (c) 2015 Jesse Hu. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class ProfileViewController: UIViewController, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITableViewDelegate  {

    var user: PFUser?
    var currentUser: Bool = true
    
    @IBOutlet var userImageView: UIImageView!
    @IBOutlet var birthday: UILabel!
    @IBOutlet var gender: UILabel!
    @IBOutlet var phone: UILabel!
    @IBOutlet var name: UILabel!
    @IBOutlet var school: UILabel!
    @IBOutlet var job: UILabel!
    @IBOutlet var intro: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if PFUser.currentUser() == nil {
            Utilities.loginUser(self)
        }
        if currentUser == true {
            navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Edit", style: .Plain, target: self, action: #selector(editButtonPressed))
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Logout", style: .Plain, target: self, action: #selector(logoutButtonPressed))
            user = PFUser.currentUser()
        } else {
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Message", style: .Plain, target: self, action: #selector(messageButtonPressed))
        }
        Profile.sharedInstance.user = user
        Profile.sharedInstance.loadUser()
        userImageView.image = Profile.sharedInstance.image
    }
    
    override func viewDidAppear(animated: Bool) {
        Profile.sharedInstance.user = user
        Profile.sharedInstance.loadUser()
        
        /*
        userImageView.layer.cornerRadius = userImageView.frame.size.width / 2;
        userImageView.layer.masksToBounds = true;
        userImageView.layer.borderWidth = 1
        userImageView.layer.borderColor = UIColor.whiteColor().CGColor
        userImageView.clipsToBounds = false
        userImageView.layer.borderWidth = 2
        userImageView.layer.borderColor = UIColor.whiteColor().CGColor
        */
        name.text = Profile.sharedInstance.name
        school.text = Profile.sharedInstance.school
        job.text = Profile.sharedInstance.job
        intro.text = Profile.sharedInstance.introduction
        phone.text = Profile.sharedInstance.phoneNumber
        gender.text = Profile.sharedInstance.gender
        birthday.text = String.mediumDateNoTime(Profile.sharedInstance.birthDay!)
        userImageView.image = Profile.sharedInstance.image
        userImageView.layer.borderWidth = 1
        userImageView.layer.masksToBounds = false
        userImageView.layer.borderColor = UIColor.whiteColor().CGColor
        userImageView.clipsToBounds = true
        userImageView.layer.borderWidth = 2
        userImageView.layer.borderColor = UIColor(red: 153.0/255, green:62.0/255.0, blue:123.0/255, alpha: 1).CGColor
        userImageView.layer.cornerRadius = userImageView.frame.height/2
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - User actions
    
    func editButtonPressed(sender: UIBarButtonItem) {
        performSegueWithIdentifier("editProfile", sender: self)
    }
    
    func messageButtonPressed(sender: UIBarButtonItem) {
        //Finish
    }
    
    func logoutButtonPressed(sender: UIBarButtonItem) {
        PFUser.logOut()
        PushNotication.parsePushUserResign()
        Utilities.postNotification(NOTIFICATION_USER_LOGGED_OUT)
        Utilities.loginUser(self)
    }
}
