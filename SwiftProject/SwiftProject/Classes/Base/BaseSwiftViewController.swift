//
//  BaseSwiftViewController.swift
//  SwiftProject
//
//  Created by txooo on 2018/10/10.
//  Copyright © 2018年 领琾. All rights reserved.
//

import UIKit

protocol BaseSwiftViewControllerProtocol {
    func tx_configSubViews()
    func tx_bindViewModel()
    func tx_loadData()
}

class BaseSwiftViewController: UIViewController, BaseSwiftViewControllerProtocol {

    override func viewDidLoad() {
        super.viewDidLoad()
        if (self.responds(to: #selector(setter: UIViewController.edgesForExtendedLayout))) {
            self.edgesForExtendedLayout = UIRectEdge.init(rawValue: 0)
        }
        self.view.backgroundColor = UIColor.white
        self.tx_configSubViews()
        self.tx_bindViewModel()
        self.tx_loadData()
    }
    
    init(params: NSDictionary) {
        super.init(nibName: nil, bundle: nil)
    }
    
    init(viewModel: BaseSwiftViewModel) {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func initWithParams(_ params: NSDictionary) -> BaseSwiftViewController {
        return self
    }
    
    func tx_configSubViews() {
        
    }
    
    func tx_bindViewModel() {
        
    }
    
    func tx_loadData() {
        
    }
    

}
