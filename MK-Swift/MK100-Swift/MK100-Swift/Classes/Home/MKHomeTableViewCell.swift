//
//  MKHomeTableViewCell.swift
//  MK100-Swift
//
//  Created by txooo on 2019/8/1.
//  Copyright © 2019 txooo. All rights reserved.
//

import UIKit
import Charts

enum MKCountType: Int {
    case orderCount = 0
    case totalAmount = 1
}

class MKHomeTableViewCell: MKBaseTableViewCell {
    
    var viewModel: MKHomeViewModel?
    
    fileprivate lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "交易趋势"
        label.font = .boldSystemFont(ofSize: 16)
        
        return label
    }()
    
    lazy var helpButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("\u{eb46}", for: UIControl.State.normal)
        button.titleLabel?.font = UIFont.vmallFont(with: 25)
        button.setTitleColor(.red, for: .normal)
        return button
    }()
    
    lazy var chartView: LineChartView = {
        let chartView = LineChartView()
        chartView.delegate = self
        chartView.chartDescription?.enabled = false
        chartView.dragEnabled = true
        chartView.setScaleEnabled(true)
        chartView.pinchZoomEnabled = false
        chartView.drawGridBackgroundEnabled = false
        chartView.scaleYEnabled = false
        chartView.scaleXEnabled = true
        chartView.doubleTapToZoomEnabled = false
        chartView.dragDecelerationFrictionCoef = 0.9 ////拖拽后惯性效果的摩擦系数(0~1)，数值越小，惯性越不明显
        chartView.noDataText = "暂无数据"
        chartView.rightAxis.enabled = false
        // 横坐标
        chartView.xAxis.axisLineWidth = kOnePiexl
        chartView.xAxis.labelPosition = .bottom
        chartView.xAxis.drawGridLinesEnabled = false
        chartView.xAxis.labelRotationAngle = 5
        // 纵坐标
        let leftAxis = chartView.leftAxis
        leftAxis.labelCount = 5
        leftAxis.forceLabelsEnabled = false
        leftAxis.axisMaximum = 0
        leftAxis.inverted = false
        leftAxis.axisLineWidth = kOnePiexl
        leftAxis.axisLineColor = .black
        leftAxis.labelPosition = .outsideChart
        leftAxis.labelTextColor = .black
        leftAxis.drawZeroLineEnabled = true
        leftAxis.labelFont = UIFont.systemFont(ofSize: 10.0)
        leftAxis.gridLineDashLengths = [2.0, 2.0]
        leftAxis.gridColor = kSeperateLine_Color
        leftAxis.gridAntialiasEnabled = false
        leftAxis.gridLineWidth = kOnePiexl
        
        // Marker
        let marker:MKBalloonMarker = MKBalloonMarker(color: kTheme_Color, font: UIFont.systemFont(ofSize: 12), textColor: .white, insets: UIEdgeInsets(top: 8.0, left: 8.0, bottom: 20.0, right: 8.0))
        marker.chartView = chartView
        marker.minimumSize = CGSize(width: 80.0, height: 40.0)
        chartView.marker = marker
        
        // legend
        chartView.legend.form = .line
        chartView.animate(xAxisDuration: 1.5, easingOption: .easeOutBack)
        
        return chartView
    }()
    
    lazy var segmentControl: UISegmentedControl = {
        let control = UISegmentedControl(items: ["订单数", "订单金额"])
        control.selectedSegmentIndex = 0
        control.apportionsSegmentWidthsByContent = true
        control.tintColor = UIColor.white
        control.backgroundColor = kBackground_Color
        control.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.gray], for: .normal)
        control.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.black], for: .selected)
        control.layer.borderColor = kSeperateLine_Color.cgColor
        control.layer.borderWidth = kOnePiexl
        control.layer.cornerRadius = 2
        
        control.addTarget(self, action: #selector(controlSelect(control:)), for: .valueChanged)
        
       return control
    }()
    
    @objc func controlSelect(control: UISegmentedControl) {
        guard viewModel?.model != nil else {
            return
        }
        self.setData(model: viewModel!.model!, type: MKCountType(rawValue: control.selectedSegmentIndex)!)
    }
    
    override func tx_configSubViews() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(helpButton)
        contentView.addSubview(segmentControl)
        contentView .addSubview(chartView)
        selectionStyle = .none
        
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(10)
            make.top.equalToSuperview().offset(10)
            make.size.equalTo(CGSize(width: 100, height: 20))
        }
        helpButton.snp.makeConstraints { (make) in
            make.right.equalTo(contentView).offset(-10)
            make.centerY.equalTo(titleLabel)
            make.size.equalTo(CGSize(width: 30, height: 30))
        }
        chartView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(10)
            make.bottom.right.equalToSuperview().offset(-10)
            make.top.equalToSuperview().offset(50)
        }
        segmentControl.snp.makeConstraints { (make) in
            make.right.equalTo(helpButton.snp.left).offset(-10)
            make.centerY.equalTo(titleLabel)
        }
    }
    
    override func configViewModel(_ viewModel: MKBaseViewModelProtocol, withIndexPath indexPath: IndexPath) {
        let viewModel = viewModel as! MKHomeViewModel
        guard (viewModel.model != nil) else {
            return
        }
        self.viewModel = viewModel
        setData(model: viewModel.model!, type: .orderCount)
    }
}

