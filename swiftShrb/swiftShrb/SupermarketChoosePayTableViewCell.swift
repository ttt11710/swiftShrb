//
//  SupermarketChoosePayTableViewCell.swift
//  swiftShrb
//
//  Created by PayBay on 15/10/14.
//  Copyright © 2015年 PayBay. All rights reserved.
//

import UIKit

class SupermarketChoosePayTableViewCell: UITableViewCell {

    
    
    
    
     var payTypeBtn : UIButton!
     var payTypeLabelButton : UIButton!
    
    @IBOutlet weak var payViewCheckCouponsView: TNCheckBoxGroup!
    
    @IBOutlet weak var memberBtn: UIButton!
    @IBOutlet weak var memberLabelBtn: UIButton!
    
    @IBOutlet weak var alipayBtn: UIButton!
    @IBOutlet weak var alipayLabelBtn: UIButton!
    
    @IBOutlet weak var internetbankBtn: UIButton!
    @IBOutlet weak var internetbankLabelBtn: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
//        self.memberBtn.addTarget(self, action: Selector("payBtnPresed:"), forControlEvents: UIControlEvents.TouchUpInside)
//        self.alipayBtn.addTarget(self, action: Selector("payBtnPresed:"), forControlEvents: UIControlEvents.TouchUpInside)
//        self.internetbankBtn.addTarget(self, action: Selector("payBtnPresed:"), forControlEvents: UIControlEvents.TouchUpInside)
        
        self.memberBtn.setBackgroundImage(UIImage(named: "icon_checkpoint_empty"), forState: UIControlState.Normal)
        self.alipayBtn.setBackgroundImage(UIImage(named: "icon_checkpoint_empty"), forState: UIControlState.Normal)
        self.internetbankBtn.setBackgroundImage(UIImage(named: "icon_checkpoint_empty"), forState: UIControlState.Normal)
        
        self.memberBtn.setBackgroundImage(UIImage(named: "icon_checkpoint_selected"), forState: UIControlState.Selected)
        self.alipayBtn.setBackgroundImage(UIImage(named: "icon_checkpoint_selected"), forState: UIControlState.Selected)
        self.internetbankBtn.setBackgroundImage(UIImage(named: "icon_checkpoint_selected"), forState: UIControlState.Selected)
        
        
        self.memberLabelBtn.setTitleColor(shrbText, forState: .Normal)
        self.memberLabelBtn.setTitleColor(shrbPink, forState: .Selected)
        
        self.alipayLabelBtn.setTitleColor(shrbText, forState: .Normal)
        self.alipayLabelBtn.setTitleColor(shrbPink, forState: .Selected)
        
        self.internetbankLabelBtn.setTitleColor(shrbText, forState: .Normal)
        self.internetbankLabelBtn.setTitleColor(shrbPink, forState: .Selected)
        
        
        
        
        // Initialization code
    }
    
    @IBAction func payBtnPresed(var sender: UIButton) {
        
        if self.payTypeBtn == nil {
            sender.selected = true
            self.payTypeBtn = sender
        }
        else if self.payTypeBtn != nil && self.payTypeBtn == sender {
            sender.selected = true
        }
        else if self.payTypeBtn != sender && self.payTypeBtn != nil {
            self.payTypeBtn.selected = false
            sender.selected = true
            self.payTypeBtn = sender
        }
        
        switch sender.tag {
        case 0:
            sender = self.memberLabelBtn
            break
        case 1:
            sender = self.alipayLabelBtn
            break
        case 2:
            sender = self.internetbankLabelBtn
            break
        default:
            break
        }
        
        if self.payTypeLabelButton == nil {
            sender.selected = true
            self.payTypeLabelButton = sender
        }
        else if self.payTypeLabelButton != nil && self.payTypeLabelButton == sender {
            sender.selected = true
        }
        else if self.payTypeLabelButton != sender && self.payTypeLabelButton != nil {
            self.payTypeLabelButton.selected = false
            sender.selected = true
            self.payTypeLabelButton = sender
        }
        
        NSNotificationCenter.defaultCenter().postNotificationName(PAY_CHANGED, object: sender)
    }
    

    @IBAction func payLabelBtnPresed(var sender: UIButton) {
        
        if self.payTypeLabelButton == nil {
            sender.selected = true
            self.payTypeLabelButton = sender
        }
        else if self.payTypeLabelButton != nil && self.payTypeLabelButton == sender {
            sender.selected = true
        }
        else if self.payTypeLabelButton != sender && self.payTypeLabelButton != nil {
            
            self.payTypeLabelButton.selected = false
            sender.selected = true
            self.payTypeLabelButton = sender
        }
        
        switch sender.tag {
        case 0:
            sender = self.memberBtn
            break
        case 1:
            sender = self.alipayBtn
            break
        case 2:
            sender = self.internetbankBtn
            break
        default:
            break
        }
        
        if self.payTypeBtn == nil {
            sender.selected = true
            self.payTypeBtn = sender
        }
        else if self.payTypeBtn != nil && self.payTypeBtn == sender {
            sender.selected = true
        }
        else if self.payTypeBtn != sender && self.payTypeBtn != nil {
            self.payTypeBtn.selected = false
            sender.selected = true
            self.payTypeBtn = sender
        }
        
        NSNotificationCenter.defaultCenter().postNotificationName(PAY_CHANGED, object: sender)
        
        
    }
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}


let PAY_CHANGED = "groupChanged"

