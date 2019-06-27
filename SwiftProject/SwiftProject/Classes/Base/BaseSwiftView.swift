//
//  BaseView.swift
//  SwiftProject
//
//  Created by txooo on 2018/10/10.
//  Copyright © 2018年 领琾. All rights reserved.
//

import UIKit

protocol BaseSwiftViewProtocol  {
    func tx_bindViewModel()
    func tx_configSubViews()
}

class BaseSwiftView: UIView, BaseSwiftViewProtocol {

    var viewModel: BaseSwiftViewModel?
    
    init(viewModel: BaseSwiftViewModel) {
        self.viewModel = viewModel
        super.init(frame:CGRect())
        self.backgroundColor = UIColor.white
        self.tx_configSubViews()
        self.tx_bindViewModel()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        self.tx_configSubViews()
        self.tx_bindViewModel()
    }
    
    required init?(coder aDecoder: NSCoder) {
        //xib创建
        super.init(coder: aDecoder)
//        fatalError("init(coder:) has not been implemented")
    }

    func tx_bindViewModel() {
        print(#function)
    }
    
    func tx_configSubViews() {
        print(self.viewModel?.params?["title"] as Any)
    }

}
