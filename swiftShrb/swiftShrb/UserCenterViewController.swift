//
//  UserCenterViewController.swift
//  swiftShrb
//
//  Created by PayBay on 15/9/29.
//  Copyright © 2015年 PayBay. All rights reserved.
//

import UIKit

class UserCenterViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    var tableView : UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setTableView()

        self.title = "我的"
        // Do any additional setup after loading the view.
    }

    func setTableView() {
        tableView = UITableView(frame: CGRectMake(0, 44+20, screenWidth, screenHeight-44-20 - 49))
        tableView.delegate = self
        tableView.dataSource = self
        self.view.addSubview(tableView)
        
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        tableView.registerNib(UINib(nibName: "HotFocusTableViewCell", bundle: nil), forCellReuseIdentifier: "HotFocusTableViewCellId")
        let cell = tableView.dequeueReusableCellWithIdentifier("HotFocusTableViewCellId", forIndexPath: indexPath) as! HotFocusTableViewCell
        
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        
        cell.textLabel?.text = "wode"
        
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        return 68
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
