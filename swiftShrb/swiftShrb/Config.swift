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


let isIos8 = Float(UIDevice.currentDevice().systemVersion) >= 8.0

let isIphone4s = UIScreen.mainScreen().bounds.size.width <= 320

//font

let font14 = UIFont.systemFontOfSize(14.0)
let font15 = UIFont.systemFontOfSize(15.0)
let font16 = UIFont.systemFontOfSize(16.0)
let font17 = UIFont.systemFontOfSize(17.0)
let font18 = UIFont.systemFontOfSize(18.0)
let font20 = UIFont.systemFontOfSize(20.0)


let shrbPink = UIColor(red: 235.0/255.0, green: 75.0/255.0, blue: 75.0/255.0, alpha: 1)
let shrbTableViewColor = UIColor(red: 240.0/255.0, green: 240.0/255.0, blue: 240.0/255.0, alpha: 1)
let shrbText = UIColor(red: 78.0/255.0, green: 78.0/255.0, blue: 78.0/255.0, alpha: 1)
let shrbLightText = UIColor(red: 154.0/255.0, green: 154.0/255.0, blue: 154.0/255.0, alpha: 1)
let shrbLightCell = UIColor(red: 242.0/255.0, green: 242.0/255.0, blue: 242.0/255.0, alpha: 1)
let shrbSectionColor = UIColor(red: 220.0/255.0, green: 220.0/255.0, blue: 220.0/255.0, alpha: 1)

let deviceIs7 = (UIDevice.currentDevice().systemVersion as NSString).floatValue>=7.0 ? true : false

let baseUrl = "http://121.40.222.162:8080/tongbao"
