//
//  UserInfoModel.swift
//  swiftShrb
//
//  Created by PayBay on 15/10/20.
//  Copyright © 2015年 PayBay. All rights reserved.
//

import UIKit
import SwiftyJSON

class UserInfoModel: NSObject {

    var userId : String!
    var password : String!
    var phone : String!
    var imgUrl : String!
    var email : String!
    var payPassword : String!
    
    init(json : JSON) {
        userId = json["userId"].stringValue
        password = json["password"].stringValue
        phone = json["phone"].stringValue
        imgUrl = json["imgUrl"].stringValue
        email = json["email"].stringValue
        payPassword = json["payPassword"].stringValue
    }

}
