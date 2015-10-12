//
//  SupermarketCollectionViewCell.swift
//  swiftShrb
//
//  Created by PayBay on 15/10/8.
//  Copyright © 2015年 PayBay. All rights reserved.
//

import UIKit

class SupermarketCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var tradeImageView: UIImageView!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var vipPriceLabel: UILabel!
    @IBOutlet weak var prodNameLabel: UILabel!
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        // Initialization code
    }

}
