//
//  UpdatePayPassViewController.swift
//  swiftShrb
//
//  Created by PayBay on 15/10/16.
//  Copyright © 2015年 PayBay. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class UpdatePayPassViewController: UIViewController,UITextFieldDelegate {

    
    var updatePayPassView : UIView!
    var oldPasswordLabel : UILabel!
    var oldPasswordTextField : UITextField!
    var betweenLine : UIImageView!
    var newPasswordLabel : UILabel!
    var newPasswordTextField : UITextField!
    
    var updatePayPasswordBtn : UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "重置支付密码"
        self.view.backgroundColor = shrbTableViewColor
        
        self.setPayPass()
        self.creatRegisterView()
        self.creatUpdatePayPasswordBtn()
        // Do any additional setup after loading the view.
    }

    func creatRegisterView() {
        
        self.updatePayPassView = UIView(frame: CGRectMake(0, 20 + 44 + 10, screenWidth, 110))
        self.updatePayPassView.backgroundColor = UIColor.whiteColor()
        self.view.addSubview(self.updatePayPassView)
        
        self.oldPasswordLabel = UILabel(frame: CGRectMake(16, 17, 0, 21))
        self.oldPasswordLabel.text = "旧密码"
        self.oldPasswordLabel.textColor = shrbPink
        self.oldPasswordLabel.sizeToFit()
        self.updatePayPassView.addSubview(self.oldPasswordLabel)
        
        self.oldPasswordTextField = UITextField(frame: CGRectMake(self.oldPasswordLabel.frame.origin.x + self.oldPasswordLabel.frame.size.width + 16, 0, screenWidth - 16 - self.oldPasswordLabel.frame.size.width - 16, 55))
        self.oldPasswordTextField.placeholder = "请输入原始密码"
        self.oldPasswordTextField.delegate = self
        self.oldPasswordTextField.secureTextEntry = true
        self.updatePayPassView.addSubview(self.oldPasswordTextField)
        
        self.betweenLine = UIImageView(frame: CGRectMake(self.oldPasswordLabel.frame.origin.x, 55, self.oldPasswordTextField.frame.size.width, 1))
        self.betweenLine.backgroundColor = shrbLightCell
        self.updatePayPassView.addSubview(self.betweenLine)
        
        self.newPasswordLabel = UILabel(frame: CGRectMake(16,  55 + 17, 0, 21))
        self.newPasswordLabel.text = "新密码"
        self.newPasswordLabel.textColor = shrbPink
        self.newPasswordLabel.sizeToFit()
        self.updatePayPassView.addSubview(self.newPasswordLabel)
        
        self.newPasswordTextField = UITextField(frame: CGRectMake(self.oldPasswordTextField.frame.origin.x, self.oldPasswordTextField.frame.size.height, self.oldPasswordTextField.frame.size.width, self.oldPasswordTextField.frame.size.height))
        self.newPasswordTextField.placeholder = "请输入新密码"
        self.newPasswordTextField.secureTextEntry = true
        self.newPasswordTextField.delegate = self
        self.updatePayPassView.addSubview(self.newPasswordTextField)
        
        let lable = UILabel(frame: CGRectMake(32, self.updatePayPassView.frame.origin.y + self.updatePayPassView.frame.size.height + 30, screenWidth-64, 30))
        lable.text = "由于设置支付密码流程暂未确定，目前测试用户支付密码自动设置为111111,即使更改过重新进入此页面也会自动还原为111111"
        lable.font = font15
        lable.textColor = shrbPink
        lable.numberOfLines = 0
        lable.sizeToFit()
        self.view.addSubview(lable)
        
    }
    
    func creatUpdatePayPasswordBtn() {
        self.updatePayPasswordBtn = UIButton(frame: CGRectMake(16, screenHeight - 100, screenWidth - 32, 44))
        self.updatePayPasswordBtn.backgroundColor = shrbPink
        self.updatePayPasswordBtn.setTitle("重置密码", forState: .Normal)
        self.updatePayPasswordBtn.layer.cornerRadius = 4
        self.updatePayPasswordBtn.layer.masksToBounds = true
        self.updatePayPasswordBtn.addTarget(self, action: Selector("updatePayPassBtnPressed"), forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(self.updatePayPasswordBtn)
        
    }
    
    func setPayPass() {
        
        Alamofire.request(.POST, baseUrl + "/user/v1.0/setPayPass?", parameters:["token":CurrentUser.user?.token == nil ? "" : CurrentUser.user!.token,"userId":CurrentUser.user?.userId == nil ? "" : CurrentUser.user!.userId,"payPass":"111111"])
        
    }
    
    func updatePayPassBtnPressed() {
        
        if !PasswordDataProcessing.resultPasswordData(self.newPasswordTextField.text!) {
            SVProgressShow.showErrorWithStatus("密码中不可以输入空格")
            return
        }

        
        if self.oldPasswordTextField.text?.characters.count == 0 || self.newPasswordTextField.text?.characters.count == 0 {
            SVProgressShow.showInfoWithStatus("信息不完整")
            return
        }
        
        if self.oldPasswordTextField.text == self.newPasswordTextField.text {
            SVProgressShow.showInfoWithStatus("新密码与旧密码不能相同!")
            return
        }
        
        Alamofire.request(.POST, baseUrl + "/user/v1.0/updatePayPass?", parameters:["token":CurrentUser.user?.token == nil ? "" : CurrentUser.user!.token,"userId":CurrentUser.user?.userId == nil ? "" : CurrentUser.user!.userId,"oldPass":self.oldPasswordTextField.text!,"newPass":self.newPasswordTextField.text!])
            .response { request, response, data, error in
                
                if error == nil {
                    let json  = JSON(data: data!)
                    
                    if RequestDataTool.processingData(json) != nil {
                        SVProgressShow.showSuccessWithStatus("支付密码重置成功!")
                        self.navigationController?.popViewControllerAnimated(true)
                    }
                }
        }
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        if (touches as NSSet).anyObject()?.view != self.oldPasswordTextField && (touches as NSSet).anyObject()?.view != self.newPasswordTextField
        {
            self.oldPasswordTextField.resignFirstResponder()
            self.newPasswordTextField.resignFirstResponder()
        }
        
    }

    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.oldPasswordTextField.resignFirstResponder()
        self.newPasswordTextField.resignFirstResponder()
        return true
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
