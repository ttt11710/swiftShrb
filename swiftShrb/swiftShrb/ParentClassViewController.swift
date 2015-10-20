//
//  ParentClassViewController.swift
//  swiftShrb
//
//  Created by PayBay on 15/10/19.
//  Copyright © 2015年 PayBay. All rights reserved.
//

import UIKit

class ParentClassViewController: UITabBarController,UITabBarControllerDelegate {

    
    var currentSelectedIndex : Int = -1
    override func viewDidLoad() {
        super.viewDidLoad()

        self.delegate = self
    
    }
    
    func tabBarController(tabBarController: UITabBarController, didSelectViewController viewController: UIViewController) {
        
        if self.selectedIndex == 0 {
            if currentSelectedIndex == 0 {
                HotFocusViewController.shareHotFocusViewController().requestData()
            }
        }
        currentSelectedIndex = self.selectedIndex
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
