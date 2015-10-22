//
//  BasicInfoViewController.swift
//  swiftShrb
//
//  Created by PayBay on 15/10/20.
//  Copyright © 2015年 PayBay. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SDWebImage

class BasicInfoViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    var tableView : UITableView!
    
    var userInfoModel : UserInfoModel!
    
    let dataArray1 : NSMutableArray = ["账号","","邮箱"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.title = "基本信息"
        self.creatTableView()
        self.requestData()
        
        // Do any additional setup after loading the view.
    }

    func requestData() {
        
        Alamofire.request(.POST, baseUrl + "/user/v1.0/info?", parameters: ["token":CurrentUser.user?.token == nil ? "" : CurrentUser.user!.token,"userId":CurrentUser.user?.userId == nil ? "" : CurrentUser.user!.userId])
            
            .response { request, response, data, error in
                
                if error == nil {
                    let json  = JSON(data: data!)
                    self.userInfoModel = UserInfoModel(json:json["user"])
                    
                }
                self.tableView.reloadData()
        }
        
    }
    
    func creatTableView() {
        tableView = UITableView(frame: CGRectMake(0, 0, screenWidth, screenHeight))
        tableView.tableFooterView = UIView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = shrbTableViewColor
        
        self.view.addSubview(tableView)
        
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 4
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return indexPath.row == 0 ? 128 : 44
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            
            tableView.registerNib(UINib(nibName: "UserCenterHeadPortraitTableViewCell", bundle: nil), forCellReuseIdentifier: "UserCenterHeadPortraitTableViewCellId")
            let cell = tableView.dequeueReusableCellWithIdentifier("UserCenterHeadPortraitTableViewCellId", forIndexPath: indexPath) as! UserCenterHeadPortraitTableViewCell
            
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            if CurrentUser.user == nil
            {
                cell.memberNumLabel.hidden = true
                cell.loginBtn.hidden = false
            }
            else {
                cell.memberNumLabel.hidden = false
                cell.loginBtn.hidden = true
            }
            cell.memberNumLabel.hidden = true
            cell.memberImageView.sd_setImageWithURL(NSURL(string: ""), placeholderImage:UIImage(named: "默认女头像"))
            return cell
        }
        else if indexPath.row == 1 || indexPath.row == 3{
            tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cellId")
            let cell : UITableViewCell = UITableViewCell(style: .Value1, reuseIdentifier: "cellId")
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            
            
            cell.textLabel?.text = dataArray1[indexPath.row-1] as? String
            cell.textLabel?.textColor = shrbText
            cell.textLabel?.font = font15
            
            if self.userInfoModel != nil {
                switch indexPath.row {
                case 1:
                    cell.detailTextLabel?.text = self.userInfoModel.phone
                default:
                    cell.detailTextLabel?.text = self.userInfoModel.email.isEmpty ? "未填写" : self.userInfoModel.email
                }
            }
            cell.detailTextLabel?.textColor = shrbLightText
            cell.detailTextLabel?.font = font15
            return cell
        }
        else {
            
            tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cellId")
            let cell = tableView.dequeueReusableCellWithIdentifier("cellId", forIndexPath: indexPath) as UITableViewCell
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            
            cell.textLabel?.text = "密码"
            cell.textLabel?.textColor = shrbText
            
            let textField = UITextField(frame:CGRectMake(screenWidth-250, 11, 234, 21))
            if self.userInfoModel != nil {
                textField.text = self.userInfoModel.password
            }
            textField.userInteractionEnabled = false
            textField.textAlignment = .Right
            textField.textColor = shrbLightText
            textField.font = font15
            textField.secureTextEntry = true
            cell.addSubview(textField)
            return cell
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
