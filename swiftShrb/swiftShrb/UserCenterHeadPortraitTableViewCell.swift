//
//  UserCenterHeadPortraitTableViewCell.swift
//  swiftShrb
//
//  Created by PayBay on 15/10/8.
//  Copyright © 2015年 PayBay. All rights reserved.
//

import UIKit

class UserCenterHeadPortraitTableViewCell: UITableViewCell {

    @IBOutlet weak var memberImageView: UIImageView!
    @IBOutlet weak var memberNumLabel: UILabel!
    @IBOutlet weak var loginBtn: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
