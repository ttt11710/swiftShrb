//
//  CardTradeRecordsModel.swift
//  swiftShrb
//
//  Created by PayBay on 15/10/20.
//  Copyright © 2015年 PayBay. All rights reserved.
//

import UIKit
import SwiftyJSON


class CardTradeRecordsModel: NSObject {
    
    var payAmount : Float!
    var consumeID : String!
    var merchName : String!
    var orderID : String!
    var acceptTime : String!
    var address : String!
    
    init(json : JSON) {
        payAmount = json["payAmount"].floatValue
        consumeID = json["consumeID"].stringValue
        merchName = json["merchName"].stringValue
        orderID = json["orderID"].stringValue
        acceptTime = json["acceptTime"].stringValue
        address = json["address"].stringValue
    }
    
    class func cardTradeRecordsModel(json:JSON) -> [CardTradeRecordsModel] {
        
        return json["data"].arrayValue.map{CardTradeRecordsModel(json: $0)}
    }

}
