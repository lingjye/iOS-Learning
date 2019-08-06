//
//  UIKit+MKAdditions.swift
//  MK100-Swift
//
//  Created by txooo on 2019/8/2.
//  Copyright © 2019 txooo. All rights reserved.
//

import UIKit

func RGBCOLOR(_ r: CGFloat, _ g: CGFloat, _ b: CGFloat) -> UIColor {
    return UIColor(red: r / 255.0, green: g / 255.0, blue: b / 255.0, alpha: 1)
}

func COLORWithHex(_ hex: UInt32) -> UIColor {
    let r = ((CGFloat)((hex & 0xFF0000) >> 16) / 255.0)
    let g = ((CGFloat)((hex & 0xFF00) >> 8) / 255.0)
    let b = (((CGFloat)(hex & 0xFF)) / 255.0)
    return UIColor(red: r, green: g, blue: b, alpha: 1.0)
}

protocol RegisterCellProtocol {}

extension RegisterCellProtocol {
    static var identifier: String { return "\(self)" }
    static var nib: UINib? { return UINib(nibName: "\(self)", bundle: nil) }
}

extension UITableView {
    // 注册
    func mk_registerCell<T: UITableViewCell>(cell: T.Type) where T: RegisterCellProtocol {
        register(cell, forCellReuseIdentifier: T.identifier)
    }
    
    // 复用cell
    func mk_dequeueReusableCell<T: UITableViewCell>(indexPath: IndexPath? = nil) -> T where T: RegisterCellProtocol {
        if indexPath != nil {
            return dequeueReusableCell(withIdentifier: T.identifier, for: indexPath!) as! T
        }
        return dequeueReusableCell(withIdentifier: T.identifier) as! T
    }
}

extension UICollectionView {
    // 注册
    func mk_registerCell<T: UICollectionViewCell>(cell: T.Type) where T: RegisterCellProtocol {
        register(cell, forCellWithReuseIdentifier: T.identifier)
    }
    
    func mk_registerSupplementaryView<T: UICollectionReusableView>(reusableView: T.Type, kind: String) where T: RegisterCellProtocol {
        register(reusableView, forSupplementaryViewOfKind: kind, withReuseIdentifier: T.identifier)
    }
    
    // 复用cell
    func mk_dequeueReusableCell<T: UICollectionViewCell>(indexPath: IndexPath) -> T where T: RegisterCellProtocol {
        return dequeueReusableCell(withReuseIdentifier: T.identifier, for: indexPath) as! T
    }
    
    func mk_dequeueReusableSupplementaryView<T: UICollectionReusableView>(kind: String, for indexPath: IndexPath) -> T where T: RegisterCellProtocol {
        return dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: T.identifier, for: indexPath) as! T
    }
    
}

extension UIView {
    var x: CGFloat {
        get {
            return frame.origin.x
        }
        set(newValue) {
            var tempFrame: CGRect = frame
            tempFrame.origin.x = newValue
            frame = tempFrame
        }
    }
    
    var y: CGFloat {
        get {
            return frame.origin.y
        }
        set {
            var tempFrame: CGRect = frame
            tempFrame.origin.y = newValue
            frame = tempFrame
        }
    }
    
    var width: CGFloat {
        get {
            return frame.size.width
        }
        set {
            var tempFrame: CGRect = frame
            tempFrame.size.width = newValue
            frame = tempFrame
        }
    }
    
    var height: CGFloat {
        get {
            return frame.size.height
        }
        set {
            var tempFrame: CGRect = frame
            tempFrame.size.height = newValue
            frame = tempFrame
        }
    }
    
    var size: CGSize {
        get {
            return frame.size
        }
        set {
            var tempFrame: CGRect = frame
            tempFrame.size = newValue
            frame = tempFrame
        }
    }
    
    var centerX: CGFloat {
        get {
            return center.x
        }
        set {
            var tempCenter: CGPoint = center
            tempCenter.x = newValue
            center = tempCenter
        }
    }
    
    var centerY: CGFloat {
        get {
            return center.y
        }
        set {
            var tempCenter:CGPoint = center
            tempCenter.y = newValue
            center = tempCenter
        }
    }
    
    var origin: CGPoint {
        get {
            return frame.origin
        }
        set {
            var tempFrame = frame
            tempFrame.origin = newValue
            frame = tempFrame
        }
    }
    
    var top: CGFloat {
        get {
            return self.frame.origin.y
        }
        set {
            var tempFrame = frame
            tempFrame.origin.y = newValue
            frame = tempFrame
        }
    }
    
    var bottom: CGFloat {
        get {
            return self.frame.origin.y + self.frame.size.height
        }
        set {
            var tempFrame = frame
            tempFrame.origin.y = newValue - frame.size.height
            frame = tempFrame
        }
    }
}
