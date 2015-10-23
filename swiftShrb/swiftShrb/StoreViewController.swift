//
//  StoreViewController.swift
//  swiftShrb
//
//  Created by PayBay on 15/10/23.
//  Copyright © 2015年 PayBay. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SDWebImage

class ShoppingNumLabel : UILabel {
    var num : NSInteger = 0
    var price : CGFloat = 0.0
    
    func mySetNum(num : NSInteger) {
       
        self.num = num
        self.text = String(format: "%ld", num)
        self.textColor = UIColor.whiteColor()
    }
    
}


var constantCountTime : NSInteger = 1200
var countTime : NSInteger = 1200
class StoreViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    
    var merchId : String = ""
    var merchTitle : String = ""
    
    var array : NSMutableArray = []
    var currentNumDic : NSMutableDictionary!
    var rect : CGRect!
    var lastContentOffset : CGFloat = 0.0
    
    var timer : NSTimer!
    var showSelectTypeTabelView : Bool = false
    
    var selectTypeTableViewBackView : UIView!
    var selectTypeTableView : UITableView!
    
    
    var tableView : UITableView!
    
    var numbutton : HJCAjustNumButton!
    
    var shoppingCardView : UIView!
    var shoppingCardImageView : UIImageView!
    
    var shoppingLineImageView : UIImageView!
    var shoppingNumLabel : ShoppingNumLabel!
    var priceLabel : UILabel!
    var shoppingFixLabel : UILabel!
    var countDownLabel : UILabel!
    var gotoPayBtn : UIButton!
    
    var path : UIBezierPath!
    
    var prodId : String = ""
    var shoppingArray : NSMutableArray = []
    
    
    var layer : CALayer!
    
    var selectProductListModel = [ProductListModel]()
    var dataProductListModel = [ProductListModel]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initView()
        self.createSelectTypeTableView()
        self.createTableView()
        self.requestData()
        self.createShoppingCardView()
        // Do any additional setup after loading the view.
    }

    func initView() {
        
        self.title = self.merchTitle
        
        let selectTpyeButtonItem : UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "screen"), style: UIBarButtonItemStyle.Plain, target: self, action: Selector("selectType"))
        
        self.navigationItem.rightBarButtonItem = selectTpyeButtonItem
    }
    
    func createTableView() {
        
        self.tableView = UITableView(frame: CGRectMake(0, 0, screenWidth, screenHeight))
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.backgroundColor = shrbTableViewColor
        self.tableView.tableFooterView = UIView(frame: CGRectMake(0,screenHeight-49,screenWidth,49))
        self.view.addSubview(self.tableView)
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
                self.tableView.reloadData()
                self.selectTypeTableView.reloadData()
                
                let delayInSeconds : Double = 1.0
                let popTime : dispatch_time_t = dispatch_time(DISPATCH_TIME_NOW, Int64(delayInSeconds * Double(NSEC_PER_SEC)))
                dispatch_after(popTime, dispatch_get_main_queue(), { () -> Void in
                        SVProgressShow.showSuccessWithStatus("加载完成!")
                })
        }
        
    }
    
    func createShoppingCardView() {
        
        self.shoppingCardView = UIView(frame: CGRectMake(0, screenHeight-49, screenWidth, 49))
        
        self.shoppingCardView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.67)
        self.view.addSubview(self.shoppingCardView)
        
        self.shoppingCardImageView = UIImageView(frame: CGRectMake(12, 12, 25, 25))
        self.shoppingCardImageView.image = UIImage(named: "shoppingCardPink")
        self.shoppingCardView.addSubview(self.shoppingCardImageView)
        
        self.shoppingNumLabel = ShoppingNumLabel(frame: CGRectMake(self.shoppingCardImageView.frame.origin.x + self.shoppingCardImageView.frame.size.width + 4 , 14, 20 , 21 ))
        self.shoppingNumLabel.mySetNum(0)
        self.shoppingCardView.addSubview(self.shoppingNumLabel)
        self.shoppingNumLabel.sizeToFit()
        
        self.priceLabel = UILabel(frame: CGRectMake(self.shoppingNumLabel.frame.origin.x + self.shoppingNumLabel.frame.size.width + 4 , 14, 100 , 21 ))
        self.priceLabel.text = "￥7500"
        self.priceLabel.textColor = UIColor.whiteColor()
        self.priceLabel.sizeToFit()
        self.shoppingCardView.addSubview(self.priceLabel)
        
        self.shoppingLineImageView = UIImageView(frame: CGRectMake(self.priceLabel.frame.origin.x + self.priceLabel.frame.size.width + 4 , 8, 1 , 33 ))
        self.shoppingLineImageView.backgroundColor = UIColor(red: 167.0/255.0, green: 167.0/255.0, blue: 167.0/255.0, alpha: 1)
        self.shoppingCardView.addSubview(self.shoppingLineImageView)
        
        self.shoppingFixLabel = UILabel(frame: CGRectMake(self.shoppingLineImageView.frame.origin.x + self.shoppingLineImageView.frame.size.width + 4 , 2, 20 , 21 ))
        self.shoppingFixLabel.text = "订单将保留"
        self.shoppingFixLabel.font = font15
        self.shoppingFixLabel.textColor = UIColor.whiteColor()
        self.shoppingFixLabel.sizeToFit()
        self.shoppingCardView.addSubview(self.shoppingFixLabel)
        
        
        self.countDownLabel = UILabel(frame: CGRectMake(self.shoppingFixLabel.frame.origin.x , self.shoppingFixLabel.frame.origin.y + self.shoppingFixLabel.frame.size.height + 2, self.shoppingFixLabel.frame.size.width , 21 ))
        self.countDownLabel.text = "20:00"
        self.countDownLabel.textAlignment = .Center
        self.countDownLabel.center = CGPointMake(self.shoppingFixLabel.frame.origin.x + self.shoppingFixLabel.frame.size.width/2,30)
        self.countDownLabel.textColor = UIColor.whiteColor()
        self.shoppingCardView.addSubview(self.countDownLabel)

        
        self.gotoPayBtn = UIButton(frame: CGRectMake(screenWidth-100,6,80,37))
        self.gotoPayBtn.setTitle("结算", forState: UIControlState.Normal)
        self.gotoPayBtn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        self.gotoPayBtn.backgroundColor = shrbPink
        self.shoppingCardView.addSubview(self.gotoPayBtn)
    }

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if tableView == self.selectTypeTableView {
            return 44
        }
        else {
            if indexPath.section == 0 {
                return 44
            }
            else {
                return isIphone4s ? 110 : 100
            }
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if tableView != self.selectTypeTableView {
            return (self.selectProductListModel.count + 1)
        }
        return 1
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if tableView != self.selectTypeTableView {
            if section == 0 {
                return ""
            }
            return self.selectProductListModel[section-1].typeName
        }
        else {
            return ""
        }
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if tableView != self.selectTypeTableView {
            return section == 0 ? 0 : 30
        }
        else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let height : CGFloat!
        let headerView : UIView = UIView()
        headerView.backgroundColor = shrbSectionColor
        
        if tableView != self.selectTypeTableView {
            height = section == 0 ? 0 : 30
            let label = UILabel(frame: CGRectMake(10,(height-18)*0.5,tableView.bounds.size.width-10,18))
            label.textColor = shrbText
            label.backgroundColor = UIColor.clearColor()
            headerView.addSubview(label)
            label.text = section == 0 ? "" : self.selectProductListModel[section-1].typeName
            
            headerView.frame = CGRectMake(0,0,tableView.bounds.size.width,height)
            return headerView
        }
        else {
            height = 0
            
            headerView.frame = CGRectMake(0,0,tableView.bounds.size.width,height)
            return headerView
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.selectTypeTableView {
            return (self.dataProductListModel.count+1)
        }
        else {
            return section == 0 ? 1 : self.selectProductListModel[section-1].prodList.count
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if tableView == self.selectTypeTableView {
            tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cellId")
            let cell = tableView.dequeueReusableCellWithIdentifier("cellId", forIndexPath: indexPath) as UITableViewCell
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            
            cell.textLabel?.text = indexPath.row == 0 ? "全部类别":self.dataProductListModel[indexPath.row-1].typeName
            
            cell.textLabel?.textColor = shrbText
            
            return cell

        }
        else {
            if indexPath.section == 0 {
                tableView.registerNib(UINib(nibName: "DeskNumTableViewCell", bundle: nil), forCellReuseIdentifier: "DeskNumTableViewCellId")
                let cell = tableView.dequeueReusableCellWithIdentifier("DeskNumTableViewCellId", forIndexPath: indexPath) as! DeskNumTableViewCell
                
                cell.selectionStyle = UITableViewCellSelectionStyle.None
                return cell
            }
            else {
                tableView.registerNib(UINib(nibName: "orderTableViewCell", bundle: nil), forCellReuseIdentifier: "orderTableViewCellId")
                let cell = tableView.dequeueReusableCellWithIdentifier("orderTableViewCellId", forIndexPath: indexPath) as! orderTableViewCell
                
                cell.selectionStyle = UITableViewCellSelectionStyle.None
                
                cell.tradeNameLabel.text = self.selectProductListModel[indexPath.section-1].prodList[indexPath.row].prodName as String
                cell.tradeImageView.sd_setImageWithURL(NSURL(string: self.selectProductListModel[indexPath.section-1].prodList[indexPath.row].imgUrl)!, placeholderImage: UIImage(named: "热点无图片"))
                cell.tradeDescriptionLabel.text = self.selectProductListModel[indexPath.section-1].prodList[indexPath.row].prodDesc!
                
                cell.priceLabel.text = String(format: "￥%.2f 原价￥%.2f", self.selectProductListModel[indexPath.section-1].prodList[indexPath.row].vipPrice!, self.selectProductListModel[indexPath.section-1].prodList[indexPath.row].price!)
                
                cell.amountTextField.hidden = true
                cell.moneyLabel.hidden = true
                
                let numbutton : HJCAjustNumButton = HJCAjustNumButton()
                numbutton.frame = CGRectMake(screenWidth-40,isIphone4s ? 40 : 35 , 30, 30)
                numbutton.callBack = { currentNum in
                    
                    print(currentNum)
                    
                    if self.shoppingArray.count == 0 {
                        let shoppingCardDataItem : ShoppingCardDataItem = ShoppingCardDataItem()
                        shoppingCardDataItem.count = NSInteger(currentNum)
                     //   shoppingCardDataItem.prodList = self.selectProductListModel[indexPath.section-1].prodList[indexPath.row]
                        
                        
                        
                    }
                    
                }
                cell.addSubview(numbutton)
                
                return cell
                
            }
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if tableView == self.selectTypeTableView {
            self.showSelectTypeTabelView = !self.showSelectTypeTabelView
            UIView.animateWithDuration(0.5, delay: 0, options: UIViewAnimationOptions.CurveEaseIn, animations: { () -> Void in
                self.selectTypeTableView.layer.transform = CATransform3DIdentity
                self.selectTypeTableViewBackView.backgroundColor = UIColor.clearColor()
                
                }) { (finished : Bool) -> Void in
                    
                    self.selectTypeTableViewBackView.hidden = true
                    
                    let myPath : NSIndexPath = NSIndexPath(forRow: 0, inSection: indexPath.row)
                    self.tableView.selectRowAtIndexPath(myPath, animated: true, scrollPosition: UITableViewScrollPosition.Top)
            }

        }
        else {
            if (indexPath.section == 0 ){
                return
            }
            else {
                DeskNumTableViewCell.shareDeskNumTableViewCell().deskTextFieldResignFirstResponder()
            }
        }
        
    }
    
    
    func selectType() {
        
        self.showSelectTypeTabelView = !self.showSelectTypeTabelView
        if self.showSelectTypeTabelView {
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
