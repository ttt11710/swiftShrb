//
//  orderTableViewCell.swift
//  swiftShrb
//
//  Created by PayBay on 15/10/14.
//  Copyright © 2015年 PayBay. All rights reserved.
//

import UIKit

class orderTableViewCell: UITableViewCell {

    @IBOutlet weak var tradeImageView: UIImageView!
    @IBOutlet weak var moneyLabel: UILabel!
    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var MemberLabel: UIImageView!
    @IBOutlet weak var tradeDescriptionLabel: UILabel!
    @IBOutlet weak var tradeNameLabel: UILabel!
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        
        self.tradeImageView.layer.cornerRadius = 10
        self.tradeImageView.layer.masksToBounds = true
        self.tradeImageView.layer.borderColor = shrbPink.CGColor
        self.tradeImageView.layer.borderWidth = 1
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
