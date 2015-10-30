//
//  RefundOrderViewController.swift
//  swiftShrb
//
//  Created by PayBay on 15/10/28.
//  Copyright © 2015年 PayBay. All rights reserved.
//

import UIKit

class RefundOrderViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    
    var tableView : UITableView!
    
    var dataArray : NSMutableArray = [["storeLogoImageView":"冰雪皇后",
        "storeNameLabel":"冰雪皇后",
        "stateLabel":"退款成功",
        "orderImageView":"冰雪皇后",
        "moneyLabel":"2300",
        "refundmoney":"1050",
        "date":"15:30 2015/06/13",
        "orderNum":"201506010003",
        "address":"徐汇区"],
        ["storeLogoImageView":"辛巴克",
            "storeNameLabel":"辛巴克",
            "stateLabel":"退款成功",
            "orderImageView":"辛巴克",
            "moneyLabel":"105",
            "refundmoney":"100",
            "date":"18:30 2015/06/01",
            "orderNum":"201506010001",
            "address":"上海市徐汇区龙吴路1333号华滨家园23#1202室"],["storeLogoImageView":"辛巴克",
                "storeNameLabel":"辛巴克",
                "stateLabel":"退款成功",
                "orderImageView":"辛巴克",
                "moneyLabel":"400",
                "refundmoney":"210",
                "date":"12:30 2015/06/04",
                "orderNum":"201506010004",
                "address":"徐汇区"],
        ["storeLogoImageView":"吉野家",
            "storeNameLabel":"吉野家",
            "stateLabel":"退款成功",
            "orderImageView":"吉野家",
            "moneyLabel":"350",
            "refundmoney":"200",
            "date":"18:30 2015/06/23",
            "orderNum":"201506010006",
            "address":"徐汇区"],
        ["storeLogoImageView":"冰雪皇后",
            "storeNameLabel":"冰雪皇后",
            "stateLabel":"退款成功",
            "orderImageView":"冰雪皇后",
            "moneyLabel":"33440",
            "refundmoney":"33000",
            "date":"18:30 2015/06/12",
            "orderNum":"201506010011",
            "address":"徐汇区"]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.creatTableView()
        // Do any additional setup after loading the view.
    }
    
    func creatTableView() {
        self.tableView = UITableView(frame: CGRectMake(0, 42, screenWidth, screenHeight-42))
        self.tableView.tableFooterView = UIView()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.backgroundColor = shrbTableViewColor
        
        self.view.addSubview(self.tableView)
        
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 190 + 8
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.dataArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        tableView.registerNib(UINib(nibName: "OrderFinishTableViewCell", bundle: nil), forCellReuseIdentifier: "OrderFinishTableViewCellId")
        let cell = tableView.dequeueReusableCellWithIdentifier("OrderFinishTableViewCellId", forIndexPath: indexPath) as! OrderFinishTableViewCell
        
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        cell.storeLogoImageView.image = UIImage(named: (self.dataArray.objectAtIndex(indexPath.row)["storeLogoImageView"] as! String))
        cell.storeNameLabel.text = self.dataArray.objectAtIndex(indexPath.row)["storeNameLabel"] as? String
        cell.stateLabel.text = self.dataArray.objectAtIndex(indexPath.row)["stateLabel"] as? String
        cell.orderImageView.image = UIImage(named: (self.dataArray.objectAtIndex(indexPath.row)["orderImageView"] as! String))
        cell.orderNum.text = String(format: "订单:%@", self.dataArray.objectAtIndex(indexPath.row)["orderNum"] as! String)
        cell.address.text = String(format: "地址:%@", self.dataArray.objectAtIndex(indexPath.row)["address"] as! String)
        cell.date.text = self.dataArray.objectAtIndex(indexPath.row)["date"] as? String
        cell.moneyLabel.text = String(format: "交易金额:%@元 退款金额:%@元", (self.dataArray.objectAtIndex(indexPath.row)["moneyLabel"] as! String), (self.dataArray.objectAtIndex(indexPath.row)["refundmoney"] as! String))
        
        
        let string =  self.dataArray.objectAtIndex(indexPath.row)["refundmoney"] as! String
        let attrString : NSMutableAttributedString = NSMutableAttributedString(string: cell.moneyLabel.text!)
        
        attrString.addAttribute(NSForegroundColorAttributeName, value:shrbPink, range: NSMakeRange((cell.moneyLabel.text?.characters.count)!-string.characters.count-1, string.characters.count+1))
        cell.moneyLabel.attributedText = attrString
        
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
