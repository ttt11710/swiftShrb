//
//  OrderListDetialViewController.swift
//  swiftShrb
//
//  Created by PayBay on 15/10/28.
//  Copyright © 2015年 PayBay. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SDWebImage

class OrderListDetialViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    
    var tableView : UITableView!
    
    var productListModel = [ProductListModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "订单详情"
        
        self.createTableView()
        self.requestData()
        // Do any additional setup after loading the view.
    }

    func createTableView() {
        
        self.tableView = UITableView(frame: CGRectMake(0, 0, screenWidth, screenHeight))
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.backgroundColor = shrbTableViewColor
        self.tableView.tableFooterView = UIView(frame: CGRectMake(0,0,screenWidth,40))
        self.view.addSubview(self.tableView)
    }

    func requestData() {
        
        SVProgressShow.showWithStatus("加载中...")
        
        Alamofire.request(.GET, baseUrl + "/product/v1.0/getProductList?", parameters: ["merchId":"201508111544260858","pageNum":"1","pageCount":"20","orderBy":"updateTime","sort":"desc","whereString":""])
            
            .response { request, response, data, error in
                
                if error == nil {
                    let json  = JSON(data: data!)
                    if json["code"].stringValue == "200" {
                        // self.merchModel =  MerchModel.merchModel(json)
                    }
                    
                    if RequestDataTool.processingData(json) != nil {
                        self.productListModel = ProductListModel.productListModel(json)
                        
                        let delayInSeconds : Double = 0.5
                        let popTime : dispatch_time_t = dispatch_time(DISPATCH_TIME_NOW, Int64(delayInSeconds * Double(NSEC_PER_SEC)))
                        dispatch_after(popTime, dispatch_get_main_queue(), { () -> Void in
                            SVProgressShow.showSuccessWithStatus("加载完成!")
                        })
                        
                    }
                }
                self.tableView.reloadData()
        }
        
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        return indexPath.row == 0 ? 44 : 93
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.productListModel.count != 0  {
            return self.productListModel[0].prodList.count+1
        }
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cellId")
            let cell = tableView.dequeueReusableCellWithIdentifier("cellId", forIndexPath: indexPath) as UITableViewCell
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            
            
            let image : UIImage = UIImage(named: "paybayLogo")!
            let itemSize : CGSize = CGSizeMake(16, 16)
            UIGraphicsBeginImageContextWithOptions(itemSize, false, 0.0)
            let imageRect : CGRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height)
            image.drawInRect(imageRect)
            cell.imageView?.image = UIGraphicsGetImageFromCurrentImageContext()
            
            cell.textLabel?.text = "HOLY RING"
            cell.textLabel?.textColor = shrbText
            
            return cell
        }
        else {
            tableView.registerNib(UINib(nibName: "orderTableViewCell", bundle: nil), forCellReuseIdentifier: "orderTableViewCellId")
            let cell = tableView.dequeueReusableCellWithIdentifier("orderTableViewCellId", forIndexPath: indexPath) as! orderTableViewCell
            
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            
            if self.productListModel.count != 0 {
                
                cell.tradeNameLabel.text = self.productListModel[0].prodList[indexPath.row-1].prodName as String
                cell.tradeImageView.sd_setImageWithURL(NSURL(string: self.productListModel[0].prodList[indexPath.row-1].imgUrl)!, placeholderImage: UIImage(named: "热点无图片"))
                cell.tradeDescriptionLabel.text = self.productListModel[0].prodList[indexPath.row-1].prodDesc!
                
                cell.priceLabel.text = String(format: "￥%.2f 原价￥%.2f", self.productListModel[0].prodList[indexPath.row-1].vipPrice!, self.productListModel[0].prodList[indexPath.row-1].price!)
            }
            cell.amountTextField.hidden = true
            cell.moneyLabel.hidden = true
            
            
            let afterSaleButton : CallBackButton = CallBackButton(frame: CGRectMake(screenWidth-100,7,90,30))
            afterSaleButton.setTitle("申请售后", forState: UIControlState.Normal)
            afterSaleButton.setTitleColor(shrbPink, forState: UIControlState.Normal)
            afterSaleButton.backgroundColor = UIColor.whiteColor()
            afterSaleButton.layer.cornerRadius = 4
            afterSaleButton.layer.masksToBounds = true
            afterSaleButton.layer.borderColor = shrbPink.CGColor
            afterSaleButton.layer.borderWidth = 1
            cell.addSubview(afterSaleButton)
            afterSaleButton.tag = indexPath.row-1
            afterSaleButton.setupBlock()
            afterSaleButton.callBack = { tag in
               print(tag)
                self.navigationController?.pushViewController(ServeSelectViewController(), animated: true)
            }
            
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
