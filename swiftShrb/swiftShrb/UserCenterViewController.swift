//
//  UserCenterViewController.swift
//  swiftShrb
//
//  Created by PayBay on 15/9/29.
//  Copyright © 2015年 PayBay. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SDWebImage

class UserCenterViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    var tableView : UITableView!
    var dataDic : NSMutableDictionary = ["":"","":"",]
    
    
    var memberNumLabelText : String = ""
    var memberImageViewUrl : String = ""
    
    let dataArray1 : NSMutableArray = ["我的订单","我的收藏"]
    let dataArray2 : NSMutableArray = ["帮助中心","通宝客服","关于通宝"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.creatTableView()

        self.title = "我的"
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.hidden = false
        self.requestData()
    }

    func requestData() {
        
        Alamofire.request(.POST, baseUrl + "/user/v1.0/info?", parameters: ["token":CurrentUser.user?.token == nil ? "" : CurrentUser.user!.token,"userId":CurrentUser.user?.userId == nil ? "" : CurrentUser.user!.userId])
            
            .response { request, response, data, error in
                
                if error == nil {
                    let json  = JSON(data: data!)
                    if json["code"].stringValue == "200" {
                        // self.merchModel =  MerchModel.merchModel(json)
                    }
                    
                    switch json["code"].intValue
                    {
                    case 200:
                        self.memberImageViewUrl = CurrentUser.user!.imgUrl
                        self.memberNumLabelText = CurrentUser.user!.userId
                    case 404:
                        CurrentUser.user = nil
                    default:
                        break
                    }
                }
                self.tableView.reloadData()
        }
        
    }
    
    func creatTableView() {
        tableView = UITableView(frame: CGRectMake(0, 0, screenWidth, screenHeight))
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = shrbTableViewColor
        
        self.view.addSubview(tableView)
        
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return section == 1 ? 2:section == 2 ? 3:1
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        switch indexPath.section
        {
        case 0:
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
            cell.memberNumLabel.text = self.memberNumLabelText
            cell.memberImageView.sd_setImageWithURL(NSURL(string: self.memberImageViewUrl), placeholderImage:UIImage(named: "默认女头像"))
            return cell
         case 1:
            tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cellId")
            let cell = tableView.dequeueReusableCellWithIdentifier("cellId", forIndexPath: indexPath) as UITableViewCell
            
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            cell.accessoryType = .DisclosureIndicator
            
            cell.imageView?.image = UIImage(named: dataArray1[indexPath.row] as! String)
            cell.textLabel?.text = dataArray1[indexPath.row] as? String
            cell.textLabel?.textColor = shrbText
            
            return cell

        case 2:
            tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cellId")
            let cell = tableView.dequeueReusableCellWithIdentifier("cellId", forIndexPath: indexPath) as UITableViewCell
            
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            cell.accessoryType = .DisclosureIndicator
            
            cell.imageView?.image = UIImage(named: dataArray2[indexPath.row] as! String)
            cell.textLabel?.text = dataArray2[indexPath.row] as? String
            cell.textLabel?.textColor = shrbText
            
            return cell
            
        default :
            tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cellId")
            let cell = tableView.dequeueReusableCellWithIdentifier("cellId", forIndexPath: indexPath) as UITableViewCell
            
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            cell.accessoryType = .DisclosureIndicator
            
            cell.imageView?.image = UIImage(named:"设置")
            cell.textLabel?.text = "设置"
            cell.textLabel?.textColor = shrbText
            
            return cell
        }
        
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 8
    }
    
   func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
    let view : UIView = UIView(frame: CGRectMake(0, 0, screenWidth, 8))
    view.backgroundColor = shrbTableViewColor
    return view
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        switch indexPath.section
        {
        case 0:
            return 130
        default:
            return 44
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        switch indexPath.section {
        case 0:
            if CurrentUser.user == nil {
                let loginViewController = LoginViewController()
                loginViewController.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(loginViewController, animated: true)
            }
            else {
                let basicInfoViewController = BasicInfoViewController()
                basicInfoViewController.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(basicInfoViewController, animated: true)
            }
        case 1:
            switch indexPath.row {
            case 0:
                let orderTabBarController = OrderTabBarController()
                orderTabBarController.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(orderTabBarController, animated: true)
            case 1:
                let collectViewController = CollectViewController()
                collectViewController.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(collectViewController, animated: true)
            default:
                break
            }
            
        case 2:
            switch indexPath.row {
            case 0:
                let helpCenterViewController = HelpCenterViewController()
                helpCenterViewController.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(helpCenterViewController, animated: true)
            case 1:
                let tBServiceViewController = TBServiceViewController()
                tBServiceViewController.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(tBServiceViewController, animated: true)
            case 2:
                let aboutTBViewController = AboutTBViewController()
                aboutTBViewController.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(aboutTBViewController, animated: true)
            default:
                break
            }
        case 3:
            let settingViewController = SettingViewController()
            settingViewController.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(settingViewController, animated: true)
        default:
            break
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
