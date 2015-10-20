//
//  TBServiceViewController.swift
//  swiftShrb
//
//  Created by PayBay on 15/10/19.
//  Copyright © 2015年 PayBay. All rights reserved.
//

import UIKit

class TBServiceViewController: UIViewController, UITextFieldDelegate {

    
    var serviceView : UIView!
    var staticEmail : UILabel!
    var emailTextField : UITextField!
    var betweenLine1 : UIImageView!
    var phoneLabel : UILabel!
    var phoneTextField : UITextField!
    var betweenLine2 : UIImageView!
    var timeLabel : UILabel!
    var timeTextField : UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = shrbTableViewColor
        
        self.title = "通宝客服"
        
        self.creatServiceView()
        // Do any additional setup after loading the view.
    }
    
    func creatServiceView() {
       
        self.serviceView = UIView(frame: CGRectMake(0, 20 + 44 + 10, screenWidth, 165))
        self.serviceView.backgroundColor = UIColor.whiteColor()
        self.view.addSubview(self.serviceView)
        
        self.staticEmail = UILabel(frame: CGRectMake(16, 17, 0, 21))
        self.staticEmail.text = "Email"
        self.staticEmail.textColor = shrbPink
        self.staticEmail.sizeToFit()
        self.serviceView.addSubview(self.staticEmail)
        
        self.emailTextField = UITextField(frame: CGRectMake(self.staticEmail.frame.origin.x + self.staticEmail.frame.size.width + 16, 0, screenWidth - 16 - self.staticEmail.frame.size.width - 16, 55))
        self.emailTextField.text = "273269077@qq.com"
        self.emailTextField.textColor = shrbText
        self.emailTextField.keyboardType = .NumberPad
        self.emailTextField.delegate = self
        self.serviceView.addSubview(self.emailTextField)
        
        self.betweenLine1 = UIImageView(frame: CGRectMake(self.staticEmail.frame.origin.x, 55, self.emailTextField.frame.size.width, 1))
        self.betweenLine1.backgroundColor = shrbLightCell
        self.serviceView.addSubview(self.betweenLine1)
        
        self.phoneLabel = UILabel(frame: CGRectMake(16,  55 + 17, 0, 21))
        self.phoneLabel.text = "客服电话"
        self.phoneLabel.textColor = shrbPink
        self.phoneLabel.sizeToFit()
        self.serviceView.addSubview(self.phoneLabel)
        
        self.phoneTextField = UITextField(frame: CGRectMake(self.phoneLabel.frame.origin.x + self.phoneLabel.frame.width + 16, self.emailTextField.frame.size.height, self.emailTextField.frame.size.width, self.emailTextField.frame.size.height))
        self.phoneTextField.text = "18267856133"
        self.phoneTextField.textColor = shrbText
        self.phoneTextField.delegate = self
        self.serviceView.addSubview(self.phoneTextField)
        
        
        self.betweenLine2 = UIImageView(frame: CGRectMake(self.phoneLabel.frame.origin.x, 110, self.phoneTextField.frame.size.width, 1))
        self.betweenLine2.backgroundColor = shrbLightCell
        self.serviceView.addSubview(self.betweenLine2)
        
        self.timeLabel = UILabel(frame: CGRectMake(16,  110 + 17, 0, 21))
        self.timeLabel.text = "服务时间"
        self.timeLabel.textColor = shrbPink
        self.timeLabel.sizeToFit()
        self.serviceView.addSubview(self.timeLabel)
        
        self.timeTextField = UITextField(frame: CGRectMake(self.phoneTextField.frame.origin.x, 110, self.phoneTextField.frame.size.width, self.phoneTextField.frame.size.height))
        self.timeTextField.text = "9:30-11:30 13:00-18:00"
        self.timeTextField.textColor = shrbText
        self.timeTextField.delegate = self
        self.serviceView.addSubview(self.timeTextField)
        
        self.emailTextField.frame = CGRectMake(self.phoneLabel.frame.origin.x + self.phoneLabel.frame.width + 16, 0, screenWidth - 16 - self.staticEmail.frame.size.width - 16, 55)
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
