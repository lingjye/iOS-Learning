//
//  MKHomeModel.swift
//  MK100-Swift
//
//  Created by txooo on 2019/8/1.
//  Copyright © 2019 txooo. All rights reserved.
//

import UIKit
import HandyJSON

struct MKHomeModel: HandyJSON {
    var success: Bool = false
    var jiaoyi = [MKCountJiaoyi]()
    var yingshou = [MKCountYingshou]()
    var xiaoshou = [MKCountXiaoshou]()
    var type: Int = 0

    mutating func mapping(mapper: HelpingMapper) {

    }
}

struct MKCountJiaoyi: HandyJSON {
    var NewAddTime: String = ""
    var OrderTotalAmount: Float = 0.0
    var UserCount: Int = 0
    var GoodsCount: Int = 0
    var OrderCount: Int = 0
}

struct MKCountYingshou: HandyJSON {
    var zfOrder: Int = 0
    var zfMoney: Float = 0.0
    var xsMoney: Float = 0.0
    var xsOrder: Int = 0
    var InComeAverage: Float = 0.0
}

struct MKCountXiaoshou: HandyJSON {
    var GoodsMoney: Float = 0.0
    var GoodsCount: Int = 0
    var first_class_id: Int = 0
    var GoodsClassName: String = ""
    var Percentage: Float = 0.0
}

struct OSStoreSaleCountModel: HandyJSON {
    var MarketFinishCount: Int = 0
    var MarketSales: Float = 0.0
    var MarketVisitors: Int = 0
    var VmallFinishCount: Int = 0
    var VmallSales: Float = 0.0
    var VmallVisitors: Int = 0
    var VmallUnconfirmedCount: Int = 0
    var VmallTransitCount: Int = 0
    var VmallCancelCount: Int = 0
}
