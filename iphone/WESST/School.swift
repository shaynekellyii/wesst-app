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

final class School {
    
    static let sharedInstance = School()
    
    var school: PFObject?
    var coverImage: UIImage?
    var logoImage: UIImage?
    var name: String?
    var info: String?
    var phoneNumber: String?
    var green: Float?
    var red: Float?
    var blue: Float?
    var url: String?
    var address: String?
    
    func loadSchool() {
        if let school = school {
            
            let schoolCoverImage = school[SCHOOL_COVER_IMAGE] as? PFFile
            if schoolCoverImage != nil {
                schoolCoverImage!.getDataInBackgroundWithBlock {
                    (imageData: NSData?, error: NSError?) -> Void in
                    if error == nil {
                        if let imageData = imageData {
                            self.coverImage = UIImage(data:imageData)
                        }
                    }
                }
            }
            let schoolLogoImage = school[SCHOOL_LOGO_IMAGE] as? PFFile
            if schoolLogoImage != nil {
                schoolLogoImage!.getDataInBackgroundWithBlock {
                    (imageData: NSData?, error: NSError?) -> Void in
                    if error == nil {
                        if let imageData = imageData {
                            self.logoImage = UIImage(data:imageData)
                        }
                    }
                }
            }
            
            name = school[SCHOOL_NAME] as? String
            info = school[SCHOOL_INFO] as? String
            phoneNumber = school[SCHOOL_PHONE] as? String
            url = school[SCHOOL_URL] as? String
            address = school[SCHOOL_ADDRESS] as? String
            green = school[SCHOOL_GREEN] as? Float
            blue = school[SCHOOL_BLUE] as? Float
            red = school[SCHOOL_RED] as? Float
        }
    }
    
    func saveSchool() {
            let query = PFQuery(className:"Schools")
            query.whereKey("name", equalTo: name!)
            query.findObjectsInBackgroundWithBlock { (objects: [PFObject]?, error: NSError?) in
                if error != nil {
                    print(error)
                } else if let object = objects?[0] {
                    self.school![SCHOOL_NAME] = self.name
                    self.school![SCHOOL_PHONE] = self.phoneNumber
                    self.school![SCHOOL_URL] = self.url
                    self.school![SCHOOL_INFO] = self.info
                    self.school![SCHOOL_ADDRESS] = self.address
                    self.school![SCHOOL_BLUE] = self.blue
                    self.school![SCHOOL_RED] = self.red
                    self.school![SCHOOL_GREEN] = self.green
                    
                    object.saveInBackgroundWithBlock({ (succeeded: Bool, error: NSError?) -> Void in
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
                }
            }
        } 
}