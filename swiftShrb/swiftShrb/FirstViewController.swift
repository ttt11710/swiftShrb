//
//  FirstViewController.swift
//  swiftShrb
//
//  Created by PayBay on 15/9/28.
//  Copyright © 2015年 PayBay. All rights reserved.
//

import UIKit


class FirstViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    var tableView : UITableView!

    let data = [
        ["orderImageView":"辛巴克.jpg","money":"金额：100元","date":"时间：18:30 2015/06/01","orderNum":"订单号：201506010001","address":"地区：上海市徐汇区龙吴路1333号华滨家园23#1202室12345343243243214321432672222222222334563456734567"],
        ["orderImageView":"冰雪皇后.jpg","money":"金额：2300元","date":"时间：15:30 2015/06/13","orderNum":"订单号：201506010003","address":"地区：徐汇区"],
        ["orderImageView":"雀巢.jpg","money":"金额：400元","date":"时间：12:30 2015/06/04","orderNum":"订单号：201506010004","address":"地区：徐汇区"],
        ["orderImageView":"吉野家.jpg","money":"金额：350元","date":"时间：18:30 2015/06/23","orderNum":"订单号：201506010006","address":"地区：徐汇区"],
        ["orderImageView":"雀巢.jpg","money":"金额：33440元","date":"时间：18:30 2015/06/12","orderNum":"订单号：201506010011","address":"地区：徐汇区"],
    ]

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "热点"
        self.setTableView()
        
    }
    
    func setTableView() {
        tableView = UITableView(frame: CGRectMake(0, 44+20, screenWidth, screenHeight-44-20))
        tableView.delegate = self
        tableView.dataSource = self
        self.view.addSubview(tableView)
        
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier:"cell")
        
        cell.textLabel?.text = data[indexPath.row]["date"]
        
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        return 110
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

