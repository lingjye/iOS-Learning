//
//  MKBaseView.swift
//  MK100-Swift
//
//  Created by txooo on 2019/7/31.
//  Copyright © 2019 txooo. All rights reserved.
//

import UIKit

protocol MKBaseViewProtocol {
    func tx_configSubViews()
    func tx_bindViewModel()
}

class MKBaseView: UIView {
    
    var viewModel: MKBaseViewModelProtocol?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        tx_configSubViews()
        tx_bindViewModel()
    }
    
    init(viewModel:MKBaseViewModelProtocol) {
        super.init(frame: CGRect.zero)
        self.viewModel = viewModel
        tx_configSubViews()
        tx_bindViewModel()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension MKBaseView: MKBaseViewProtocol {
    func tx_configSubViews() {
        
    }
    
    func tx_bindViewModel() {
        
    }
}
