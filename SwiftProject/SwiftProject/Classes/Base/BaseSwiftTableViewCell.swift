//
//  BaseSwiftTableViewCell.swift
//  SwiftProject
//
//  Created by txooo on 2018/10/10.
//  Copyright © 2018年 领琾. All rights reserved.
//

import UIKit

protocol BaseSwiftTableViewCellProtocol {
    func tx_configSubViews()
    func set(viewModel: BaseSwiftViewModel, with indexPath: IndexPath)
}

class BaseSwiftTableViewCell: UITableViewCell, BaseSwiftTableViewCellProtocol {

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.tx_configSubViews();
    }
    
    func tx_configSubViews() {
        
    }
    
    func set(viewModel: BaseSwiftViewModel, with indexPath: IndexPath) {
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
