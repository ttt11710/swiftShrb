//
//  CouponsDetailReceiveTableViewCell.swift
//  swiftShrb
//
//  Created by PayBay on 15/10/28.
//  Copyright © 2015年 PayBay. All rights reserved.
//

import UIKit

class CouponsDetailReceiveTableViewCell: UITableViewCell {

    @IBOutlet weak var redPacketImageView: UIImageView!
    @IBOutlet weak var couponsImageView: UIImageView!
    @IBOutlet weak var moneyLabel: UILabel!
    @IBOutlet weak var expirationDateLabel: UILabel!
    @IBOutlet weak var countLabel: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
