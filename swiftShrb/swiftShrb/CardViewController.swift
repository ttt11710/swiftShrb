//
//  CardViewController.swift
//  swiftShrb
//
//  Created by PayBay on 15/10/19.
//  Copyright © 2015年 PayBay. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SDWebImage

class CardViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    var tableView : UITableView!
    
    var cardInfoModel : [CardInfoModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "会员卡"
        self.creatTableView()
        self.requestData()
        
        // Do any additional setup after loading the view.
    }
    
    func creatTableView() {
       
        tableView = UITableView(frame: CGRectMake(0, 0, screenWidth, screenHeight))
        tableView.separatorStyle = .None
        tableView.backgroundColor = shrbTableViewColor
        tableView.delegate = self
        tableView.dataSource = self
        self.view.addSubview(tableView)
        
    }
    
    func requestData() {
        
        if CurrentUser.user == nil {
            SVProgressShow.showInfoWithStatus("请先登录!")
            
            let delayInSeconds : Double = 1
            let popTime : dispatch_time_t = dispatch_time(DISPATCH_TIME_NOW, Int64(delayInSeconds * Double(NSEC_PER_SEC)))
            dispatch_after(popTime, dispatch_get_main_queue(), { () -> Void in
                SVProgressShow.dismiss()
                self.navigationController?.popViewControllerAnimated(true)
            })
            return
        }
        
        SVProgressShow.showWithStatus("加载中...")
        Alamofire.request(.GET, baseUrl + "/card/v1.0/findCardList?", parameters: ["token":CurrentUser.user?.token == nil ? "" : CurrentUser.user!.token,"userId":CurrentUser.user?.userId == nil ? "" : CurrentUser.user!.userId])
            
            .response { request, response, data, error in
                
                if error == nil {
                    let json  = JSON(data: data!)
                    
                    self.cardInfoModel = CardInfoModel.cardInfoModel(RequestDataTool.processingDataMes(json))
                }
                else {
                    SVProgressShow.showErrorWithStatus("请求失败!")
                }
                SVProgressShow.dismiss()
                self.tableView.reloadData()
                
        }
        
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.cardInfoModel.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        tableView.registerNib(UINib(nibName: "CardDetailTableViewCell", bundle: nil), forCellReuseIdentifier: "CardDetailTableViewCellId")
        let cell = tableView.dequeueReusableCellWithIdentifier("CardDetailTableViewCellId", forIndexPath: indexPath) as! CardDetailTableViewCell
        
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        
        cell.backgroundColor = shrbTableViewColor
        if self.cardInfoModel.count != 0 {
            cell.cardBackImageView.sd_setImageWithURL(self.cardInfoModel[indexPath.row].cardImgUrl == nil ? nil : NSURL(string: self.cardInfoModel[indexPath.row].cardImgUrl), placeholderImage: UIImage(named: "cardBack"))
            cell.merchNameLabel.text = self.cardInfoModel[indexPath.row].merchName
           
            //cell.amountLabel.text = String(format: "金额:￥%.2f", self.cardInfoModel[indexPath.row].amount)
            
            let string : String = String(format: "金额:￥%.2f", self.cardInfoModel[indexPath.row].amount)
            let attrString : NSMutableAttributedString = NSMutableAttributedString(string: string)
            
            attrString.addAttribute(NSForegroundColorAttributeName, value:UIColor(red: 255.0/255.0, green: 212.0/255.0, blue: 0.0/255.0, alpha: 1), range: NSMakeRange(3, string.characters.count-3))
            
            attrString.addAttribute(NSFontAttributeName, value: UIFont.systemFontOfSize(18), range: NSMakeRange(0, 3))
            attrString.addAttribute(NSFontAttributeName, value: UIFont.systemFontOfSize(24), range: NSMakeRange(3, string.characters.count-3))
            cell.amountLabel.attributedText = attrString
            
            
            
            let integralString : String = String(format: "积分:%.0f", self.cardInfoModel[indexPath.row].score)
            let integralAttrString : NSMutableAttributedString = NSMutableAttributedString(string: integralString)
            
            integralAttrString.addAttribute(NSForegroundColorAttributeName, value:UIColor(red: 255.0/255.0, green: 212.0/255.0, blue: 0.0/255.0, alpha: 1), range: NSMakeRange(3, integralString.characters.count-3))
            
            integralAttrString.addAttribute(NSFontAttributeName, value: UIFont.systemFontOfSize(18), range: NSMakeRange(0, 3))
            integralAttrString.addAttribute(NSFontAttributeName, value: UIFont.systemFontOfSize(24), range: NSMakeRange(3, integralString.characters.count-3))
            cell.scoreLabel.attributedText = integralAttrString
            
          
            cell.cardNoLabel.text = String(format: "卡号:%@", self.cardInfoModel[indexPath.row].cardNo)
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return screenWidth/170*90
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        UserDefaultsSaveInfo.userDefaultsStandardUserDefaultsObject("viewControllers[1]", keyString: "QRPay")
        
        SVProgressShow.showWithStatus("进入卡片...")
        
        let delayInSeconds : Double = 1.0
        let popTime : dispatch_time_t = dispatch_time(DISPATCH_TIME_NOW, Int64(delayInSeconds * Double(NSEC_PER_SEC)))
        dispatch_after(popTime, dispatch_get_main_queue(), { () -> Void in
            
            let cardDetailViewController = CardDetailViewController()
            cardDetailViewController.merchId = self.cardInfoModel[indexPath.row].merchId
            cardDetailViewController.cardNo = self.cardInfoModel[indexPath.row].cardNo
            self.navigationController?.pushViewController(cardDetailViewController, animated: true)
            SVProgressShow.dismiss()
        })
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
