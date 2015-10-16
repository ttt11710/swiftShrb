//
//  RegisterViewController.swift
//  swiftShrb
//
//  Created by PayBay on 15/10/16.
//  Copyright © 2015年 PayBay. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class RegisterViewController: UIViewController,UITextFieldDelegate {

    
    var registerView : UIView!
    var staticUserName : UILabel!
    var phoneTextField : UITextField!
    var betweenLine : UIImageView!
    var passwordLabel : UILabel!
    var passwordTextField : UITextField!
    
    
    var captchaView : UIView!
    var captchaTextField : UITextField!
    var captchaBtn : UIButton!
    
    
    var agreeClauseView : TNCheckBoxGroup!
    var registerBtn : UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "注册"
        
        self.view.backgroundColor = shrbLightCell

        self.creatRegisterView()
        self.creatcaptchaView()
        self.creatRegisterBtnView()
        // Do any additional setup after loading the view.
    }

    func creatRegisterView() {
        
        self.registerView = UIView(frame: CGRectMake(0, 20 + 44 + 10, screenWidth, 110))
        self.registerView.backgroundColor = UIColor.whiteColor()
        self.view.addSubview(self.registerView)
        
        self.staticUserName = UILabel(frame: CGRectMake(16, 17, 0, 21))
        self.staticUserName.text = "用户名"
        self.staticUserName.textColor = shrbPink
        self.staticUserName.sizeToFit()
        self.registerView.addSubview(self.staticUserName)
        
        self.phoneTextField = UITextField(frame: CGRectMake(self.staticUserName.frame.origin.x + self.staticUserName.frame.size.width + 16, 0, screenWidth - 16 - self.staticUserName.frame.size.width - 16, 55))
        self.phoneTextField.placeholder = "请输入手机号码"
        self.phoneTextField.delegate = self
        self.phoneTextField.keyboardType = .NumberPad
        self.registerView.addSubview(self.phoneTextField)
        
        self.betweenLine = UIImageView(frame: CGRectMake(self.staticUserName.frame.origin.x, 55, self.phoneTextField.frame.size.width, 1))
        self.betweenLine.backgroundColor = shrbLightCell
        self.registerView.addSubview(self.betweenLine)
        
        self.passwordLabel = UILabel(frame: CGRectMake(16,  55 + 17, 0, 21))
        self.passwordLabel.text = "密码"
        self.passwordLabel.textColor = shrbPink
        self.passwordLabel.sizeToFit()
        self.registerView.addSubview(self.passwordLabel)
        
        self.passwordTextField = UITextField(frame: CGRectMake(self.phoneTextField.frame.origin.x, self.phoneTextField.frame.size.height, self.phoneTextField.frame.size.width, self.phoneTextField.frame.size.height))
        self.passwordTextField.placeholder = "请输入密码"
        self.passwordTextField.secureTextEntry = true
        self.passwordTextField.delegate = self
        self.registerView.addSubview(self.passwordTextField)
        
    }
    
    func creatcaptchaView() {
        
        self.captchaView = UIView(frame: CGRectMake(0, self.registerView.frame.origin.y + self.registerView.frame.size.height + 40, screenWidth, 55))
        self.captchaView.backgroundColor = UIColor.whiteColor()
        self.view.addSubview(self.captchaView)
        
        self.captchaTextField = UITextField(frame: CGRectMake(16, 0, screenWidth-110, 55))
        self.captchaTextField.placeholder = "请输入验证码"
        self.captchaTextField.delegate = self
        self.captchaTextField.keyboardType = .NumberPad
        self.captchaView.addSubview(self.captchaTextField)
        
        
        self.captchaBtn = UIButton(type: .Custom)
        self.captchaBtn.setTitle("获取验证码", forState: .Normal)
        self.captchaBtn.setTitleColor(shrbPink, forState: .Normal)
        self.captchaBtn.layer.cornerRadius = 4
        self.captchaBtn.layer.borderColor = shrbPink.CGColor
        self.captchaBtn.layer.borderWidth = 1
        self.captchaBtn.layer.masksToBounds = true
        self.captchaBtn.titleLabel?.font = font16
        self.captchaBtn.frame = CGRectMake(self.captchaTextField.frame.origin.x + self.captchaTextField.frame.size.width, 10, 90, 35)
        self.captchaBtn.addTarget(self, action: Selector("getCodeBtnPressed"), forControlEvents: UIControlEvents.TouchUpInside)
        self.captchaView.addSubview(self.captchaBtn)
        
    }
    
    
    func creatRegisterBtnView() {
        
        let agreeClauseBoxData = TNImageCheckBoxData()
        agreeClauseBoxData.identifier = "agreeClause"
        agreeClauseBoxData.labelText = "同意《通宝用户协议》"
        agreeClauseBoxData.checked = true
        agreeClauseBoxData.checkedImage = UIImage(named: "checked")
        agreeClauseBoxData.uncheckedImage = UIImage(named: "unchecked")
        
        self.agreeClauseView = TNCheckBoxGroup(frame: CGRectMake(16, self.captchaView.frame.origin.y + self.captchaView.frame.size.height + 58, screenWidth-32, 28))
        self.agreeClauseView.checkBoxData = [agreeClauseBoxData]
        self.agreeClauseView.layout = TNCheckBoxLayoutVertical
        self.agreeClauseView.labelColor = shrbPink
        self.agreeClauseView.myCreate()
        self.view.addSubview(self.agreeClauseView)
        
        self.registerBtn = UIButton(frame: CGRectMake(16, self.agreeClauseView.frame.origin.y + self.agreeClauseView.frame.size.height + 10, screenWidth - 32, 44))
        self.registerBtn.backgroundColor = shrbPink
        self.registerBtn.setTitle("注册", forState: .Normal)
        self.registerBtn.layer.cornerRadius = 4
        self.registerBtn.layer.masksToBounds = true
        self.registerBtn.addTarget(self, action: Selector("registerBtnPressed"), forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(self.registerBtn)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("agreeClauseViewChanged:"), name: GROUP_CHANGED, object: self.agreeClauseView)
        
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

    
    func registerBtnPressed() {
        
        if !PasswordDataProcessing.resultPasswordData(self.passwordTextField.text!) {
            SVProgressShow.showErrorWithStatus("密码中不可以输入空格")
            return
        }

        if self.phoneTextField.text!.isEmpty || self.passwordTextField.text!.isEmpty || self.captchaTextField.text!.isEmpty {
            SVProgressShow.showErrorWithStatus("请输入所有信息")
            return
        }
        SVProgressShow.showWithStatus("发送中...")
        
        Alamofire.request(.POST, baseUrl + "/user/v1.0/register?", parameters:["phone":self.phoneTextField.text!,"password":self.passwordTextField.text!,"code":self.captchaTextField.text!])
            
            .response { request, response, data, error in
                
                if error == nil {
                    let json  = JSON(data: data!)
                    
                    if RequestDataTool.processingData(json) != nil {
                        
                        SVProgressShow.showSuccessWithStatus("注册成功!")
                        
                        self.navigationController?.popViewControllerAnimated(true)
                        
                    }
                }
                else {
                    SVProgressShow.showErrorWithStatus("请求失败!")
                }
        }

    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.phoneTextField.resignFirstResponder()
        self.passwordTextField.resignFirstResponder()
        self.captchaTextField.resignFirstResponder()
        
        return true
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if (touches as NSSet).anyObject()?.view != self.phoneTextField || (touches as NSSet).anyObject()?.view != self.captchaTextField || (touches as NSSet).anyObject()?.view != self.passwordTextField {
            self.phoneTextField.resignFirstResponder()
            self.captchaTextField.resignFirstResponder()
            self.passwordTextField.resignFirstResponder()
        }
    }

    func agreeClauseViewChanged(notification : NSNotification) {
        print(self.agreeClauseView.checkedCheckBoxes)
        print(self.agreeClauseView.uncheckedCheckBoxes)
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
