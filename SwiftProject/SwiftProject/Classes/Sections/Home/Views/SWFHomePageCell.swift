//
//  SWFHomePageCell.swift
//  SwiftProject
//
//  Created by txooo on 2018/10/27.
//  Copyright © 2018年 领琾. All rights reserved.
//

import UIKit

class SWFHomePageCell: BaseSwiftTableViewCell {
    
    var viewModel : SWFHomePageViewModel?
    
    var labelText : String = ""
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func set(viewModel: BaseSwiftViewModel, with indexPath: IndexPath) {
        self.viewModel = viewModel as? SWFHomePageViewModel
        let text = self.viewModel?.dataArray.object(at: indexPath.row) as! String
        self.textLabel?.text = text
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
