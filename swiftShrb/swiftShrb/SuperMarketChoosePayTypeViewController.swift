//
//  SuperMarketChoosePayTypeViewController.swift
//  swiftShrb
//
//  Created by PayBay on 15/10/14.
//  Copyright © 2015年 PayBay. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class SuperMarketChoosePayTypeViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    var imageViewWidth : CGFloat = screenWidth/4
    var imageViewSpace : CGFloat = 4
    
    static var payTypeBtn : UIButton!
    
    var cardInfoModel : CardInfoModel!
    
    var dataArray : NSMutableArray = ["热点无图片","热点无图片","热点无图片","热点无图片"]
    var cardNo : String = ""
    var merchId : String = ""
    
    var tableView : UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.creatTableView()
        
        // Do any additional setup after loading the view.
    }

    
    func creatTableView() {
        self.automaticallyAdjustsScrollViewInsets = false
        
        self.tableView = UITableView(frame: CGRectMake(0, 20 + 44, screenWidth, screenHeight - 20-44))
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.tableView.tableFooterView = UIView()
        self.tableView.backgroundColor = shrbTableViewColor
        self.view.addSubview(self.tableView)
        
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cellId")
            let cell = tableView.dequeueReusableCellWithIdentifier("cellId", forIndexPath: indexPath) as UITableViewCell
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            
            cell.textLabel?.text = "商店名称"
            cell.textLabel?.textColor = shrbText
            cell.textLabel?.font = font15
            
            return cell
            
        }
        else if indexPath.row == 1 {
            
            tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cellId")
            let cell = tableView.dequeueReusableCellWithIdentifier("cellId", forIndexPath: indexPath) as UITableViewCell
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            
            for index in 0..<(3>self.dataArray.count ? self.dataArray.count : 3) {
                let imageView = UIImageView(image: UIImage(named: String(format: "%@.jpg", (self.dataArray[index] as? String)!)))
                imageView.frame = CGRectMake(16 + CGFloat(index)*(imageViewWidth + imageViewSpace), 10, imageViewWidth,imageViewWidth)
                imageView.layer.cornerRadius = 8
                imageView.layer.masksToBounds = true
                cell.addSubview(imageView)
            }
            
            cell.detailTextLabel?.text = String(format: "共%lu件商品", self.dataArray.count)
            cell.detailTextLabel?.font = font14
            
            NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("payChanged:"), name: PAY_CHANGED, object: nil)
            
            return cell
            
        }
        else {
            tableView.registerNib(UINib(nibName: "SupermarketChoosePayTableViewCell", bundle: nil), forCellReuseIdentifier: "SupermarketChoosePayTableViewCellId")
            let cell = tableView.dequeueReusableCellWithIdentifier("SupermarketChoosePayTableViewCellId", forIndexPath: indexPath) as! SupermarketChoosePayTableViewCell
            
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            
            let checkBoxData = TNImageCheckBoxData()
            checkBoxData.identifier = "check"
            checkBoxData.labelText = "100PMB电子券"
            checkBoxData.labelColor = UIColor(red: 78.0/255.0, green: 78.0/255.0, blue: 78.0/255.0, alpha: 1)
            checkBoxData.labelFont = font14
            checkBoxData.checked = true
            checkBoxData.checkedImage = UIImage(named: "checked")
            checkBoxData.uncheckedImage = UIImage(named: "unchecked")
            
            if cell.payViewCheckCouponsView.checkedCheckBoxes == nil {
                cell.payViewCheckCouponsView.myInitWithCheckBoxData([checkBoxData], style: TNCheckBoxLayoutVertical)
                cell.payViewCheckCouponsView.create()
            }
            
            return cell
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        if indexPath.row == 0 {
            return 44
        }
        else if indexPath.row == 1 {
            return imageViewWidth + 20
        }
        else {
            return 250
        }
    }

    
    func payChanged(notification : NSNotification) {
        
        let button : UIButton = notification.object as! UIButton
        switch button.tag {
        case 0:
            //会员支付
            if CurrentUser.user?.token == "" {
                SVProgressShow.showInfoWithStatus("请先登录账号!")
                return
            }
            
            SVProgressShow.showWithStatus("支付中...")
            
            Alamofire.request(.GET, baseUrl + "/card/v1.0/findCardByMerch?", parameters: ["userId":CurrentUser.user!.userId,"token":CurrentUser.user?.token == nil ? "" : CurrentUser.user!.token,"merchId":self.merchId])
                
                .response { request, response, data, error in
                    
                    if error == nil {
                        let json  = JSON(data: data!)
                        if RequestDataTool.processingData(json) != nil {
                            self.cardInfoModel = CardInfoModel(json: RequestDataTool.processingData(json)["data"])
                            self.cardNo = self.cardInfoModel.cardNo
                            Alamofire.request(.GET, baseUrl + "/card/v1.0/pay?", parameters: ["userId":CurrentUser.user!.userId,"token":CurrentUser.user?.token == nil ? "" : CurrentUser.user!.token,"merchId":self.merchId,"cardNo":self.cardInfoModel.cardNo,"payAmount":(0)])
                                .response { request, response, data, error in
                                    
                                    if error == nil {
                                        let json  = JSON(data: data!)
                                        if RequestDataTool.processingDataMes(json) != nil {
                                            SVProgressShow.showSuccessWithStatus("支付成功!")
                                            let completeVoucherViewController = CompleteVoucherViewController()
                                            completeVoucherViewController.merchId = self.merchId
                                            completeVoucherViewController.cardNo = self.cardInfoModel.cardNo
                                            completeVoucherViewController.title = "支付完成"
                                            self.navigationController?.pushViewController(completeVoucherViewController, animated: true)
                                            
                                        }
                                    }
                                    
                            }
                            
                        }
                    }
            }
        case 1:
            SVProgressShow.showSuccessWithStatus("支付宝支付方式")
        case 2:
            SVProgressShow.showSuccessWithStatus("银联支付方式")
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
