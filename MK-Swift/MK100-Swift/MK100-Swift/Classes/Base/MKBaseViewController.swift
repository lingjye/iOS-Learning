//
//  MKBaseViewController.swift
//  MK100-Swift
//
//  Created by txooo on 2019/7/31.
//  Copyright © 2019 txooo. All rights reserved.
//

import UIKit

protocol MKBaseViewControllerProtocol {
    func tx_configSubViews()
    func tx_bindViewModel()
    func tx_loadData()
}

class MKBaseViewController: UIViewController, MKBaseViewControllerProtocol {
    
    var params: NSDictionary?
    var viewModel: AnyObject?
    
    init(viewModel:MKBaseViewModel) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
    }
    
    init(parameters: NSDictionary?) {
        super.init(nibName: nil, bundle: nil)
        var className = NSStringFromClass(self.classForCoder)
        className = className.replacingOccurrences(of: "Controller", with: "Model")
        
        let type = NSClassFromString(className) as! MKBaseViewModel.Type
        self.viewModel = type.init(paramters: parameters)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tx_configSubViews()
        tx_bindViewModel()
        tx_loadData()
    }
    
    func tx_configSubViews() {
        
    }
    
    func tx_bindViewModel() {
        
    }
    
    func tx_loadData() {
        
    }
    
}
