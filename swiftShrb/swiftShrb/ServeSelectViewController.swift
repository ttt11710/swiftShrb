//
//  ServeSelectViewController.swift
//  swiftShrb
//
//  Created by PayBay on 15/10/28.
//  Copyright © 2015年 PayBay. All rights reserved.
//

import UIKit

class ServeSelectViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    var tableView : UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "服务选择"
        
        self.createTableView()
        // Do any additional setup after loading the view.
    }

    func createTableView() {
        
        self.tableView = UITableView(frame: CGRectMake(0, 0, screenWidth, screenHeight))
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.backgroundColor = shrbTableViewColor
        self.tableView.tableFooterView = UIView(frame: CGRectMake(0,0,screenWidth,40))
        self.view.addSubview(self.tableView)
    }

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        return 80
        
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return 2
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cellId")
        let cell : UITableViewCell = UITableViewCell(style: .Subtitle, reuseIdentifier: "cellId")

        cell.selectionStyle = UITableViewCellSelectionStyle.None
        cell.accessoryType = .DisclosureIndicator

        cell.textLabel?.textColor = shrbText
        cell.detailTextLabel?.textColor = shrbLightText
        cell.detailTextLabel?.font = font15
        cell.textLabel?.text = indexPath.row == 0 ? "退货退款" : "仅退款"
        cell.detailTextLabel?.text = indexPath.row == 0 ? "已收到货，需要退还已收到的货物" : "未收到货，或与商家协商同意前提下申请"
        
        return cell
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == 1 {
            self.navigationController?.pushViewController(AppleRefundViewController(), animated: true)
        }
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
