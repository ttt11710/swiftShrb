//
//  CollectViewController.swift
//  swiftShrb
//
//  Created by PayBay on 15/10/28.
//  Copyright © 2015年 PayBay. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SDWebImage

class CollectViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    var tableView : UITableView!
    var merchModel = [MerchModel]()
    
    
    var supermarketCollectController = SupermarketCollectController()
    var indexPath : NSIndexPath!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.title = "我的收藏"
        self.creatTableView()
        self.preferredStatusBarStyle()
        self.requestData()
    }
    
    
    //http://121.40.222.162:8080/tongbao/merch/v1.0/getMerchList?&orderBy=updateTime&pageCount=20&pageNum=1&sort=desc&whereString=
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
        Alamofire.request(.GET, baseUrl + "/merch/v1.0/getMerchList?", parameters: ["pageNum":"1","pageCount":"20","orderBy":"updateTime","sort":"desc","whereString":""])
            
            .response { request, response, data, error in
                
                if error == nil {
                    let json  = JSON(data: data!)
                    
                    self.merchModel = MerchModel.merchModel(RequestDataTool.processingData(json))
                  
                }
                else {
                    SVProgressShow.showErrorWithStatus("请求失败!")
                }
                SVProgressShow.dismiss()
                self.tableView.reloadData()
                
        }
        
    }
    
    func creatTableView() {
        tableView = UITableView(frame: CGRectMake(0, 0, screenWidth, screenHeight))
        tableView.backgroundColor = shrbTableViewColor
        tableView.separatorStyle = .None
        tableView.delegate = self
        tableView.dataSource = self
        self.view.addSubview(tableView)
    }
    

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.merchModel.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        tableView.registerNib(UINib(nibName: "HotFocusTableViewCell", bundle: nil), forCellReuseIdentifier: "HotFocusTableViewCellId")
        let cell = tableView.dequeueReusableCellWithIdentifier("HotFocusTableViewCellId", forIndexPath: indexPath) as! HotFocusTableViewCell
        
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        
        cell.descriptionLabel.text = self.merchModel[indexPath.row].merchDesc
        cell.hotImageView.sd_setImageWithURL(NSURL(string: self.merchModel[indexPath.row].merchImglist[0].imgUrl), placeholderImage: UIImage(named: "热点无图片"))
        
        let imageView : UIImageView = UIImageView(frame: CGRectMake(screenWidth-46, cell.bounds.size.height-46, 30, 30))
        imageView.image = UIImage(named: "我的收藏")
        cell.addSubview(imageView)
        
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        let merchDescriptionLabel = UILabel(frame: CGRectMake(0, 0, screenWidth-32, 0))
        merchDescriptionLabel.font = font18
        merchDescriptionLabel.text = self.merchModel[indexPath.row].merchDesc
        merchDescriptionLabel.numberOfLines = 0
        merchDescriptionLabel.sizeToFit()
        
        return screenWidth/8*5+16+CGFloat(merchDescriptionLabel.frame.size.height)+16 + 8
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
