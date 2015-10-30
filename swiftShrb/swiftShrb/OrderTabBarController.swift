//
//  OrderTabBarController.swift
//  swiftShrb
//
//  Created by PayBay on 15/10/27.
//  Copyright © 2015年 PayBay. All rights reserved.
//

import UIKit

class OrderTabBarController: UITabBarController {

    
    var tabBarView : UIImageView!
    var previousBtn : NTButton!
    
    var scorllView : UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "我的订单"
        self.tabBar.hidden = true
        self.view.backgroundColor = UIColor.whiteColor()
        
        self.tabBarView = UIImageView(frame: CGRectMake(0, 20+44, screenWidth, 42))
        self.tabBarView.backgroundColor = UIColor(red: 250.0/255.0, green: 239.0/255.0, blue: 232.0/255.0, alpha: 1)
        self.tabBarView.userInteractionEnabled = true
        self.tabBarView.backgroundColor = UIColor.whiteColor()
        self.view.addSubview(self.tabBarView)
        
        self.scorllView = UIView(frame: CGRectMake(0,self.tabBarView.frame.size.height-2,self.tabBarView.frame.size.width/2,2))
        self.scorllView.backgroundColor = shrbPink
        self.tabBarView.addSubview(self.scorllView)
        
        self.creatButtonWithNormalName("订单记录", SelectName: "未评价高亮", Index: 0)
        self.creatButtonWithNormalName("退款记录", SelectName: "已评价高亮", Index: 1)
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(animated)
        
        if CurrentUser.user == nil {
            SVProgressShow.showInfoWithStatus("请先登录!")
            
            let delayInSeconds : Double = 1
            let popTime : dispatch_time_t = dispatch_time(DISPATCH_TIME_NOW, Int64(delayInSeconds * Double(NSEC_PER_SEC)))
            dispatch_after(popTime, dispatch_get_main_queue(), { () -> Void in
                SVProgressShow.dismiss()
                self.navigationController?.popViewControllerAnimated(true)
            })
            return
        }
        
        let orderListViewController = OrderListViewController()
        orderListViewController.hidesBottomBarWhenPushed = true
        
        
        let navi1 : UINavigationController = UINavigationController(rootViewController: orderListViewController)
        navi1.tabBarController?.hidesBottomBarWhenPushed = true
        
        let refundOrderViewController = RefundOrderViewController()
        refundOrderViewController.hidesBottomBarWhenPushed = true
        
        let navi2 : UINavigationController = UINavigationController(rootViewController: refundOrderViewController)
        navi2.tabBarController?.hidesBottomBarWhenPushed = true
        
        self.viewControllers = [orderListViewController,refundOrderViewController]
        
        self.previousBtn = NTButton()
        let button : NTButton = self.tabBarView.subviews[1] as! NTButton
        self.changeViewController(button)


    }
    
    func creatButtonWithNormalName(normal : String, SelectName : String, Index : Int) {
        
        let customButton = NTButton(type: .Custom)
        customButton.tag = Index
        let buttonW = self.tabBarView.frame.size.width/2
        let buttonH = self.tabBarView.frame.size.height
        
        customButton.frame = CGRectMake(buttonW * CGFloat(Index), 0, buttonW, buttonH)
        
        customButton.setBackgroundImage(UIImage(named: "未评价选中选中高亮"), forState: UIControlState.Disabled)
        customButton.setTitle(normal, forState: UIControlState.Normal)
        customButton.setTitleColor(shrbPink, forState: UIControlState.Disabled)
        customButton.setTitleColor(UIColor.lightGrayColor(), forState: UIControlState.Normal)
        customButton.titleLabel?.font = font18
        customButton.addTarget(self, action: Selector("changeViewController:"), forControlEvents: UIControlEvents.TouchDown)
        customButton.imageView?.contentMode = .Center
        self.tabBarView.addSubview(customButton)
        
        let imageView : UIImageView = UIImageView(frame: CGRectMake(self.tabBarView.frame.size.width/2-3, 0, 6, self.tabBarView.frame.size.height-2.5))
        imageView.backgroundColor = UIColor.whiteColor()
        
    }
    
    func changeViewController(sender : NTButton) {
      
        if self.previousBtn != sender {
            self.previousBtn.enabled = true
            
            UIView.animateWithDuration(0.25, delay: 0, options: UIViewAnimationOptions.CurveLinear, animations: { () -> Void in
                
                if sender.tag == 1 {
                    self.scorllView.layer.transform = CATransform3DMakeTranslation(self.tabBarView.frame.size.width/2, 0, 0)
                }
                else {
                    self.scorllView.layer.transform = CATransform3DIdentity
                }
                
                }, completion: { (finished : Bool) -> Void in
                   
                    self.selectedIndex = sender.tag
                    sender.enabled = false
                    self.selectedViewController?.hidesBottomBarWhenPushed = true
                    self.selectedViewController = self.viewControllers![sender.tag]
                    self.previousBtn = sender
            })
        }
        else {
            self.selectedIndex = sender.tag
            sender.enabled = false
            self.selectedViewController?.hidesBottomBarWhenPushed = true
            self.selectedViewController = self.viewControllers![sender.tag]
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
