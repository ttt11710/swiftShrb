//
//  GiveCouponsViewController.swift
//  swiftShrb
//
//  Created by PayBay on 15/10/29.
//  Copyright © 2015年 PayBay. All rights reserved.
//

import UIKit

class GiveCouponsViewController: UIViewController {
    
    var backView : UIView!
    var couponsImageView : UIImageView!
    var moneyLabel : UILabel!
    var descriotionLabel : UILabel!
    
    var giveFriendsLabel : UILabel!
    var smsBtn : UIButton!
    var weixinBtn : UIButton!
    var QQBtn : UIButton!
    var weiboBtn : UIButton!
    
    var smsLabel : UILabel!
    var weixinLabel : UILabel!
    var QQLabel : UILabel!
    var weiboLabel : UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "送好友"
        self.view.backgroundColor = UIColor.whiteColor()
        self.creatDetialView()
        self.creatGiveFriendsBtnView()
        
        // Do any additional setup after loading the view.
    }
    
    func creatDetialView() {
        self.backView = UIView(frame: CGRectMake(8,20+44,screenWidth-16,200))
       // self.backView.layer.cornerRadius = 4
       // self.backView.layer.masksToBounds = true
       // self.backView.backgroundColor = shrbLightCell
        self.view.addSubview(self.backView)
        
        self.couponsImageView = UIImageView(frame: CGRectMake(16,8,60,60))
        self.couponsImageView.image = UIImage(named: "paybayLogo")
        self.couponsImageView.layer.cornerRadius = 4
        self.couponsImageView.layer.masksToBounds = true
        self.backView.addSubview(self.couponsImageView)
        
        self.moneyLabel = UILabel(frame: CGRectMake(self.couponsImageView.frame.origin.x + self.couponsImageView.frame.size.width + 20, self.couponsImageView.frame.origin.y + self.couponsImageView.frame.size.height - 25,300,25))
        self.moneyLabel.text = "金额:100RMB"
        self.moneyLabel.textColor = shrbText
        self.backView.addSubview(self.moneyLabel)
        
        self.descriotionLabel = UILabel(frame: CGRectMake(8, self.couponsImageView.frame.origin.y+self.couponsImageView.frame.size.height+16, self.backView.frame.size.width-16,100))
        self.descriotionLabel.backgroundColor = UIColor.whiteColor()
        self.descriotionLabel.textColor = shrbPink
        self.descriotionLabel.numberOfLines = 0
        self.descriotionLabel.text = "使用期限:\n2015.01.01——2016.05.20\n\n送好友:\n好友接收到电子券，就可以凭券消费。。。\n\n转送方式:\n以链接的方式，直接通过短信、微信、QQ、微博等发给指定好友即可。"
        self.descriotionLabel.font = font14
        self.descriotionLabel.sizeToFit()
        self.backView.addSubview(self.descriotionLabel)
        
        self.backView.frame = CGRectMake(8, 20+44+20, screenWidth-16, 8+self.couponsImageView.frame.size.height + 16 + self.descriotionLabel.frame.size.height + 16)
    }
    
    func creatGiveFriendsBtnView() {
        self.giveFriendsLabel = UILabel(frame: CGRectMake(8,self.backView.frame.origin.y + self.backView.frame.size.height + 34,200,25))
        self.giveFriendsLabel.text = "赠送方式"
        self.giveFriendsLabel.textColor = shrbPink
        self.giveFriendsLabel.font = font17
        self.view.addSubview(self.giveFriendsLabel)
        
        let betweenBtn : CGFloat = (screenWidth-60*4)/5
        
        self.smsBtn = UIButton(frame: CGRectMake(betweenBtn,self.giveFriendsLabel.frame.origin.y + self.giveFriendsLabel.frame.size.height + 8,60,60))
        self.smsBtn.setBackgroundImage(UIImage(named: "sms"), forState: UIControlState.Normal)
        self.smsBtn.tag = 0
        self.smsBtn.addTarget(self, action: Selector("giveCouponsBtnPressed:"), forControlEvents: UIControlEvents.TouchUpInside)
        self.smsBtn.layer.cornerRadius = 4
        self.smsBtn.layer.masksToBounds = true
        self.view.addSubview(self.smsBtn)
        
        self.smsLabel = UILabel()
        self.smsLabel.font = font16
        self.smsLabel.text = "短信"
         self.smsLabel.sizeToFit()
        self.smsLabel.textAlignment = .Center
        self.smsLabel.textColor = shrbText
        self.smsLabel.center = CGPointMake(self.smsBtn.center.x, self.smsBtn.center.y + 50)
        self.view.addSubview(self.smsLabel)
        
        self.weixinBtn = UIButton(frame: CGRectMake(betweenBtn*2+self.smsBtn.frame.size.width,self.smsBtn.frame.origin.y ,60,60))
        self.weixinBtn.setBackgroundImage(UIImage(named: "weixin"), forState: UIControlState.Normal)
        self.weixinBtn.tag = 1
        self.weixinBtn.addTarget(self, action: Selector("giveCouponsBtnPressed:"), forControlEvents: UIControlEvents.TouchUpInside)
        self.weixinBtn.layer.cornerRadius = 4
        self.weixinBtn.layer.masksToBounds = true
        self.view.addSubview(self.weixinBtn)
        
        self.weixinLabel = UILabel()
        self.weixinLabel.font = font16
        self.weixinLabel.text = "微信"
        self.weixinLabel.sizeToFit()
        self.weixinLabel.textAlignment = .Center
        self.weixinLabel.textColor = shrbText
        self.weixinLabel.center = CGPointMake(self.weixinBtn.center.x, self.weixinBtn.center.y + 50)
        self.view.addSubview(self.weixinLabel)
        
        self.QQBtn = UIButton(frame: CGRectMake(betweenBtn*3+self.smsBtn.frame.size.width*2,self.smsBtn.frame.origin.y ,60,60))
        self.QQBtn.setBackgroundImage(UIImage(named: "qq"), forState: UIControlState.Normal)
        self.QQBtn.tag = 2
        self.QQBtn.addTarget(self, action: Selector("giveCouponsBtnPressed:"), forControlEvents: UIControlEvents.TouchUpInside)
        self.QQBtn.layer.cornerRadius = 4
        self.QQBtn.layer.masksToBounds = true
        self.view.addSubview(self.QQBtn)
        
        self.QQLabel = UILabel()
        self.QQLabel.font = font16
        self.QQLabel.text = "QQ"
        self.QQLabel.sizeToFit()
        self.QQLabel.textAlignment = .Center
        self.QQLabel.textColor = shrbText
        self.QQLabel.center = CGPointMake(self.QQBtn.center.x, self.QQBtn.center.y + 50)
        self.view.addSubview(self.QQLabel)
        
        self.weiboBtn = UIButton(frame: CGRectMake(betweenBtn*4+self.smsBtn.frame.size.width*3,self.smsBtn.frame.origin.y ,60,60))
        self.weiboBtn.setBackgroundImage(UIImage(named: "weibo"), forState: UIControlState.Normal)
        self.weiboBtn.tag = 3
        self.weiboBtn.addTarget(self, action: Selector("giveCouponsBtnPressed:"), forControlEvents: UIControlEvents.TouchUpInside)
        self.weiboBtn.layer.cornerRadius = 4
        self.weiboBtn.layer.masksToBounds = true
        self.view.addSubview(self.weiboBtn)
        
        self.weiboLabel = UILabel()
        self.weiboLabel.font = font16
        self.weiboLabel.text = "微博"
        self.weiboLabel.sizeToFit()
        self.weiboLabel.textAlignment = .Center
        self.weiboLabel.textColor = shrbText
        self.weiboLabel.center = CGPointMake(self.weiboBtn.center.x, self.weiboBtn.center.y + 50)
        self.view.addSubview(self.weiboLabel)
        
    }
    
    func giveCouponsBtnPressed(sender : UIButton) {
        
        let delayInSeconds : Double = 1
        SVProgressShow.showWithStatus("赠送中...")
        let popTime : dispatch_time_t = dispatch_time(DISPATCH_TIME_NOW, Int64(delayInSeconds * Double(NSEC_PER_SEC)))
        dispatch_after(popTime, dispatch_get_main_queue(), { () -> Void in
            switch sender.tag {
            case 0:
                SVProgressShow.showSuccessWithStatus("短信赠送成功!")
            case 1:
                SVProgressShow.showSuccessWithStatus("微信赠送成功!")
            case 2:
                SVProgressShow.showSuccessWithStatus("QQ赠送成功!")
            case 3:
                SVProgressShow.showSuccessWithStatus("微博赠送成功!")
            default:
                break
            }
            self.navigationController?.popViewControllerAnimated(true)
        })
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
