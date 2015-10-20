//
//  HelpCenterViewController.swift
//  swiftShrb
//
//  Created by PayBay on 15/10/19.
//  Copyright © 2015年 PayBay. All rights reserved.
//

import UIKit

class HelpCenterViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    var tableView : UITableView!
    var dataArray : NSMutableArray = ["如何注册会员卡?","如何给会员卡充值?","如何用会员卡提现?","如何注销会员卡?","如何使用电子券?","如何赠送好友电子券?"]
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "帮助中心"
        
        self.creatTableView()
        // Do any additional setup after loading the view.
    }
    
    func creatTableView() {
        self.tableView = UITableView(frame: CGRectMake(0, 0, screenWidth, screenHeight), style: .Plain)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.backgroundColor = shrbTableViewColor
        self.tableView.tableFooterView = UIView()
        self.view.addSubview(self.tableView)
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArray.count
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "常见问题"
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let height : CGFloat = 44
        let headerView = UIView(frame: CGRectMake(0, 0, tableView.bounds.size.width, height))
        headerView.backgroundColor = UIColor.whiteColor()
        
        let label = UILabel(frame: CGRectMake(16, (height-18)*0.5, tableView.bounds.size.width - 10, 18))
        label.textColor = shrbText
        label.text = "常见问题"
        label.backgroundColor = UIColor.clearColor()
        headerView.addSubview(label)
        
        let footView = UIView(frame: CGRectMake(0, height-1, tableView.bounds.size.width, 1))
        footView.backgroundColor = shrbTableViewColor
        headerView.addSubview(footView)
        
        return headerView
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cellId")
        let cell = tableView.dequeueReusableCellWithIdentifier("cellId", forIndexPath: indexPath) as UITableViewCell
        
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        cell.accessoryType = .DisclosureIndicator
        cell.textLabel?.text = self.dataArray[indexPath.row] as? String
        cell.textLabel?.textColor = shrbText
        
        cell
        
        
        return cell
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
