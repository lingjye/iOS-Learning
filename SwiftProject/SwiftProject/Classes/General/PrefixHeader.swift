//
//  PrefixHeader.swift
//  SwiftProject
//
//  Created by txooo on 2018/10/10.
//  Copyright © 2018年 领琾. All rights reserved.
//

import UIKit

let kScreenWidth = UIScreen.main.bounds.width
let kScreenHeight = UIScreen.main.bounds.height

let kViewDefaultHeight = 50.0

let kBackgroundColor = UIColor.init(red: 245 / 255.0, green: 245 / 255.0, blue: 245 / 255.0, alpha: 1)

public func RGBCOLOR(r: CGFloat, g: CGFloat, b: CGFloat) -> UIColor {
    return RGBCOLORA(r: r, g: g, b: b, a: 1)
}

public func RGBCOLORA(r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat) -> UIColor {
    return UIColor.init(red: r / 255.0, green: g / 255.0, blue: b / 255.0, alpha: a)
}

public func isTelNumber(num: String) -> Bool {
    let MOBILE = "^1(2[2]|3[0-9]|4[57]|5[0-35-9]|6[0-9]|8[0-9]|7[0-9]|9[0-9])\\d{8}$"
    let regexMobie = NSPredicate.init(format: "SELF MATCHES %@", MOBILE)
    if (regexMobie.evaluate(with: num)) {
        return true
    }
    return false
}

public func isTruePassword(string: String) -> Bool {
    let password = "^(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{8,16}$"
    let regexPassword = NSPredicate.init(format: "SELF MATCHES %@", password)
    if (regexPassword.evaluate(with: string)) {
        return true
    }
    return false
}

