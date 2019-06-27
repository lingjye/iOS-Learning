//
//  SFRouter.swift
//  SwiftProject
//
//  Created by txooo on 2018/10/26.
//  Copyright © 2018年 领琾. All rights reserved.
//

import UIKit

class SFRouter: NSObject {

    static let sharedInstance = SFRouter()
    
    private override init() {
        super.init()
    }
    
    func viewModelForViewController(viewController: BaseSwiftViewController) -> BaseSwiftViewModel {
        let viewClassString = NSStringFromClass(type(of: viewController))
        let viewModelString = viewClassString.replacingOccurrences(of: "Controller", with: "Model")
        let viewModelClass: AnyClass? = NSClassFromString(viewModelString)
        
        guard let viewModelType = viewModelClass as? BaseSwiftViewModel.Type else {
            print("转换失败, 请手动创建viewModel", "asd")
            return BaseSwiftViewModel()
        }
        
        let viewModel = viewModelType.init()
        
        return viewModel
    }
}
