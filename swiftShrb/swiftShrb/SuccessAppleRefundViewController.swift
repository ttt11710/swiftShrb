//
//  SuccessAppleRefundViewController.swift
//  swiftShrb
//
//  Created by PayBay on 15/10/28.
//  Copyright © 2015年 PayBay. All rights reserved.
//

import UIKit

class SuccessAppleRefundViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "退款成功"
        self.view.backgroundColor = UIColor.whiteColor()
        
        let imageView : UIImageView = UIImageView(image: UIImage(named: "success"))
        imageView.frame = CGRectMake(screenWidth/2-35, screenHeight/2-100, 70, 70)
        self.view.addSubview(imageView)
        
        let label : UILabel = UILabel()
        label.font = font18
        label.text = "恭喜,退款成功"
        label.sizeToFit()
        label.textAlignment = .Center
        label.center = CGPointMake(screenWidth/2, screenHeight/2)
        self.view.addSubview(label)
        
        
        let label2 : UILabel = UILabel()
        label2.font = font18
        label2.text = "金额预计3个工作日内退至您的账户"
        label2.sizeToFit()
        label2.textAlignment = .Center
        label2.center = CGPointMake(screenWidth/2, screenHeight/2 + 22)
        self.view.addSubview(label2)
        
        // Do any additional setup after loading the view.
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
