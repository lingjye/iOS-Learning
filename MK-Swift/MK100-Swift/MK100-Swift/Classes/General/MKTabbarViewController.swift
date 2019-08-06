//
//  MKTabbarViewController.swift
//  MK100-Swift
//
//  Created by txooo on 2019/7/31.
//  Copyright © 2019 txooo. All rights reserved.
//

import UIKit

class MKTabbarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let homeCtl = MKHomeViewController(parameters: nil)
        self.addChild(homeCtl, title: "首页", image: "Home灰", selectImage: "Home绿")
        
        let orderCtl = MKOrderViewController(parameters: nil)
        self.addChild(orderCtl, title: "订单", image: "订单灰", selectImage: "订单绿")
        
    }
    
    func addChild(_ childController: UIViewController, title: String, image: String, selectImage: String) {
        let navigationCtl = MKBaseNavigationViewController(rootViewController: childController)
        navigationCtl.tabBarItem = UITabBarItem(title: title, image: UIImage(named: image)?.withRenderingMode(.alwaysOriginal), selectedImage: UIImage(named: selectImage)?.withRenderingMode(.alwaysOriginal))
        navigationCtl.tabBarItem.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: kTheme_Color, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12)] , for: .selected)
        navigationCtl.tabBarItem.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.lightGray], for: .normal)
        self.addChild(navigationCtl)
    }
    
}
