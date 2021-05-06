//
//  MixSwiftView.swift
//  MixSwift
//
//  Created by huangyibo on 2021/4/28.
//

import UIKit

public class MixSwiftView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    @objc public static func log(_ title: String?) {
        print("\(String(describing: title))")
    }

}
