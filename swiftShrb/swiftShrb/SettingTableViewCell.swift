//
//  SettingTableViewCell.swift
//  swiftShrb
//
//  Created by PayBay on 15/10/16.
//  Copyright © 2015年 PayBay. All rights reserved.
//

import UIKit

class SettingTableViewCell: UITableViewCell {

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var myswitch: UISwitch!
    override func awakeFromNib() {
        super.awakeFromNib()
    self.myswitch.onTintColor = shrbPink
    }
    

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
