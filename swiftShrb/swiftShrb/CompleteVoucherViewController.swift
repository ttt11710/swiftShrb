//
//  CompleteVoucherViewController.swift
//  swiftShrb
//
//  Created by PayBay on 15/10/15.
//  Copyright © 2015年 PayBay. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SDWebImage
import BFPaperButton

class CompleteVoucherViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    var merchId : String = ""
    var cardNo : String = ""
    
    
    var cardInfoModel : CardInfoModel!
    
    var tableView : UITableView!
    var completeBtn : BFPaperButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.requestData()
        self.creatTableView()
        self.creatCompleteBtn()
        
        // Do any additional setup after loading the view.
    }
    
    func requestData() {
    
        
        Alamofire.request(.GET, baseUrl + "/card/v1.0/findCardDetail?", parameters: ["userId":CurrentUser.user!.userId,"token":CurrentUser.user?.token == nil ? "" : CurrentUser.user!.token,"merchId":self.merchId,"cardNo":self.cardNo])
            
            .response { request, response, data, error in
                
                if error == nil {
                    let json  = JSON(data: data!)
                    
                    self.cardInfoModel = CardInfoModel(json: RequestDataTool.processingDataMes(json)["data"])
                    self.tableView.reloadData()
                    
                }
                
        }
    }
    
        
    func creatTableView() {
        
        self.automaticallyAdjustsScrollViewInsets = false
        
        self.tableView = UITableView(frame: CGRectMake(0, 20 + 44, screenWidth, screenHeight - 20-44 - 44))
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.tableView.tableFooterView = UIView()
        self.tableView.backgroundColor = shrbTableViewColor
        self.view.addSubview(self.tableView)
    }
    
    
    func creatCompleteBtn() {
        
        completeBtn = BFPaperButton()
        completeBtn.backgroundColor = shrbPink
        completeBtn.frame = CGRectMake(0, screenHeight-44, screenWidth, 44)
        completeBtn.setTitle("完成", forState: .Normal)
        completeBtn.titleFont = font18
        completeBtn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        completeBtn.addTarget(self, action: Selector("completeBtnPressed:"), forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(completeBtn)

        
    }

    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let height : CGFloat = 30
        let headerView = UIView(frame: CGRectMake(0, 0, self.tableView.bounds.size.width, height))
        headerView.backgroundColor = shrbLightCell
        
        let label = UILabel(frame: CGRectMake(16, (height-18)*0.5, self.tableView.bounds.size.width-10, 18))
        label.textColor = shrbText
        label.text = "30天内积分记录"
        label.backgroundColor = UIColor.clearColor()
        headerView.addSubview(label)
        
        return headerView
        
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 1 ? 30 : 0
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            tableView.registerNib(UINib(nibName: "CardDetailTableViewCell", bundle: nil), forCellReuseIdentifier: "CardDetailTableViewCellId")
            let cell = tableView.dequeueReusableCellWithIdentifier("CardDetailTableViewCellId", forIndexPath: indexPath) as! CardDetailTableViewCell
            
            cell.backgroundColor = shrbPink
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            
            if self.cardInfoModel != nil {
                
                cell.cardBackImageView.sd_setImageWithURL(self.cardInfoModel.cardImgUrl == nil ? nil : NSURL(string: self.cardInfoModel.cardImgUrl), placeholderImage: UIImage(named: "cardBack"))
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
        else  {
            
            tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cellId")
            let cell = tableView.dequeueReusableCellWithIdentifier("cellId", forIndexPath: indexPath) as UITableViewCell
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            
            cell.textLabel?.text = "充值交易100元"
            cell.textLabel?.textColor = shrbLightText
            cell.detailTextLabel?.text = "2015-5-20 PM15:47"
            cell.detailTextLabel?.textColor = shrbSectionColor
            cell.detailTextLabel?.font = font15
            
            return cell
            
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        if indexPath.section == 0 || indexPath.section == 2 {
            return screenWidth/170*90 + 60
        }
        else {
            return 44
        }
    }
    
    func completeBtnPressed(sender : UIButton) {
        
        let QRPay : String = NSUserDefaults.standardUserDefaults().stringForKey("QRPay")!
        if QRPay == "viewControllers[1]" {
            self.navigationController?.popToViewController(self.navigationController!.viewControllers[1], animated: true)
        }
        else if QRPay == "viewControllers[-4]" {
            self.navigationController?.popToViewController(self.navigationController!.viewControllers[(self.navigationController?.viewControllers.count)!-4], animated: true)
        }
        else if QRPay == "viewControllers[0]" {
            self.navigationController?.popToRootViewControllerAnimated(true)
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
