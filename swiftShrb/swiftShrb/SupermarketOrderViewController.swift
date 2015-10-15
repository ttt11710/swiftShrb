//
//  SupermarketOrderViewController.swift
//  swiftShrb
//
//  Created by PayBay on 15/10/14.
//  Copyright © 2015年 PayBay. All rights reserved.
//

import UIKit
import BFPaperButton

class SupermarketOrderViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    var merchId :String = ""
    
    var tableView : UITableView!
    
    var submitOrderBtn : BFPaperButton!
    
    var dataArray : NSMutableArray = ["纯色拼接修身外套","简约拉链夹克","纯棉9分直筒裤","男士休闲羊毛西服"]
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "购物车"
        
        self.creatTableView()
        self.creatSubmitOrderBtn()

        // Do any additional setup after loading the view.
    }

    func creatTableView() {
        tableView = UITableView(frame: CGRectMake(0, 0, screenWidth, screenHeight-44))
        tableView.backgroundColor = shrbTableViewColor
        tableView.tableFooterView = UIView()
        
        tableView.delegate = self
        tableView.dataSource = self
        self.view.addSubview(tableView)
    
    }
    
    func creatSubmitOrderBtn() {
        
        submitOrderBtn = BFPaperButton()
        submitOrderBtn.backgroundColor = shrbPink
        submitOrderBtn.frame = CGRectMake(0, screenHeight-44, screenWidth, 44)
        submitOrderBtn.setTitle("提交订单", forState: .Normal)
        submitOrderBtn.titleFont = font18
        submitOrderBtn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        submitOrderBtn.addTarget(self, action: Selector("submitOrder"), forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(submitOrderBtn)
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArray.count + 2
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cellId")
            let cell = tableView.dequeueReusableCellWithIdentifier("cellId", forIndexPath: indexPath) as UITableViewCell
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            
            cell.textLabel?.text = String(format: "共%lu件商品", self.dataArray.count)
            
            cell.textLabel?.textColor = shrbText
            cell.textLabel?.font = font15
            
            return cell

        }
        else if indexPath.row <= self.dataArray.count {
            
            tableView.registerNib(UINib(nibName: "orderTableViewCell", bundle: nil), forCellReuseIdentifier: "orderTableViewCellId")
            let cell = tableView.dequeueReusableCellWithIdentifier("orderTableViewCellId", forIndexPath: indexPath) as! orderTableViewCell
            
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            
            cell.tradeNameLabel.text = self.dataArray[indexPath.row-1] as? String
            cell.tradeImageView.sd_setImageWithURL(NSURL(string: ""), placeholderImage: UIImage(named: "热点无图片"))
            cell.priceLabel.text = "￥300 原价￥350"
            cell.amountTextField.text = "1"
            cell.moneyLabel.text = "￥300"
            
            return cell
            
        }
        else {
            tableView.registerNib(UINib(nibName: "PriceGatherTableViewCell", bundle: nil), forCellReuseIdentifier: "PriceGatherTableViewCellId")
            let cell = tableView.dequeueReusableCellWithIdentifier("PriceGatherTableViewCellId", forIndexPath: indexPath) as! PriceGatherTableViewCell
            
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            
            cell.totalLabel.text = "总价:450元"
            cell.memberTotalLabel.text = "会员价:350元"
            
            let checkBoxData = TNImageCheckBoxData()
            checkBoxData.identifier = "check"
            checkBoxData.labelText = "100PMB电子券"
            checkBoxData.labelColor = UIColor(red: 78.0/255.0, green: 78.0/255.0, blue: 78.0/255.0, alpha: 1)
            checkBoxData.labelFont = font14
            checkBoxData.checked = true
            checkBoxData.checkedImage = UIImage(named: "checked")
            checkBoxData.uncheckedImage = UIImage(named: "unchecked")
            
            if cell.checkCouponsView.checkedCheckBoxes == nil {
                cell.checkCouponsView.myInitWithCheckBoxData([checkBoxData], style: TNCheckBoxLayoutVertical)
                cell.checkCouponsView.create()
            }
            
            return cell
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        if indexPath.row == 0 {
            return 44
        }
        else if indexPath.row <= self.dataArray.count {
            return 93
        }
        else {
            return 100
        }
    }
    
    
    func submitOrder() {
        
        let superMarketChoosePayTypeViewController = SuperMarketChoosePayTypeViewController()
        superMarketChoosePayTypeViewController.merchId = self.merchId
        self.navigationController?.pushViewController(superMarketChoosePayTypeViewController, animated: true)
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
