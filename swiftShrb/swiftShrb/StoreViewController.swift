//
//  StoreViewController.swift
//  swiftShrb
//
//  Created by PayBay on 15/10/23.
//  Copyright © 2015年 PayBay. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SDWebImage

class ShoppingNumLabel : UILabel {
    var num : NSInteger = 0
    var price : Float = 0.0
    
    func mySetNum(num : NSInteger) {
       
        self.num = num
        self.text = String(format: "%ld", num)
        self.textColor = UIColor.whiteColor()
    }
    
}



class StoreViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    
    var merchId : String = ""
    var merchTitle : String = ""
    
    var constantCountTime : Double = 1200
    var countTime : Double = 1200
    
    var array : NSMutableArray = []
    var currentNumDic : NSMutableDictionary = NSMutableDictionary()

    var rect : CGRect!
    var lastContentOffset : CGFloat = 0.0
    
    var timer : NSTimer!
    var showSelectTypeTabelView : Bool = false
    
    var selectTypeTableViewBackView : UIView!
    var selectTypeTableView : UITableView!
    
    
    var tableView : UITableView!
    
    var numbutton : HJCAjustNumButton!
    
    var shoppingCardView : UIView!
    var shoppingCardImageView : UIImageView!
    
    var shoppingLineImageView : UIImageView!
    var shoppingNumLabel : ShoppingNumLabel!
    var priceLabel : UILabel!
    var shoppingFixLabel : UILabel!
    var countDownLabel : UILabel!
    var gotoPayBtn : UIButton!
    
    var path : UIBezierPath!
    
    var prodId : String = ""
    var shoppingArray : NSMutableArray = []
    
    
    var layer : CALayer!
    
    var selectProductListModel = [ProductListModel]()
    var dataProductListModel = [ProductListModel]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initView()
        self.createTableView()
        self.createSelectTypeTableView()
        self.requestData()
        self.createShoppingCardView()
        // Do any additional setup after loading the view.
    }

    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        if self.timer != nil {
            if self.timer.valid {
                self.timer.invalidate()
            }
        }
    }

    
    func initView() {
        
        self.title = self.merchTitle
        
        let selectTpyeButtonItem : UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "screen"), style: UIBarButtonItemStyle.Plain, target: self, action: Selector("selectType"))
        
        self.navigationItem.rightBarButtonItem = selectTpyeButtonItem
    }
    
    func createTableView() {
        
        self.tableView = UITableView(frame: CGRectMake(0, 0, screenWidth, screenHeight))
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.backgroundColor = shrbTableViewColor
        self.tableView.tableFooterView = UIView(frame: CGRectMake(0,screenHeight-49,screenWidth,49))
        self.view.addSubview(self.tableView)
        
    }

    func createSelectTypeTableView() {
        
        self.selectTypeTableViewBackView = UIView(frame: CGRectMake(0, 0, screenWidth, screenHeight))
        self.selectTypeTableViewBackView.hidden = true
        
        self.selectTypeTableView = UITableView(frame: CGRectMake(screenWidth, 20+44, screenWidth/2, screenHeight))
        self.selectTypeTableView.tableFooterView = UIView()
        self.selectTypeTableView.dataSource = self
        self.selectTypeTableView.delegate = self
        self.selectTypeTableView.backgroundColor = UIColor.clearColor()
        
        self.view.addSubview(self.selectTypeTableViewBackView)
        self.view.addSubview(self.selectTypeTableView)
    }

    func requestData() {
        
        SVProgressShow.showWithStatus("加载中...")
        
        Alamofire.request(.GET, baseUrl + "/product/v1.0/getProductList?", parameters: ["merchId":self.merchId,"pageNum":"1","pageCount":"20","orderBy":"updateTime","sort":"desc","whereString":""])
            
            .response { request, response, data, error in
                
                if error == nil {
                    let json  = JSON(data: data!)
                    if json["code"].stringValue == "200" {
                        // self.merchModel =  MerchModel.merchModel(json)
                    }
                    
                    if RequestDataTool.processingData(json) != nil {
                        self.selectProductListModel = ProductListModel.productListModel(json)
                        self.dataProductListModel = ProductListModel.productListModel(json)
                        
                        let delayInSeconds : Double = 0.5
                        let popTime : dispatch_time_t = dispatch_time(DISPATCH_TIME_NOW, Int64(delayInSeconds * Double(NSEC_PER_SEC)))
                        dispatch_after(popTime, dispatch_get_main_queue(), { () -> Void in
                            SVProgressShow.showSuccessWithStatus("加载完成!")
                        })
                        
                    }
                }
                self.tableView.reloadData()
                self.tableView.reloadDataAnimateWithWave(.RightToLeftWaveAnimation)
                self.selectTypeTableView.reloadData()
        }
        
    }
    
    func createShoppingCardView() {
        
        self.shoppingCardView = UIView(frame: CGRectMake(0, screenHeight-49, screenWidth, 49))
        
        self.shoppingCardView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.67)
        self.view.addSubview(self.shoppingCardView)
        
        self.shoppingCardImageView = UIImageView(frame: CGRectMake(12, 12, 25, 25))
        self.shoppingCardImageView.image = UIImage(named: "shoppingCardPink")
        self.shoppingCardView.addSubview(self.shoppingCardImageView)
        
        self.shoppingNumLabel = ShoppingNumLabel(frame: CGRectMake(self.shoppingCardImageView.frame.origin.x + self.shoppingCardImageView.frame.size.width + 4 , 14, 20 , 21 ))
        self.shoppingNumLabel.mySetNum(0)
        self.shoppingCardView.addSubview(self.shoppingNumLabel)
        self.shoppingNumLabel.sizeToFit()
        
        self.priceLabel = UILabel(frame: CGRectMake(self.shoppingNumLabel.frame.origin.x + self.shoppingNumLabel.frame.size.width + 4 , 14, 100 , 21 ))
        self.priceLabel.text = "￥0:00"
        self.priceLabel.textColor = UIColor.whiteColor()
        self.priceLabel.sizeToFit()
        self.shoppingCardView.addSubview(self.priceLabel)
        
        self.shoppingLineImageView = UIImageView(frame: CGRectMake(self.priceLabel.frame.origin.x + self.priceLabel.frame.size.width + 4 , 8, 1 , 33 ))
        self.shoppingLineImageView.backgroundColor = UIColor(red: 167.0/255.0, green: 167.0/255.0, blue: 167.0/255.0, alpha: 1)
        self.shoppingCardView.addSubview(self.shoppingLineImageView)
        
        self.shoppingFixLabel = UILabel(frame: CGRectMake(self.shoppingLineImageView.frame.origin.x + self.shoppingLineImageView.frame.size.width + 4 , 2, 20 , 21 ))
        self.shoppingFixLabel.text = "订单将保留"
        self.shoppingFixLabel.font = font15
        self.shoppingFixLabel.textColor = UIColor.whiteColor()
        self.shoppingFixLabel.sizeToFit()
        self.shoppingCardView.addSubview(self.shoppingFixLabel)
        
        
        self.countDownLabel = UILabel(frame: CGRectMake(self.shoppingFixLabel.frame.origin.x , self.shoppingFixLabel.frame.origin.y + self.shoppingFixLabel.frame.size.height + 2, self.shoppingFixLabel.frame.size.width , 21 ))
        self.countDownLabel.text = "20:00"
        self.countDownLabel.textAlignment = .Center
        self.countDownLabel.center = CGPointMake(self.shoppingFixLabel.frame.origin.x + self.shoppingFixLabel.frame.size.width/2,30)
        self.countDownLabel.textColor = UIColor.whiteColor()
        self.shoppingCardView.addSubview(self.countDownLabel)

        
        self.gotoPayBtn = UIButton(frame: CGRectMake(screenWidth-100,6,80,37))
        self.gotoPayBtn.setTitle("结算", forState: UIControlState.Normal)
        self.gotoPayBtn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        self.gotoPayBtn.addTarget(self, action: Selector("gotoPayView"), forControlEvents: UIControlEvents.TouchUpInside)
        self.gotoPayBtn.backgroundColor = shrbPink
        self.shoppingCardView.addSubview(self.gotoPayBtn)
    }
    
    func updateShoppingCardView() {
        
        self.shoppingNumLabel.sizeToFit()
        
        self.priceLabel.frame = CGRectMake(self.shoppingNumLabel.frame.origin.x + self.shoppingNumLabel.frame.size.width + 4 , 14, 100 , 21 )
        self.priceLabel.sizeToFit()
        
        self.shoppingLineImageView.frame = CGRectMake(self.priceLabel.frame.origin.x + self.priceLabel.frame.size.width + 4 , 8, 1 , 33 )
        
        self.shoppingFixLabel.frame = CGRectMake(self.shoppingLineImageView.frame.origin.x + self.shoppingLineImageView.frame.size.width + 4 , 2, 20 , 21 )
        self.shoppingFixLabel.sizeToFit()
        
        self.countDownLabel.frame = CGRectMake(self.shoppingFixLabel.frame.origin.x , self.shoppingFixLabel.frame.origin.y + self.shoppingFixLabel.frame.size.height + 2, self.shoppingFixLabel.frame.size.width , 21 )
    }

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if tableView == self.tableView {
            if indexPath.section == 0 {
                return 44
            }
            else {
                return isIphone4s ? 110 : 100
            }
            
            
        }
        else {
            return 44
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if tableView != self.selectTypeTableView {
            return (self.selectProductListModel.count + 1)
        }
        return 1
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if tableView != self.selectTypeTableView {
            if section == 0 {
                return ""
            }
            return self.selectProductListModel[section-1].typeName
        }
        else {
            return ""
        }
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if tableView != self.selectTypeTableView {
            return section == 0 ? 0 : 30
        }
        else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let height : CGFloat!
        let headerView : UIView = UIView()
        headerView.backgroundColor = shrbSectionColor
        
        if tableView != self.selectTypeTableView {
            height = section == 0 ? 0 : 30
            let label = UILabel(frame: CGRectMake(10,(height-18)*0.5,tableView.bounds.size.width-10,18))
            label.textColor = shrbText
            label.backgroundColor = UIColor.clearColor()
            headerView.addSubview(label)
            label.text = section == 0 ? "" : self.selectProductListModel[section-1].typeName
            
            headerView.frame = CGRectMake(0,0,tableView.bounds.size.width,height)
            return headerView
        }
        else {
            height = 0
            
            headerView.frame = CGRectMake(0,0,tableView.bounds.size.width,height)
            return headerView
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.tableView {
            return section == 0 ? 1 : self.selectProductListModel[section-1].prodList.count
        }
        else {
            return (self.dataProductListModel.count+1)
            
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if tableView == self.tableView {
            if indexPath.section == 0 {
                tableView.registerNib(UINib(nibName: "DeskNumTableViewCell", bundle: nil), forCellReuseIdentifier: "DeskNumTableViewCellId")
                let cell = tableView.dequeueReusableCellWithIdentifier("DeskNumTableViewCellId", forIndexPath: indexPath) as! DeskNumTableViewCell
                
                cell.selectionStyle = UITableViewCellSelectionStyle.None
                return cell
            }
            else {
                tableView.registerNib(UINib(nibName: "orderTableViewCell", bundle: nil), forCellReuseIdentifier: "orderTableViewCellId")
                let cell = tableView.dequeueReusableCellWithIdentifier("orderTableViewCellId", forIndexPath: indexPath) as! orderTableViewCell
                
                cell.selectionStyle = UITableViewCellSelectionStyle.None
                
                cell.tradeNameLabel.text = self.selectProductListModel[indexPath.section-1].prodList[indexPath.row].prodName as String
                cell.tradeImageView.sd_setImageWithURL(NSURL(string: self.selectProductListModel[indexPath.section-1].prodList[indexPath.row].imgUrl)!, placeholderImage: UIImage(named: "热点无图片"))
                cell.tradeDescriptionLabel.text = self.selectProductListModel[indexPath.section-1].prodList[indexPath.row].prodDesc!
                
                cell.priceLabel.text = String(format: "￥%.2f 原价￥%.2f", self.selectProductListModel[indexPath.section-1].prodList[indexPath.row].vipPrice!, self.selectProductListModel[indexPath.section-1].prodList[indexPath.row].price!)
                
                
                let vipString : String = String(format: "%.2f", self.selectProductListModel[indexPath.section-1].prodList[indexPath.row].vipPrice!)
                
                let priceString : String = String(format: "%.2f", self.selectProductListModel[indexPath.section-1].prodList[indexPath.row].price!)
                
                let attrString : NSMutableAttributedString = NSMutableAttributedString(string: cell.priceLabel.text!)
                
                attrString.addAttribute(NSStrikethroughStyleAttributeName, value:NSNumber(integer: 1), range: NSMakeRange(vipString.characters.count+2, priceString.characters.count+3))

                attrString.addAttribute(NSForegroundColorAttributeName, value:shrbPink, range: NSMakeRange(0, vipString.characters.count+1))
                
                attrString.addAttribute(NSForegroundColorAttributeName, value:shrbLightText, range: NSMakeRange(vipString.characters.count+2, priceString.characters.count+3))
                
                
                attrString.addAttribute(NSFontAttributeName, value:font20, range: NSMakeRange(0, vipString.characters.count+1))
                attrString.addAttribute(NSFontAttributeName, value:font14, range: NSMakeRange(vipString.characters.count+2, priceString.characters.count+3))
                cell.priceLabel.attributedText = attrString
                
                cell.amountTextField.hidden = true
                cell.moneyLabel.hidden = true
                
                let numbutton : HJCAjustNumButton = HJCAjustNumButton()
                numbutton.frame = CGRectMake(screenWidth-40,isIphone4s ? 40 : 35 , 30, 30)
                numbutton.callBack = { currentNum in
                    
                    print(currentNum)
                    
                    if self.shoppingArray.count == 0 {
                        let shoppingCardDataItem : ShoppingCardDataItem = ShoppingCardDataItem()
                        shoppingCardDataItem.count = currentNum
                        shoppingCardDataItem.prodList = self.selectProductListModel[indexPath.section-1].prodList[indexPath.row]
                        self.shoppingArray.addObject(shoppingCardDataItem)
                        self.prodId = self.selectProductListModel[indexPath.section-1].prodList[indexPath.row].prodId
                        self.shoppingNumLabel.price = self.selectProductListModel[indexPath.section-1].prodList[indexPath.row].price
                    }
                    else {
                        self.shoppingNumLabel.price += self.selectProductListModel[indexPath.section-1].prodList[indexPath.row].price
                        var result = ShoppingCardDataItem()
                        var num : Int = 0
                        for i in 0..<self.shoppingArray.count {
                            result = self.shoppingArray.objectAtIndex(i) as! ShoppingCardDataItem
                            var arr : ProdList!
                            arr = self.selectProductListModel[indexPath.section-1].prodList[indexPath.row]
                            
                            if result.prodList.isEqual(arr) {
                                result.count = currentNum
                            }
                            else {
                                num = num + 1
                                if self.shoppingArray.count == num {
                                    let shoppingCardDataItem = ShoppingCardDataItem()
                                    shoppingCardDataItem.count = currentNum
                                    shoppingCardDataItem.prodList = self.selectProductListModel[indexPath.section-1].prodList[indexPath.row]
                                    self.shoppingArray.addObject(shoppingCardDataItem)
                                    
                                }
                            }
                        }
                    }
                    
                    self.rect = self.tableView.superview?.convertRect(CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height), fromView: cell)
                    
                    if self.currentNumDic .count == 0 {
                        self.currentNumDic.setObject(currentNum, forKey: indexPath.row)
                        
                        self.startAnimationWithImageNsstring("热点无图片")
                    }
                    else {
                        if self.currentNumDic.objectForKey(indexPath.row) == nil {
                            self.currentNumDic.setObject(currentNum, forKey: indexPath.row-1)
                            
                            self.startAnimationWithImageNsstring("热点无图片")
                            
                        }
                        else {
                            //减少
                            if self.currentNumDic.objectForKey(indexPath.row) as? Float > Float(currentNum) {
                                self.currentNumDic.setObject(currentNum, forKey: indexPath.row-1)
                            }
                            else {
                                self.currentNumDic.setObject(currentNum, forKey: indexPath.row-1)
                                
                                self.startAnimationWithImageNsstring("热点无图片")
                            }
                        }
                    }
                }
                cell.addSubview(numbutton)
                
                    return cell
                    
            }
        }
        else {
            tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cellId")
            let cell = tableView.dequeueReusableCellWithIdentifier("cellId", forIndexPath: indexPath) as UITableViewCell
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            
            cell.textLabel?.text = indexPath.row == 0 ? "全部类别":self.dataProductListModel[indexPath.row-1].typeName
            
            cell.textLabel?.textColor = shrbText
            
            return cell
            
        }
        
    }
    
    func startAnimationWithImageNsstring(imageNsstring : String) {
        
        
        let path : UIBezierPath = UIBezierPath()
        path.moveToPoint(CGPointMake(46, self.rect.origin.y + 40))
        path.addQuadCurveToPoint(CGPointMake(30, screenHeight-20), controlPoint: CGPointMake(screenWidth*0.5, screenHeight*0.6))
        self.path = path
        
        
        self.selectTypeTableViewBackView.hidden = false
        if self.layer == nil {
            self.layer = CALayer()
            self.layer.contents = UIImage(named: imageNsstring)?.CGImage
            
            
            
            self.layer.contentsGravity = kCAGravityResizeAspectFill
            self.layer.bounds = CGRectMake(screenWidth*0.1, screenHeight*0.5, 50, 50)
            self.layer.cornerRadius = CGRectGetHeight(self.layer.bounds)/2
            self.layer.masksToBounds = true
            self.layer.position = CGPointMake(screenWidth*0.1, screenHeight*0.5)
            self.view.layer.addSublayer(self.layer)
        }
        self.groupAnimation()
        
    }
    
    func groupAnimation() {
        let animation : CAKeyframeAnimation = CAKeyframeAnimation(keyPath: "position")
        animation.path = self.path.CGPath
        animation.rotationMode = kCAAnimationRotateAuto
        let expandAnimation : CABasicAnimation = CABasicAnimation(keyPath: "transform.scale")
        expandAnimation.duration = 0.5
        expandAnimation.fromValue = 1
        expandAnimation.toValue = 2
        expandAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
        
        let narrowAnimation : CABasicAnimation = CABasicAnimation(keyPath: "transform.scale")
        narrowAnimation.beginTime = 0.5
        narrowAnimation.fromValue = 2
        narrowAnimation.duration = 1
        narrowAnimation.toValue = 0.5
        narrowAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        
        let groups : CAAnimationGroup = CAAnimationGroup()
        groups.animations = [animation,expandAnimation,narrowAnimation]
        groups.duration = 1
        groups.removedOnCompletion = false
        groups.fillMode = kCAFillModeForwards
        groups.delegate = self
        self.layer.addAnimation(groups, forKey: "group")
        
    }
    
    override func animationDidStop(anim: CAAnimation, finished flag: Bool) {
        self.shoppingNumLabel.mySetNum(self.shoppingNumLabel.num + 1)
      //  self.shoppingNumLabel.num  = self.shoppingNumLabel.num + 1
        self.priceLabel.text = String(format: "￥%.2f", self.shoppingNumLabel.price)
        UserDefaultsSaveInfo.userDefaultsStandardUserDefaultsInteger(self.shoppingNumLabel.num, keyInteger: "num")
        
        self.countDown()
        self.updateShoppingCardView()
        
        self.selectTypeTableViewBackView.hidden = true
        if anim == self.layer.animationForKey("group") {
            self.layer.removeFromSuperlayer()
            self.layer = nil
        }
        
        print(self.shoppingArray)
        
    }
    
    func countDown() {
        if self.shoppingNumLabel.num == 0 {
          return
        }
        if self.timer == nil {
           self.timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: Selector("timerFireMethod:"), userInfo: nil, repeats: true)
        }
        else if !self.timer.valid {
        
            //打开
            self.timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: Selector("timerFireMethod:"), userInfo: nil, repeats: true)
            
//            //关闭
//            self.timer.invalidate()
            
        }
        else {
            
        }
    }
    
    func timerFireMethod(timer : NSTimer) {
        let calendar : NSCalendar = NSCalendar.currentCalendar()
        let today : NSDate = NSDate()
        let fireDate = NSDate(timeIntervalSinceNow: --self.countTime)
        
        let unitFlags : NSCalendarUnit = [NSCalendarUnit.Year,NSCalendarUnit.Month,NSCalendarUnit.Day,NSCalendarUnit.Hour,NSCalendarUnit.Minute,NSCalendarUnit.Second]

        let d : NSDateComponents = calendar.components(unitFlags, fromDate: today, toDate: fireDate, options: .WrapComponents)
        
        self.countDownLabel.text = String(format: "%ld:%ld", d.minute,d.second)
        if d.second < 10 {
            self.countDownLabel.text = String(format: "%ld:0%ld", d.minute,d.second)
        }
        if d.minute < 10 {
             self.countDownLabel.text = String(format: "0%ld:%ld", d.minute,d.second)
        }
        if d.minute<10 && d.second < 10 {
             self.countDownLabel.text = String(format: "0%ld:0%ld", d.minute,d.second)
        }
        if d.minute == 0 && d.second == 0 {
            self.timer.fireDate = NSDate.distantFuture()
            self.countDownLabel.text = "20:00"
            self.countTime = self.constantCountTime
            self.shoppingNumLabel.num = 0
            self.shoppingNumLabel.price = 0
            self.priceLabel.text = "￥0.00"
            SVProgressShow.showInfoWithStatus("订单过期!")
        }
        UserDefaultsSaveInfo.userDefaultsStandardUserDefaultsDouble(self.countTime, keyDouble: "countTime")
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if tableView == self.tableView {
            
            if (indexPath.section == 0 ){
                return
            }
            else {
                DeskNumTableViewCell.shareDeskNumTableViewCell().deskTextFieldResignFirstResponder()
            }
            
        
            let productDescriptionView : ProductDescriptionView = ProductDescriptionView(frame: CGRectMake(0,20+44,screenWidth,screenHeight-20-44))
            productDescriptionView.plistArr = self.dataProductListModel
            productDescriptionView.currentRow = indexPath.row
            productDescriptionView.currentSection = indexPath.section-1
            productDescriptionView.refreshDescriptionView()
            self.view.addSubview(productDescriptionView)
        }
        else {
            self.showSelectTypeTabelView = !self.showSelectTypeTabelView
            UIView.animateWithDuration(0.5, delay: 0, options: UIViewAnimationOptions.CurveEaseIn, animations: { () -> Void in
                self.selectTypeTableView.layer.transform = CATransform3DIdentity
                self.selectTypeTableViewBackView.backgroundColor = UIColor.clearColor()
                
                }) { (finished : Bool) -> Void in
                    
                    self.selectTypeTableViewBackView.hidden = true
                    
                    let myPath : NSIndexPath = NSIndexPath(forRow: 0, inSection: indexPath.row)
                    self.tableView.selectRowAtIndexPath(myPath, animated: true, scrollPosition: UITableViewScrollPosition.Top)
            }
            
        }
        
    }
    
    
    func selectType() {
        
        self.showSelectTypeTabelView = !self.showSelectTypeTabelView
        if self.showSelectTypeTabelView {
            self.selectTypeTableViewBackView.hidden = false
            
            UIView.animateWithDuration(0.8, delay: 0, usingSpringWithDamping: 0.3, initialSpringVelocity: 0, options: UIViewAnimationOptions.CurveEaseIn, animations: { () -> Void in
                
                self.selectTypeTableView.layer.transform = CATransform3DMakeTranslation(-screenWidth/2, 0, 0)
                
                }, completion: { (finished : Bool) -> Void in
                    
            })
            
            UIView.animateWithDuration(0.3, delay: 0, options: UIViewAnimationOptions.CurveEaseIn, animations: { () -> Void in
                
                self.selectTypeTableViewBackView.backgroundColor = UIColor(white: 0, alpha: 0.5)
                
                }, completion: { (finished : Bool) -> Void in
                    
            })
        }
        else {
            UIView.animateWithDuration(0.8, delay: 0, usingSpringWithDamping: 0.3, initialSpringVelocity: 0, options: UIViewAnimationOptions.CurveEaseIn, animations: { () -> Void in
                
                self.selectTypeTableView.layer.transform = CATransform3DMakeTranslation(screenWidth/2, 0, 0)
                
                }, completion: { (finished : Bool) -> Void in
                    
            })
            
            UIView.animateWithDuration(0.3, delay: 0, options: UIViewAnimationOptions.CurveEaseIn, animations: { () -> Void in
                
                self.selectTypeTableViewBackView.backgroundColor = UIColor.clearColor()
                }, completion: { (finished : Bool) -> Void in
                    
            })
            
            UIView.animateWithDuration(0.3, delay: 0, options: UIViewAnimationOptions.CurveEaseIn, animations: { () -> Void in
                
                }, completion: { (finished : Bool) -> Void in
                    self.selectTypeTableViewBackView.hidden = true
            })
            
        }
    }

    
    func gotoPayView() {
        if self.shoppingArray.count == 0 {
            SVProgressShow.showInfoWithStatus("您未选购任何商品!")
            return
        }
        
        let ordersViewController : OrdersViewController = OrdersViewController()
        ordersViewController.merchId = self.merchId
        ordersViewController.prodId = self.prodId
        ordersViewController.shoppingArray = self.shoppingArray
        ordersViewController.title = self.title
        self.navigationController?.pushViewController(ordersViewController, animated: true)
        
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
