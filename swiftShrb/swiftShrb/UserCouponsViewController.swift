//
//  UserCouponsViewController.swift
//  swiftShrb
//
//  Created by PayBay on 15/10/29.
//  Copyright © 2015年 PayBay. All rights reserved.
//

import UIKit

class UserCouponsViewController: UIViewController {

    var couponsBackView : UIView!
    var redPacketBack1 : UIImageView!
    var redPacketBack1SubView : UIView!
    var redPacketLogoImageView : UIImageView!
    var couponsImageView : UIImageView!
    var moneyLabel : UILabel!
    

    var redPacketBack2 : UIImageView!
    var outOfDateLabel : UILabel!
    var expiryDateLabel : UILabel!
    
    var ruleView : UIView!
    var ruleLabel : UILabel!
    
    var userBtn : UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "电子券使用"
        self.view.backgroundColor = shrbTableViewColor
        
        self.creatCouponsDetialView()
        self.creatRedPacketBack1View()
        self.creatRedPacketBack2View()
        self.creatRuleView()
        self.creatUserBtnView()
        // Do any additional setup after loading the view.
    }
    
    func creatCouponsDetialView() {
        self.couponsBackView = UIView(frame: CGRectMake(16,20+44+12,screenWidth-32,125))
        self.view.addSubview(self.couponsBackView)
        
        self.redPacketBack1 = UIImageView(frame: CGRectMake(0,0,self.couponsBackView.frame.size.width,self.couponsBackView.frame.size.height/25*19))
        self.redPacketBack1.image = UIImage(named: "redPacketBack1")
        self.couponsBackView.addSubview(self.redPacketBack1)
        
        self.redPacketBack1SubView = UIView(frame: self.redPacketBack1.bounds)
        self.couponsBackView.addSubview(self.redPacketBack1SubView)
        
        self.redPacketBack2 = UIImageView(frame: CGRectMake(0,self.redPacketBack1.frame.origin.y + self.redPacketBack1.frame.size.height,self.couponsBackView.frame.size.width,self.couponsBackView.frame.size.height-self.redPacketBack1.frame.size.height))
        self.redPacketBack2.image = UIImage(named: "redPacketBack2")
        self.couponsBackView.addSubview(self.redPacketBack2)
        
    }
    
    func creatRedPacketBack1View() {
        
        self.redPacketLogoImageView = UIImageView(frame: CGRectMake(0, 0, 50, 20))
        self.redPacketLogoImageView.image = UIImage(named: "redPacketLogo")
        self.redPacketBack1SubView.addSubview(self.redPacketLogoImageView)
        
        self.couponsImageView = UIImageView(frame: CGRectMake(30, 24, 50, 50))
        self.couponsImageView.image = UIImage(named: "paybayLogo")
        self.couponsImageView.layer.cornerRadius = 4
        self.couponsImageView.layer.masksToBounds = true
        self.redPacketBack1SubView.addSubview(self.couponsImageView)
        
        self.moneyLabel = UILabel(frame: CGRectMake(self.couponsImageView.frame.origin.x + self.couponsImageView.frame.size.width + 8,self.couponsImageView.frame.origin.y ,200,50))
        let string : String = "￥1000RMB"
        let attrString : NSMutableAttributedString = NSMutableAttributedString(string: string)
        
        attrString.addAttribute(NSForegroundColorAttributeName, value:UIColor(red: 251.0/255.0, green: 102.0/255.0, blue: 49.0/255.0, alpha: 1), range: NSMakeRange(0, string.characters.count))
        
        attrString.addAttribute(NSFontAttributeName, value: UIFont.systemFontOfSize(34), range: NSMakeRange(1, string.characters.count-1))
        
        if isIphone4s {
            attrString.addAttribute(NSFontAttributeName, value: UIFont.systemFontOfSize(24), range: NSMakeRange(1, string.characters.count-1))
        }
        self.moneyLabel.attributedText = attrString
        self.redPacketBack1SubView.addSubview(self.moneyLabel)
        
    }
    
    func creatRedPacketBack2View() {
        self.outOfDateLabel = UILabel(frame: CGRectMake(8,4,200,25))
        self.outOfDateLabel.text = "还有4天过期"
        self.outOfDateLabel.font = font14
        self.outOfDateLabel.textColor = shrbLightText
        self.redPacketBack2.addSubview(self.outOfDateLabel)
        
        self.expiryDateLabel = UILabel(frame: CGRectMake(self.redPacketBack2.frame.size.width-200,4,200,25))
        self.expiryDateLabel.text = "有效期至:2015-12-31"
        self.expiryDateLabel.font = font14
        self.expiryDateLabel.textColor = shrbLightText
        self.expiryDateLabel.sizeToFit()
        self.expiryDateLabel.frame = CGRectMake(self.redPacketBack2.frame.size.width-self.expiryDateLabel.frame.size.width-8, 4, self.expiryDateLabel.frame.size.width, 25)
        self.redPacketBack2.addSubview(self.expiryDateLabel)
        
    }
    
    func creatRuleView() {
        
        self.ruleView = UIView(frame: CGRectMake(0,self.couponsBackView.frame.origin.y + self.couponsBackView.frame.size.height + 32,screenWidth,100))
        self.ruleView.backgroundColor = UIColor.whiteColor()
        self.view.addSubview(self.ruleView)
        
        self.ruleLabel = UILabel(frame: CGRectMake(8,10,self.ruleView.frame.size.width-16,100))
        self.ruleLabel.numberOfLines = 0
        self.ruleLabel.text = "电子券使用规则\n    1、电子抵用券，只可在消费时直接使用，不可把电子券金额转存至会员卡中。支付消费时，会提示使用此类电子券。\n       此类电子券有一定的时效期限，据商家而定。\n    2、电子红包券，是可以把电子券金额转存至会员卡中，且单项操作。电子券转存的会员卡金额不可以体现。"
        self.ruleLabel.font = font15
        self.ruleLabel.textColor = shrbLightText
        self.ruleLabel.sizeToFit()
        self.ruleView.addSubview(self.ruleLabel)
        self.ruleView.frame = CGRectMake(0,self.couponsBackView.frame.origin.y + self.couponsBackView.frame.size.height + 32,screenWidth, 10 + self.ruleLabel.frame.size.height + 10)
    }
    
    func creatUserBtnView() {
        self.userBtn = UIButton(frame: CGRectMake(30,self.ruleView.frame.origin.y + self.ruleView.frame.size.height + 20,screenWidth-60,44))
        self.userBtn.setTitle("转存", forState: UIControlState.Normal)
        self.userBtn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        self.userBtn.layer.cornerRadius = 4
        self.userBtn.layer.masksToBounds = true
        self.userBtn.addTarget(self, action: Selector("userBtnPressed"), forControlEvents: UIControlEvents.TouchUpInside)
        self.userBtn.backgroundColor = shrbPink
        self.view.addSubview(self.userBtn)
    }
    
    func userBtnPressed() {
        SVProgressShow.showSuccessWithStatus("转存成功!")
        
        let delayInSeconds : Double = 1
        let popTime : dispatch_time_t = dispatch_time(DISPATCH_TIME_NOW, Int64(delayInSeconds * Double(NSEC_PER_SEC)))
        dispatch_after(popTime, dispatch_get_main_queue(), { () -> Void in
            SVProgressShow.dismiss()
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
