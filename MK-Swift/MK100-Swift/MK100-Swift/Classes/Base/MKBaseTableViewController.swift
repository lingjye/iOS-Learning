//
//  MKBaseTableViewController.swift
//  MK100-Swift
//
//  Created by txooo on 2019/7/31.
//  Copyright © 2019 txooo. All rights reserved.
//

import UIKit
import MJRefresh

protocol MKBaseTableViewControllerProtocol: MKBaseViewControllerProtocol {
    func tx_refreshData()
    func tx_loadMoreData()
}

class MKBaseTableViewController: MKBaseViewController, MKBaseTableViewControllerProtocol, UITableViewDataSource, UITableViewDelegate {
    
    private lazy var vm: MKBaseTableViewModel = {
        return viewModel as! MKBaseTableViewModel
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //@objc  Do any additional setup after loading the view.
        view.addSubview(tableView)
        tx_refreshData()
        
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    func tx_refreshData() {
        self.tableView.mj_header = MKRefreshHeader(refreshingBlock: { [weak self] in
            guard let `self` = self else { return }
            self.tx_loadData()
        })
        
        self.tableView.mj_footer = MKRefreshFooter(refreshingBlock: { [weak self] in
            guard let `self` = self else { return }
            self.tx_loadMoreData()
        })
    }
    
    override func tx_loadData() {
        vm.tx_loadData()
    }
    
    func tx_loadMoreData() {
        vm.tx_requestData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vm.dataArray.count
    }
    
    private static let cellID = "MKBaseTableViewCellID"
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: MKBaseTableViewController.cellID)
        if cell == nil {
            cell = MKBaseTableViewCell(style: .default, reuseIdentifier: MKBaseTableViewController.cellID)
        }
        return cell!
    }
}
