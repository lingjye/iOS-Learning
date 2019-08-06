//
//  MKBaseTableViewModel.swift
//  MK100-Swift
//
//  Created by txooo on 2019/7/31.
//  Copyright © 2019 txooo. All rights reserved.
//

import UIKit

protocol MKBaseTableViewModelProtocol: MKBaseViewModelProtocol {
    func tx_requestData()
}

class MKBaseTableViewModel: MKBaseViewModel, MKBaseTableViewModelProtocol {
    
    var pageIndex = 1
    
    public lazy var dataArray: NSMutableArray = {
        let tmpArray = NSMutableArray()
        return tmpArray
    }()
    
    override func tx_loadData() {
        pageIndex = 1
    }
    
    func tx_requestData() {
        pageIndex += 1
    }
}
