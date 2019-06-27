//
//  SwiftSingleton.swift
//  SwiftProject
//
//  Created by txooo on 2018/10/10.
//  Copyright © 2018年 领琾. All rights reserved.
//

import UIKit

class SwiftSingleton: NSObject {

    private(set) var netStatus: Int
    
    static let sharedInstance = SwiftSingleton()
    
    private override init() {
        self.netStatus = 1
        super.init()
    }
    
}
