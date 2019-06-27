//
//  BaseSwiftTableViewModel.swift
//  SwiftProject
//
//  Created by txooo on 2018/10/10.
//  Copyright © 2018年 领琾. All rights reserved.
//

import UIKit
import ReactiveSwift
import Result

protocol BaseSwiftTableViewModelProtocol {
    
}

class BaseSwiftTableViewModel: BaseSwiftViewModel {
    lazy var dataArray: NSMutableArray = {
        return NSMutableArray.init()
    }()
    
    override func tx_initialize() {
        
    }
    
}
