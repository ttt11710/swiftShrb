//
//  CardAndCouponsViewController.swift
//  swiftShrb
//
//  Created by PayBay on 15/9/28.
//  Copyright © 2015年 PayBay. All rights reserved.
//

import UIKit

class CardAndCouponsViewController: UIViewController {
    
    var cardBtn : UIButton!
    var couponsBtn : UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setView()
        
        self.title = "卡包"
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.hidden = false
    }

    
    func setView() {
        cardBtn = UIButton(frame: CGRectMake(16, 20 + 44 + 16, screenWidth-32, (screenWidth-32)/2))
        cardBtn.setBackgroundImage(UIImage(named: "vipBack"), forState: UIControlState.Normal)
        cardBtn.setBackgroundImage(UIImage(named: "vipBack"), forState: UIControlState.Highlighted)
        cardBtn.addTarget(self, action: Selector("gotoCardView"), forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(cardBtn)
        
        couponsBtn = UIButton(frame: CGRectMake(self.cardBtn.frame.origin.x, self.cardBtn.frame.origin.y + self.cardBtn.frame.size.height + 20 , self.cardBtn.frame.size.width, self.cardBtn.frame.size.height))
        couponsBtn.setBackgroundImage(UIImage(named: "couponsBack"), forState: UIControlState.Normal)
        couponsBtn.setBackgroundImage(UIImage(named: "couponsBack"), forState: UIControlState.Highlighted)
        couponsBtn.addTarget(self, action: Selector("gotoCouponsView"), forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(couponsBtn)
        
    }
    
    func gotoCardView() {
        let cardViewController = CardViewController()
        cardViewController.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(cardViewController, animated: true)
    }
    
    func gotoCouponsView() {
        print("显示电子券页面")
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

