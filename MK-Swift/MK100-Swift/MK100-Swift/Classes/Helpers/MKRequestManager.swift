//
//  Request.swift
//  MK100-Swift
//
//  Created by txooo on 2019/8/2.
//  Copyright © 2019 txooo. All rights reserved.
//

import UIKit
import Alamofire
//import HandyJSON
import SwiftyJSON

typealias MKRequestResultHandle = (_ result:JSON?, _ error: Error?) -> ()

fileprivate let kPrivateKey: String = ""

class MKRequestManager: NSObject {

    static let shared: MKRequestManager = {
        let instance = MKRequestManager()
        return instance
    }()
}

extension MKRequestManager {
    func GET(urlString: String, parameters: [String: AnyObject]?, completionHandle:@escaping(MKRequestResultHandle)) {
//        let interval = NSDate().timeIntervalSince1970
//        let sign = self.sign(interval: interval, params: parameters, onlyUidAndToken: false)
//        let urlString = urlString.appendingFormat("?userid=%@&token=%@&brandid=%@&timeStamp=%f&sign=%@", kUserId, kUserToken, kBrandId, interval, sign)
        let urlString = urlString.appendingFormat("?userid=%@&token=%@&brandid=%@&txtest=1", kUserId, kUserToken, kBrandId)
        
        Alamofire.request(urlString, parameters: parameters).responseJSON { (response) in
            debugPrint(response.result.isSuccess)
            guard response.result.isSuccess else {
                completionHandle(nil, response.error)
                return
            }
            if let value = response.result.value {
                let json = JSON(value)
                completionHandle(json, nil)
            }
        }
    }
    
    func POST(urlString: String, parameters: [String: AnyObject], completionHandle:@escaping(MKRequestResultHandle)) {
        Alamofire.request(urlString, method: .post, parameters: parameters).responseJSON { (response) in
            debugPrint(response)
            guard response.result.isSuccess else {
                completionHandle(nil, response.error)
                return
            }
            if let value = response.result.value {
                let json = JSON(value)
                completionHandle(json, nil)
            }
        }
    }
    
    func POST(urlString: String, queryParameters: [String: AnyObject], bodyParameters: [String: AnyObject], completionHandle:@escaping(MKRequestResultHandle)) {
        Alamofire.request(urlString, method: .post, parameters: bodyParameters).responseJSON { (response) in
            guard response.result.isSuccess else {
                completionHandle(nil, response.error)
                return
            }
            if let value = response.result.value {
                let json = JSON(value)
                completionHandle(json, nil)
            }
        }
    }
}

extension MKRequestManager {
    func sign(interval: TimeInterval, params: [String: AnyObject]?, isLogIn: Bool = true, onlyUidAndToken: Bool = true) -> String {
        var array = [String(format: "timeStamp=%f", arguments: [interval])]
        if isLogIn {
            array.append(String(format: "userid=%@", arguments:[kUserId]))
            array.append(String(format: "token=%@", arguments:[kUserToken]))
            if !onlyUidAndToken {
                array.append(String(format: "brandid=%@", arguments: [kBrandId]))
            }
        }
        if let params = params {
            for (key, value) in params {
                array.append(String(format: "%@=%@", arguments:[key, value as! CVarArg]))
            }
        }
        array.sort { (a:String, b) -> Bool in
            let range1 = a.range(of: "=")!
            let range2 = b.range(of: "=")!
            let str1 = a[..<range1.lowerBound]
            let str2 = b[..<range2.lowerBound]
            return str1.caseInsensitiveCompare(str2).rawValue == -1
        }
        
        var sign = ""
        for str in array {
            sign = sign.appendingFormat("%@&", str)
        }
        if (sign.count > 0) {
            let index = sign.index(before: sign.endIndex)
            sign = String(sign[..<index])
        }
        sign = sign.appendingFormat("&%@", kPrivateKey)
        sign = sign.md5
        return sign
    }
}
