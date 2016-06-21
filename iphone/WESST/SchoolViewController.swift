//
//  EditSchoolViewController.swift
//  Former-Demo
//
//  Created by Ryo Aoyama on 10/31/15.
//  Copyright © 2015 Ryo Aoyama. All rights reserved.
//
//  Modified by Nathan Tannar

import UIKit
import Former
import Parse
import ParseUI

final class SchoolViewController: FormViewController {
    
    var schoolName: String?
    
    // MARK: Public
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .Plain, target: self, action: #selector(saveButtonPressed))
        let query = PFQuery(className: "Schools")
        query.whereKey("name", equalTo: schoolName!)
        query.countObjectsInBackgroundWithBlock { (count: Int32, error: NSError?) in
            if error == nil {
                if count == 0 {
                    //Create School
                    let school = PFObject(className: "Schools")
                    school[SCHOOL_NAME] = self.schoolName!
                    school[SCHOOL_PHONE] = ""
                    school[SCHOOL_URL] = ""
                    school[SCHOOL_INFO] = "Student Socity's Introduction"
                    school[SCHOOL_ADDRESS] = ""
                    school[SCHOOL_BLUE] = 1.0
                    school[SCHOOL_RED] = 1.0
                    school[SCHOOL_GREEN] = 1.0
                    school[SCHOOL_COVER_IMAGE] = nil
                    school[SCHOOL_LOGO_IMAGE] = nil
                    school.saveInBackground()
                    School.sharedInstance.school = school
                    print("School Created")
                }
                else {
                    query.getFirstObjectInBackgroundWithBlock({ (object: PFObject?, error: NSError?) in
                        School.sharedInstance.school = object
                    })
                }
            } else {
                print(error)
            }
        }
        School.sharedInstance.loadSchool()
        configure()
    }
    
    func saveButtonPressed(sender: UIBarButtonItem) {
        School.sharedInstance.saveSchool()
    }
    
    override func viewDidAppear(animated: Bool) {
        navigationController!.navigationBar.barTintColor = UIColor(red: 153.0/255, green:62.0/255.0, blue:123.0/255, alpha: 1)
    }
    
    // MARK: Private
    
    private lazy var formerInputAccessoryView: FormerInputAccessoryView = FormerInputAccessoryView(former: self.former)
    
    private lazy var imageSelectionRow: LabelRowFormer<ProfileImageCell> = {
        LabelRowFormer<ProfileImageCell>(instantiateType: .Nib(nibName: "ProfileImageCell")) {
            $0.iconView.image = School.sharedInstance.coverImage
            }.configure {
                $0.text = "Choose School image from library"
                $0.rowHeight = 60
            }.onSelected { [weak self] _ in
                self?.former.deselect(true)
                self?.presentImagePicker()
        }
    }()
    
    private func configure() {
        title = ""
        tableView.contentInset.top = 20
        tableView.contentInset.bottom = 0
        
        // Create RowFomers
        
        let nameRow = TextFieldRowFormer<ProfileFieldCell>(instantiateType: .Nib(nibName: "ProfileFieldCell")) { [weak self] in
            $0.titleLabel.text = "Name"
            $0.textField.inputAccessoryView = self?.formerInputAccessoryView
            }.configure {
                $0.placeholder = "Add your name"
                $0.text = School.sharedInstance.name
            }.onTextChanged {
                School.sharedInstance.name = $0
        }
        let imageRow = LabelRowFormer<ImageCell>(instantiateType: .Nib(nibName: "ImageCell")) { [weak self] in
            $0.displayImage.image = School.sharedInstance.coverImage
            }.configure {
                    $0.rowHeight = 200
        }
        let phoneRow = TextFieldRowFormer<ProfileFieldCell>(instantiateType: .Nib(nibName: "ProfileFieldCell")) { [weak self] in
            $0.titleLabel.text = "Phone"
            $0.textField.keyboardType = .NumberPad
            $0.textField.inputAccessoryView = self?.formerInputAccessoryView
            }.configure {
                $0.placeholder = "Add your phone number"
                $0.text = School.sharedInstance.phoneNumber
            }.onTextChanged {
                School.sharedInstance.phoneNumber = $0
        }
        let introductionRow = TextViewRowFormer<FormTextViewCell>() { [weak self] in
            $0.textView.textColor = .formerSubColor()
            $0.textView.font = .systemFontOfSize(15)
            $0.textView.inputAccessoryView = self?.formerInputAccessoryView
            }.configure {
                $0.placeholder = "Add your self-introduction"
                $0.text = School.sharedInstance.info
            }.onTextChanged {
                School.sharedInstance.info = $0
        }
        let urlRow = TextFieldRowFormer<ProfileFieldCell>(instantiateType: .Nib(nibName: "ProfileFieldCell")) { [weak self] in
            $0.titleLabel.text = "Website"
            $0.textField.inputAccessoryView = self?.formerInputAccessoryView
            }.configure {
                $0.placeholder = "URL"
                $0.text = School.sharedInstance.url
            }.onTextChanged {
                School.sharedInstance.url = $0
        }
        let addressRow = TextFieldRowFormer<ProfileFieldCell>(instantiateType: .Nib(nibName: "ProfileFieldCell")) { [weak self] in
            $0.titleLabel.text = "Address"
            $0.textField.inputAccessoryView = self?.formerInputAccessoryView
            }.configure {
                $0.placeholder = "Address"
                $0.text = School.sharedInstance.address
            }.onTextChanged {
                School.sharedInstance.address = $0
        }
        
        // Create Headers
        
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
        
        // Create SectionFormers
        
        let imageSection = SectionFormer(rowFormer: imageRow, imageSelectionRow).set(headerViewFormer: createHeader("School Image"))
        
        let introductionSection = SectionFormer(rowFormer: introductionRow).set(headerViewFormer: createHeader("Introduction"))
        
        let aboutSection = SectionFormer(rowFormer: nameRow, phoneRow, addressRow, urlRow).set(headerViewFormer: createHeader("About")).set(footerViewFormer: createFooter(""))
        
        former.append(sectionFormer: imageSection, introductionSection, aboutSection)
            .onCellSelected { [weak self] _ in
                self?.formerInputAccessoryView.update()
        }
        // Profile.sharedInstance.moreInformation {
        //   former.append(sectionFormer: informationSection)
        //}
    }
    
    private func presentImagePicker() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .PhotoLibrary
        picker.allowsEditing = false
        presentViewController(picker, animated: true, completion: nil)
    }
}

