//
//  MKBaseCollectionViewCell.swift
//  MK100-Swift
//
//  Created by txooo on 2019/7/31.
//  Copyright © 2019 txooo. All rights reserved.
//

import UIKit

protocol MKBaseCollectionViewCellProtocol {
    func tx_configSubViews()
    func configViewModel(_ viewModel: MKBaseViewModelProtocol, withIndexPath indexPath: IndexPath)
}

class MKBaseCollectionViewCell: UICollectionViewCell, MKBaseCollectionViewCellProtocol, RegisterCellProtocol {
    
    var indexPath: IndexPath?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        tx_configSubViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func tx_configSubViews() {
        
    }
    
    func configViewModel(_ viewModel: MKBaseViewModelProtocol, withIndexPath indexPath: IndexPath) {
        self.indexPath = indexPath
    }
    
}
