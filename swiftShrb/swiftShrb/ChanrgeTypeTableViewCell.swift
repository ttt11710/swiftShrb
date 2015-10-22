//
//  ChanrgeTypeTableViewCell.swift
//  swiftShrb
//
//  Created by PayBay on 15/10/21.
//  Copyright © 2015年 PayBay. All rights reserved.
//

import UIKit

class ChanrgeTypeTableViewCell: UITableViewCell {

    @IBOutlet weak var chanrgeTypNameLabel: UILabel!
    @IBOutlet weak var chanrgeTypBtn: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.chanrgeTypBtn.setImage(UIImage(named: "payUncheck"), forState: UIControlState.Normal)
        self.chanrgeTypBtn.setImage(UIImage(named: "paycheck"), forState: UIControlState.Selected)
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
