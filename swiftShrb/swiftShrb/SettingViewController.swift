//
//  SettingViewController.swift
//  swiftShrb
//
//  Created by PayBay on 15/10/16.
//  Copyright © 2015年 PayBay. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class SettingViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    var tableView : UITableView!
    
    let dataArray1 : NSMutableArray = ["重置支付密码","重置登录密码"]
    let dataArray2 : NSMutableArray = ["接收热点消息推送","优惠活动促销","系统通知","单笔最高消费"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "设置"
        self.creatTableView()
        // Do any additional setup after loading the view.
    }
    
    func creatTableView() {
        self.tableView = UITableView(frame: CGRectMake(0, 0, screenWidth, screenHeight))
        self.tableView.backgroundColor = shrbTableViewColor
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.view.addSubview(self.tableView)
        
    }

    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 8
    }
    
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view : UIView = UIView(frame: CGRectMake(0, 0, screenWidth, 8))
        view.backgroundColor = shrbTableViewColor
        return view
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return section == 0 ? 2:section == 1 ? 4:1
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        switch indexPath.section
        {
        case 0:
            tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cellId")
            let cell = tableView.dequeueReusableCellWithIdentifier("cellId", forIndexPath: indexPath) as UITableViewCell
            
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            cell.accessoryType = .DisclosureIndicator
            
            cell.textLabel?.text = dataArray1[indexPath.row] as? String
            cell.textLabel?.textColor = shrbText
            
            return cell
        case 1:
            tableView.registerNib(UINib(nibName: "SettingTableViewCell", bundle: nil), forCellReuseIdentifier: "SettingTableViewCellId")
            let cell = tableView.dequeueReusableCellWithIdentifier("SettingTableViewCellId", forIndexPath: indexPath) as! SettingTableViewCell
            
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            
            cell.label.text = dataArray2[indexPath.row] as? String
            cell.label.textColor = shrbText
            

            return cell
        
        default :
            tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cellId")
            let cell = tableView.dequeueReusableCellWithIdentifier("cellId", forIndexPath: indexPath) as UITableViewCell
            
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            cell.textLabel?.text = "注销"
            cell.textLabel?.textColor = shrbText
            
            return cell
        }
        
    }

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        return 44
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0:
                self.navigationController?.pushViewController(UpdatePayPassViewController(), animated: true)
            case 1:
                self.navigationController?.pushViewController(UpdatePassViewController(), animated: true)
            default:
                break
            }
            
        case 2:
            Alamofire.request(.POST, baseUrl + "/user/v1.0/logout?", parameters: ["token":CurrentUser.user?.token == nil ? "" : CurrentUser.user!.token,"userId":CurrentUser.user?.userId == nil ? "" : CurrentUser.user!.userId])
                
                .response { request, response, data, error in
                    
                    if error == nil {
                        let json  = JSON(data: data!)
                        
                        if RequestDataTool.processingData(json) != nil {
                            CurrentUser.user = nil
                            SVProgressShow.showSuccessWithStatus("注销成功")
                            self.navigationController?.popViewControllerAnimated(true)
                            
                        }
                        
                    }
            }
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
