//
//  MKBaseTableViewCell.swift
//  MK100-Swift
//
//  Created by txooo on 2019/7/31.
//  Copyright © 2019 txooo. All rights reserved.
//

import UIKit

protocol MKBaseTableViewCellProtocol: RegisterCellProtocol {
    func tx_configSubViews()
    func configViewModel(_ viewModel: MKBaseViewModelProtocol, withIndexPath indexPath: IndexPath)
}

class MKBaseTableViewCell: UITableViewCell, MKBaseTableViewCellProtocol, RegisterCellProtocol {
    
    var indexPath: IndexPath?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
