//
//  VoucherCenterViewController.swift
//  swiftShrb
//
//  Created by PayBay on 15/10/21.
//  Copyright © 2015年 PayBay. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SDWebImage

class VoucherCenterViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {

    var cardNo : String = ""
    var amount : Float = 0.0
    var score : Float = 0.0
    var merchId : String = ""
    var cardImgUrl : String = ""
    
    var cardInfoModel : CardInfoModel!
    
    var tableView : UITableView!
    
    var json : JSON!
    var voucherAmount : Float! = 0.00
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "充值中心"
        
        self.view.backgroundColor = shrbLightCell
        self.creatTableView()
        self.requestData()
        
        // Do any additional setup after loading the view.
    }

    func creatTableView() {
        
        tableView = UITableView(frame: CGRectMake(0, 0, screenWidth, screenHeight))
        tableView.backgroundColor = shrbTableViewColor
        tableView.delegate = self
        tableView.dataSource = self
        self.view.addSubview(tableView)
        
    }

    
    
    func requestData() {
        
        //http://121.40.222.162:8080/tongbao/card/v1.0/findCardRechargeTypeList?&token=0b812b7bfbc62114590c56f5dd14b822&userId=1440743804888668829
        SVProgressShow.showWithStatus("加载中...")
        Alamofire.request(.GET, baseUrl + "/card/v1.0/findCardRechargeTypeList?", parameters: ["token":CurrentUser.user?.token == nil ? "" : CurrentUser.user!.token,"userId":CurrentUser.user?.userId == nil ? "" : CurrentUser.user!.userId])
            
            .response { request, response, data, error in
                
                if error == nil {
                    self.json  = JSON(data: data!)
                    
                }
                else {
                    SVProgressShow.showErrorWithStatus("请求失败!")
                }
                SVProgressShow.dismiss()
                self.tableView.reloadData()
                
        }
        
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.json != nil {
            return self.json["data"].count + 3
        }
        else {
           return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            tableView.registerNib(UINib(nibName: "CardDetailTableViewCell", bundle: nil), forCellReuseIdentifier: "CardDetailTableViewCellId")
            let cell = tableView.dequeueReusableCellWithIdentifier("CardDetailTableViewCellId", forIndexPath: indexPath) as! CardDetailTableViewCell
            
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            
            cell.backgroundColor = shrbTableViewColor
            if self.cardInfoModel != nil {
                cell.cardBackImageView.sd_setImageWithURL(NSURL(string: self.cardInfoModel.cardImgUrl as String), placeholderImage: UIImage(named: "cardBack"))
                cell.merchNameLabel.text = self.cardInfoModel.merchName
                let string : String = String(format: "金额:￥%.2f", self.cardInfoModel.amount)
                let attrString : NSMutableAttributedString = NSMutableAttributedString(string: string)
                
                attrString.addAttribute(NSForegroundColorAttributeName, value:UIColor(red: 255.0/255.0, green: 212.0/255.0, blue: 0.0/255.0, alpha: 1), range: NSMakeRange(3, string.characters.count-3))
                
                attrString.addAttribute(NSFontAttributeName, value: UIFont.systemFontOfSize(18), range: NSMakeRange(0, 3))
                attrString.addAttribute(NSFontAttributeName, value: UIFont.systemFontOfSize(24), range: NSMakeRange(3, string.characters.count-3))
                cell.amountLabel.attributedText = attrString
                
                
                
                let integralString : String = String(format: "积分:%.0f", self.cardInfoModel.score)
                let integralAttrString : NSMutableAttributedString = NSMutableAttributedString(string: integralString)
                
                integralAttrString.addAttribute(NSForegroundColorAttributeName, value:UIColor(red: 255.0/255.0, green: 212.0/255.0, blue: 0.0/255.0, alpha: 1), range: NSMakeRange(3, integralString.characters.count-3))
                
                integralAttrString.addAttribute(NSFontAttributeName, value: UIFont.systemFontOfSize(18), range: NSMakeRange(0, 3))
                integralAttrString.addAttribute(NSFontAttributeName, value: UIFont.systemFontOfSize(24), range: NSMakeRange(3, integralString.characters.count-3))
                cell.scoreLabel.attributedText = integralAttrString
                
                cell.cardNoLabel.text = String(format: "卡号:%@", self.cardInfoModel.cardNo)
            }
            return cell
        }
        else if indexPath.row == 1{
            tableView.registerNib(UINib(nibName: "VoucherAmoutTableViewCell", bundle: nil), forCellReuseIdentifier: "VoucherAmoutTableViewCellId")
            let cell = tableView.dequeueReusableCellWithIdentifier("VoucherAmoutTableViewCellId", forIndexPath: indexPath) as! VoucherAmoutTableViewCell
            
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            
            return cell
        }
        else if indexPath.row == (self.json["data"].count + 2) {
            tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cellId")
            let cell = tableView.dequeueReusableCellWithIdentifier("cellId", forIndexPath: indexPath) as UITableViewCell
            
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            
            cell.backgroundColor = shrbTableViewColor
            
            let button : UIButton = UIButton(type: .Custom)
            button.frame = CGRectMake(16, 30, screenWidth-32, 44)
            button.setTitle("充值", forState: .Normal)
            button.setTitleColor(UIColor.whiteColor(), forState: .Normal)
            button.titleLabel?.font = font18
            button.backgroundColor = shrbPink
            button.layer.cornerRadius = 4
            button.layer.masksToBounds = true
            button.addTarget(self, action: Selector("cardRecharge"), forControlEvents: UIControlEvents.TouchUpInside)
            cell.contentView.addSubview(button)
            
            return cell
        }
        else {
            tableView.registerNib(UINib(nibName: "ChanrgeTypeTableViewCell", bundle: nil), forCellReuseIdentifier: "ChanrgeTypeTableViewCellId")
            let cell = tableView.dequeueReusableCellWithIdentifier("ChanrgeTypeTableViewCellId", forIndexPath: indexPath) as! ChanrgeTypeTableViewCell
            
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            
            if self.json != nil {
                cell.chanrgeTypNameLabel.text = self.json["data"][indexPath.row-2]["chanrgeTypName"].stringValue
                cell.tag = indexPath.row - 2
                if cell.tag == 0 {
                    cell.chanrgeTypBtn.selected = true
                }

            }
            
            return cell

        }
        
        //VoucherAmoutTableViewCellId
        
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.row == 0 || indexPath.row == self.json["data"].count+2 {
            return screenWidth/170*90 + 50
        }
        else {
            return 56
        }
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        for indexPath in self.tableView.indexPathsForVisibleRows! {
            if indexPath.row == 1 {
                let cell : VoucherAmoutTableViewCell = self.tableView.cellForRowAtIndexPath(indexPath) as! VoucherAmoutTableViewCell
                cell.amountTextField.resignFirstResponder()
            }
        }
        if indexPath.row >= 2 && indexPath.row < (self.json["data"].count + 2) {
            for indexPath in self.tableView.indexPathsForVisibleRows! {
                if indexPath.row >= 2 && indexPath.row < (self.json["data"].count + 2) {
                    let cell : ChanrgeTypeTableViewCell = self.tableView.cellForRowAtIndexPath(indexPath) as! ChanrgeTypeTableViewCell
                    cell.chanrgeTypBtn.selected = false
                }
            }
            let cell : ChanrgeTypeTableViewCell = self.tableView.cellForRowAtIndexPath(indexPath) as! ChanrgeTypeTableViewCell
            cell.chanrgeTypBtn.selected = true
            
        }
    }
    
    func cardRecharge() {
    
        for indexPath in self.tableView.indexPathsForVisibleRows! {
            if indexPath.row == 1 {
                let cell : VoucherAmoutTableViewCell = self.tableView.cellForRowAtIndexPath(indexPath) as! VoucherAmoutTableViewCell
                if cell.amountTextField.text?.characters.count == 0 {
                    SVProgressShow.showInfoWithStatus("请输入充值金额!")
                    return
                }
                self.voucherAmount = Float(cell.amountTextField.text!)!
            }
        }
        
        SVProgressShow.showWithStatus("充值处理中...")
        
        Alamofire.request(.POST, baseUrl + "/card/v1.0/cardMemberRecharge?", parameters: ["token":CurrentUser.user?.token == nil ? "" : CurrentUser.user!.token,"userId":CurrentUser.user?.userId == nil ? "" : CurrentUser.user!.userId,"amount":self.voucherAmount,"cardNo":self.cardInfoModel.cardNo,"chanrgeTypeId":"1"])
            
            .response { request, response, data, error in
                
                if error == nil {
                    let json  = JSON(data: data!)
                    if RequestDataTool.processingDataMes(json) != nil {
                        SVProgressShow.showSuccessWithStatus("充值成功!")
                        self.cardInfoModel.amount = self.voucherAmount + self.cardInfoModel.amount
                        self.tableView.reloadData()
                        
                        let completeVoucherViewController = CompleteVoucherViewController()
                        completeVoucherViewController.merchId = self.merchId
                        completeVoucherViewController.cardNo = self.cardInfoModel.cardNo
                        completeVoucherViewController.title = "充值成功"
                        self.navigationController?.pushViewController(completeVoucherViewController, animated: true)
                        
                    }
                    
//                    if json["code"].stringValue == "200" {
//                        SVProgressShow.showSuccessWithStatus("充值成功!")
//                    }
                }
               // SVProgressShow.dismiss()
        }
    }
    
    //    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        
//        SVProgressShow.showWithStatus("进入卡片...")
//        
//        let delayInSeconds : Double = 1.0
//        let popTime : dispatch_time_t = dispatch_time(DISPATCH_TIME_NOW, Int64(delayInSeconds * Double(NSEC_PER_SEC)))
//        dispatch_after(popTime, dispatch_get_main_queue(), { () -> Void in
//            
//            let cardDetailViewController = CardDetailViewController()
//            cardDetailViewController.merchId = self.cardInfoModel[indexPath.row].merchId
//            cardDetailViewController.cardNo = self.cardInfoModel[indexPath.row].cardNo
//            self.navigationController?.pushViewController(cardDetailViewController, animated: true)
//            SVProgressShow.dismiss()
//        })
//    }
//
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
