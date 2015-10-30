//
//  OrderFinishTableViewCell.swift
//  swiftShrb
//
//  Created by PayBay on 15/10/28.
//  Copyright © 2015年 PayBay. All rights reserved.
//

import UIKit

class OrderFinishTableViewCell: UITableViewCell {

    @IBOutlet weak var storeLogoImageView: UIImageView!
    @IBOutlet weak var storeNameLabel: UILabel!
    @IBOutlet weak var stateLabel: UILabel!
    @IBOutlet weak var orderImageView: UIImageView!
    @IBOutlet weak var orderNum: UILabel!
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var moneyLabel: UILabel!
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
