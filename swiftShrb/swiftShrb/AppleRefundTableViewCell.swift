//
//  AppleRefundTableViewCell.swift
//  swiftShrb
//
//  Created by PayBay on 15/10/28.
//  Copyright © 2015年 PayBay. All rights reserved.
//

import UIKit

class AppleRefundTableViewCell: UITableViewCell,UITextFieldDelegate,UITextViewDelegate {

    var returnCallBack:((String)->())?
    var callBack:((String)->())?
    
    @IBOutlet weak var returnGoodsReasonLabel: UILabel!
    @IBOutlet weak var moneyTextField: UITextField!
    @IBOutlet weak var explainTextView: UITextView!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.moneyTextField.delegate = self
        self.explainTextView.delegate = self
        
        let tap : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: Selector("chooseReturnGoodsReason"))
        self.returnGoodsReasonLabel.addGestureRecognizer(tap)
        self.returnGoodsReasonLabel.userInteractionEnabled = true
        
        // Initialization code
    }
    
    @IBAction func appleRefundBtnPressed(sender: AnyObject) {
        
        self.callBack!(self.moneyTextField.text!)
    }
    
     func textFieldDidBeginEditing(textField: UITextField) {
        let tableView : UITableView = self.superview!.superview as! UITableView
        tableView.setContentOffset(CGPointMake(0, tableView.contentSize.height-tableView.bounds.size.height), animated: true)
        UIView.animateWithDuration(0.2, delay: 0, options: UIViewAnimationOptions.CurveEaseIn, animations: { () -> Void in
            self.layer.transform = CATransform3DMakeTranslation(0, -100, 0)
            }) { (finished : Bool) -> Void in
                
        }
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        UIView.animateWithDuration(0.2, delay: 0, options: UIViewAnimationOptions.CurveEaseIn, animations: { () -> Void in
            self.layer.transform = CATransform3DIdentity
            }) { (finished : Bool) -> Void in
                
        }
    }
    
    func textViewDidBeginEditing(textView: UITextView) {
        if self.explainTextView.text == "   请输入原因最多不超过200字" {
            self.explainTextView.text = ""
        }
        
        let tableView : UITableView = self.superview!.superview as! UITableView
        tableView.setContentOffset(CGPointMake(0, tableView.contentSize.height-tableView.bounds.size.height), animated: true)
        UIView.animateWithDuration(0.2, delay: 0, options: UIViewAnimationOptions.CurveEaseIn, animations: { () -> Void in
            self.layer.transform = CATransform3DMakeTranslation(0, -200, 0)
            }) { (finished : Bool) -> Void in
                
        }
        
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        UIView.animateWithDuration(0.2, delay: 0, options: UIViewAnimationOptions.CurveEaseIn, animations: { () -> Void in
            self.layer.transform = CATransform3DIdentity
            }) { (finished : Bool) -> Void in
                
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.textFieldResignFirstResponder()
        return true
    }

    
    func textFieldResignFirstResponder() {
        self.moneyTextField.resignFirstResponder()
        self.explainTextView.resignFirstResponder()
    }

    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if (touches as NSSet).anyObject()?.view != self.moneyTextField || (touches as NSSet).anyObject()?.view != self.explainTextView {
            self.textFieldResignFirstResponder()
        }
    }
    

    func chooseReturnGoodsReason() {
        self.returnCallBack!("退货理由")
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
