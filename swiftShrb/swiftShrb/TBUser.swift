//
//  TBUser.swift
//  swiftShrb
//
//  Created by PayBay on 15/10/8.
//  Copyright © 2015年 PayBay. All rights reserved.
//

import UIKit
import SwiftyJSON

class TBUser: NSObject,NSCoding {
    
    var userId : String = ""
    var userName : String = ""
    var imgUrl : String = ""
    var token : String = ""
    
    
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(userId, forKey: "userId")
        aCoder.encodeObject(userName, forKey: "userName")
        aCoder.encodeObject(imgUrl, forKey: "imgUrl")
        aCoder.encodeObject(token, forKey: "token")
    }
    
    init(json : JSON) {
        userId = json["userId"].stringValue
        userName = json["userName"].stringValue
        imgUrl = json["imgUrl"].stringValue
        token = json["token"].stringValue
    }
    
    required init(coder aDecoder: NSCoder) {
        userId  = (aDecoder.decodeObjectForKey("userId") ?? "") as! String
        userName  = (aDecoder.decodeObjectForKey("userName") ?? "") as! String
        imgUrl = (aDecoder.decodeObjectForKey("imgUrl") ?? "") as! String
        token = (aDecoder.decodeObjectForKey("token") ?? "")as! String
        
    }
    
}

struct CurrentUser {
    static var user : TBUser? {
        set {
        let data = NSMutableData()
        let archiver = NSKeyedArchiver(forWritingWithMutableData: data)
        archiver.encodeObject(newValue, forKey: "TBUser")
        archiver.finishEncoding()
        NSUserDefaults.standardUserDefaults().setValue(data, forKey: "TBUser")
        NSUserDefaults.standardUserDefaults().synchronize()
        }
        get {
            let data = NSUserDefaults.standardUserDefaults().valueForKey("TBUser") as! NSData?
            if let userData = data {
                let unarchiver = NSKeyedUnarchiver(forReadingWithData: userData)
                return unarchiver.decodeObjectForKey("TBUser") as? TBUser
            }
            else {
                return nil
            }
        }
    }
}































