//
//  RequestDataTool.swift
//  swiftShrb
//
//  Created by PayBay on 15/10/8.
//  Copyright © 2015年 PayBay. All rights reserved.
//

import UIKit
import SwiftyJSON


class RequestDataTool: NSObject {
    
    class func processingData(json : JSON ) ->JSON {
        
        switch json["code"].intValue
        {
        case 200:
            return json
        case 404,500,501,502,503:
            SVProgressShow.showErrorWithStatus(json["msg"].stringValue ?? "加载失败")
            return nil
        default:
            SVProgressShow.showErrorWithStatus(json["msg"].stringValue)
            return nil
        }
    }

    
    class func processingDataMes(json : JSON) ->JSON {
        
        switch json["code"].intValue
        {
        case 200:
            return json
        case 404,503:
            SVProgressShow.showErrorWithStatus(json["mes"].stringValue ?? "加载失败")
            return nil
        default:
            SVProgressShow.showErrorWithStatus(json["mes"].stringValue)
            return nil
        }
    }

    
}


