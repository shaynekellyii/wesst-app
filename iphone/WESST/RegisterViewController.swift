//
//  RegisterViewController.swift
//  SwiftParseChat
//
//  Created by Jesse Hu on 2/21/15.
//  Copyright (c) 2015 Jesse Hu. All rights reserved.
//

import UIKit
import Parse

class RegisterViewController: UITableViewController, UITextFieldDelegate, UIPickerViewDelegate {
    
    var pickerDataSource = ["UBC Vancouver", "UVic A", "UVic B", "SFU"];
    var chosenSchool = String()
    
    @IBOutlet var nameField: UITextField!
    @IBOutlet var emailField: UITextField!
    @IBOutlet var passwordField: UITextField!
    @IBOutlet var schoolPicker: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(RegisterViewController.dismissKeyboard)))
        self.nameField.delegate = self
        self.emailField.delegate = self
        self.passwordField.delegate = self
        self.schoolPicker.delegate = self;
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.nameField.becomeFirstResponder()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerDataSource.count;
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerDataSource[row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        chosenSchool = pickerDataSource[row]
    }
    
    func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField == self.nameField {
            self.emailField.becomeFirstResponder()
        } else if textField == self.emailField {
            self.passwordField.becomeFirstResponder()
        } else if textField == self.passwordField {
            self.register()
        }
        return true
    }
    
    @IBAction func registerButtonPressed(sender: UIButton) {
        self.register()
    }
    
    func register() {
        let name = nameField.text
        let email = emailField.text
        let password = passwordField.text!.lowercaseString
        
        if name!.characters.count == 0 {
            print("Name must be set.")
            displayAlert("", message: "You must enter a name")
            return
        }
        if password.characters.count == 0 {
            print("Password must be set.")
            displayAlert("", message: "You must enter a password")
            return
        }
        if email!.characters.count == 0 {
            print("Email must be set.")
            displayAlert("", message: "You must enter an email")
            return
        }
        
        let user = PFUser()
        user.username = email
        user.password = password
        user.email = email
        user[PF_USER_EMAILCOPY] = email
        user[PF_USER_FULLNAME] = name
        user[PF_USER_FULLNAME_LOWER] = name!.lowercaseString
        user[PF_USER_GENDER] = "Not Defined"
        user[PF_USER_INFO] = ""
        user[PF_USER_BIRTHDAY] = NSDate()
        user[PF_USER_SCHOOL] = chosenSchool
        user[PF_USER_PHONE] = ""
        user.signUpInBackgroundWithBlock { (succeeded: Bool, error: NSError?) -> Void in
            if error == nil {
                PushNotication.parsePushUserAssign()
                Profile.sharedInstance.loadUser()
                print("Succeeded.")
                self.dismissViewControllerAnimated(true, completion: { let banner = Banner(title: "Welcome", subtitle: "\(PFUser.currentUser()!.valueForKey(PF_USER_FULLNAME)!)", image: UIImage(named: "Icon"), backgroundColor: UIColor(red: 137.0/255, green:73.0/255.0, blue:124.0/255, alpha: 1))
                    banner.dismissesOnTap = true
                    banner.show(duration: 1.0) })
            } else {
                print(error)
                self.displayAlert("Oops", message: (error?.description)!)
            }
        }
    }
    
    func displayAlert(title: String, message: String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction((UIAlertAction(title: "OK", style: .Default, handler: { (action) -> Void in
            
            self.dismissViewControllerAnimated(true, completion: nil)
            
        })))
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }

}
