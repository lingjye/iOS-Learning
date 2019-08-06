//
//  MKRootViewTool.swift
//  MK100-Swift
//
//  Created by txooo on 2019/8/1.
//  Copyright © 2019 txooo. All rights reserved.
//

import UIKit

class MKRootViewTool: NSObject {
    open class func setMKRootViewController(animation: Bool) {
        let tabbarController = MKTabbarViewController()
        UIApplication.shared.delegate?.window??.rootViewController = tabbarController
    }
}
