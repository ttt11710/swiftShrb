//
//  HotFocusViewController.swift
//  swiftShrb
//
//  Created by PayBay on 15/9/28.
//  Copyright © 2015年 PayBay. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SDWebImage


class HotFocusViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    var tableView : UITableView!
    
    var merchModel = [MerchModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "热点"
        self.setTableView()
        self.preferredStatusBarStyle()
        
        Alamofire.request(.GET, baseUrl + "/merch/v1.0/getMerchList?", parameters: ["pageNum":"1","pageCount":"20","orderBy":"updateTime","sort":"desc","whereString":""])
        
            .response { request, response, data, error in
                
                if error == nil {
                    let json  = JSON(data: data!)
                    if json["code"].stringValue == "200" {
                     self.merchModel =  MerchModel.merchModel(json)
                    }
                }
                self.tableView.reloadData()
        }
    }
    
    func setTableView() {
        tableView = UITableView(frame: CGRectMake(0, 44+20, screenWidth, screenHeight-44-20 - 49))
        tableView.delegate = self
        tableView.dataSource = self
        self.view.addSubview(tableView)
        
    }
    
    //child ViewController的作为状态栏
    override func childViewControllerForStatusBarStyle() -> UIViewController? {
        super.setNeedsStatusBarAppearanceUpdate()
        return nil;
    }
    //child ViewController的状态栏是否隐藏设置状态栏
    override func childViewControllerForStatusBarHidden() -> UIViewController? {
        return nil;
    }
    //设置当前ViewController的StatusBar的样式
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
        
    }
    //隐藏还是展示statusBar
    override func prefersStatusBarHidden() -> Bool {
        return false
    }
    //statusBar的改变动画
    override func preferredStatusBarUpdateAnimation() -> UIStatusBarAnimation {
        return .Fade  
    }
    
    override func setNeedsStatusBarAppearanceUpdate()
    {
        super.setNeedsStatusBarAppearanceUpdate()
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
        
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
       let merchDescriptionLabel = UILabel(frame: CGRectMake(0, 0, screenWidth-32, 0))
        merchDescriptionLabel.font = UIFont(name: "Arial", size: 18)
        merchDescriptionLabel.text = self.merchModel[indexPath.row].merchDesc
        merchDescriptionLabel.numberOfLines = 0
        merchDescriptionLabel.sizeToFit()
        
        return screenWidth/8*5+16+CGFloat(merchDescriptionLabel.frame.size.height)+16+8
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