extension SchoolViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        
        var imageToBeSaved = image
        picker.dismissViewControllerAnimated(true, completion: nil)
        School.sharedInstance.coverImage = image
        imageSelectionRow.cellUpdate {
            $0.iconView.image = image
        }
        
        
        if image.size.width > 280 {
            imageToBeSaved = Images.resizeImage(image, width: 280, height: 280)!
        }
        
        let pictureFile = PFFile(name: "picture.jpg", data: UIImageJPEGRepresentation(imageToBeSaved, 0.6)!)
        pictureFile!.saveInBackgroundWithBlock { (succeeded: Bool, error: NSError?) -> Void in
            if error != nil {
                print("Network error")
            }
        }
        
        
        if image.size.width > 60 {
            imageToBeSaved = Images.resizeImage(image, width: 60, height: 60)!
        }
        
        let thumbnailFile = PFFile(name: "thumbnail.jpg", data: UIImageJPEGRepresentation(imageToBeSaved, 0.6)!)
        thumbnailFile!.saveInBackgroundWithBlock { (succeeded: Bool, error: NSError?) -> Void in
            if error != nil {
                print("Network error")
            }
        }
        
        let user = PFUser.currentUser()!
        user[PF_USER_PICTURE] = pictureFile
        user[PF_USER_THUMBNAIL] = thumbnailFile
        user.saveInBackgroundWithBlock { (succeeded: Bool, error: NSError?) -> Void in
            if error != nil {
                print("Network error")
                let banner = Banner(title: "Network Error", subtitle: "Image could not be saved", image: UIImage(named: "Icon"), backgroundColor: UIColor(red: 153.0/255, green:62.0/255.0, blue:123.0/255, alpha: 1))
                banner.dismissesOnTap = true
                banner.show(duration: 1.0)
            }
            else {
                let banner = Banner(title: "Image Saved", subtitle: nil, image: UIImage(named: "Icon"), backgroundColor: UIColor(red: 153.0/255, green:62.0/255.0, blue:123.0/255, alpha: 1))
                banner.dismissesOnTap = true
                banner.show(duration: 1.0)
            }
        }
        
        
    }
    
}