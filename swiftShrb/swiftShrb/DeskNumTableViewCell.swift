//
//  DeskNumTableViewCell.swift
//  swiftShrb
//
//  Created by PayBay on 15/10/23.
//  Copyright © 2015年 PayBay. All rights reserved.
//

import UIKit


var defaultDeskNumTableViewCell : DeskNumTableViewCell!

class DeskNumTableViewCell: UITableViewCell,UITextFieldDelegate {

    @IBOutlet weak var deskTextField: UITextField!
    override func awakeFromNib() {
        super.awakeFromNib()
       
        defaultDeskNumTableViewCell = self
        self.deskTextField.delegate = self
        // Initialization code
    }
    class func shareDeskNumTableViewCell() -> DeskNumTableViewCell {
        return defaultDeskNumTableViewCell
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.deskTextField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if (touches as NSSet).anyObject()?.view != self.deskTextField {
            self.deskTextField.resignFirstResponder()
        }
    }


    func deskTextFieldResignFirstResponder() {
       self.deskTextField.resignFirstResponder()
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
