//
//  LoginViewController.swift
//  SwiftParseChat
//
//  Created by Jesse Hu on 2/22/15.
//  Copyright (c) 2015 Jesse Hu. All rights reserved.
//

import UIKit
import Parse

class LoginViewController: UITableViewController, UITextFieldDelegate {

    @IBOutlet var emailField: UITextField!
    @IBOutlet var passwordField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(LoginViewController.dismissKeyboard)))
        self.emailField.delegate = self
        self.passwordField.delegate = self
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.emailField.becomeFirstResponder()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField == self.emailField {
            self.passwordField.becomeFirstResponder()
        } else if textField == self.passwordField {
            self.login()
        }
        return true
    }
    
    @IBAction func loginButtonPressed(sender: UIButton) {
        self.login();
    }
    
    func login() {
        let email = emailField.text!.lowercaseString
        let password = passwordField.text!
        
        if email.characters.count == 0 {
            print("Email field is empty.")
            displayAlert("", message: "Email field is empty")
            return
        } else if password.characters.count == 0 {
            print("Password field is empty.")
            displayAlert("", message: "Password field is empty")
            
        }
        
        print("Signing in...")
        PFUser.logInWithUsernameInBackground(email, password: password) { (user: PFUser?, error: NSError?) -> Void in
            if user != nil {
                PushNotication.parsePushUserAssign()
                Profile.sharedInstance.loadUser()
                print("Welcome back, \(user![PF_USER_FULLNAME])")
                self.dismissViewControllerAnimated(true, completion: { let banner = Banner(title: "Welcome Back!", subtitle: "\(PFUser.currentUser()!.valueForKey(PF_USER_FULLNAME)!)", image: UIImage(named: "Icon"), backgroundColor: UIColor(red: 137.0/255, green:73.0/255.0, blue:124.0/255, alpha: 1))
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
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
}
