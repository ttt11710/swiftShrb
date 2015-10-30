//
//  UserDefaultsSaveInfo.swift
//  swiftShrb
//
//  Created by PayBay on 15/10/14.
//  Copyright © 2015年 PayBay. All rights reserved.
//

import UIKit

class UserDefaultsSaveInfo: NSObject {

   class func userDefaultsStandardUserDefaultsObject(setobjectString : String, keyString : String) {
    
        NSUserDefaults.standardUserDefaults().removeObjectForKey(keyString)
        NSUserDefaults.standardUserDefaults().setObject(setobjectString, forKey: keyString)
    }
    
    class func userDefaultsStandardUserDefaultsInteger(setInteger : NSInteger, keyInteger : String) {
        
        NSUserDefaults.standardUserDefaults().removeObjectForKey(keyInteger)
        NSUserDefaults.standardUserDefaults().setInteger(setInteger, forKey: keyInteger)    }
    
    
    class func userDefaultsStandardUserDefaultsDouble(setDouble : Double, keyDouble : String) {
        
        NSUserDefaults.standardUserDefaults().removeObjectForKey(keyDouble)
        NSUserDefaults.standardUserDefaults().setDouble(setDouble, forKey: keyDouble)
    }

}
