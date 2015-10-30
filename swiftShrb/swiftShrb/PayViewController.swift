//
//  PayViewController.swift
//  swiftShrb
//
//  Created by PayBay on 15/10/27.
//  Copyright © 2015年 PayBay. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SDWebImage

class PayViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    var prodId : String = ""
    var merchId : String = ""
    var totalPrice : CGFloat = 0.00
    var shoppingArray : NSMutableArray = []
    
    var tableView : UITableView!
    var checkCouponsView : TNCheckBoxGroup!
    
    var gotoPayBtn : UIButton!
    
    var payTypeArray : NSMutableArray = [["payTypeLogo":"paybayLogo","payTypeName":"会员卡支付","payRuleLabel":"允许注册本店会员的用户使用"],["payTypeLogo":"weixinpay","payTypeName":"微信支付","payRuleLabel":"推荐安装微信5.0及以上版本的使用"],["payTypeLogo":"yinhangpay","payTypeName":"银行卡支付","payRuleLabel":"支持储蓄卡信用卡，无需开通网银"]]
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "付款"
        self.createTableView()
        self.creatBtn()
        // Do any additional setup after loading the view.
    }

    func createTableView() {
        
        self.tableView = UITableView(frame: CGRectMake(0, 0, screenWidth, screenHeight-44))
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.backgroundColor = shrbTableViewColor
        self.tableView.tableFooterView = UIView(frame: CGRectMake(0,0,screenWidth,60))
        self.view.addSubview(self.tableView)
    }

    func creatBtn() {
        
        self.gotoPayBtn = UIButton(type: .Custom)
        self.gotoPayBtn.frame = CGRectMake(0, screenHeight-44, screenWidth, 44)
        self.gotoPayBtn.backgroundColor = shrbPink
        self.gotoPayBtn.setTitle("提交订单", forState: UIControlState.Normal)
        self.gotoPayBtn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        self.gotoPayBtn.titleLabel?.font = font17
        self.gotoPayBtn.addTarget(self, action: Selector("gotoPayView"), forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(self.gotoPayBtn)
    }

    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {

        if indexPath.row == 0 || indexPath.row == self.shoppingArray.count+1 || indexPath.row == self.shoppingArray.count+2 {
            return 44
        }
        else if indexPath.row == self.shoppingArray.count+3 || indexPath.row == self.shoppingArray.count+4 || indexPath.row == self.shoppingArray.count+5 {
            return 55
        }
        else {
            return 93
        }
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.shoppingArray.count + 6
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cellId")
            let cell = tableView.dequeueReusableCellWithIdentifier("cellId", forIndexPath: indexPath) as UITableViewCell
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            
            
            cell.textLabel?.text = String(format: "共%lu件商品", self.shoppingArray.count)
            cell.textLabel?.font = font15
            cell.textLabel?.textColor = shrbText
            
            return cell
        }
        else if indexPath.row == self.shoppingArray.count+1 {
            tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cellId")
            let cell = tableView.dequeueReusableCellWithIdentifier("cellId", forIndexPath: indexPath) as UITableViewCell
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            
            let checkBoxData = TNImageCheckBoxData()
            checkBoxData.identifier = "check"
            checkBoxData.labelText = "100RMB电子券"
            checkBoxData.labelColor = UIColor(red: 78.0/255.0, green: 78.0/255.0, blue: 78.0/255.0, alpha: 1)
            checkBoxData.labelFont = font14
            checkBoxData.checked = true
            checkBoxData.checkedImage = UIImage(named: "checked")
            checkBoxData.uncheckedImage = UIImage(named: "unchecked")
            
            self.checkCouponsView = TNCheckBoxGroup(checkBoxData: [checkBoxData], style: TNCheckBoxLayoutVertical)
            self.checkCouponsView.frame = CGRectMake(screenWidth-150, 8, 100, 30)
            self.checkCouponsView.myCreate()
            
            
            NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("userCouponsChanged:"), name: GROUP_CHANGED, object: self.checkCouponsView)
            
            cell.addSubview(self.checkCouponsView)
            
            return cell
            
        }
        else if indexPath.row == self.shoppingArray.count+2 {
            tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cellId")
            let cell = tableView.dequeueReusableCellWithIdentifier("cellId", forIndexPath: indexPath) as UITableViewCell
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            
            
            cell.textLabel?.text = String(format: "实付款:￥%.2f", self.totalPrice)
            cell.textLabel?.font = font15
            cell.textLabel?.textColor = shrbText
            
            return cell
        }
        else if indexPath.row >= self.shoppingArray.count+3 && indexPath.row <= self.shoppingArray.count+5 {
            tableView.registerNib(UINib(nibName: "OrderChoosePayTableViewCell", bundle: nil), forCellReuseIdentifier: "OrderChoosePayTableViewCellId")
            let cell = tableView.dequeueReusableCellWithIdentifier("OrderChoosePayTableViewCellId", forIndexPath: indexPath) as! OrderChoosePayTableViewCell
            
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            var i : Int = indexPath.row
            i = i-(self.shoppingArray.count+3)
            cell.payTypeLogo.image = UIImage(named: self.payTypeArray.objectAtIndex(i)["payTypeLogo"] as! String)
            cell.payTypeName.text = self.payTypeArray.objectAtIndex(i)["payTypeName"] as? String
            cell.payRuleLabel.text = self.payTypeArray.objectAtIndex(i)["payRuleLabel"] as? String
            if i != 0 {
               cell.payTypeChooseBtn.setImage(UIImage(named: "payUncheck"), forState: UIControlState.Normal)
            }
            
            
            return cell
        }
        else {
            tableView.registerNib(UINib(nibName: "orderTableViewCell", bundle: nil), forCellReuseIdentifier: "orderTableViewCellId")
            let cell = tableView.dequeueReusableCellWithIdentifier("orderTableViewCellId", forIndexPath: indexPath) as! orderTableViewCell
            
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            
            let shoppingCardDataItem : ShoppingCardDataItem = self.shoppingArray[indexPath.row-1] as! ShoppingCardDataItem
            
            cell.tradeNameLabel.text = shoppingCardDataItem.prodList.prodName
            cell.tradeImageView.sd_setImageWithURL(NSURL(string: shoppingCardDataItem.prodList.imgUrl), placeholderImage: UIImage(named: "热点无图片"))
            cell.tradeDescriptionLabel.text = shoppingCardDataItem.prodList.prodDesc
            
            
            cell.priceLabel.text = String(format: "￥%.2f 原价￥%.2f", shoppingCardDataItem.prodList.price , shoppingCardDataItem.prodList.vipPrice)

            cell.amountTextField.text = shoppingCardDataItem.count
            cell.moneyLabel.text = String(Float(shoppingCardDataItem.count)!  * shoppingCardDataItem.prodList.price)
            
            return cell

        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        for indexPath in self.tableView.indexPathsForVisibleRows! {
            if indexPath.row >= self.shoppingArray.count+3 && indexPath.row <=  self.shoppingArray.count+5 {
                let cell : OrderChoosePayTableViewCell = self.tableView.cellForRowAtIndexPath(indexPath) as! OrderChoosePayTableViewCell
                cell.payTypeChooseBtn.setImage(UIImage(named: "payUncheck"), forState: UIControlState.Normal)
            }
        }
        
        if indexPath.row >= self.shoppingArray.count+3 && indexPath.row <=  self.shoppingArray.count+5 {
            let cell : OrderChoosePayTableViewCell = self.tableView.cellForRowAtIndexPath(indexPath) as! OrderChoosePayTableViewCell
            
            if cell.payTypeChooseBtn.currentImage!.isEqual(UIImage(named: "payUncheck")) {
                cell.payTypeChooseBtn.setImage(UIImage(named: "paycheck"), forState: UIControlState.Normal)
            }
            else {
                cell.payTypeChooseBtn.setImage(UIImage(named: "payUncheck"), forState: UIControlState.Normal)
            }
            
        }


    }
    
    func userCouponsChanged(notification : NSNotification) {
        
        print(self.checkCouponsView.checkedCheckBoxes)
        print(self.checkCouponsView.uncheckedCheckBoxes)
    }

    
    func gotoPayView() {
       
        for indexPath in self.tableView.indexPathsForVisibleRows! {
            if indexPath.row >= self.shoppingArray.count+3 && indexPath.row <=  self.shoppingArray.count+5 {
                let cell : OrderChoosePayTableViewCell = self.tableView.cellForRowAtIndexPath(indexPath) as! OrderChoosePayTableViewCell
                
                if cell.payTypeChooseBtn.currentImage!.isEqual(UIImage(named: "paycheck")) {
                    switch indexPath.row - self.shoppingArray.count {
                    case 3:
                        self.cardPay()
                        break
                    case 4:
                        SVProgressShow.showInfoWithStatus("支付方式:微信")
                        break
                    case 5:
                        SVProgressShow.showInfoWithStatus("支付方式:银行卡")
                    default:
                        break
                    }
                }
            }
        }
        
    }
    
    func cardPay() {
        if CurrentUser.user == nil {
            SVProgressShow.showInfoWithStatus("请先登录!")
            return
        }
        
        SVProgressShow.showWithStatus("支付处理中...")
        
        Alamofire.request(.GET, baseUrl + "/card/v1.0/findCardByMerch?", parameters: ["token":CurrentUser.user?.token == nil ? "" : CurrentUser.user!.token,"userId":CurrentUser.user?.userId == nil ? "" : CurrentUser.user!.userId,"merchId":self.merchId])
            
            .response { request, response, data, error in
                
                if error == nil {
                    let json  = JSON(data: data!)
                    if json["code"].stringValue == "200" {
                        // self.merchModel =  MerchModel.merchModel(json)
                    }
                    if RequestDataTool.processingDataMes(json) != nil {
                        let cardNo : String = RequestDataTool.processingDataMes(json)["data"]["cardNo"].stringValue
                        
                        Alamofire.request(.GET, baseUrl + "/card/v1.0/pay?", parameters: ["token":CurrentUser.user?.token == nil ? "" : CurrentUser.user!.token,"userId":CurrentUser.user?.userId == nil ? "" : CurrentUser.user!.userId,"cardNo":cardNo,"payAmount":self.totalPrice,"merchId":self.merchId])
                            .response { request, response, data, error in
                                
                                if error == nil {
                                    if RequestDataTool.processingDataMes(json) != nil {
                                        SVProgressShow.showSuccessWithStatus("支付完成!")
                                        
                                        
                                        let completeVoucherViewController = CompleteVoucherViewController()
                                        completeVoucherViewController.merchId = self.merchId
                                        completeVoucherViewController.cardNo = cardNo
                                        completeVoucherViewController.title = "支付完成"
                                        self.navigationController?.pushViewController(completeVoucherViewController, animated: true)
                                    }
                                }
                        }
                    }
                   
                }
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
