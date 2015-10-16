//
//  PasswordDataProcessing.swift
//  swiftShrb
//
//  Created by PayBay on 15/10/16.
//  Copyright © 2015年 PayBay. All rights reserved.
//

import UIKit

class PasswordDataProcessing: NSObject {
    
    class func resultPasswordData( password : String) ->Bool {
       
        let target : String = " "
        let str : String = password.stringByReplacingOccurrencesOfString(target, withString: "")
        var result : Bool = true
        if password.characters.count != str.characters.count {
            
            result = false
        }
        
        return result
    }

}
