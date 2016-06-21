//
//  EditProfileViewController.swift
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

final class EditProfileViewController: FormViewController {

    // MARK: Public
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .Plain, target: self, action: #selector(saveButtonPressed))
        configure()
    }
    
    func saveButtonPressed(sender: UIBarButtonItem) {
        Profile.sharedInstance.saveUser()
    }
    
    // MARK: Private
    
    private lazy var formerInputAccessoryView: FormerInputAccessoryView = FormerInputAccessoryView(former: self.former)
    
    private lazy var imageRow: LabelRowFormer<ProfileImageCell> = {
        LabelRowFormer<ProfileImageCell>(instantiateType: .Nib(nibName: "ProfileImageCell")) {
            $0.iconView.image = Profile.sharedInstance.image
            }.configure {
                $0.text = "Choose profile image from library"
                $0.rowHeight = 60
            }.onSelected { [weak self] _ in
                self?.former.deselect(true)
                self?.presentImagePicker()
        }
    }()
    
    private lazy var onlyImageRow: LabelRowFormer<ImageCell> = {
        LabelRowFormer<ImageCell>(instantiateType: .Nib(nibName: "ImageCell")) {
            $0.displayImage.image = Profile.sharedInstance.image
            }.configure {
                $0.rowHeight = 200
        }
    }()
    
    private func configure() {
        title = "Edit Profile"
        tableView.contentInset.top = 20
        tableView.contentInset.bottom = 0
        
        // Create RowFomers
        
        let nameRow = TextFieldRowFormer<ProfileFieldCell>(instantiateType: .Nib(nibName: "ProfileFieldCell")) { [weak self] in
            $0.titleLabel.text = "Name"
            $0.textField.inputAccessoryView = self?.formerInputAccessoryView
            }.configure {
                $0.placeholder = "Add your name"
                $0.text = Profile.sharedInstance.name
            }.onTextChanged {
                Profile.sharedInstance.name = $0
        }
        let locationRow = InlinePickerRowFormer<ProfileLabelCell, String>(instantiateType: .Nib(nibName: "ProfileLabelCell")) {
            $0.titleLabel.text = "School"
            }.configure {
                let schools = ["University of Victoria", "UBC Vancouver", "UBC Okanagan", "SFU Burnaby", "SFU Surrey", "BCIT", "UNBC", "University of Calgary", "University of Alberta", "University of Saskatchewan", "University of Regina", "University of Manitoba"]
                $0.pickerItems = schools.map {
                    InlinePickerItem(title: $0)
                }
                if let gender = Profile.sharedInstance.school {
                    $0.selectedRow = schools.indexOf(gender) ?? 0
                }
            }.onValueChanged {
                Profile.sharedInstance.school = $0.title
        }
        let phoneRow = TextFieldRowFormer<ProfileFieldCell>(instantiateType: .Nib(nibName: "ProfileFieldCell")) { [weak self] in
            $0.titleLabel.text = "Phone"
            $0.textField.keyboardType = .NumberPad
            $0.textField.inputAccessoryView = self?.formerInputAccessoryView
            }.configure {
                $0.placeholder = "Add your phone number"
                $0.text = Profile.sharedInstance.phoneNumber
            }.onTextChanged {
                Profile.sharedInstance.phoneNumber = $0
        }
        let jobRow = TextFieldRowFormer<ProfileFieldCell>(instantiateType: .Nib(nibName: "ProfileFieldCell")) { [weak self] in
            $0.titleLabel.text = "Title"
            $0.textField.inputAccessoryView = self?.formerInputAccessoryView
            }.configure {
                $0.placeholder = "Add your title (if applicable)"
                $0.text = Profile.sharedInstance.job
            }.onTextChanged {
                Profile.sharedInstance.job = $0
        }
        let genderRow = InlinePickerRowFormer<ProfileLabelCell, String>(instantiateType: .Nib(nibName: "ProfileLabelCell")) {
            $0.titleLabel.text = "Gender"
            }.configure {
                let genders = ["Male", "Female", "Neither", "Undefined"]
                $0.pickerItems = genders.map {
                    InlinePickerItem(title: $0)
                }
                if let gender = Profile.sharedInstance.gender {
                    $0.selectedRow = genders.indexOf(gender) ?? 0
                }
            }.onValueChanged {
                Profile.sharedInstance.gender = $0.title
        }
        let birthdayRow = InlineDatePickerRowFormer<ProfileLabelCell>(instantiateType: .Nib(nibName: "ProfileLabelCell")) {
            $0.titleLabel.text = "Birthday"
            }.configure {
                $0.date = Profile.sharedInstance.birthDay ?? NSDate()
            }.inlineCellSetup {
                $0.datePicker.datePickerMode = .Date
            }.displayTextFromDate {
                return String.mediumDateNoTime($0)
            }.onDateChanged {
                Profile.sharedInstance.birthDay = $0
        }
        let introductionRow = TextViewRowFormer<FormTextViewCell>() { [weak self] in
            $0.textView.textColor = .formerSubColor()
            $0.textView.font = .systemFontOfSize(15)
            $0.textView.inputAccessoryView = self?.formerInputAccessoryView
            }.configure {
                $0.placeholder = "Add your self-introduction"
                $0.text = Profile.sharedInstance.introduction
            }.onTextChanged {
                Profile.sharedInstance.introduction = $0
        }
        
        
        
        let licenseRow = LabelRowFormer<CenterLabelCell>() { [weak self] in
            $0.textLabel?.text = "View Licenses and Acknowledgements"
            }.onSelected {_ in
                let licensingViewController = LicensingViewController()
                
                licensingViewController.title = "Acknowledgments"
                
                let parseItem = LicensingItem(
                    title: "Parse",
                    license: License.MIT(owner: "Parse", years: "2016")
                )
                
                let formerItem = LicensingItem(
                    title: "Former",
                    license: License.MIT(owner: "Ryo Aoyama (https://github.com/ra1028/Former)", years: "2015")
                )
                
                let messagesItem = LicensingItem(
                    title: "JSQMessagesController",
                    license: License.MIT(owner: "Jessie Squires (https://github.com/jessesquires/JSQMessagesViewController)", years: "2015")
                )
                
                let bannerItem = LicensingItem(
                    title: "BRYX Banner",
                    license: License.MIT(owner: "Harlan Haskins (https://github.com/bryx-inc/BRYXBanner)", years: "2015")
                )
                
                let agrumeItem = LicensingItem(
                    title: "Agrume",
                    license: License.MIT(owner: "Jan Gorman (https://github.com/JanGorman/Agrume)", years: "2015")
                )
                
                
                licensingViewController.items = [parseItem, formerItem, messagesItem, bannerItem, agrumeItem]
                self.navigationController?.pushViewController(licensingViewController, animated: true)
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
        
        let imageSection = SectionFormer(rowFormer: onlyImageRow, imageRow).set(headerViewFormer: createHeader("Profile Image"))
        
        let introductionSection = SectionFormer(rowFormer: introductionRow).set(headerViewFormer: createHeader("Introduction"))
        
        let aboutSection = SectionFormer(rowFormer: nameRow, locationRow, jobRow, phoneRow, genderRow, birthdayRow).set(headerViewFormer: createHeader("About")).set(footerViewFormer: createFooter(""))
            
        let licenseSection = SectionFormer(rowFormer: licenseRow).set(headerViewFormer: createHeader("")).set(footerViewFormer: createFooter(""))
        
        former.append(sectionFormer: imageSection, introductionSection, aboutSection, licenseSection)
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

extension EditProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        
        var imageToBeSaved = image
        picker.dismissViewControllerAnimated(true, completion: nil)
        Profile.sharedInstance.image = image
        imageRow.cellUpdate {
            $0.iconView.image = image
        }
        onlyImageRow.cellUpdate {
            $0.displayImage.image = image
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