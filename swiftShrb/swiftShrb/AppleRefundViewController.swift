//
//  AppleRefundViewController.swift
//  swiftShrb
//
//  Created by PayBay on 15/10/28.
//  Copyright © 2015年 PayBay. All rights reserved.
//

import UIKit

class AppleRefundViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,IQActionSheetPickerViewDelegate {

    
    var pickMutableArray : NSMutableArray = ["  退货原因","  商品破损","  商品错发/漏发","  商品质量问题","  未按约定时间发货"]
    
    var tableView : UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "申请退款"
        self.createTableView()
    }

    func createTableView() {
        
        self.tableView = UITableView(frame: CGRectMake(0, 0, screenWidth, screenHeight))
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.tableFooterView = UIView(frame: CGRectMake(0,0,screenWidth,40))
        self.view.addSubview(self.tableView)
    }

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        return 580
        
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        tableView.registerNib(UINib(nibName: "AppleRefundTableViewCell", bundle: nil), forCellReuseIdentifier: "AppleRefundTableViewCellId")
        let cell = tableView.dequeueReusableCellWithIdentifier("AppleRefundTableViewCellId", forIndexPath: indexPath) as! AppleRefundTableViewCell
        
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        cell.returnGoodsReasonLabel.text = "  退货原因";
        cell.callBack = { money in
            print(money)
            
            self.navigationController?.pushViewController(SuccessAppleRefundViewController(), animated: true)
        }
        
        cell.returnCallBack = { string in
          
            print(string)
            
            let picker : IQActionSheetPickerView = IQActionSheetPickerView(title: "Single Picker", delegate: self)
            picker.tag = indexPath.row
            picker.titlesForComponenets = [self.pickMutableArray]
            picker.selectRow(0, inComponent: 0, animated: true)
            picker.show()
        }
        
        return cell
        
    }
    
    func actionSheetPickerView(pickerView: IQActionSheetPickerView!, didSelectTitles titles: [AnyObject]!) {
        let cell : AppleRefundTableViewCell = self.tableView.cellForRowAtIndexPath(self.tableView.indexPathsForVisibleRows![0]) as! AppleRefundTableViewCell
        cell.returnGoodsReasonLabel.text = titles[0] as? String
    }
    
    func pickerCancelClicked(barButton: UIBarButtonItem!) {
        
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
