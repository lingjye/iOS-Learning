//
//  BaseSwiftTableViewHeaderFooterView.swift
//  SwiftProject
//
//  Created by txooo on 2018/10/10.
//  Copyright © 2018年 领琾. All rights reserved.
//

import UIKit

protocol BaseSwiftTableViewHeaderFooterViewProtocol {
    func tx_configSubViews()
    func set(viewModel: BaseSwiftViewModel, with section: NSInteger)
}

class BaseSwiftTableViewHeaderFooterView: UITableViewHeaderFooterView, BaseSwiftTableViewHeaderFooterViewProtocol {

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        self.tx_configSubViews()
    }
    
    func tx_configSubViews() {
        
    }
    
    func set(viewModel: BaseSwiftViewModel, with section: NSInteger) {
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
