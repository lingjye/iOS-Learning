//
//  MKHomeViewController.swift
//  MK100-Swift
//
//  Created by txooo on 2019/7/31.
//  Copyright © 2019 txooo. All rights reserved.
//

import UIKit

class MKHomeViewController: MKBaseTableViewController {
    
    lazy var vmdl: MKHomeViewModel = {
        return viewModel as! MKHomeViewModel
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "首页"
        view.backgroundColor = .yellow
        print(vmdl.paramsName!)
    }
    
    private static let cellID = "HomeCellID"
    
    override func tx_configSubViews() {
        tableView.mk_registerCell(cell: MKHomeTableViewCell.self)
        tableView.separatorStyle = .none
    }
    
    override func tx_loadData() {
        vmdl.tx_loadData()
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2, execute: {
            self.tableView.reloadData()
            self.tableView.mj_header.endRefreshing()
            self.tableView.mj_footer.endRefreshingWithNoMoreData()
        })
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.mk_dequeueReusableCell() as MKHomeTableViewCell
        cell.configViewModel(vmdl, withIndexPath: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Screen_Width * 0.8 + 40
    }
}
