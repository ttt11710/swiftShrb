//
//  OrderChoosePayTableViewCell.swift
//  swiftShrb
//
//  Created by PayBay on 15/10/27.
//  Copyright © 2015年 PayBay. All rights reserved.
//

import UIKit

class OrderChoosePayTableViewCell: UITableViewCell {

    @IBOutlet weak var payTypeLogo: UIImageView!
    @IBOutlet weak var payTypeName: UILabel!
    @IBOutlet weak var payRuleLabel: UILabel!
    @IBOutlet weak var payTypeChooseBtn: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.payTypeChooseBtn.userInteractionEnabled = false
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
