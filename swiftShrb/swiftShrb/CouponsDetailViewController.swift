//
//  CouponsDetailViewController.swift
//  swiftShrb
//
//  Created by PayBay on 15/10/28.
//  Copyright © 2015年 PayBay. All rights reserved.
//

import UIKit

class CouponsDetailViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    var tableView : UITableView!
    
    var dataArray : NSMutableArray = [[
        "couponsImage" : "辛巴克",
        "money" : "10000",
        "count":"4",
        "expirationDate":"2016-3-2",
        "canUse":true
        ],
        [
            "couponsImage" : "辛巴克",
            "money" : "2000",
            "count":"1",
            "expirationDate":"2016-4-2",
            "canUse":true
        ],
        [
            "couponsImage" : "辛巴克",
            "money" : "3000",
            "count":"3",
            "expirationDate":"2016-2-2",
            "canUse":false
        ],
        [
            "couponsImage" : "辛巴克",
            "money" : "4000",
            "count":"10",
            "expirationDate":"2016-1-2",
            "canUse":false
        ],
        [
            "couponsImage" : "辛巴克",
            "money" : "200",
            "count":"2",
            "expirationDate":"2015-12-2",
            "canUse":false
        ],
        [
            "couponsImage" : "辛巴克",
            "money" : "2000",
            "count":"1",
            "expirationDate":"2016-4-2",
            "canUse":true
        ]]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "电子券详情"
        self.creatTableView()
        
        // Do any additional setup after loading the view.
    }

    func creatTableView() {
        
        tableView = UITableView(frame: CGRectMake(0, 0, screenWidth, screenHeight))
        tableView.separatorStyle = .None
        tableView.backgroundColor = shrbTableViewColor
        tableView.delegate = self
        tableView.dataSource = self
        self.view.addSubview(tableView)
        
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArray.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 135
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        tableView.registerNib(UINib(nibName: "CouponsDetailTableViewCell", bundle: nil), forCellReuseIdentifier: "CouponsDetailTableViewCellId")
        let cell = tableView.dequeueReusableCellWithIdentifier("CouponsDetailTableViewCellId", forIndexPath: indexPath) as! CouponsDetailTableViewCell
        
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        cell.backgroundColor = shrbTableViewColor
        
        cell.couponsImageView.image = UIImage(named: self.dataArray[indexPath.row]["couponsImage"] as! String)
        
        let string : String = String(format: "￥%@RMB", self.dataArray[indexPath.row]["money"] as! String)
        let attrString : NSMutableAttributedString = NSMutableAttributedString(string: string)
        
        attrString.addAttribute(NSForegroundColorAttributeName, value:UIColor(red: 251.0/255.0, green: 102.0/255.0, blue: 49.0/255.0, alpha: 1), range: NSMakeRange(0, string.characters.count))
        
        attrString.addAttribute(NSFontAttributeName, value: UIFont.systemFontOfSize(34), range: NSMakeRange(1, string.characters.count-1))
        
        if isIphone4s {
            attrString.addAttribute(NSFontAttributeName, value: UIFont.systemFontOfSize(24), range: NSMakeRange(1, string.characters.count-1))
        }
        cell.moneyLabel.attributedText = attrString
        cell.expirationDateLabel.text = String(format: "有效期至:%@", self.dataArray[indexPath.row]["expirationDate"] as! String)
        cell.countLabel.hidden = true
        cell.giveFriendsOnlyBtn.tag = indexPath.row
        cell.userCouponBtn.tag = indexPath.row
    
        if self.dataArray[indexPath.row]["canUse"] as! Bool {
            
            cell.userCouponBtn.setupBlock()
            cell.userCouponBtn.callBack = { tag in
                print("转存")
                self.navigationController?.pushViewController(UserCouponsViewController(), animated: true)
            }
        }
        else {
            cell.userCouponBtn.userInteractionEnabled = false
            cell.userCouponBtn.titleLabel?.textColor = shrbLightText
        }
        cell.giveFriendsOnlyBtn.setupBlock()
        cell.giveFriendsOnlyBtn.callBack = { tag in
            print("送好友")
            
            self.navigationController?.pushViewController(GiveCouponsViewController(), animated: true)
        }
        
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
