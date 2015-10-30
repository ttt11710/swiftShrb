//
//  ProductDescriptionView.swift
//  swiftShrb
//
//  Created by PayBay on 15/10/26.
//  Copyright © 2015年 PayBay. All rights reserved.
//

import UIKit

class ProductDescriptionView: UIView {

    var currentSection : NSInteger = 0
    var currentRow : NSInteger = 0
    
    var plistArr = [ProductListModel]()
    
    
    var data : NSMutableArray = []
    
    
    var mainView : UIView!
    var descriptionView : UIView!
    var paning : Bool = false
    var nameLabel : UILabel!
    var shadowView : UIView!
    var descriptionImageView : UIImageView!
    var saveMoneyLabel : UILabel!
    var descriptionLabel : UILabel!
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        self.userInteractionEnabled = true
        self.backgroundColor = UIColor(white: 0, alpha: 0.5)
        self.initMainView()
        self.initSubView()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initMainView() {
        self.mainView = UIView(frame: CGRectMake(screenWidth/10,20,4*screenWidth/5,3*screenHeight/4))
        self.mainView.backgroundColor = UIColor.clearColor()
        self.addSubview(self.mainView)
    }
    
    func initSubView() {
        self.descriptionView = UIView(frame: CGRectMake(0,0,4*screenWidth/5,3*screenHeight/4))
        self.descriptionView.backgroundColor = UIColor.whiteColor()
        self.descriptionView.userInteractionEnabled = true
        let panGestureRecognizer : UIPanGestureRecognizer = UIPanGestureRecognizer(target: self, action: Selector("cardPanEven:"))
        self.descriptionView.addGestureRecognizer(panGestureRecognizer)
        self.descriptionView.layer.cornerRadius = 8
        self.descriptionView.layer.masksToBounds = true
        
        self.mainView.insertSubview(self.descriptionView, atIndex: 0)
        
        self.nameLabel = UILabel(frame: CGRectMake(12,12,200,21))
        
        self.nameLabel.textColor = shrbText
        self.descriptionView.addSubview(self.nameLabel)
        
        self.descriptionImageView = UIImageView(frame: CGRectMake(12, self.nameLabel.frame.origin.y + self.nameLabel.frame.size.height + 4, 4*screenWidth/5-12*2, 4*screenWidth/5-50))
        
        self.descriptionImageView.layer.cornerRadius = 8
        self.descriptionImageView.layer.masksToBounds = true
        
        //4边阴影
        self.shadowView = UIView(frame: CGRectMake(12,self.nameLabel.frame.origin.y + self.nameLabel.frame.size.height+4,4*screenWidth/5-12*2,4*screenWidth/5-50))
        self.shadowView.userInteractionEnabled = false
        self.shadowView.backgroundColor = UIColor.whiteColor()
        self.shadowView.layer.cornerRadius = 8
        self.shadowView.layer.shadowColor = UIColor.blackColor().CGColor
        self.shadowView.layer.shadowOffset = CGSizeMake(0, 0)
        self.shadowView.layer.shadowOpacity = 0.5
        self.shadowView.layer.shadowRadius = 2
        
        //路径阴影
        let path : UIBezierPath = UIBezierPath()
        let width : CGFloat = self.shadowView.bounds.size.width
        let height : CGFloat = self.shadowView.bounds.size.height
        let x = self.shadowView.bounds.origin.x
        let y = self.shadowView.bounds.origin.y
        let addWH : CGFloat = 2
        let topLeft : CGPoint = CGPointMake(x, y)
        let topMiddle : CGPoint = CGPointMake(x+width/2, y-addWH)
        let topRight : CGPoint = CGPointMake(x+width, y)
        
        let rightMiddle : CGPoint = CGPointMake(x+width+addWH, y+height/2)
        
        let bottomRight : CGPoint = CGPointMake(x+width, y+height)
        let bottomMiddle : CGPoint = CGPointMake(x + width/2, y+height+addWH)
        let bottomLeft : CGPoint = CGPointMake(x, y+height)
        
        let leftMiddle : CGPoint = CGPointMake(x-addWH, y+height/2)
        path.moveToPoint(topLeft)
        
        //4个二元曲面
        path.addQuadCurveToPoint(topRight, controlPoint: topMiddle)
        path.addQuadCurveToPoint(bottomRight, controlPoint: rightMiddle)
        path.addQuadCurveToPoint(bottomLeft, controlPoint: bottomMiddle)
        path.addQuadCurveToPoint(topLeft, controlPoint: leftMiddle)
        
        //设置阴影路径
        self.shadowView.layer.shadowPath = path.CGPath
        
        self.descriptionView.addSubview(self.shadowView)
        self.descriptionView.addSubview(self.descriptionImageView)
        self.addBlurViewView(self.descriptionImageView)
        
        
        self.saveMoneyLabel = UILabel(frame: CGRectMake(12,self.descriptionImageView.frame.size.height-21-12,100,21))
        self.saveMoneyLabel.text = "省40元"
        
        self.saveMoneyLabel.textColor = UIColor.orangeColor()
        self.descriptionImageView.addSubview(self.saveMoneyLabel)
        
        self.descriptionLabel = UILabel(frame: CGRectMake(12,self.descriptionImageView.frame.origin.y+self.descriptionImageView.frame.size.height+4,4*screenWidth/5-12*2,30))
        
        self.descriptionLabel.backgroundColor = UIColor.whiteColor()
        self.descriptionLabel.textColor = UIColor.grayColor()
        self.descriptionLabel.numberOfLines = 0
        self.descriptionLabel.lineBreakMode = NSLineBreakMode.ByTruncatingTail
        self.descriptionView.addSubview(self.descriptionLabel)
        self.descriptionLabel.font = isIphone4s ? font15 : font16
        
        
        let shareBtn : UIButton = UIButton(type: .Custom)
        shareBtn.frame = CGRectMake(self.descriptionImageView.frame.origin.x+self.descriptionImageView.frame.size.width-41-15, self.descriptionImageView.frame.origin.y+self.descriptionImageView.frame.size.height-40, 41, 35)
        shareBtn.setBackgroundImage(UIImage(named: "fenxiang"), forState: UIControlState.Normal)
        shareBtn.addTarget(self, action: Selector("shareBtnPressed"), forControlEvents: UIControlEvents.TouchUpInside)
        shareBtn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Highlighted)
        self.descriptionView.addSubview(shareBtn)
        
        
        let collectBtn : UIButton = UIButton(type: .Custom)
        collectBtn.frame = CGRectMake(shareBtn.frame.origin.x-40,shareBtn.frame.origin.y, 40, 35)
        collectBtn.setBackgroundImage(UIImage(named: "shoucang"), forState: UIControlState.Normal)
        collectBtn.addTarget(self, action: Selector("collectBtnPressed"), forControlEvents: UIControlEvents.TouchUpInside)
        collectBtn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Highlighted)
        self.descriptionView.addSubview(collectBtn)
        
        let addButton : UIButton = UIButton(frame: CGRectMake(4*screenWidth/5-55,8,40,25))
        addButton.layer.cornerRadius = 4
        addButton.layer.masksToBounds = true
        addButton.layer.borderColor = shrbPink.CGColor
        addButton.layer.borderWidth = 1
        addButton.titleLabel?.font = font14
        addButton.setTitle("添加", forState: UIControlState.Normal)
        addButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        addButton.setTitleColor(shrbPink, forState: UIControlState.Highlighted)
        addButton.setBackgroundImage(UIImage(named: "button_highlight"), forState: UIControlState.Normal)
        addButton.setBackgroundImage(UIImage(named: "button"), forState: UIControlState.Highlighted)
        addButton.addTarget(self, action: Selector("addButtonEven"), forControlEvents: UIControlEvents.TouchUpInside)
        self.descriptionView.addSubview(addButton)
        
    }
    
    func refreshDescriptionView() {
        self.nameLabel.text = self.plistArr[self.currentSection].prodList[self.currentRow].prodName
        self.descriptionImageView.sd_setImageWithURL(NSURL(string: self.plistArr[self.currentSection].prodList[self.currentRow].imgUrl)!, placeholderImage: UIImage(named: "热点无图片"))
        self.saveMoneyLabel.text = String(format: "省￥%.2f", self.plistArr[self.currentSection].prodList[self.currentRow].price - self.plistArr[self.currentSection].prodList[self.currentRow].vipPrice)
        self.descriptionLabel.text = self.plistArr[self.currentSection].prodList[self.currentRow].prodDesc
        self.descriptionLabel.sizeToFit()
        
        self.descriptionView.frame = CGRectMake(0, 0, 4*screenWidth/5, self.descriptionImageView.frame.origin.y+self.descriptionImageView.frame.size.height+4+self.descriptionLabel.frame.size.height+12)
        self.mainView.frame = CGRectMake(screenWidth/10, 0, 4*screenWidth/5, self.descriptionImageView.frame.origin.y+self.descriptionImageView.frame.size.height+4+self.descriptionLabel.frame.size.height+12)
        self.mainView.center = CGPointMake(screenWidth/2, (screenHeight-20-44)/2)
    }
    
    var startPoint : CGPoint!
    var endPoint : CGPoint!
    var oldSection : NSInteger!
    var oldRow : NSInteger!
    
    
    func cardPanEven(sender : UIPanGestureRecognizer) {
        if !self.paning {
            self.mainView.bringSubviewToFront(sender.view!)
            startPoint = sender.translationInView(self.mainView)
            endPoint = startPoint
            oldSection = self.currentSection
            oldRow = self.currentRow
            
            if (oldRow < (self.plistArr[oldSection].prodList.count-1)) && (oldRow >= 0) {
                oldRow = oldRow + 1
            }
            
            else {
                oldRow = 0
                oldSection = oldSection + 1
            }
            if oldSection == self.plistArr.count {
                oldSection = 0
            }
            self.currentRow = oldRow
            self.currentSection = oldSection
            
            self.initSubView()
            self.refreshDescriptionView()
            self.descriptionView.transform = CGAffineTransformMakeScale(0.5, 0.5)
            self.descriptionView.userInteractionEnabled = false
            self.paning = true
            
        }
        
        let point : CGPoint = sender.translationInView(self.mainView)
        endPoint = CGPointMake(endPoint.x + point.x, endPoint.y + point.y)
        sender.view?.transform = CGAffineTransformTranslate((sender.view?.transform)!, point.x, point.y)
        sender.setTranslation(CGPointMake(0,0), inView: self.mainView)
        
        var scale : CGFloat = (abs(endPoint.x-startPoint.x)+abs(endPoint.y-startPoint.y))*0.0005;
        scale = min(0.1, scale)
        self.descriptionView.transform = CGAffineTransformMakeScale(0.5+scale, 0.5+scale)
        
        if sender.state == UIGestureRecognizerState.Ended {
            if abs(endPoint.x-startPoint.x) <= 100 && abs(endPoint.y-startPoint.y) <= 100 {
                self.descriptionView.removeFromSuperview()
                self.descriptionView = sender.view
                self.refreshDescriptionView()
                UIView.animateWithDuration(0.2, animations: { () -> Void in
                    sender.view?.transform = CGAffineTransformIdentity
                })
                self.paning = false
                return
            }
            let x : CGFloat
            let y : CGFloat
            x = sender.view?.frame.origin.x >= 0 ? screenWidth : 0
            y = screenHeight
            
            UIView.animateWithDuration(0.6, animations: { () -> Void in
                sender.view!.frame = CGRectMake(x, y, 0, 0)
                self.descriptionView.transform = CGAffineTransformIdentity
                }, completion: { (finished : Bool) -> Void in
                    sender.view?.removeFromSuperview()
                    self.paning = false
                    self.descriptionView.userInteractionEnabled = true
            })
            
        }
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if (touches as NSSet).anyObject()?.view != self.mainView  && (touches as NSSet).anyObject()?.view != self.descriptionView{
            self.removeFromSuperview()
        }
    }
    

    
    func addBlurViewView(view : UIView) {
        if isIos8 {
            let blurEffect : UIBlurEffect = UIBlurEffect(style: .Light)
            let blurEffectView : UIVisualEffectView = UIVisualEffectView(effect: blurEffect)
            blurEffectView.backgroundColor = UIColor(white: 0, alpha: 0.2)
            blurEffectView.frame = CGRectMake(0, view.frame.size.height-45, view.frame.size.width, 45)
            view.insertSubview(blurEffectView, atIndex: 0)
        }
        else {
            let blurEffectView : UIView = UIView()
            blurEffectView.backgroundColor = UIColor(white: 0, alpha: 0.2)
            blurEffectView.frame = CGRectMake(0, view.frame.size.height-45, view.frame.size.width, 45)
            view.insertSubview(blurEffectView, atIndex: 0)
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
    
    func collectBtnPressed() {
       
        SVProgressShow.showWithStatus("收藏中")
        let delayInSeconds : Int64 = 1
        let popTime : dispatch_time_t = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds)
        dispatch_after(popTime, dispatch_get_main_queue()) { () -> Void in
            SVProgressShow.showSuccessWithStatus("收藏成功!")
        }
    }
    
    func addButtonEven() {
        SVProgressShow.showSuccessWithStatus("添加成功")
    }
    
}




















