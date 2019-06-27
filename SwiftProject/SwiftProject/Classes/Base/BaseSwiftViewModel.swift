//
//  BaseSwiftViewModel.swift
//  SwiftProject
//
//  Created by txooo on 2018/10/10.
//  Copyright © 2018年 领琾. All rights reserved.
//

import UIKit

protocol BaseSwiftViewModelProtocol {
    func tx_initialize()
    func pushViewModel(_ viewModel: BaseSwiftViewModel, animated: Bool)
    func popViewModel(animated: Bool)
    func popToRootViewModelAnimated(animated: Bool)
    func presentViewModel(_ viewModel: BaseSwiftViewModel, animated: Bool, completion:() -> ())
    func dismissViewModel(animated: Bool, completion:() -> ())
}

class BaseSwiftViewModel: NSObject, BaseSwiftViewModelProtocol {

    var params: NSDictionary?
    var title: NSString?

    init(params: NSDictionary) {
        super.init()
        self.params = params
        self.title = params["title"] as? NSString
        self.tx_initialize()
    }
    
    override required init() {
        super.init()
        self.tx_initialize()
    }
    
    func tx_initialize() {
        print(#function)
    }
    
    //MARK: BaseViewModelProtocol
    func pushViewModel(_ viewModel: BaseSwiftViewModel, animated: Bool) {
        
    }
    
    func popViewModel(animated: Bool) {
        
    }
    
    func popToRootViewModelAnimated(animated: Bool) {
        
    }
    
    func presentViewModel(_ viewModel: BaseSwiftViewModel, animated: Bool, completion: () -> ()) {
        
    }
    
    func dismissViewModel(animated: Bool, completion: () -> ()) {
        
    }
}
