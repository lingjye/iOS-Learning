//
//  BaseSwiftNavigationViewController.swift
//  SwiftProject
//
//  Created by txooo on 2018/10/10.
//  Copyright © 2018年 领琾. All rights reserved.
//

import UIKit

class BaseSwiftNavigationViewController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
        print("initialze")
        setupNavigationBarAttribute()
    }
    
    func setupNavigationBarAttribute() {
        let navBar = UINavigationBar.appearance()
        navBar.titleTextAttributes = [.foregroundColor: UIColor.red,
            .font: UIFont.boldSystemFont(ofSize: 18)
        ]
        navBar.tintColor = .white
        UIApplication.shared.statusBarStyle = .lightContent
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
