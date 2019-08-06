//
//  MKRefreshHeader.swift
//  MK100-Swift
//
//  Created by txooo on 2019/8/5.
//  Copyright © 2019 txooo. All rights reserved.
//

import MJRefresh

class MKRefreshHeader: MJRefreshNormalHeader {

    override func prepare() {
        super.prepare()
        
        setTitle("下拉刷新", for: .idle)
        setTitle("松开刷新", for: .pulling)
        setTitle("刷新中", for: .refreshing)
    }

}

class MKRefreshFooter: MJRefreshAutoNormalFooter {
    
    override func prepare() {
        super.prepare()
        
        setTitle("上拉加载数据", for: .idle)
        setTitle("正在努力加载", for: .pulling)
        setTitle("正在努力加载", for: .refreshing)
        setTitle("没有更多数据啦", for: .noMoreData)
    }
}
