//
//  BaseModel.swift
//  SwiftProject
//
//  Created by txooo on 2018/10/10.
//  Copyright © 2018年 领琾. All rights reserved.
//

import UIKit

class BaseSwiftModel: NSObject, NSCopying, NSCoding {
    func copy(with zone: NSZone? = nil) -> Any {
        return self
    }
    
    func encode(with aCoder: NSCoder) {
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        
    }
    
    override init() {
        super.init()
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
    
    override func value(forUndefinedKey key: String) -> Any? {
        return nil;
    }
    
}
