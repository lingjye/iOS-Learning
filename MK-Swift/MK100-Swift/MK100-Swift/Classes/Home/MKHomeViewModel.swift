//
//  MKHomeViewModel.swift
//  MK100-Swift
//
//  Created by txooo on 2019/8/1.
//  Copyright © 2019 txooo. All rights reserved.
//

import UIKit
import SwiftyJSON
import HandyJSON

class MKHomeViewModel: MKBaseTableViewModel {
    
    var paramsName: String?
    var startTime: String?
    var endTime: String?
    var storeId = "0"
    open var model: MKHomeModel?
    
    
    override func tx_initialize() {
        paramsName = "Home"
        
        startTime = NSDate.todayDate()
        endTime = NSDate.dateFromTodayWithDays(days: -1)
    }
    
    override func tx_loadData() {
        print("Hello, Home", pageIndex)
        let urlString = HttpsPrefix + Index_GetIndexReportData
        let paramters = [ "startTime" : startTime,
                          "endTime" : endTime,
                          "storeid" : storeId
        ]
        
        MKRequestManager.shared.GET(urlString: urlString, parameters: paramters as [String : AnyObject]) { (result, error) in
            if (error != nil) {
                print(error!)
            } else {
                guard result!["success"].boolValue else {
                    return
                }
                self.model = MKHomeModel.deserialize(from: result?.description)
                
                // test
//                let ss: Dictionary = ["success":"true"]
//                let modl = MKHomeModel.deserialize(from: ss)
//
//                print(modl ?? "失败", modl?.success ?? "失败")
            }
        }
    }
}
