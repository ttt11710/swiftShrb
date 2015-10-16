//
//  LoginViewController.swift
//  swiftShrb
//
//  Created by PayBay on 15/10/15.
//  Copyright © 2015年 PayBay. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class LoginViewController: UIViewController,UITextFieldDelegate {
    

    var paybayLogoImageView : UIImageView!
    
    var registerView : UIView!
    var staticUserName : UILabel!
    var phoneTextField : UITextField!
    var betweenLine : UIImageView!
    var passwordLabel : UILabel!
    var passwordTextField : UITextField!
    
    var loginBtn : UIButton!
    
    var forgetPasswordBtn : UIButton!
    var belowLine : UIImageView!
    
    var hintLabel : UILabel!
    var registerBtn : UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "登录"
        
        self.view.backgroundColor = shrbLightCell

        self.creatPaybayLogo()
        self.creatRegisterView()
        self.creatLogin()
        
        // Do any additional setup after loading the view.
    }
    
    func creatPaybayLogo() {
        self.paybayLogoImageView = UIImageView(frame: CGRectMake((screenWidth - 75)/2, 27 + 20 + 44 , 75, 75))
        self.paybayLogoImageView.image = UIImage(named: "paybayLogo")
        self.view.addSubview(self.paybayLogoImageView)
    }
    
    func creatRegisterView() {
        
        self.registerView = UIView(frame: CGRectMake(0, 20 + 44 + 130, screenWidth, 110))
        self.registerView.backgroundColor = UIColor.whiteColor()
        self.view.addSubview(self.registerView)
        
        self.staticUserName = UILabel(frame: CGRectMake(16, 17, 0, 21))
        self.staticUserName.text = "用户名"
        self.staticUserName.textColor = shrbPink
        self.staticUserName.sizeToFit()
        self.registerView.addSubview(self.staticUserName)
        
        self.phoneTextField = UITextField(frame: CGRectMake(self.staticUserName.frame.origin.x + self.staticUserName.frame.size.width + 16, 0, screenWidth - 16 - self.staticUserName.frame.size.width - 16, 55))
        self.phoneTextField.placeholder = "请输入手机号码"
        self.phoneTextField.keyboardType = .NumberPad
        self.phoneTextField.delegate = self
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
    
    func creatLogin() {
        self.loginBtn = UIButton(frame: CGRectMake(16, self.registerView.frame.origin.y + self.registerView.frame.size.height + 60, screenWidth - 32, 44))
        self.loginBtn.backgroundColor = shrbPink
        self.loginBtn.setTitle("登录", forState: .Normal)
        self.loginBtn.layer.cornerRadius = 4
        self.loginBtn.layer.masksToBounds = true
        self.loginBtn.addTarget(self, action: Selector("loginInBtnPressed"), forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(self.loginBtn)
        
        self.forgetPasswordBtn = UIButton(frame: CGRectMake(screenWidth - 100, self.loginBtn.frame.origin.y + self.loginBtn.frame.size.height + 8, 0, 21))
        self.forgetPasswordBtn.setTitle("忘记密码?", forState: .Normal)
        self.forgetPasswordBtn.setTitleColor(shrbPink, forState: .Normal)
        self.forgetPasswordBtn.titleLabel?.font = font17
        self.forgetPasswordBtn.backgroundColor = UIColor.clearColor()
        self.forgetPasswordBtn.sizeToFit()
        self.forgetPasswordBtn.addTarget(self, action: Selector("forgetPassword"), forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(self.forgetPasswordBtn)
        
        self.belowLine = UIImageView(frame: CGRectMake(self.forgetPasswordBtn.frame.origin.x, self.forgetPasswordBtn.frame.origin.y + self.forgetPasswordBtn.frame.size.height - 5, self.forgetPasswordBtn.frame.size.width, 1))
        self.belowLine.backgroundColor = shrbLightText
        self.view.addSubview(self.belowLine)
        
        
        self.hintLabel = UILabel()
        self.hintLabel.center = CGPointMake(screenWidth/2 - 100, self.loginBtn.frame.origin.y + self.loginBtn.frame.size.height + 50)
        self.hintLabel.text = "还没有账号?"
        self.hintLabel.textColor = shrbText
        self.hintLabel.sizeToFit()
        self.view.addSubview(self.hintLabel)
        
        self.registerBtn = UIButton(frame: CGRectMake(0, 0, 0, self.hintLabel.frame.size.height))
        self.registerBtn.center = CGPointMake(self.hintLabel.center.x + 50, self.hintLabel.center.y-6)
        self.registerBtn.setTitle("注册", forState: .Normal)
        self.registerBtn.setTitleColor(shrbPink, forState: .Normal)
        self.registerBtn.sizeToFit()
        self.registerBtn.addTarget(self, action: Selector("registerBtnPressed"), forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(self.registerBtn)
        
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        if isIphone4s {
            
            UIView.animateWithDuration(0.2, delay: 0, options: UIViewAnimationOptions.CurveEaseIn, animations: { () -> Void in
                
                self.view.layer.transform = CATransform3DMakeTranslation(0, -100, 0)
                }, completion: { (finished : Bool) -> Void in
                    
            })
        }
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        
        if isIphone4s {
            UIView.animateWithDuration(0.25, delay: 0, options: UIViewAnimationOptions.CurveEaseIn, animations: { () -> Void in
                self.view.layer.transform = CATransform3DIdentity
                }, completion: { (finished : Bool) -> Void in
                    
            })
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.phoneTextField.resignFirstResponder()
        self.passwordTextField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if (touches as NSSet).anyObject()?.view == self.passwordTextField  {
            
            self.passwordTextField.secureTextEntry = false
        }
        
        if (touches as NSSet).anyObject()?.view != self.passwordTextField && (touches as NSSet).anyObject()?.view != self.phoneTextField
        {
            self.phoneTextField.resignFirstResponder()
            self.passwordTextField.resignFirstResponder()
        }

    }
    
    
    func loginInBtnPressed() {
        
        if self.phoneTextField.text?.characters.count <= 0 || self.passwordTextField.text?.characters.count <= 0 {
            SVProgressShow.showInfoWithStatus("信息输入不完整")
            return
        }
        
        self.phoneTextField.resignFirstResponder()
        self.passwordTextField.resignFirstResponder()
        
        SVProgressShow.showWithStatus("正在登录...")
        
        Alamofire.request(.POST, baseUrl + "/user/v1.0/login?", parameters:["phone":self.phoneTextField.text!,"password":self.passwordTextField.text!])
            
            .response { request, response, data, error in
                
                if error == nil {
                    let json  = JSON(data: data!)
                    
                    if RequestDataTool.processingData(json) != nil {
                        CurrentUser.user = TBUser(json: RequestDataTool.processingData(json))
                        
                        SVProgressShow.showSuccessWithStatus("登录成功")
                        self.navigationController?.navigationBarHidden = false
                        self.navigationController?.popViewControllerAnimated(true)
                    }
                    
                }
                else {
                    SVProgressShow.showErrorWithStatus("请求失败!")
                }
                
        }

        
    }
    
    func forgetPassword() {
        self.navigationController?.pushViewController(ForgetPasswordViewController(), animated: true)
    }
    
    func registerBtnPressed() {
        self.navigationController?.pushViewController(RegisterViewController(), animated: true)
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
