//
//  VoucherAmoutTableViewCell.swift
//  swiftShrb
//
//  Created by PayBay on 15/10/21.
//  Copyright © 2015年 PayBay. All rights reserved.
//

import UIKit

class VoucherAmoutTableViewCell: UITableViewCell,UITextFieldDelegate {

    @IBOutlet weak var amountTextField: UITextField!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.amountTextField.delegate = self
        self.amountTextField.keyboardType = .NumberPad
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        if isIphone4s {
            let tableView : UITableView = self.superview?.superview as! UITableView
            tableView.setContentOffset(CGPointMake(0, tableView.contentSize.height - tableView.bounds.size.height-100), animated: true)
            UIView.animateWithDuration(0.2, delay: 0, options: UIViewAnimationOptions.CurveEaseIn, animations: { () -> Void in
                self.superview?.superview?.layer.transform = CATransform3DMakeTranslation(0, -100, 0)
                }, completion: { (finished : Bool) -> Void in
                    
            })
        }
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        if isIphone4s {
            UIView.animateWithDuration(0.25, delay: 0, options: UIViewAnimationOptions.CurveEaseIn, animations: { () -> Void in
                self.superview?.superview?.layer.transform = CATransform3DIdentity
                }, completion: { (finished : Bool) -> Void in
                    
            })
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.amountTextField.resignFirstResponder()
        return true
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
