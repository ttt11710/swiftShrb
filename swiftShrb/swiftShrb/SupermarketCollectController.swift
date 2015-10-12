//
//  SupermarketCollectController.swift
//  swiftShrb
//
//  Created by PayBay on 15/10/8.
//  Copyright © 2015年 PayBay. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SDWebImage

class SupermarketCollectController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UITableViewDataSource, UITableViewDelegate,CollectionViewWaterfallLayoutDelegate {

    
    var merchId : String = ""
    var merchTitle : String = ""
    
    var collevtionView : UICollectionView!
    var selectTypeTableView : UITableView!
    
    var selectArray : JSON = []
    var dataArray : JSON = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        self.initView()
        self.createCollection()
        self.createSelectTypeTableView()
        self.requestData()

        // Do any additional setup after loading the view.
    }
    
    func initView() {
        
        self.title = self.merchTitle
        
        let selectTpyeButtonItem : UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "screen"), style: UIBarButtonItemStyle.Plain, target: self, action: Selector("selectType"))
        
        self.navigationItem.rightBarButtonItem = selectTpyeButtonItem
    }
    
    
    func requestData() {
        
        
        SVProgressShow.showWithStatus("加载中...")
        
        Alamofire.request(.GET, baseUrl + "/product/v1.0/getProductList?", parameters: ["merchId":self.merchId,"pageNum":"1","pageCount":"20","orderBy":"updateTime","sort":"desc","whereString":""])
            
            .response { request, response, data, error in
                
                if error == nil {
                    let json  = JSON(data: data!)
                    if json["code"].stringValue == "200" {
                        // self.merchModel =  MerchModel.merchModel(json)
                    }
                    
                    switch json["code"].intValue
                    {
                    case 200:
                        self.dataArray = json["productList"]
                        self.selectArray = json["productList"]
                    case 404,503:
                        SVProgressShow.showErrorWithStatus(json["msg"].stringValue)
                    default:
                        break
                    }
                }
                self.collevtionView.reloadData()
                
                let delayInSeconds : Double = 1.0
                let popTime : dispatch_time_t = dispatch_time(DISPATCH_TIME_NOW, Int64(delayInSeconds * Double(NSEC_PER_SEC)))
                dispatch_after(popTime, dispatch_get_main_queue(), { () -> Void in
                    SVProgressShow.showSuccessWithStatus("加载完成!")
                })
        }
        
    }

    
    func createCollection() {
       
        let tbLayout : CollectionViewWaterfallLayout = CollectionViewWaterfallLayout()
        
        tbLayout.sectionInset = UIEdgeInsets(top: 0, left: 4, bottom: 0, right: 4)
        tbLayout.headerInset = UIEdgeInsetsMake(4, 0, 0, 0)
        tbLayout.minimumColumnSpacing = 4
        tbLayout.minimumInteritemSpacing = 4
        
        
        self.collevtionView = UICollectionView(frame: CGRectMake(0, 2, screenWidth, screenHeight), collectionViewLayout: tbLayout)
        self.collevtionView.registerNib(UINib(nibName: "SupermarketCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "SupermarketCollectionViewCellId")
        
        self.collevtionView.backgroundColor = shrbTableViewColor
        self.collevtionView.delegate = self
        self.collevtionView.dataSource = self
        
        self.view.addSubview(self.collevtionView)
    }
    
    
    func createSelectTypeTableView() {
        
        self.selectTypeTableView = UITableView(frame: CGRectMake(screenWidth, 20+44, screenWidth/2, screenHeight))
        self.selectTypeTableView.tableFooterView = UIView()
        self.selectTypeTableView.dataSource = self
        self.selectTypeTableView.delegate = self
        self.selectTypeTableView.backgroundColor = UIColor.clearColor()
        
        self.view.addSubview(self.selectTypeTableView)
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return  self.selectArray[section]["prodList"].count
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return self.selectArray.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell : SupermarketCollectionViewCell = collevtionView.dequeueReusableCellWithReuseIdentifier("SupermarketCollectionViewCellId", forIndexPath: indexPath) as! SupermarketCollectionViewCell
        
        cell.backgroundColor = UIColor.whiteColor()
        cell.prodNameLabel.text = self.selectArray[indexPath.section]["prodList"][indexPath.row]["prodName"].stringValue.characters.count == 0 ? "商品名称" : self.selectArray[indexPath.section]["prodList"][indexPath.row]["prodName"].stringValue
        
        cell.tradeImageView.sd_setImageWithURL(NSURL(string: self.selectArray[indexPath.section]["prodList"][indexPath.row]["imgUrl"].stringValue), placeholderImage: UIImage(named: "热点无图片"))
        
        cell.vipPriceLabel.text = "会员价:￥" + self.selectArray[indexPath.section]["prodList"][indexPath.row]["vipPrice"].stringValue
        
        cell.priceLabel.text = "原价:￥" + self.selectArray[indexPath.section]["prodList"][indexPath.row]["price"].stringValue
        
        return cell
        
    }
    
    func collectionView(collectionView: UICollectionView, layout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        let tradeNameLabel = UILabel(frame: CGRectMake(0, 0, (screenWidth-12)/2, 0))
        let theFont1 = font17
        tradeNameLabel.numberOfLines = 0
        tradeNameLabel.font = theFont1
        
        let string1 =  self.selectArray[indexPath.section]["prodList"][indexPath.row]["prodName"].stringValue
        
        tradeNameLabel.text = string1
        tradeNameLabel.sizeToFit()
        
        return CGSizeMake((screenWidth-20)/2, screenWidth/2-10 + tradeNameLabel.frame.size.height + 25 + 21 + 8)
        
    }
    
    func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        Alamofire.request(.GET, baseUrl + "/product/v1.0/getProduct?", parameters: ["prodId":self.selectArray[indexPath.section]["prodList"][indexPath.row]["prodId"].stringValue,"token":CurrentUser.user?.token == nil ? "" : CurrentUser.user!.token])
            
            .response { request, response, data, error in
                
                if error == nil {
                    let json  = JSON(data: data!)
                    
                    switch json["code"].intValue
                    {
                    case 200:
                        print(json)
                        if json["card"].isEmpty {
                            let productViewController =  ProductViewController()
                            productViewController.productDataDic = json["product"]
                            self.navigationController?.pushViewController(productViewController, animated: true)
                        }
                        else {
                            let productIsMemberViewController =  ProductIsMemberViewController()
                            productIsMemberViewController.productDataDic = json["product"]
                            productIsMemberViewController.cardDataDic = json["card"]
                            self.navigationController?.pushViewController(productIsMemberViewController, animated: true)
                        }
                    default:
                        break
                    }
                }
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 44
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArray.count + 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cellId")
        let cell = tableView.dequeueReusableCellWithIdentifier("cellId", forIndexPath: indexPath) as UITableViewCell
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        cell.textLabel?.text = indexPath.row == 0 ? "全部类别":self.dataArray[indexPath.row-1]["typeName"].stringValue
        cell.textLabel?.textColor = shrbText
        
        return cell
    }
    
    
    func selectType() {
    
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
