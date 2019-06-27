//
//  BaseSwiftCollectionViewCell.swift
//  SwiftProject
//
//  Created by txooo on 2018/10/10.
//  Copyright © 2018年 领琾. All rights reserved.
//

import UIKit

protocol BaseSwiftCollectionViewCellProtocol {
    func tx_configSubViews()
    func set(viewModel: BaseSwiftViewModel, with indexPath: IndexPath)
}

class BaseSwiftCollectionViewCell: UICollectionViewCell, BaseSwiftCollectionViewCellProtocol {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.tx_configSubViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func tx_configSubViews() {
        
    }
    
    func set(viewModel: BaseSwiftViewModel, with indexPath: IndexPath) {
        
    }
    
}
