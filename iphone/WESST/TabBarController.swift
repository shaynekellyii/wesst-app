//
//  TabBarController.swift
//  MainStream
//
//  Created by Nathan Tannar on 2016-03-31.
//  Copyright © 2016 Shrikar Archak. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Sets the default color of the icon of the selected UITabBarItem and Title
        UITabBar.appearance().tintColor = UIColor(red: 137.0/255, green:73.0/255.0, blue:124.0/255, alpha: 1)
        
        // Sets the default color of the background of the UITabBar
        //UITabBar.appearance().barTintColor = UIColor.whiteColor()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
