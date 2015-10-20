//
//  AutoresizeLabelTableViewCell.swift
//  swiftShrb
//
//  Created by PayBay on 15/10/20.
//  Copyright © 2015年 PayBay. All rights reserved.
//

import UIKit

class AutoresizeLabelTableViewCell: UITableViewCell {

    @IBOutlet weak var autoresizeLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
