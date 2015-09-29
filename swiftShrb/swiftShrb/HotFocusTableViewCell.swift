//
//  HotFocusTableViewCell.swift
//  swiftShrb
//
//  Created by PayBay on 15/9/29.
//  Copyright © 2015年 PayBay. All rights reserved.
//

import UIKit

class HotFocusTableViewCell: UITableViewCell {

    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var hotImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