extension MKHomeTableViewCell {
    
    func setData(model:MKHomeModel, type: MKCountType) {
        guard model.jiaoyi.count != 0 else {
            self.chartView.data = LineChartData()
            return
        }
        
        var xVals = [Float]()
        var yVals = [ChartDataEntry]()
        let jiaoyi = model.jiaoyi.first
        var max = type == .orderCount ? Float(jiaoyi?.OrderCount ?? 0) : jiaoyi?.OrderTotalAmount ?? 0
        for (index, xModel) in model.jiaoyi.enumerated() {
            xVals.append(type == .orderCount ? Float(xModel.OrderCount) : xModel.OrderTotalAmount)
            let val = type == .orderCount ? Float(xModel.OrderCount) : xModel.OrderTotalAmount
            let entry = ChartDataEntry(x: Double(index), y: Double(val))
            yVals.append(entry)
            if CGFloat(val) > CGFloat(max) {
                max = val
            }
        }
        
//        self.chartView.xAxis.valueFormatter = DefaultAxisValueFormatter.init()

        chartView.leftAxis.axisMaximum = Double(max + (max > 1000 ? 3000 : max > 1000 ? 1000 : max > 100 ? 100 : 10))
        
//        chartView.data = nil;
        let set1 = LineChartDataSet.init(entries: yVals, label: "Max")
        set1.lineCapType = .square
        
        set1.lineWidth = kOnePiexl * 2
        set1.drawValuesEnabled = true
        set1.valueColors = [UIColor.brown]
        set1.setColor(RGBCOLOR(135, 234, 254))
        set1.drawCirclesEnabled = true
        set1.drawCircleHoleEnabled = true
        set1.circleRadius = 4
        set1.circleHoleRadius = 2.0
        set1.mode = .cubicBezier
        set1.drawFilledEnabled = true
        
        let colors:CFArray = [ChartColorTemplates.colorFromString("#FFFFFFFF").cgColor,
                              RGBCOLOR(135, 234, 254).cgColor] as CFArray
        let gradientRef = CGGradient(colorsSpace: nil, colors: colors, locations: nil)
        set1.fillAlpha = 0.5
        set1.fill = Fill.fillWithLinearGradient(gradientRef!, angle: 90.0)
//        set1.fill = Fill.fillWithColor(kTheme_Color)
        
        set1.highlightEnabled = true;//选中拐点,是否开启高亮效果(显示十字线)
        set1.highlightColor = UIColor.red;//点击选中拐点的十字线的颜色
        set1.highlightLineWidth = kOnePiexl;//十字线宽度
        set1.highlightLineDashLengths = [5, 5];//十字线的
        
        let numberFormatter = NumberFormatter()
        if type == .orderCount {
            numberFormatter.numberStyle = .none
        } else {
            numberFormatter.numberStyle = .decimal
            numberFormatter.maximumIntegerDigits = 2
        }
        
        let formatter = DefaultValueFormatter(formatter: numberFormatter)
        set1.valueFormatter = formatter

        let data = LineChartData(dataSet: set1)
        data.setValueFont(UIFont.systemFont(ofSize: 8))
        data.setValueTextColor(.black)
        chartView.data = data
    }
}


extension MKHomeTableViewCell: ChartViewDelegate, IAxisValueFormatter {
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        chartView.drawMarkers = true;
        let marker = chartView.marker as! MKBalloonMarker
        
        if Int(entry.x) >= (viewModel?.model?.jiaoyi.count)! {
            return;
        }
        
        let jiaoyi = viewModel?.model?.jiaoyi[Int(entry.x)]
        let title = String(format: "订单数:%d\n%@", jiaoyi!.OrderCount, jiaoyi!.NewAddTime)
        marker.setLabel(title)
        
//        let title = String(format: "订单金额:%.2f\n%d", jiaoyi!.floatValue, jiaoyi!.NewAddTime)
    }
    
    func chartValueNothingSelected(_ chartView: ChartViewBase) {
        
    }
    
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        return String.init(format: "%f", value)
    }
    
}
