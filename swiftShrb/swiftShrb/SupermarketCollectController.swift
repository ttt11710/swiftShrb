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
    
    var QRViewBtn : UIButton!
    var QRLabel : UILabel!
    
    var showSelectTypeTableView : Bool = false
    var selectTypeTableViewBackView : UIView!
    
    
    var selectProductListModel = [ProductListModel]()
    var dataProductListModel = [ProductListModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        self.initView()
        self.createCollection()
        self.creatQRButtonView()
        self.createSelectTypeTableView()
        self.requestData()
        

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.QRButtonAnimation()
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
                        self.selectProductListModel = ProductListModel.productListModel(json)
                        self.dataProductListModel = ProductListModel.productListModel(json)
                        
                    case 404,503:
                        SVProgressShow.showErrorWithStatus(json["msg"].stringValue)
                    default:
                        break
                    }
                }
                self.collevtionView.reloadData()
                self.selectTypeTableView.reloadData()
                
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
        
        self.selectTypeTableViewBackView = UIView(frame: CGRectMake(0, 0, screenWidth, screenHeight))
        self.selectTypeTableViewBackView.hidden = true
        
        self.selectTypeTableView = UITableView(frame: CGRectMake(screenWidth, 20+44, screenWidth/2, screenHeight))
        self.selectTypeTableView.tableFooterView = UIView()
        self.selectTypeTableView.dataSource = self
        self.selectTypeTableView.delegate = self
        self.selectTypeTableView.backgroundColor = UIColor.clearColor()
        
        self.view.addSubview(self.selectTypeTableViewBackView)
        self.view.addSubview(self.selectTypeTableView)
    }
    
    func creatQRButtonView() {
        
        self.QRViewBtn = UIButton(type: .Custom)
        self.QRViewBtn.frame = CGRectMake(screenWidth-80, screenHeight-80, 60, 60)
        self.QRViewBtn.backgroundColor = shrbPink
        self.QRViewBtn.layer.cornerRadius = self.QRViewBtn.frame.size.width/2
        self.QRViewBtn.layer.masksToBounds = true
        self.QRViewBtn.addTarget(self, action: Selector("goToQRView"), forControlEvents: UIControlEvents.TouchUpInside)
        self.QRViewBtn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Highlighted)
        self.view.addSubview(self.QRViewBtn)
        
        self.QRLabel = UILabel(frame: CGRectMake(0, 0, 50, 50))
        self.QRLabel.center = CGPointMake(self.QRViewBtn.frame.size.width/2, self.QRViewBtn.frame.size.height/2)
        self.QRLabel.numberOfLines = 2
        self.QRLabel.text = "扫一扫支付";
        self.QRLabel.textAlignment = .Center
        self.QRLabel.textColor = UIColor.whiteColor()
        self.QRLabel.font = font15
        self.QRViewBtn.addSubview(self.QRLabel)
        
        self.QRViewBtn.layer.transform = CATransform3DMakeScale(1, 0, 1)
    }
    
    func QRButtonAnimation() {
        UIView.animateWithDuration(0.5, delay: 0.5, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: UIViewAnimationOptions.CurveEaseIn, animations: { () -> Void in
            
            self.QRViewBtn.layer.transform = CATransform3DIdentity
            
            }) { (finished : Bool) -> Void in
                
                UIView.animateWithDuration(0.2, delay: 0, options: UIViewAnimationOptions.CurveLinear, animations: { () -> Void in
                    self.QRViewBtn.layer.transform = CATransform3DMakeScale(0.9, 0.9, 1)
                    self.QRLabel.layer.transform = CATransform3DMakeScale(0.8, 0.8, 1)
                    }, completion: { (finished : Bool) -> Void in
                        
                })
                
                UIView.animateWithDuration(0.5, delay: 0.2, usingSpringWithDamping: 0.3, initialSpringVelocity: 0.2, options: UIViewAnimationOptions.CurveLinear, animations: { () -> Void in
                    
                    self.QRViewBtn.layer.transform = CATransform3DIdentity
                    self.QRLabel.layer.transform = CATransform3DIdentity
                    
                    }, completion: { (finished : Bool) -> Void in
                        
                })
        }
    }
    
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       // return  self.selectArray[section]["prodList"].count
        return self.selectProductListModel[section].prodList.count
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
       // return self.selectArray.count
        return self.selectProductListModel.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell : SupermarketCollectionViewCell = collevtionView.dequeueReusableCellWithReuseIdentifier("SupermarketCollectionViewCellId", forIndexPath: indexPath) as! SupermarketCollectionViewCell
        
        cell.backgroundColor = UIColor.whiteColor()
        
        cell.prodNameLabel.text = self.selectProductListModel[indexPath.section].prodList[indexPath.row].prodName == "" ? "商品名称" : self.selectProductListModel[indexPath.section].prodList[indexPath.row].prodName
        
        cell.tradeImageView.sd_setImageWithURL(NSURL(string: self.selectProductListModel[indexPath.section].prodList[indexPath.row].imgUrl), placeholderImage: UIImage(named: "热点无图片"))
        
        cell.vipPriceLabel.text = "会员价:￥" + String(self.selectProductListModel[indexPath.section].prodList[indexPath.row].vipPrice)
        
        cell.priceLabel.text = "原价:￥" + String(self.selectProductListModel[indexPath.section].prodList[indexPath.row].price)
        
        if self.selectProductListModel.count != 0 {
            cell.tradeImageView.layer.transform = CATransform3DMakeScale(1, 0, 1)
            cell.tradeImageView.layer.transform = CATransform3DMakeTranslation(0, -screenWidth/2, 0)
            
            cell.prodNameLabel.alpha = 0
            cell.vipPriceLabel.alpha = 0
            cell.priceLabel.alpha = 0
            
            UIView.animateWithDuration(1.0, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: UIViewAnimationOptions.CurveEaseIn, animations: { () -> Void in
                
                cell.tradeImageView.layer.transform = CATransform3DIdentity
                
                }, completion: { (finished : Bool) -> Void in
                    
            })
            
            UIView.animateWithDuration(0.8, delay: 0.6, options: UIViewAnimationOptions.CurveLinear, animations: { () -> Void in
                cell.prodNameLabel.alpha = 1
                }, completion: { (finished : Bool) -> Void in
                    
            })
            
            UIView.animateWithDuration(0.8, delay: 1.0, options: UIViewAnimationOptions.CurveLinear, animations: { () -> Void in
                cell.vipPriceLabel.alpha = 1
                cell.priceLabel.alpha = 1
                }, completion: { (finished : Bool) -> Void in
                    
            })

        }
        
        return cell
        
    }
    
    func collectionView(collectionView: UICollectionView, layout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        let tradeNameLabel = UILabel(frame: CGRectMake(0, 0, (screenWidth-12)/2, 0))
        let theFont1 = font17
        tradeNameLabel.numberOfLines = 0
        tradeNameLabel.font = theFont1
        
      //  let string1 =  self.selectArray[indexPath.section]["prodList"][indexPath.row]["prodName"].stringValue
        let string1 = self.selectProductListModel[indexPath.section].prodList[indexPath.row].prodName
        tradeNameLabel.text = string1
        tradeNameLabel.sizeToFit()
        
        return CGSizeMake((screenWidth-20)/2, screenWidth/2-10 + tradeNameLabel.frame.size.height + 25 + 21 + 8)
        
    }
    
    func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        Alamofire.request(.GET, baseUrl + "/product/v1.0/getProduct?", parameters: ["prodId":self.selectProductListModel[indexPath.section].prodList[indexPath.row].prodId,"token":CurrentUser.user?.token == nil ? "" : CurrentUser.user!.token])
            
            .response { request, response, data, error in
                
                if error == nil {
                    let json  = JSON(data: data!)
    
                    if RequestDataTool.processingData(json) == nil {
                        return
                    }
                    if RequestDataTool.processingData(json)["card"].isEmpty {
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

                    
//                    switch json["code"].intValue
//                    {
//                    case 200:
//                        
//                        if json["card"].isEmpty {
//                            let productViewController =  ProductViewController()
//                            productViewController.productDataDic = json["product"]
//                            self.navigationController?.pushViewController(productViewController, animated: true)
//                        }
//                        else {
//                            let productIsMemberViewController =  ProductIsMemberViewController()
//                            productIsMemberViewController.productDataDic = json["product"]
//                            productIsMemberViewController.cardDataDic = json["card"]
//                            self.navigationController?.pushViewController(productIsMemberViewController, animated: true)
//                        }
//                    default:
//                        break
//                    }
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
       // return self.dataArray.count + 1
        return self.dataProductListModel.count + 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cellId")
        let cell = tableView.dequeueReusableCellWithIdentifier("cellId", forIndexPath: indexPath) as UITableViewCell
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        
        cell.textLabel?.text = indexPath.row == 0 ? "全部类别":self.dataProductListModel[indexPath.row-1].typeName

        cell.textLabel?.textColor = shrbText
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.showSelectTypeTableView = !self.showSelectTypeTableView
        UIView.animateWithDuration(0.5, delay: 0, options: UIViewAnimationOptions.CurveEaseIn, animations: { () -> Void in
                self.selectTypeTableView.layer.transform = CATransform3DIdentity
            self.selectTypeTableViewBackView.backgroundColor = UIColor.clearColor()
            
            }) { (finished : Bool) -> Void in
                
                self.selectTypeTableViewBackView.hidden = true
                
                if indexPath.row == 0 {
                    self.selectProductListModel.removeAll()
                    for index in 0..<self.dataProductListModel.count {
                        self.selectProductListModel.insert(self.dataProductListModel[index], atIndex: index)
                        
                    }
                }
                else {
                    self.selectProductListModel.removeAll()
                    self.selectProductListModel.insert(self.dataProductListModel[indexPath.row-1], atIndex: 0)
                }
                
                self.collevtionView.reloadData()
                self.collevtionView.setContentOffset(CGPointMake(0, -20 - 44), animated: true)
        }
    }
    
    
    func selectType() {
    
        self.showSelectTypeTableView = !self.showSelectTypeTableView
        if self.showSelectTypeTableView {
            self.selectTypeTableViewBackView.hidden = false
            
            UIView.animateWithDuration(0.8, delay: 0, usingSpringWithDamping: 0.3, initialSpringVelocity: 0, options: UIViewAnimationOptions.CurveEaseIn, animations: { () -> Void in
                
                self.selectTypeTableView.layer.transform = CATransform3DMakeTranslation(-screenWidth/2, 0, 0)
                
                }, completion: { (finished : Bool) -> Void in
                   
            })
            
            UIView.animateWithDuration(0.3, delay: 0, options: UIViewAnimationOptions.CurveEaseIn, animations: { () -> Void in
                
                self.selectTypeTableViewBackView.backgroundColor = UIColor(white: 0, alpha: 0.5)
                
                }, completion: { (finished : Bool) -> Void in
                    
            })
        }
        else {
            UIView.animateWithDuration(0.8, delay: 0, usingSpringWithDamping: 0.3, initialSpringVelocity: 0, options: UIViewAnimationOptions.CurveEaseIn, animations: { () -> Void in
                
                self.selectTypeTableView.layer.transform = CATransform3DMakeTranslation(screenWidth/2, 0, 0)
                
                }, completion: { (finished : Bool) -> Void in
                    
            })
            
            UIView.animateWithDuration(0.3, delay: 0, options: UIViewAnimationOptions.CurveEaseIn, animations: { () -> Void in
                
                self.selectTypeTableViewBackView.backgroundColor = UIColor.clearColor()
                }, completion: { (finished : Bool) -> Void in
                    
            })
            
            UIView.animateWithDuration(0.3, delay: 0, options: UIViewAnimationOptions.CurveEaseIn, animations: { () -> Void in
                
                }, completion: { (finished : Bool) -> Void in
                    self.selectTypeTableViewBackView.hidden = true
            })

        }
    }
    
    func goToQRView() {
        
        UserDefaultsSaveInfo.userDefaultsStandardUserDefaultsObject("QRPay", setobjectString: "SupermarketNewStore", keyString: "QRPay")
        
        UIView.animateWithDuration(0.2, delay: 0, options: UIViewAnimationOptions.CurveEaseIn, animations: { () -> Void in
            
            self.QRViewBtn.layer.transform = CATransform3DMakeScale(1.2, 1.2, 1)
            }) { (finished : Bool) -> Void in
                
                UIView.animateWithDuration(0.8, delay: 0, usingSpringWithDamping: 0.3, initialSpringVelocity: 0, options: UIViewAnimationOptions.CurveEaseIn, animations: { () -> Void in
                        self.QRViewBtn.layer.transform = CATransform3DIdentity
                    }, completion: { (finished : Bool) -> Void in
                      
                        if self.validateCamera() {
                            
                            let supermarketQRViewController = SupermarketQRViewController()
                            supermarketQRViewController.merchId = self.merchId
                            self.navigationController?.pushViewController(supermarketQRViewController, animated: true)
                            
                        }
                        else {
                            
                            let alertController = UIAlertController(title: "提示", message: "没有摄像头或摄像头不可用", preferredStyle: UIAlertControllerStyle.Alert)
                            let okAction = UIAlertAction(title: "确定", style: UIAlertActionStyle.Default, handler: nil)
                            alertController.addAction(okAction)
                          //  self.presentViewController(alertController, animated: true, completion: nil)
                            
                            let supermarketOrderViewController = SupermarketOrderViewController()
                            supermarketOrderViewController.merchId = self.merchId
                            self.navigationController?.pushViewController(supermarketOrderViewController, animated: true)
                        }
                })
                
        }
    }
    
    func validateCamera() -> Bool{
        return UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera) && UIImagePickerController.isCameraDeviceAvailable(UIImagePickerControllerCameraDevice.Rear)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
    
//        if (touches as NSSet).anyObject()?.view == self.selectTypeTableView {
//            print("ok")
//        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
