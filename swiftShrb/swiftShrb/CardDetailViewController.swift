//
//  CardDetailViewController.swift
//  swiftShrb
//
//  Created by PayBay on 15/10/19.
//  Copyright © 2015年 PayBay. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SDWebImage

class SectionModel : NSObject {
    var flag : Bool = true
    var sectionDataMutableArray : NSMutableArray = []
}

class SectionHeaderView: UIView {
    var imageView : UIImageView!
    var titleLabel : UILabel!
    var flag : Bool!
    var bottomLineView : UIView!
    
    var number : Int! = 0
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.whiteColor()
        self.imageView = UIImageView(image: UIImage(named: "back_normal.png"))
        self.imageView.frame = CGRectMake(self.frame.size.width-25, 15, 15, self.frame.size.height - 25)
        self.addSubview(self.imageView)
        
        self.titleLabel = UILabel(frame: CGRectMake(18, 0, self.frame.size.width-100, self.frame.size.height))
        self.titleLabel.textColor = shrbText
        self.addSubview(self.titleLabel)
        
        self.bottomLineView = UIView(frame: CGRectMake(16, self.frame.size.height-1, self.frame.size.width, 1))
        self.bottomLineView.backgroundColor = shrbTableViewColor
        self.addSubview(self.bottomLineView)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setFlag(flag : Bool) {
        if !flag {
            UIView.animateWithDuration(0.25, delay: 0, options: UIViewAnimationOptions.CurveEaseIn, animations: { () -> Void in
                self.imageView.layer.transform = CATransform3DIdentity
                }, completion: { (finished : Bool) -> Void in
                    
            })
        }
        else {
            UIView.animateWithDuration(0.25, delay: 0, options: UIViewAnimationOptions.CurveEaseIn, animations: { () -> Void in
                self.imageView.layer.transform = CATransform3DMakeRotation(-180*3.1415926/180.0, 0, 0, 1)
                }, completion: { (finished : Bool) -> Void in
                    
            })
            
        }
        
    }
    
    override func layoutSubviews() {
        self.imageView.frame = CGRectMake(self.frame.size.width-25, 15, 15, self.frame.size.height - 25)
        self.titleLabel.frame = CGRectMake(18, 0, self.frame.size.width-100, self.frame.size.height)
        self.bottomLineView.frame = CGRectMake(16, self.frame.size.height-1, self.frame.size.width, 1)
 
    }

}


class CardDetailViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    
    var cardNo : String! = ""
    var merchId : String! = ""
    var dataMutableArray : NSMutableArray! = []
    var rowDataMutableArray : NSMutableArray! = []
    var memberRuleArray : NSMutableArray! = []
    var integralRuleArray : NSMutableArray! = []
    
     var cardInfoModel : CardInfoModel!
    
    
    var tableView : UITableView!
    var payBtn : UIButton!
    var voucherBtn : UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "会员卡详情"
        self.view.backgroundColor = shrbTableViewColor
        self.requestData()
        self.creatTableView()
        self.creatBtn()
        self.initData()
        
        // Do any additional setup after loading the view.
    }
    
    func requestData() {
        
        SVProgressShow.showWithStatus("加载中...")
        
        //http://121.40.222.162:8080/tongbao/card/v1.0/findCardDetail?&cardNo=1441780304974&merchId=201508111544260856&token=a58aca31642dfe555757a6b4943d9a6b&userId=1441591396095000842
        Alamofire.request(.GET, baseUrl + "/card/v1.0/findCardDetail?", parameters: ["token":CurrentUser.user?.token == nil ? "" : CurrentUser.user!.token,"userId":CurrentUser.user?.userId == nil ? "" : CurrentUser.user!.userId,"merchId":self.merchId,"cardNo":self.cardNo])
            
            .response { request, response, data, error in
                
                if error == nil {
                    let json  = JSON(data: data!)
                    
                    self.cardInfoModel = CardInfoModel(json: RequestDataTool.processingDataMes(json)["data"])
                    
                }
                else {
                    SVProgressShow.showErrorWithStatus("请求失败!")
                }
                SVProgressShow.dismiss()
                self.tableView.reloadData()
                
        }

    }
    
    func creatTableView() {
        
        self.tableView = UITableView(frame: CGRectMake(0, 0, screenWidth, screenHeight-44))
        self.tableView.tableFooterView = UIView()
        self.tableView.separatorStyle = .SingleLine
        self.tableView.tableFooterView = UIView(frame: CGRectMake(0, 0, screenWidth, 80))
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.backgroundColor = shrbTableViewColor
        self.view.addSubview(self.tableView)
    }
    
    func creatBtn() {
        self.payBtn = UIButton(type: .Custom)
        self.payBtn.frame = CGRectMake(0, screenHeight-44, screenWidth/2, 44)
        self.payBtn.backgroundColor = shrbPink
        self.payBtn.setTitle("扫码支付", forState: .Normal)
        self.payBtn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        self.payBtn.addTarget(self, action: Selector("goToQRView"), forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(self.payBtn)
        
        
        self.voucherBtn = UIButton(type: .Custom)
        self.voucherBtn.frame = CGRectMake(screenWidth/2+1, screenHeight-44, screenWidth/2-1, 44)
        self.voucherBtn.backgroundColor = shrbPink
        self.voucherBtn.setTitle("充值", forState: .Normal)
        self.voucherBtn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        self.voucherBtn.addTarget(self, action: Selector("goVoucherCenterBtn"), forControlEvents: UIControlEvents.TouchUpInside)

        self.view.addSubview(self.voucherBtn)
    }
    
    
    func initData() {
        
        self.rowDataMutableArray = ["会员规则\n1、会员卡注册不需缴纳任何费用。\n2、针对不同商家使用同一张会员卡，但优惠金额由商家决定。\n3、会员卡注销时需缴纳余额5%的手续费，且注销后不再享受会员优惠。","积分规则\n1、免费注册会员，即刻赠送20积分。\n2、成功交易一笔订单可获得积分，不同商品积分标准不同。\n3、消费时可使用积分抵消现金，不同商品使用标准不同。"]
        self.memberRuleArray = ["会员规则\n1、会员卡注册不需缴纳任何费用。\n2、针对不同商家使用同一张会员卡，但优惠金额由商家决定。\n3、会员卡注销时需缴纳余额5%的手续费，且注销后不再享受会员优惠。"]
        
        self.integralRuleArray = ["积分规则\n1、免费注册会员，即刻赠送20积分。\n2、成功交易一笔订单可获得积分，不同商品积分标准不同。\n3、消费时可使用积分抵消现金，不同商品使用标准不同。"]
        
        for i in 0..<2 {
            
            let sectionModel = SectionModel()
            sectionModel.flag = false
            
            for j in 0..<1 {
                if i == 0 {
                    sectionModel.sectionDataMutableArray.addObject(self.memberRuleArray[0])
                }
                else {
                    sectionModel.sectionDataMutableArray.addObject(self.integralRuleArray[0])
                }
            }
            self.dataMutableArray.addObject(sectionModel)
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return screenWidth/170*90 + 32
        }
        else if indexPath.section == 3 {
            return 44
        }
        else {
            let label = UILabel(frame: CGRectMake(0, 0, screenWidth-16, screenHeight))
            label.numberOfLines = 0
            label.font = font15
            label.text = self.rowDataMutableArray[indexPath.section-1] as? String
            label.sizeToFit()
            
            return label.frame.size.height + 32
        }
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return (section == 0 || section == 3) ? 0 : 44
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if self.cardInfoModel != nil {
            
            if section == 1 || section == 2 {
                let sectionHeaderView = SectionHeaderView(frame: CGRectMake(0, 0, screenWidth, 44))
                sectionHeaderView.tag = section-1
                
                if section == 1 {
                    sectionHeaderView.titleLabel.text =  String(format: "金额:￥%.2f", self.cardInfoModel.amount)
                }
                else {
                    sectionHeaderView.titleLabel.text = String(format: "积分:%.0f分", self.cardInfoModel.score)
                }
                
                let sectionModel : SectionModel = self.dataMutableArray[section-1] as! SectionModel
                sectionHeaderView.flag = sectionModel.flag
                let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: Selector("sectionClick:"))
                sectionHeaderView.addGestureRecognizer(tapGestureRecognizer)
                
                return sectionHeaderView
                
            }
        }
        return nil
    }
    
    func sectionClick( tapGestureRecognizer : UITapGestureRecognizer) {
        var sectionHeaderView = SectionHeaderView(frame: CGRectMake(0, 0, screenWidth, 44))
        sectionHeaderView = tapGestureRecognizer.view as! SectionHeaderView
       
        let sectionModel : SectionModel = self.dataMutableArray[sectionHeaderView.tag] as! SectionModel
        sectionModel.flag = !(sectionModel.flag)
        sectionHeaderView.flag = sectionModel.flag
        sectionHeaderView.setFlag(sectionHeaderView.flag)
        let indexPathsMutableArray = NSMutableArray()
        for i in 0..<sectionModel.sectionDataMutableArray.count {
            let indexPath = NSIndexPath(forRow: i, inSection: sectionHeaderView.tag+1)
            indexPathsMutableArray.addObject(indexPath)
        }
        
        let indexPathsArray : NSArray = indexPathsMutableArray.copy() as! NSArray
        if sectionModel.flag {
            self.tableView.insertRowsAtIndexPaths(indexPathsArray as! [NSIndexPath], withRowAnimation: .Automatic)
        }
        else {
            self.tableView.deleteRowsAtIndexPaths(indexPathsArray as! [NSIndexPath], withRowAnimation: .Automatic)
        }
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 3:
            return 2
        default:
            let sectionModel : SectionModel = self.dataMutableArray.objectAtIndex(section-1) as! SectionModel
            if sectionModel.flag {
                return sectionModel.sectionDataMutableArray.count
            }
            else {
                return 0
            }
        }
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return section == 0 ? 1 : 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            tableView.registerNib(UINib(nibName: "CardDetailTableViewCell", bundle: nil), forCellReuseIdentifier: "CardDetailTableViewCellId")
            let cell = tableView.dequeueReusableCellWithIdentifier("CardDetailTableViewCellId", forIndexPath: indexPath) as! CardDetailTableViewCell
            
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            
            cell.backgroundColor = shrbTableViewColor
            if self.cardInfoModel != nil {
                cell.cardBackImageView.sd_setImageWithURL(NSURL(string: self.cardInfoModel.cardImgUrl as String), placeholderImage: UIImage(named: "cardBack"))
                cell.merchNameLabel.text = self.cardInfoModel.merchName
                
                let string : String = String(format: "金额:￥%.2f", self.cardInfoModel.amount)
                let attrString : NSMutableAttributedString = NSMutableAttributedString(string: string)
                
                attrString.addAttribute(NSForegroundColorAttributeName, value:UIColor(red: 255.0/255.0, green: 212.0/255.0, blue: 0.0/255.0, alpha: 1), range: NSMakeRange(3, string.characters.count-3))
                
                attrString.addAttribute(NSFontAttributeName, value: UIFont.systemFontOfSize(18), range: NSMakeRange(0, 3))
                attrString.addAttribute(NSFontAttributeName, value: UIFont.systemFontOfSize(24), range: NSMakeRange(3, string.characters.count-3))
                cell.amountLabel.attributedText = attrString
                
                let integralString : String = String(format: "积分:%.0f", self.cardInfoModel.score)
                let integralAttrString : NSMutableAttributedString = NSMutableAttributedString(string: integralString)
                
                integralAttrString.addAttribute(NSForegroundColorAttributeName, value:UIColor(red: 255.0/255.0, green: 212.0/255.0, blue: 0.0/255.0, alpha: 1), range: NSMakeRange(3, integralString.characters.count-3))
                
                integralAttrString.addAttribute(NSFontAttributeName, value: UIFont.systemFontOfSize(18), range: NSMakeRange(0, 3))
                integralAttrString.addAttribute(NSFontAttributeName, value: UIFont.systemFontOfSize(24), range: NSMakeRange(3, integralString.characters.count-3))
                cell.scoreLabel.attributedText = integralAttrString
                
                cell.cardNoLabel.text = String(format: "卡号:%@", self.cardInfoModel.cardNo)
            }
            
            return cell

        }
        else if indexPath.section == 3 {
            tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cellId")
            let cell = tableView.dequeueReusableCellWithIdentifier("cellId", forIndexPath: indexPath) as UITableViewCell
            
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            cell.accessoryType = .DisclosureIndicator
            
            switch indexPath.row {
            case 0:
                cell.textLabel?.text = "交易记录"
            default:
                cell.textLabel?.text = "适用门店电话及地址"
            }
            cell.textLabel?.textColor = shrbText
            
            return cell

        }
        else {
            tableView.registerNib(UINib(nibName: "AutoresizeLabelTableViewCell", bundle: nil), forCellReuseIdentifier: "AutoresizeLabelTableViewCellId")
            let cell = tableView.dequeueReusableCellWithIdentifier("AutoresizeLabelTableViewCellId", forIndexPath: indexPath) as! AutoresizeLabelTableViewCell
            
            cell.selectionStyle = UITableViewCellSelectionStyle.None
           
            let sectionModel : SectionModel = self.dataMutableArray[indexPath.section-1] as! SectionModel
            
            cell.autoresizeLabel.text = sectionModel.sectionDataMutableArray[indexPath.row] as? String
            
            cell.backgroundColor = shrbTableViewColor
            return cell

        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    
        if indexPath.section == 3 && indexPath.row == 0 {
            let tradingRecordViewController = TradingRecordViewController()
            tradingRecordViewController.cardNo = self.cardNo
            self.navigationController?.pushViewController(tradingRecordViewController, animated: true)
        }
    }
    
    func goToQRView() {
        
        
       
        if self.validateCamera() {
            
            let payQRViewController = PayQRViewController()
            payQRViewController.merchId = self.merchId
            self.navigationController?.pushViewController(payQRViewController, animated: true)
            
        }
        else {
            
            let alertController = UIAlertController(title: "提示", message: "没有摄像头或摄像头不可用", preferredStyle: UIAlertControllerStyle.Alert)
            let okAction = UIAlertAction(title: "确定", style: UIAlertActionStyle.Default, handler: nil)
            alertController.addAction(okAction)
            self.presentViewController(alertController, animated: true, completion: nil)
            
        }

    }
    
    func validateCamera() -> Bool{
        return UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera) && UIImagePickerController.isCameraDeviceAvailable(UIImagePickerControllerCameraDevice.Rear)
    }
    
    func goVoucherCenterBtn() {
        UserDefaultsSaveInfo.userDefaultsStandardUserDefaultsObject("viewControllers[0]", keyString: "QRPay")
        
        let voucherCenterViewController = VoucherCenterViewController()
        voucherCenterViewController.cardInfoModel = self.cardInfoModel
        voucherCenterViewController.merchId = self.merchId
        self.navigationController?.pushViewController(voucherCenterViewController, animated: true)
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
