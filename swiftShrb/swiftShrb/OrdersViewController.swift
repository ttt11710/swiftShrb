//
//  OrdersViewController.swift
//  swiftShrb
//
//  Created by PayBay on 15/10/27.
//  Copyright © 2015年 PayBay. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SDWebImage

class OrdersViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    var tnCheckBoxGroup : TNCheckBoxGroup!
    var tap : UITapGestureRecognizer!
    
    var vipPrice : Float = 0.00
    var price : Float = 0.00
    var prodId : String = ""
    var merchId : String = ""
    var shoppingArray : NSMutableArray = []
    
    var merchName : String = ""
    
    var isMember : Bool = false
    
    var cardDataDic : JSON = []
    
    var tableView : UITableView!
    var gotoPayBtn : UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.merchName = self.title!
        
        self.title = "订单详情"
        self.createTableView()
        
        self.creatBtn()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.requestData()
    }

    func createTableView() {
        
        self.tableView = UITableView(frame: CGRectMake(0, 0, screenWidth, screenHeight-44))
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.backgroundColor = shrbTableViewColor
        self.tableView.tableFooterView = UIView(frame: CGRectMake(0,0,screenWidth,40))
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

    func requestData() {
        
        SVProgressShow.showWithStatus("加载中...")
        
        Alamofire.request(.GET, baseUrl + "/product/v1.0/getProduct?", parameters: ["token":CurrentUser.user?.token == nil ? "" : CurrentUser.user!.token,"prodId":self.prodId])
            
            .response { request, response, data, error in
                
                if error == nil {
                    let json  = JSON(data: data!)
                    
                    if RequestDataTool.processingData(json) == nil {
                        return
                    }
                    if RequestDataTool.processingData(json)["card"].isEmpty {
                        self.isMember = false
                    }
                    else {
                        self.isMember = true
                        self.cardDataDic = json["card"]
                        
                    }
                    
                    self.price = 0.00
                    self.vipPrice = 0.00
                    
                    self.tableView.reloadData()
                    SVProgressShow.dismiss()
                }
        }
        
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if self.isMember {
            if indexPath.row < self.shoppingArray.count {
                return 93
            }
            else if indexPath.row == self.shoppingArray.count {
                return 88
            }
            else {
                return screenWidth/170*90+10
            }
        }
        else {
            if indexPath.row < self.shoppingArray.count {
                return 93
            }
            else if indexPath.row == self.shoppingArray.count {
                return 88
            }
            else if indexPath.row == self.shoppingArray.count+1 {
                return 120
            }
            else {
                return 164
            }
        }
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.isMember ? self.shoppingArray.count+2 : self.shoppingArray.count+3
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if indexPath.row < self.shoppingArray.count {
            tableView.registerNib(UINib(nibName: "orderTableViewCell", bundle: nil), forCellReuseIdentifier: "orderTableViewCellId")
            let cell = tableView.dequeueReusableCellWithIdentifier("orderTableViewCellId", forIndexPath: indexPath) as! orderTableViewCell
            
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            let shoppingCardDataItem : ShoppingCardDataItem = self.shoppingArray[indexPath.row] as! ShoppingCardDataItem
            
            cell.tradeNameLabel.text = shoppingCardDataItem.prodList.prodName
            cell.tradeImageView.sd_setImageWithURL(NSURL(string: shoppingCardDataItem.prodList.imgUrl), placeholderImage: UIImage(named: "热点无图片"))
            cell.tradeDescriptionLabel.text = shoppingCardDataItem.prodList.prodDesc
                
            
            cell.priceLabel.text = String(format: "￥%.2f 原价￥%.2f", shoppingCardDataItem.prodList.price , shoppingCardDataItem.prodList.vipPrice)
            
            let vipString : String = String(format: "%.2f", shoppingCardDataItem.prodList.vipPrice!)
            
            let priceString : String = String(format: "%.2f", shoppingCardDataItem.prodList.price!)
            
            let attrString : NSMutableAttributedString = NSMutableAttributedString(string: cell.priceLabel.text!)
            
            attrString.addAttribute(NSStrikethroughStyleAttributeName, value:NSNumber(integer: 1), range: NSMakeRange(vipString.characters.count+2, priceString.characters.count+3))
            
            attrString.addAttribute(NSForegroundColorAttributeName, value:shrbPink, range: NSMakeRange(0, vipString.characters.count+1))
            
            attrString.addAttribute(NSForegroundColorAttributeName, value:shrbLightText, range: NSMakeRange(vipString.characters.count+2, priceString.characters.count+3))
            
            
            attrString.addAttribute(NSFontAttributeName, value:font20, range: NSMakeRange(0, vipString.characters.count+1))
            attrString.addAttribute(NSFontAttributeName, value:font14, range: NSMakeRange(vipString.characters.count+2, priceString.characters.count+3))
            cell.priceLabel.attributedText = attrString
            
            cell.amountTextField.hidden = true
            cell.moneyLabel.hidden = true
            
                
            let numbutton : HJCAjustNumButton3 = HJCAjustNumButton3()
            numbutton.currentNum = shoppingCardDataItem.count
            numbutton.frame = CGRectMake(screenWidth-85,34 , 75, 25)
            numbutton.callBack = { currentNum in
                
                shoppingCardDataItem.count = currentNum
                self.vipPrice = 0.00
                self.price = 0.00
                self.tableView.reloadData()
            }
            cell.addSubview(numbutton)
            self.vipPrice = self.vipPrice + Float(shoppingCardDataItem.count)!  * shoppingCardDataItem.prodList.vipPrice
            self.price = self.price + Float(shoppingCardDataItem.count)!  * shoppingCardDataItem.prodList.price
            
            return cell
        }
        else if indexPath.row == self.shoppingArray.count {
           
            tableView.registerNib(UINib(nibName: "PriceGatherTableViewCell", bundle: nil), forCellReuseIdentifier: "PriceGatherTableViewCellId")
            let cell = tableView.dequeueReusableCellWithIdentifier("PriceGatherTableViewCellId", forIndexPath: indexPath) as! PriceGatherTableViewCell
            
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            
            cell.totalLabel.text = String(format: "总价:￥%.2f", self.price)
            cell.memberTotalLabel.text = String(format: "会员价:￥%.2f", self.vipPrice)
            
            let checkBoxData = TNImageCheckBoxData()
            checkBoxData.identifier = "check"
            checkBoxData.labelText = "100RMB电子券"
            checkBoxData.labelColor = UIColor(red: 78.0/255.0, green: 78.0/255.0, blue: 78.0/255.0, alpha: 1)
            checkBoxData.labelFont = font14
            checkBoxData.checked = true
            checkBoxData.checkedImage = UIImage(named: "checked")
            checkBoxData.uncheckedImage = UIImage(named: "unchecked")
            
            if cell.checkCouponsView.checkedCheckBoxes == nil {
                cell.checkCouponsView.myInitWithCheckBoxData([checkBoxData], style: TNCheckBoxLayoutVertical)
                cell.checkCouponsView.create()
            }
            
            NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("userCouponsChanged:"), name: GROUP_CHANGED, object: cell.checkCouponsView)
            
            return cell
        }
        else if indexPath.row == self.shoppingArray.count+1 {
            if self.isMember {
                tableView.registerNib(UINib(nibName: "CardDetailTableViewCell", bundle: nil), forCellReuseIdentifier: "CardDetailTableViewCellId")
                let cell = tableView.dequeueReusableCellWithIdentifier("CardDetailTableViewCellId", forIndexPath: indexPath) as! CardDetailTableViewCell
                
                cell.selectionStyle = UITableViewCellSelectionStyle.None
                
                
                if self.cardDataDic != nil {
                    
                    cell.cardBackView.backgroundColor = shrbLightCell
                    cell.cardBackImageView.sd_setImageWithURL(NSURL(string: self.cardDataDic["cardImgUrl"].stringValue), placeholderImage: UIImage(named: "cardBack"))
                    cell.merchNameLabel.text = self.merchName
                    cell.amountLabel.text! = String(format: "金额:￥%.2f",self.cardDataDic["amount"].floatValue)
                    cell.scoreLabel.text = String(format: "积分:%.0f", self.cardDataDic["score"].floatValue)
                    cell.cardNoLabel.text = String(format: "卡号:%@", self.cardDataDic["cardNo"].stringValue)
                    
                }
                
                return cell

            }
            else {
                tableView.registerNib(UINib(nibName: "AutoresizeLabelTableViewCell", bundle: nil), forCellReuseIdentifier: "AutoresizeLabelTableViewCellId")
                let cell = tableView.dequeueReusableCellWithIdentifier("AutoresizeLabelTableViewCellId", forIndexPath: indexPath) as! AutoresizeLabelTableViewCell
                
                cell.selectionStyle = UITableViewCellSelectionStyle.None
                
                cell.autoresizeLabel.text = "会员好处：成为会员可以享受会员折扣，付款可直接用会员卡，并有更多优惠哦！\n\n会员规则:会员卡充值后不可以取现，可以注销，同时扣除手续费5%。"
                
                return cell

            }
        }
        else {
            tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cellId")
            let cell = tableView.dequeueReusableCellWithIdentifier("cellId", forIndexPath: indexPath) as UITableViewCell
            
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            
            
            
            let button : UIButton = UIButton(type: .Custom)
            button.frame = CGRectMake(16, 60, screenWidth-32, 44)
            button.setTitle("会员注册", forState: .Normal)
            button.setTitleColor(UIColor.whiteColor(), forState: .Normal)
            button.titleLabel?.font = font18
            button.backgroundColor = shrbPink
            button.layer.cornerRadius = 4
            button.layer.masksToBounds = true
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: Selector("getProduct"))
            button.addGestureRecognizer(tapGestureRecognizer)
            
            cell.contentView.addSubview(button)
        
            return cell

        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == self.shoppingArray.count+1 {
            if self.isMember {
                self.gotoCardDetailTap()
            }
        }
    }
    
    
    func gotoCardDetailTap() {
        
        UserDefaultsSaveInfo.userDefaultsStandardUserDefaultsObject("viewControllers[0]", keyString: "QRPay")
        let cardDetailViewController = CardDetailViewController()
        cardDetailViewController.merchId = self.cardDataDic["merchId"].stringValue
        cardDetailViewController.cardNo = self.cardDataDic["cardNo"].stringValue
        self.navigationController?.pushViewController(cardDetailViewController, animated: true)
        
    }

    
    func getProduct() {
        
        if CurrentUser.user == nil {
            SVProgressShow.showInfoWithStatus("请先登录!")
            return
        }
        
        SVProgressShow.showWithStatus("会员卡申请中...")
        
        Alamofire.request(.POST, baseUrl + "/card/v1.0/applyCard?", parameters: ["token":CurrentUser.user?.token == nil ? "" : CurrentUser.user!.token,"userId":CurrentUser.user?.userId == nil ? "" : CurrentUser.user!.userId,"merchId":self.merchId])
            
            .response { request, response, data, error in
                
                if error == nil {
                    let json  = JSON(data: data!)
                    
                    if RequestDataTool.processingData(json) != nil {
                        SVProgressShow.showSuccessWithStatus("会员卡申请成功!")
                        self.requestData()
                    }
                    
                }
        }

    }
    
    func userCouponsChanged(notification : NSNotification) {
        
        
        for indexPath in self.tableView.indexPathsForVisibleRows! {
            if indexPath.row == self.shoppingArray.count {
                let cell : PriceGatherTableViewCell = self.tableView.cellForRowAtIndexPath(indexPath) as! PriceGatherTableViewCell
                print(cell.checkCouponsView.checkedCheckBoxes)
                print(cell.checkCouponsView.uncheckedCheckBoxes)
            }
        }
    }
    
    func gotoPayView() {
        if self.price == 0 {
            SVProgressShow.showInfoWithStatus("您未选购任何商品!")
            return
        }
        let payViewController : PayViewController = PayViewController()
        payViewController.merchId = self.merchId
        payViewController.totalPrice = CGFloat(self.price)
        payViewController.shoppingArray = self.shoppingArray
        self.navigationController?.pushViewController(payViewController, animated: true)

        UserDefaultsSaveInfo.userDefaultsStandardUserDefaultsObject("viewControllers[0]", keyString: "QRPay")
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
