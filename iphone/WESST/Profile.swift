//
//  Profile.swift
//  Former-Demo
//
//  Created by Ryo Aoyama on 10/31/15.
//  Copyright © 2015 Ryo Aoyama. All rights reserved.
//

import UIKit
import Parse
import ParseUI

final class Profile {
    
    static let sharedInstance = Profile()
    
    var user: PFUser?
    var image: UIImage?
    var name: String?
    var gender: String?
    var birthDay: NSDate?
    var introduction: String?
    var school: String?
    var phoneNumber: String?
    var job: String?
    
    func loadUser() {
        if let user = user {
            
            let userImageFile = user[PF_USER_PICTURE] as? PFFile
            if userImageFile != nil {
                userImageFile!.getDataInBackgroundWithBlock {
                    (imageData: NSData?, error: NSError?) -> Void in
                    if error == nil {
                        if let imageData = imageData {
                            self.image = UIImage(data:imageData)
                        }
                    }
                }
            }
            
            
            name = user[PF_USER_FULLNAME] as? String
            if (user[PF_USER_PHONE] != nil) {
                phoneNumber = user[PF_USER_PHONE] as? String
            }
            if (user[PF_USER_SCHOOL] != nil) {
                school = user[PF_USER_SCHOOL] as? String
            }
            if (user[PF_USER_TITLE] != nil) {
                job = user[PF_USER_TITLE] as? String
            }
            if (user[PF_USER_INFO] != nil) {
                introduction = user[PF_USER_INFO] as? String
            }
            if (user[PF_USER_GENDER] != nil) {
                gender = user[PF_USER_GENDER] as? String
            } else {
                gender = "Not Defined"
            }
            if (user[PF_USER_BIRTHDAY] != nil) {
                birthDay = user[PF_USER_BIRTHDAY] as? NSDate
            }
        }
    }
    
    func saveUser() {
        let fullName = name
        if fullName!.characters.count > 0 {
            let user = PFUser.currentUser()!
            user[PF_USER_FULLNAME] = fullName!
            user[PF_USER_FULLNAME_LOWER] = fullName!.lowercaseString
            user[PF_USER_INFO] = introduction
            user[PF_USER_GENDER] = gender
            user[PF_USER_BIRTHDAY] = birthDay
            user[PF_USER_PHONE] = phoneNumber
            user[PF_USER_TITLE] = job
            user[PF_USER_SCHOOL] = school
            user.saveInBackgroundWithBlock({ (succeeded: Bool, error: NSError?) -> Void in
                if error == nil {
                    print("Saved")
                    let banner = Banner(title: "Profile Saved", subtitle: nil, image: UIImage(named: "Icon"), backgroundColor: UIColor(red: 153.0/255, green:62.0/255.0, blue:123.0/255, alpha: 1))
                    banner.dismissesOnTap = true
                    banner.show(duration: 1.0)
                } else {
                    print("Network error")
                    let banner = Banner(title: "Network Error", subtitle: "Profile could not be saved", image: UIImage(named: "Icon"), backgroundColor: UIColor(red: 153.0/255, green:62.0/255.0, blue:123.0/255, alpha: 1))
                    banner.dismissesOnTap = true
                    banner.show(duration: 1.0)

                }
            })
        } else {
            print("Name field must not be empty")
        }
    }
}