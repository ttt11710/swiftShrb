//
//  CardDetailTableViewCell.swift
//  swiftShrb
//
//  Created by PayBay on 15/10/15.
//  Copyright © 2015年 PayBay. All rights reserved.
//

import UIKit

class CardDetailTableViewCell: UITableViewCell {

    
    

    @IBOutlet weak var cardBackView: UIView!
    @IBOutlet weak var cardBackImageView: UIImageView!
    @IBOutlet weak var merchNameLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var cardNoLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
