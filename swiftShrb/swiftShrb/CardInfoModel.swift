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
    var merchTitle : String!
    var merchId : String!
    
    init(json :JSON) {
        score = json["scode"].floatValue
        amount = json["amount"].floatValue
        cardNo = json["cardNo"].stringValue
        merchName = json["merchName"].stringValue
        cardImgUrl = json["cardImgUrl"].stringValue
        merchTitle = json["merchTitle"].stringValue
        merchId = json["merchId"].stringValue
    }
    class func cardInfoModel(json:JSON) -> [CardInfoModel] {
        
        return json["data"].arrayValue.map{CardInfoModel(json: $0)}
    }

}
