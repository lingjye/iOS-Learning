//
//  MKBaseViewModel.swift
//  MK100-Swift
//
//  Created by txooo on 2019/7/31.
//  Copyright © 2019 txooo. All rights reserved.
//

import UIKit

protocol MKBaseViewModelProtocol {
    func tx_initialize()
    func tx_loadData()
}

class MKBaseViewModel: NSObject, MKBaseViewModelProtocol {
    var params: NSDictionary?

    required
    init(paramters: NSDictionary?) {
        super.init()
        params = paramters
        tx_initialize()
    }
    
    override init() {
        super.init()
        tx_initialize()
    }
    
    func tx_initialize() {
        
    }
    
    func tx_loadData() {
        
    }
}
