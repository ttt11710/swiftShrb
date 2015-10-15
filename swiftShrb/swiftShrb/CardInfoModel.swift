//
//  CardInfoModel.swift
//  swiftShrb
//
//  Created by PayBay on 15/10/15.
//  Copyright © 2015年 PayBay. All rights reserved.
//

import UIKit
import SwiftyJSON

class CardInfoModel: NSObject {

    var score : Float!
    var amount : Float!
    var cardNo : String!
    var merchName : String!
    var cardImgUrl : String!
    
    init(json :JSON) {
        score = json["scode"].floatValue
        amount = json["amount"].floatValue
        cardNo = json["cardNo"].stringValue
        merchName = json["merchName"].stringValue
        cardImgUrl = json["cardImgUrl"].stringValue
    }
}
