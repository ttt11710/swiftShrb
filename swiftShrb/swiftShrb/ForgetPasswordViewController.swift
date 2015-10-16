//
//  ForgetPasswordViewController.swift
//  swiftShrb
//
//  Created by PayBay on 15/10/16.
//  Copyright © 2015年 PayBay. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ForgetPasswordViewController: UIViewController,UITextFieldDelegate {

    
    var registerView : UIView!
    var staticUserName : UILabel!
    var phoneTextField : UITextField!
    var betweenLine1 : UIImageView!
    
    var captchaLabel : UILabel!
    var captchaTextField : UITextField!
    var betweenLine2 : UIImageView!
    var getCaptchaBtn : UIButton!
    
    var newPasswordLabel : UILabel!
    var newPasswordTextField : UITextField!
    
    var setPassBtn : UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "忘记密码"
        
        self.view.backgroundColor = shrbLightCell
        
        self.creatRegisterView()
        self.creatSetPassBtn()
        
        // Do any additional setup after loading the view.
    }
    
    func creatRegisterView() {
        
        self.registerView = UIView(frame: CGRectMake(0, 20 + 44 + 10, screenWidth, 165))
        self.registerView.backgroundColor = UIColor.whiteColor()
        self.view.addSubview(self.registerView)
        
        self.staticUserName = UILabel(frame: CGRectMake(16, 17, 0, 21))
        self.staticUserName.text = "手机号"
        self.staticUserName.textColor = shrbPink
        self.staticUserName.sizeToFit()
        self.registerView.addSubview(self.staticUserName)
        
        self.phoneTextField = UITextField(frame: CGRectMake(self.staticUserName.frame.origin.x + self.staticUserName.frame.size.width + 16, 0, screenWidth - 16 - self.staticUserName.frame.size.width - 16, 55))
        self.phoneTextField.placeholder = "请输入手机号码"
        self.phoneTextField.delegate = self
        self.phoneTextField.keyboardType = .NumberPad
        self.registerView.addSubview(self.phoneTextField)
        
        self.betweenLine1 = UIImageView(frame: CGRectMake(self.staticUserName.frame.origin.x, 55, self.phoneTextField.frame.size.width, 1))
        self.betweenLine1.backgroundColor = shrbLightCell
        self.registerView.addSubview(self.betweenLine1)
        
        self.captchaLabel = UILabel(frame: CGRectMake(16,  55 + 17, 0, 21))
        self.captchaLabel.text = "验证码"
        self.captchaLabel.textColor = shrbPink
        self.captchaLabel.sizeToFit()
        self.registerView.addSubview(self.captchaLabel)
        
        self.captchaTextField = UITextField(frame: CGRectMake(self.phoneTextField.frame.origin.x, self.phoneTextField.frame.size.height, self.phoneTextField.frame.size.width - 100, self.phoneTextField.frame.size.height))
        self.captchaTextField.placeholder = "请输入短信验证码"
        self.captchaTextField.secureTextEntry = true
        self.captchaTextField.delegate = self
        self.captchaTextField.keyboardType = .NumberPad
        self.registerView.addSubview(self.captchaTextField)
        
        self.getCaptchaBtn = UIButton(type: .Custom)
        self.getCaptchaBtn.setTitle("获取验证码", forState: .Normal)
        self.getCaptchaBtn.setTitleColor(shrbPink, forState: .Normal)
        self.getCaptchaBtn.frame = CGRectMake(screenWidth-100, self.captchaTextField.frame.origin.y + 5 , 90, 45)
        self.getCaptchaBtn.addTarget(self, action: Selector("getCodeBtnPressed"), forControlEvents: UIControlEvents.TouchUpInside)
        self.registerView.addSubview(self.getCaptchaBtn)
        
        
        self.betweenLine2 = UIImageView(frame: CGRectMake(self.staticUserName.frame.origin.x, 110, self.phoneTextField.frame.size.width, 1))
        self.betweenLine2.backgroundColor = shrbLightCell
        self.registerView.addSubview(self.betweenLine2)
        
        
        self.newPasswordLabel = UILabel(frame: CGRectMake(16, 110 + 17, 0, 21))
        self.newPasswordLabel.text = "新密码"
        self.newPasswordLabel.textColor = shrbPink
        self.newPasswordLabel.sizeToFit()
        self.registerView.addSubview(self.newPasswordLabel)
        
        self.newPasswordTextField = UITextField(frame: CGRectMake(self.newPasswordLabel.frame.origin.x + self.newPasswordLabel.frame.size.width + 16, 110, screenWidth - 16 - self.newPasswordLabel.frame.size.width - 16, 55))
        self.newPasswordTextField.placeholder = "请输入新密码"
        self.newPasswordTextField.delegate = self
        self.registerView.addSubview(self.newPasswordTextField)

    }
    
    func creatSetPassBtn() {
        self.setPassBtn = UIButton(frame: CGRectMake(16, self.registerView.frame.origin.y + self.registerView.frame.size.height + 60, screenWidth - 32, 44))
        self.setPassBtn.backgroundColor = shrbPink
        self.setPassBtn.setTitle("重置密码", forState: .Normal)
        self.setPassBtn.layer.cornerRadius = 4
        self.setPassBtn.layer.masksToBounds = true
        self.setPassBtn.addTarget(self, action: Selector("setPassBtnPressed"), forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(self.setPassBtn)
        
    }
    func getCodeBtnPressed() {
        
        if self.phoneTextField.text!.isEmpty {
            SVProgressShow.showErrorWithStatus("请输入手机号")
            return
        }
        SVProgressShow.showWithStatus("发送中...")
        
        Alamofire.request(.GET, baseUrl + "/user/v1.0/getCode?", parameters:["phone":self.phoneTextField.text!])
            
            .response { request, response, data, error in
                
                if error == nil {
                    let json  = JSON(data: data!)
                    
                    if RequestDataTool.processingData(json) != nil {
                        
                        SVProgressShow.showSuccessWithStatus("验证码已发送!")
                        
                    }
                }
                else {
                    SVProgressShow.showErrorWithStatus("请求失败!")
                }
                
        }

        
    }
    
    func setPassBtnPressed() {
      
        SVProgressShow.showInfoWithStatus("忘记密码暂无相应接口")
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.phoneTextField.resignFirstResponder()
        self.captchaTextField.resignFirstResponder()
        self.newPasswordTextField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if (touches as NSSet).anyObject()?.view != self.phoneTextField || (touches as NSSet).anyObject()?.view != self.captchaTextField || (touches as NSSet).anyObject()?.view != self.newPasswordTextField {
            self.phoneTextField.resignFirstResponder()
            self.captchaTextField.resignFirstResponder()
            self.newPasswordTextField.resignFirstResponder()
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
