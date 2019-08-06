//
//  MKBaseCollectionViewController.swift
//  MK100-Swift
//
//  Created by txooo on 2019/7/31.
//  Copyright © 2019 txooo. All rights reserved.
//

import UIKit
import MJRefresh
   
protocol MKBaseCollectionViewControllerProtocol: MKBaseViewControllerProtocol {
    func tx_refreshData()
    func tx_loadMoreData()
}

class MKBaseCollectionViewController: MKBaseViewController, MKBaseCollectionViewControllerProtocol {
    
    lazy var vm: MKBaseTableViewModel = {
        return viewModel as! MKBaseTableViewModel
    }()
    
    lazy var collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        
        let tmpCollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: flowLayout)
        tmpCollectionView.delegate = self as? UICollectionViewDelegate
        tmpCollectionView.dataSource = self as? UICollectionViewDataSource
        tmpCollectionView.mk_registerCell(cell: MKBaseCollectionViewCell.self)
        return tmpCollectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tx_refreshData()
    }
    func tx_refreshData() {
        self.collectionView.mj_header = MJRefreshNormalHeader.init(refreshingBlock: { [weak self] in
            guard let `self` = self else { return }
            self.tx_loadData()
        })
        
        self.collectionView.mj_footer = MJRefreshAutoNormalFooter.init(refreshingBlock: { [weak self] in
            guard let `self` = self else { return }
            self.tx_loadMoreData()
        })
    }
    
    override func tx_loadData() {
//        vm.tx_loadData()
    }
    
    func tx_loadMoreData() {
//        vm.tx_requestData()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return vm.dataArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.mk_dequeueReusableCell(indexPath: indexPath) as MKBaseCollectionViewCell
        return cell
    }
}
