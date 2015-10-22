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


var defaultHotFocusViewController : HotFocusViewController!

class HotFocusViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,TQTableViewCellRemoveControllerDelegate,UIViewControllerPreviewingDelegate {
    
    var tableView : UITableView!
    var cellRemoveController : TQTableViewCellRemoveController!
    
    var merchModel = [MerchModel]()
    
    
    var supermarketCollectController = SupermarketCollectController()
    var indexPath : NSIndexPath!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        defaultHotFocusViewController = self
        
        
      //  self.registerForPreviewingWithDelegate(self, sourceView: self.view)
        
        
        self.title = "热点"
        self.creatTableView()
        self.preferredStatusBarStyle()
        self.requestData()
        
        if self.traitCollection.forceTouchCapability == UIForceTouchCapability.Available {
            self.registerForPreviewingWithDelegate(self, sourceView: self.tableView)
        }
        
        let payQRViewButtonItem : UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "QRIcon"), style: UIBarButtonItemStyle.Plain, target: self, action: Selector("showQRView"))
        
        self.navigationItem.rightBarButtonItem = payQRViewButtonItem
        
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.hidden = false
    }
    
    class func shareHotFocusViewController() -> HotFocusViewController {
        return defaultHotFocusViewController
    }

    
    //http://121.40.222.162:8080/tongbao/merch/v1.0/getMerchList?&orderBy=updateTime&pageCount=20&pageNum=1&sort=desc&whereString=
    func requestData() {
        
        SVProgressShow.showWithStatus("加载中...")
        Alamofire.request(.GET, baseUrl + "/merch/v1.0/getMerchList?", parameters: ["pageNum":"1","pageCount":"20","orderBy":"updateTime","sort":"desc","whereString":""])
            
            .response { request, response, data, error in
                
                if error == nil {
                    let json  = JSON(data: data!)
                    
                    self.merchModel = MerchModel.merchModel(RequestDataTool.processingData(json))
                    
//                    switch json["code"].intValue
//                    {
//                    case 200:
//                        self.merchModel =  MerchModel.merchModel(json)
//                    default:
//                        break
//                    }
                }
                else {
                    SVProgressShow.showErrorWithStatus("请求失败!")
                }
                SVProgressShow.dismiss()
                self.tableView.reloadData()
                
                }

    }
    
    func creatTableView() {
        tableView = UITableView(frame: CGRectMake(0, 44+20, screenWidth, screenHeight-44-20 - 49))
        tableView.backgroundColor = shrbTableViewColor
        tableView.separatorStyle = .None
        tableView.delegate = self
        tableView.dataSource = self
        self.view.addSubview(tableView)
        
        
        self.cellRemoveController = TQTableViewCellRemoveController.init(tableView: self.tableView)
        self.cellRemoveController.delegate = self
        
    }
    
    func showQRView() {
        
        UserDefaultsSaveInfo.userDefaultsStandardUserDefaultsObject("viewControllers[0]", keyString: "QRPay")
        
        let supermarketQRViewController = SupermarketQRViewController()
        supermarketQRViewController.merchId = "201508111544260859"
        supermarketQRViewController.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(supermarketQRViewController, animated: true)
        
    }
    
    //    //child ViewController的作为状态栏
//    override func childViewControllerForStatusBarStyle() -> UIViewController? {
//        super.setNeedsStatusBarAppearanceUpdate()
//        return nil;
//    }
//    //child ViewController的状态栏是否隐藏设置状态栏
//    override func childViewControllerForStatusBarHidden() -> UIViewController? {
//        return nil;
//    }
//    //设置当前ViewController的StatusBar的样式
//    override func preferredStatusBarStyle() -> UIStatusBarStyle {
//        return .LightContent
//        
//    }
//    //隐藏还是展示statusBar
//    override func prefersStatusBarHidden() -> Bool {
//        return false
//    }
//    //statusBar的改变动画
//    override func preferredStatusBarUpdateAnimation() -> UIStatusBarAnimation {
//        return .Fade  
//    }
    
//    override func setNeedsStatusBarAppearanceUpdate()
//    {
//        super.setNeedsStatusBarAppearanceUpdate()
//    }
    
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
        merchDescriptionLabel.font = font18
        merchDescriptionLabel.text = self.merchModel[indexPath.row].merchDesc
        merchDescriptionLabel.numberOfLines = 0
        merchDescriptionLabel.sizeToFit()
        
        return screenWidth/8*5+16+CGFloat(merchDescriptionLabel.frame.size.height)+16 + 8
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        SVProgressShow.showWithStatus("进入店铺...")
        
        let delayInSeconds : Double = 1.0
        let popTime : dispatch_time_t = dispatch_time(DISPATCH_TIME_NOW, Int64(delayInSeconds * Double(NSEC_PER_SEC)))
        dispatch_after(popTime, dispatch_get_main_queue(), { () -> Void in
            
            let supermarketCollectController = SupermarketCollectController()
            supermarketCollectController.merchId = self.merchModel[indexPath.row].merchId
            supermarketCollectController.merchTitle = self.merchModel[indexPath.row].merchTitle
            supermarketCollectController.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(supermarketCollectController, animated: true)
            SVProgressShow.dismiss()
        })
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell.alpha = 1
    }
    
    func tableView(tableView: UITableView, didEndDisplayingCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell.alpha = 0
        cell.transform = CGAffineTransformMakeTranslation(0, 0)
    }
    
    func didRemoveTableViewCellWithIndexPath(indexPath: NSIndexPath!) {
        let deleteArr = self.merchModel[indexPath.row]
        self.merchModel.removeAtIndex(indexPath.row)
        
        self.tableView.beginUpdates()
        self.tableView.deleteRowsAtIndexPaths([indexPath!],  withRowAnimation: UITableViewRowAnimation.Bottom)
        self.tableView.endUpdates()
        
        self.merchModel.insert(deleteArr, atIndex: self.merchModel.count)
        self.tableView.reloadData()
        
    }
    
    //按了之后弹出的页面
    func previewingContext(previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        
        self.indexPath = self.tableView.indexPathForRowAtPoint(location)!
    
        print(self.indexPath.row)
        let supermarketCollectController = SupermarketCollectController()
        supermarketCollectController.merchId = self.merchModel[self.indexPath.row].merchId
        supermarketCollectController.merchTitle = self.merchModel[self.indexPath.row].merchTitle
        supermarketCollectController.showSVProgressShow = false
       // supermarketCollectController.preferredContentSize = CGSizeMake(0, 240)
        let cell : UITableViewCell = self.tableView.cellForRowAtIndexPath(self.indexPath)!
        previewingContext.sourceRect = cell.frame
       
        return supermarketCollectController
    }
    //再按弹出的页面
    func previewingContext(previewingContext: UIViewControllerPreviewing, commitViewController viewControllerToCommit: UIViewController) {
        
        let viewControllerToCommit = SupermarketCollectController()
        viewControllerToCommit.merchId = self.merchModel[self.indexPath.row].merchId
        viewControllerToCommit.merchTitle = self.merchModel[self.indexPath.row].merchTitle
        viewControllerToCommit.hidesBottomBarWhenPushed = true
        self.showViewController(viewControllerToCommit, sender: self)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}




















