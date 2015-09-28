//
//  Config.swift
//  swiftShrb
//
//  Created by PayBay on 15/9/28.
//  Copyright © 2015年 PayBay. All rights reserved.
//

import Foundation
import UIKit


let screenWidth = UIScreen.mainScreen().bounds.size.width
let screenHeight = UIScreen.mainScreen().bounds.size.height


let shrbPink = UIColor(red: 235.0/255.0, green: 75.0/255.0, blue: 75.0/255.0, alpha: 1)

let shrbTableViewColor = UIColor(red: 240.0/255.0, green: 240.0/255.0, blue: 240.0/255.0, alpha: 1)

let deviceIs7 = (UIDevice.currentDevice().systemVersion as NSString).floatValue>=7.0 ? true : false

let baseUrl = "http://121.40.222.162:8080/tongbao"
