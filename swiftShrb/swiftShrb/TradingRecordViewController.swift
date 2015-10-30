//
//  TradingRecordViewController.swift
//  swiftShrb
//
//  Created by PayBay on 15/10/20.
//  Copyright © 2015年 PayBay. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON


class TradingRecordViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    var cardNo : String! = ""
    var tableView : UITableView!
    
    var emptyView : UIView!
    
    var cardTradeRecordsModel : [CardTradeRecordsModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "交易记录"
        
        self.requestData()
        self.creatTableView()
        
        // Do any additional setup after loading the view.
    }

    func requestData() {
        
        SVProgressShow.showWithStatus("加载中...")
        
        //http://121.40.222.162:8080/tongbao/card/v1.0/findCardTradeRecords?&cardNo=1441780304974&token=363afbe51ff56ca94f90b6ed2ed4b30b&userId=1441591396095000842
        Alamofire.request(.GET, baseUrl + "/card/v1.0/findCardTradeRecords?", parameters: ["token":CurrentUser.user?.token == nil ? "" : CurrentUser.user!.token,"userId":CurrentUser.user?.userId == nil ? "" : CurrentUser.user!.userId,"cardNo":self.cardNo])
            
            .response { request, response, data, error in
                
                if error == nil {
                    let json  = JSON(data: data!)
                    
                    self.cardTradeRecordsModel = CardTradeRecordsModel.cardTradeRecordsModel(json)
                    if self.cardTradeRecordsModel.count == 0 {
                        self.creatEmpty()
                    }
                    else {
                        self.tableView.reloadData()
                    }
                }
                else {
                    SVProgressShow.showErrorWithStatus("请求失败!")
                }
                SVProgressShow.dismiss()
                
                
                
                
        }
        
    }

    func creatTableView() {
        
        tableView = UITableView(frame: CGRectMake(0, 0, screenWidth, screenHeight))
        tableView.backgroundColor = shrbTableViewColor
        tableView.tableFooterView = UIView()
        tableView.delegate = self
        tableView.dataSource = self
        self.view.addSubview(tableView)
        
    }
    
    func creatEmpty() {
        self.emptyView = UIView(frame: CGRectMake(0, 0, screenWidth, screenHeight))
        self.emptyView.backgroundColor = UIColor.whiteColor()
        let imageView = UIImageView(image: UIImage(named: "empty"))
        imageView.frame = CGRectMake(0, 0, 80, 80)
        imageView.center = CGPointMake(screenWidth/2, screenHeight/2)
        self.emptyView.addSubview(imageView)
        self.view.addSubview(self.emptyView)
        
    }

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 150
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.cardTradeRecordsModel.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        tableView.registerNib(UINib(nibName: "ExpenseTableViewCell", bundle: nil), forCellReuseIdentifier: "ExpenseTableViewCellId")
        let cell = tableView.dequeueReusableCellWithIdentifier("ExpenseTableViewCellId", forIndexPath: indexPath) as! ExpenseTableViewCell
        
        cell.selectionStyle = UITableViewCellSelectionStyle.None
    
        let timeStamp : String = self.cardTradeRecordsModel[indexPath.row].acceptTime
        let date1 : NSTimeInterval = NSTimeInterval(timeStamp)!/1000
        let date2 : NSDate = NSDate(timeIntervalSince1970: date1)
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "HH:mm   yyyy/MM/dd"
        let dateString : String = dateFormatter.stringFromDate(date2)
        
        cell.dateLabel.text = dateString
        cell.expenseTextView.text = String(format: "金额:%.2f元\n订单:%@\n商铺名称:%@\n地址:%@", self.cardTradeRecordsModel[indexPath.row].payAmount,self.cardTradeRecordsModel[indexPath.row].consumeID,self.cardTradeRecordsModel[indexPath.row].merchName,self.cardTradeRecordsModel[indexPath.row].address)
        
        
        return cell
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
