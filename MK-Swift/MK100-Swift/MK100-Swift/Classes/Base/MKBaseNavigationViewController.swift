//
//  MKBaseNavigationViewController.swift
//  MK100-Swift
//
//  Created by txooo on 2019/8/1.
//  Copyright © 2019 txooo. All rights reserved.
//

import UIKit

class MKBaseNavigationViewController: UINavigationController {
    
    class func setUpDefaultNavigation() {
        let navigationBar = UINavigationBar.appearance()
        navigationBar.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor : UIColor.white,
            NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 18)
        ]
        navigationBar.tintColor = .white
        navigationBar.setBackgroundImage(.imageWithColor(color: kTheme_Color), for: .default)
        
        UIBarButtonItem.appearance().setTitlePositionAdjustment(UIOffset(horizontal: .leastNormalMagnitude, vertical: .leastNormalMagnitude), for: .default)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        MKBaseNavigationViewController.setUpDefaultNavigation()
        // Do any additional setup after loading the view.
    }

}
