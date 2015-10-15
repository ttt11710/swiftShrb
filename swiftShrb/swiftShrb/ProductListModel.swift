//
//  ProductListModel.swift
//  swiftShrb
//
//  Created by PayBay on 15/10/9.
//  Copyright © 2015年 PayBay. All rights reserved.
//

import UIKit
import SwiftyJSON


class ProdList: NSObject {
    
    var prodId : String!
    var prodName : String!
    var prodDesc : String!
    var merchId : String!
    var typeId : String!
    var typeName : String!
    var price : Float!
    var vipPrice : Float!
    var imgUrl : String!
    
    init(json:JSON) {
        prodId = json["prodId"].stringValue
        prodName = json["prodName"].stringValue
        prodDesc = json["prodDesc"].stringValue
        merchId = json["merchId"].stringValue
        typeId = json["typeId"].stringValue
        typeName = json["typeName"].stringValue
        price = json["price"].floatValue
        vipPrice = json["vipPrice"].floatValue
        imgUrl = json["imgUrl"].stringValue
    }
    
    class func prodList(json : JSON) ->[ProdList] {
        return json["prodList"].arrayValue.map{ProdList(json: $0)}
    }
    
}

class ProductListModel: NSObject {

    var typeId : String!
    var typeName : String!
    var prodList : [ProdList]
    
    init(json : JSON) {
        typeId = json["typeId"].stringValue
        typeName = json["typeName"].stringValue
        prodList = ProdList.prodList(json)
    }
    
    class func productListModel(json : JSON) ->[ProductListModel] {
        return json["productList"].arrayValue.map{ProductListModel(json: $0)}
    }
    
}






















