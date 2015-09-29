//
//  MerchModel.swift
//  swiftShrb
//
//  Created by PayBay on 15/9/29.
//  Copyright © 2015年 PayBay. All rights reserved.
//

import UIKit
import SwiftyJSON

class MerchImglist : NSObject {
    var merchId : String!
    var imgUrl : String!
    var imgType : String!
    
    init(json:JSON ) {
        merchId = json["merchId"].stringValue
        imgUrl = json["imgUrl"].stringValue
        imgType = json["imgType"].stringValue
    }
    
    class func merchImglist(json:JSON) -> [MerchImglist] {
        
        return json["merchImglist"].arrayValue.map{MerchImglist(json: $0)}
    }
}

class MerchModel: NSObject {
    
    var merchDesc : String!
    var merchId : String!
    var cityCode : String!
    var showType : String!
    var merchName : String!
    var merchTitle : String!
    var merchImglist : [MerchImglist]
    
    init(json:JSON ) {
        merchDesc = json["merchDesc"].stringValue
        merchId = json["merchId"].stringValue
        cityCode = json["cityCode"].stringValue
        showType = json["showType"].stringValue
        merchName = json["merchName"].stringValue
        merchTitle = json["merchTitle"].stringValue
        merchImglist = MerchImglist.merchImglist(json)
    }
    class func merchModel(json:JSON) -> [MerchModel] {
    
        return json["merchList"].arrayValue.map{MerchModel(json: $0)}
    }
}
