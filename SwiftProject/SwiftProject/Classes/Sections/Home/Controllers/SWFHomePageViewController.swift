//
//  HomePageViewController.swift
//  SwiftProject
//
//  Created by txooo on 2018/10/10.
//  Copyright © 2018年 领琾. All rights reserved.
//

import UIKit
import SnapKit

class SWFHomePageViewController: BaseSwiftTableViewController {

    lazy var viewModel: SWFHomePageViewModel = {
        return SWFHomePageViewModel.init(params: [:])
        }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "首页"
        // Do any additional setup after loading the view.
    }
     
    override func tx_configSubViews() {
        self.viewModel.dataArray.addObjects(from: ["销售简报", "交易趋势", "商品销售统计", "微店订单完成统计"])
        self.tableView.separatorInset = UIEdgeInsets.init()
        self.tableView.register(SWFHomePageCell.classForCoder(), forCellReuseIdentifier: "SWFHomePageCellID")
    }
    
    override func tx_bindViewModel() {
        
    }
    
    override func tx_loadData() {
        
    }
    
    override func tx_refreshData() {
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.dataArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : SWFHomePageCell = tableView.dequeueReusableCell(withIdentifier: "SWFHomePageCellID", for: indexPath) as! SWFHomePageCell
        cell.set(viewModel: self.viewModel, with: indexPath)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let viewController = SWFHomePageInfoViewController.init(params: [:])
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}
