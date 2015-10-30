//
//  ProductViewController.swift
//  swiftShrb
//
//  Created by PayBay on 15/10/10.
//  Copyright © 2015年 PayBay. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SDWebImage

class ProductViewController: UIViewController, UIScrollViewDelegate {

    
    var productDataDic : JSON = []
    
    
    var imageArray : NSMutableArray = []
    var timer : NSTimer!
    
    
    var mainScrollView : UIScrollView!
    var cardView : UIView!
    var cardScrollView : UIScrollView!
    var imagePageControl : UIPageControl!
    var cardPhontoView : UIImageView!
    var blurEffectView : UIView!
    var collectBtn : UIButton!
    var shareBtn : UIButton!
    
    
    var tradeNameAndPriceView : UIView!
    var prodNameLabel : UILabel!
    var vipPriceLabel : UILabel!
    var saveMoneyLabel : UILabel!
    var priceLabel : UILabel!
    
    var descriptionAndRegisterView : UIView!
    
    var prodDescLabel : UILabel!
    var registerBtn : CallBackButton!
    

    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "商品详情"
        self.view.backgroundColor = UIColor.orangeColor()
        
        self.initData()
        self.initMainView()
        self.initCardView()
        self.initTradeNameAndPriceView()
        self.initDescriptionAndregisterView()
        self.cardAnimation()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        if self.timer != nil {
            if self.timer.valid {
                self.timer.invalidate()
            }
        }
    }
    
    
    func initData() {
        
        self.imageArray = NSMutableArray()
        for index in 0..<self.productDataDic["imgList"].count {
           self.imageArray.addObject(self.productDataDic["imgList"][index]["imgUrl"].stringValue)
        }
        if self.imageArray.count != 0 {
            if self.timer == nil {
                self.startTime()
            }
            
        }
    }
    
    func initMainView() {
        
        self.mainScrollView = UIScrollView(frame: CGRectMake(0, 0, screenWidth, screenHeight))
        self.mainScrollView.backgroundColor = shrbTableViewColor
        self.view.addSubview(self.mainScrollView)
        
    }
    
    func initCardView() {
        
        self.cardView = UIView(frame: CGRectMake(0, 0, screenWidth, screenWidth/1.37))
        self.cardView.backgroundColor = UIColor.whiteColor()
        self.mainScrollView.addSubview(self.cardView)
        
        self.cardScrollView = UIScrollView(frame: CGRectMake(0, 0, self.cardView.frame.size.width, self.cardView.frame.size.height))
        if self.imageArray.count == 0 {
            self.cardScrollView.contentSize = CGSizeMake(self.cardScrollView.frame.size.width, 0)
            self.cardScrollView.contentOffset = CGPointMake(0, 0)
        }
        else {
            self.cardScrollView.contentSize = CGSizeMake(self.cardScrollView.frame.size.width*CGFloat(self.imageArray.count+2), 0)
            self.cardScrollView.contentOffset = CGPointMake(self.cardScrollView.frame.size.width, 0)
        }
        
        self.cardScrollView.delegate = self
        self.cardScrollView.pagingEnabled = true
        self.cardScrollView.showsHorizontalScrollIndicator = false
        self.cardScrollView.showsVerticalScrollIndicator = false
        self.cardView.addSubview(self.cardScrollView)
        
        
        self.imagePageControl = UIPageControl(frame: CGRectMake(0, self.cardView.frame.size.height - 30, self.cardView.frame.size.width, 20))
        self.imagePageControl.numberOfPages = self.imageArray.count
        self.imagePageControl.currentPage = 0
        self.imagePageControl.addTarget(self, action: Selector(""), forControlEvents: UIControlEvents.ValueChanged)
        self.imagePageControl.currentPageIndicatorTintColor = shrbPink
        self.imagePageControl.pageIndicatorTintColor = UIColor.whiteColor()
        self.cardView.addSubview(self.imagePageControl)
        
        
        if self.imageArray.count == 0 {
            let imageView = UIImageView(frame: CGRectMake(0, 0, self.cardView.frame.size.width, self.cardView.frame.size.height))
            imageView.clipsToBounds = true
            imageView.contentMode = .ScaleToFill
            imageView.sd_setImageWithURL(NSURL(string: self.productDataDic["imgUrl"].stringValue), placeholderImage: UIImage(named: "热点无图片"))
            self.cardScrollView.addSubview(imageView)
            
        }
        else {
            for index in 0..<self.imageArray.count + 2 {
                
                let imageView = UIImageView(frame: CGRectMake(self.cardScrollView.frame.size.width * CGFloat(index), 0, self.cardView.frame.size.width, self.cardView.frame.size.height))
                imageView.clipsToBounds = true
                imageView.contentMode = .ScaleAspectFill
                if index == 0 {
                    imageView.sd_setImageWithURL(NSURL(string: (self.imageArray[self.imageArray.count-1] as! String))!, placeholderImage: UIImage(named: "热点无图片"))
                    imageView.tag = self.imageArray.count - 1
                }
                else if index == (self.imageArray.count + 1) {
                    imageView.sd_setImageWithURL(NSURL(string: (self.imageArray[0] as! String))!, placeholderImage: UIImage(named: "热点无图片"))
                    imageView.tag = 0
                }
                else {
                    imageView.sd_setImageWithURL(NSURL(string: self.imageArray[index-1] as! String)!, placeholderImage: UIImage(named: "热点无图片"))
                    imageView.tag = index-1
                }
                
                imageView.userInteractionEnabled = true
                
                self.cardScrollView.addSubview(imageView)
            }
        }
        
        
        if isIos8 {
            
            let blurEffect = UIBlurEffect(style: .Light)
            self.blurEffectView = UIVisualEffectView(effect: blurEffect)
            self.blurEffectView.backgroundColor = UIColor(white: 0, alpha: 0.2)
            
        }
        else {
            self.blurEffectView = UIView()
            self.blurEffectView.backgroundColor = UIColor(white: 0, alpha: 0.2)
        }
        
        if screenHeight <= 480 {
            self.blurEffectView.frame = CGRectMake(screenWidth - 45 - 46 - 16, self.cardView.frame.size.height - 42, 45 + 46, 32)
        }
        else {
            self.blurEffectView.frame = CGRectMake(screenWidth - 54 - 55 - 16, self.cardView.frame.size.height - 47, 54 + 55, 37)
        }
        
        self.cardView.addSubview(self.blurEffectView)
        
        
        self.collectBtn = UIButton(type: .Custom)
        self.collectBtn.setBackgroundImage(UIImage(named: "shoucang"), forState: UIControlState.Normal)
        self.collectBtn.setBackgroundImage(UIImage(named: "shoucang"), forState: UIControlState.Highlighted)
        self.collectBtn.frame = CGRectMake(0, 0, (self.blurEffectView.frame.size.width-1)/2, self.blurEffectView.frame.size.height)
        self.collectBtn.addTarget(self, action: Selector("collectBtnPressed"), forControlEvents: UIControlEvents.TouchUpInside)
        self.blurEffectView.addSubview(self.collectBtn)
        
        let lineImageView = UIImageView(frame: CGRectMake((self.blurEffectView.frame.size.width)/2, 5, 1, 30))
        lineImageView.backgroundColor = UIColor(white: 1, alpha: 0.5)
        
        self.shareBtn = UIButton(type: .Custom)
        self.shareBtn.setBackgroundImage(UIImage(named: "fenxiang"), forState: UIControlState.Normal)
        self.shareBtn.setBackgroundImage(UIImage(named: "fenxiang"), forState: UIControlState.Highlighted)
        self.shareBtn.frame = CGRectMake((self.blurEffectView.frame.size.width+1)/2, 0, (self.blurEffectView.frame.size.width-1)/2, self.blurEffectView.frame.size.height)
        self.shareBtn.addTarget(self, action: Selector("shareBtnPressed"), forControlEvents: UIControlEvents.TouchUpInside)
        self.blurEffectView.addSubview(self.shareBtn)
        
    }
    
    func initTradeNameAndPriceView() {
        
        self.tradeNameAndPriceView = UIView(frame: CGRectMake(0, self.cardScrollView.frame.origin.y + self.cardScrollView.frame.size.height, screenWidth, 105))
        self.tradeNameAndPriceView.backgroundColor = UIColor.whiteColor()
        self.mainScrollView.addSubview(self.tradeNameAndPriceView)
        
        //商品名
        self.prodNameLabel = UILabel(frame: CGRectMake(16, 12, screenWidth-16*2, 30))
        self.prodNameLabel.font = font17
        self.prodNameLabel.textColor = shrbText
        self.prodNameLabel.text = self.productDataDic["prodName"].stringValue
        self.tradeNameAndPriceView.addSubview(self.prodNameLabel)
        
        //会员价
        self.vipPriceLabel = UILabel(frame: CGRectMake(16, self.prodNameLabel.frame.origin.y + self.prodNameLabel.frame.size.height + 4, 100 , 30))
        self.vipPriceLabel.font = font18
        self.vipPriceLabel.textColor = shrbPink
        self.vipPriceLabel.text = "会员价:￥" + self.productDataDic["vipPrice"].stringValue
        self.vipPriceLabel.sizeToFit()
        self.tradeNameAndPriceView.addSubview(self.vipPriceLabel)
        
        //节省价格
        self.saveMoneyLabel = UILabel(frame:CGRectMake(self.vipPriceLabel.frame.origin.x + self.vipPriceLabel.frame.size.width + 8, self.vipPriceLabel.frame.origin.y, 80, 24))
        self.saveMoneyLabel.center = CGPointMake(self.vipPriceLabel.frame.origin.x + self.vipPriceLabel.frame.size.width + 8 + 40, self.vipPriceLabel.center.y)
        self.saveMoneyLabel.font = font15
        self.saveMoneyLabel.textColor = UIColor.whiteColor()
        self.saveMoneyLabel.backgroundColor = shrbPink
        self.saveMoneyLabel.textAlignment = .Center
        self.saveMoneyLabel.text = String(format: "省￥%.2f", self.productDataDic["price"].floatValue - self.productDataDic["vipPrice"].floatValue)
        self.tradeNameAndPriceView.addSubview(self.saveMoneyLabel)
        
        
        //原价
        self.priceLabel = UILabel(frame: CGRectMake(16, self.vipPriceLabel.frame.origin.y + self.vipPriceLabel.frame.size.height + 4, 100 , 21))
        self.priceLabel.font = font15
        self.priceLabel.textColor = UIColor.lightGrayColor()
        self.priceLabel.text = String(format: "原价:￥%.2f", self.productDataDic["price"].floatValue)
        self.priceLabel.sizeToFit()
        self.tradeNameAndPriceView.addSubview(self.priceLabel)
        
        let attrString : NSMutableAttributedString = NSMutableAttributedString(string: self.priceLabel.text!)
        
        attrString.addAttribute(NSStrikethroughStyleAttributeName, value:NSNumber(integer: 1), range: NSMakeRange(0, (self.priceLabel.text?.characters.count)!))
        
        self.priceLabel.attributedText = attrString
        
    }
    
    func initDescriptionAndregisterView() {
        
        if self.descriptionAndRegisterView != nil {
            self.descriptionAndRegisterView.removeFromSuperview()
        }
        
        self.descriptionAndRegisterView = UIView(frame: CGRectMake(0, self.tradeNameAndPriceView.frame.origin.y + self.tradeNameAndPriceView.frame.size.height + 8, screenWidth,230))
        self.descriptionAndRegisterView.backgroundColor = UIColor.whiteColor()
        self.mainScrollView.addSubview(self.descriptionAndRegisterView)
        
        let label = UILabel(frame: CGRectMake(16, 16, 200, 30))
        label.text = "商品详情"
        label.textColor = shrbText
        label.font = font20
        self.descriptionAndRegisterView.addSubview(label)
        
        //商品描述
        self.prodDescLabel = UILabel(frame: CGRectMake(16, label.frame.origin.y + label.frame.size.height + 16, screenWidth - 32, 40))
        self.prodDescLabel.numberOfLines = 1000
        self.prodDescLabel.font = font15
        self.prodDescLabel.textColor = shrbLightText
        self.prodDescLabel.text = self.productDataDic["prodDesc"].stringValue
        self.prodDescLabel.sizeToFit()
        self.descriptionAndRegisterView.addSubview(self.prodDescLabel)
        
        self.registerBtn = CallBackButton(type: .Custom)
        self.registerBtn.setTitle("会员注册", forState: .Normal)
        self.registerBtn.titleLabel?.font = font18
        self.registerBtn.backgroundColor = shrbPink
        self.registerBtn.frame = CGRectMake(16, self.prodDescLabel.frame.origin.y + self.prodDescLabel.frame.size.height + 16, screenWidth - 32, 44)
        self.registerBtn.layer.cornerRadius = 4
        self.registerBtn.layer.masksToBounds = true
        self.registerBtn.setupBlock()
        self.registerBtn.callBack = { tag in
            
            self.getProduct()
        }
       
        self.descriptionAndRegisterView.addSubview(self.registerBtn)
        
        self.registerBtn.hidden = false
        
        self.descriptionAndRegisterView.frame = CGRectMake(0, self.tradeNameAndPriceView.frame.origin.y + self.tradeNameAndPriceView.frame.size.height + 8, screenWidth, label.frame.origin.y + label.frame.size.height + 16 + self.prodDescLabel.frame.size.height + 16 + self.registerBtn.frame.size.height + 30)
        
        if self.cardView.frame.size.height + self.tradeNameAndPriceView.frame.size.height + 8 + self.descriptionAndRegisterView.frame.size.height + 10 < screenHeight - 20 - 44 {
            self.mainScrollView.scrollEnabled = false
            self.mainScrollView.contentSize = CGSizeMake(0, 0)
            return
        }
        
        self.mainScrollView.scrollEnabled = true
        self.mainScrollView.contentSize = CGSizeMake(0, self.cardView.frame.size.height + self.tradeNameAndPriceView.frame.size.height + 8 + self.descriptionAndRegisterView.frame.size.height + 10)
    }
    
    
    func cardAnimation() {
        
        self.registerBtn.layer.transform = CATransform3DMakeTranslation(screenWidth, 0, 0)
        self.cardView.layer.transform = CATransform3DMakeScale(0, 0, 1)
        self.prodDescLabel.alpha = 0
        
        UIView.animateWithDuration(0.8, delay: 0.1, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: UIViewAnimationOptions.CurveEaseIn, animations: { () -> Void in
            self.cardView.layer.transform = CATransform3DIdentity
            }) { (finished : Bool) -> Void in
                
        }
        
        UIView.animateWithDuration(2.0, delay: 0.5, options: UIViewAnimationOptions.CurveLinear, animations: { () -> Void in
            self.prodDescLabel.alpha = 1
            }, completion: nil)
        
        UIView.animateWithDuration(0.8, delay: 1.5, usingSpringWithDamping: 0.3, initialSpringVelocity: 0.5, options: UIViewAnimationOptions.CurveEaseIn, animations: { () -> Void in
            self.registerBtn.layer.transform = CATransform3DMakeScale(0.5, 1, 1)
            }, completion: nil)
        
        UIView.animateWithDuration(1.5, delay: 1.5, usingSpringWithDamping: 0.3, initialSpringVelocity: 0, options: UIViewAnimationOptions.CurveEaseIn, animations: { () -> Void in
            self.registerBtn.layer.transform = CATransform3DIdentity
            }, completion: nil)
    }
    
    func startTime() {
        self.timer = NSTimer.scheduledTimerWithTimeInterval(3, target: self, selector: Selector("timerFun"), userInfo: nil, repeats: true)
    }
    
    func timerFun() {
        if self.imageArray.count == 0 {
            return
        }
        
        self.imagePageControl.currentPage = (self.imagePageControl.currentPage + 1)%self.imageArray.count
        if self.imagePageControl.currentPage == 0 {
            UIView.animateWithDuration(0.25, animations: { () -> Void in
                self.cardScrollView.contentOffset = CGPointMake(CGFloat(self.imageArray.count + 1)*self.cardScrollView.bounds.size.width, 0)
                }, completion: { (finished : Bool) -> Void in
                    self.cardScrollView.contentOffset = CGPointMake(self.cardScrollView.bounds.size.width, 0)
            })
        }
        else {
            self.cardScrollView.setContentOffset(CGPointMake(CGFloat(self.imagePageControl.currentPage + 1) * self.cardScrollView.bounds.size.width, 0), animated: true)
        }
    }
    
    func pageControlValueChanged() {
        
        self.cardScrollView.setContentOffset(CGPointMake((CGFloat(self.imagePageControl.currentPage) + 1)*self.cardView.bounds.size.width, 0), animated: true)
    }
    
    
    func scrollViewWillBeginDecelerating(scrollView: UIScrollView) {
        
        if self.timer.valid {
            self.timer.invalidate()
        }
    }
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        
        if !self.timer.valid {
            self.startTime()
        }
        
        let page = Int(scrollView.contentOffset.x / scrollView.bounds.size.width)
        if page == (self.imageArray.count + 1) {
            scrollView.contentOffset = CGPointMake(scrollView.bounds.size.width, 0)
            self.imagePageControl.currentPage = 0
        }
        else if page == 0 {
            scrollView.contentOffset = CGPointMake(scrollView.bounds.size.width * CGFloat(self.imageArray.count), 0)
            self.imagePageControl.currentPage = self.imageArray.count - 1
        }
        else {
            self.imagePageControl.currentPage = page - 1
        }
    }
    
    func collectBtnPressed() {
        SVProgressShow.showWithStatus("收藏中")
        let delayInSeconds : Int64 = 1
        let popTime : dispatch_time_t = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds)
        dispatch_after(popTime, dispatch_get_main_queue()) { () -> Void in
            SVProgressShow.showSuccessWithStatus("收藏成功!")
        }
    
    }
    
    func shareBtnPressed() {
        let action1 : DOPAction = DOPAction(name: "微信", iconName: "weixin") { () -> Void in
            SVProgressShow.showWithStatus("分享中...")
            let delayInSeconds : Int64 = 1
            let popTime : dispatch_time_t = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds)
            dispatch_after(popTime, dispatch_get_main_queue()) { () -> Void in
                SVProgressShow.showSuccessWithStatus("微信分享成功!")
            }
        }
        
        let action2 : DOPAction = DOPAction(name: "QQ", iconName: "qq") { () -> Void in
            SVProgressShow.showWithStatus("分享中...")
            let delayInSeconds : Int64 = 1
            let popTime : dispatch_time_t = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds)
            dispatch_after(popTime, dispatch_get_main_queue()) { () -> Void in
                SVProgressShow.showSuccessWithStatus("QQ分享成功!")
            }
        }
        
        let action3 : DOPAction = DOPAction(name: "微信朋友圈", iconName: "wxFriends") { () -> Void in
            SVProgressShow.showWithStatus("分享中...")
            let delayInSeconds : Int64 = 1
            let popTime : dispatch_time_t = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds)
            dispatch_after(popTime, dispatch_get_main_queue()) { () -> Void in
                SVProgressShow.showSuccessWithStatus("微信朋友圈分享成功!")
            }
        }
        
        let action4 : DOPAction = DOPAction(name: "QQ空间", iconName: "qzone") { () -> Void in
            SVProgressShow.showWithStatus("分享中...")
            let delayInSeconds : Int64 = 1
            let popTime : dispatch_time_t = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds)
            dispatch_after(popTime, dispatch_get_main_queue()) { () -> Void in
                SVProgressShow.showSuccessWithStatus("QQ空间分享成功!")
            }
        }
        
        let action5 : DOPAction = DOPAction(name: "微博", iconName: "weibo") { () -> Void in
            SVProgressShow.showWithStatus("分享中...")
            let delayInSeconds : Int64 = 1
            let popTime : dispatch_time_t = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds)
            dispatch_after(popTime, dispatch_get_main_queue()) { () -> Void in
                SVProgressShow.showSuccessWithStatus("新浪微博分享成功!")
            }
        }
        
        let action6 : DOPAction = DOPAction(name: "短信", iconName: "sms") { () -> Void in
            SVProgressShow.showWithStatus("短信发送中...")
            let delayInSeconds : Int64 = 1
            let popTime : dispatch_time_t = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds)
            dispatch_after(popTime, dispatch_get_main_queue()) { () -> Void in
                SVProgressShow.showSuccessWithStatus("短信发送成功!")
            }
        }
        
        let action7 : DOPAction = DOPAction(name: "邮件", iconName: "email") { () -> Void in
            SVProgressShow.showWithStatus("邮件发送中...")
            let delayInSeconds : Int64 = 1
            let popTime : dispatch_time_t = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds)
            dispatch_after(popTime, dispatch_get_main_queue()) { () -> Void in
                SVProgressShow.showSuccessWithStatus("邮件发送成功!")
            }
        }
        
        let actions : NSArray = ["",[action1,action2,action3,action4],"",[action5,action6,action7]]
        let myAs : DOPScrollableActionSheet = DOPScrollableActionSheet(actionArray: actions as [AnyObject])
        myAs.show()
    }
    
    
    func getProduct() {
        
        if CurrentUser.user == nil {
            SVProgressShow.showInfoWithStatus("请先登录!")
            return
        }
        
        SVProgressShow.showWithStatus("会员卡申请中...")
        
        Alamofire.request(.POST, baseUrl + "/card/v1.0/applyCard?", parameters: ["token":CurrentUser.user?.token == nil ? "" : CurrentUser.user!.token,"userId":CurrentUser.user?.userId == nil ? "" : CurrentUser.user!.userId,"merchId":self.productDataDic["merchId"].stringValue])
            
            .response { request, response, data, error in
                
                if error == nil {
                    let json  = JSON(data: data!)
                    
                    if RequestDataTool.processingData(json) != nil {
                        SVProgressShow.showSuccessWithStatus("会员卡申请成功!")
                       
                        Alamofire.request(.GET, baseUrl + "/product/v1.0/getProduct?", parameters: ["prodId":self.productDataDic["prodId"].stringValue,"token":CurrentUser.user?.token == nil ? "" : CurrentUser.user!.token])
                            
                            .response { request, response, data, error in
                             
                                if error == nil {
                                    let json  = JSON(data: data!)
                                    var nav : UINavigationController = UINavigationController()
                                    nav = self.navigationController!
                                    self.navigationController?.popViewControllerAnimated(false)
                                    
                                    let productIsMemberViewController =  ProductIsMemberViewController()
                                    productIsMemberViewController.productDataDic = json["product"]
                                    productIsMemberViewController.cardDataDic = json["card"]
                                    nav.pushViewController(productIsMemberViewController, animated: true)
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
