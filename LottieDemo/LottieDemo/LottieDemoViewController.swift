//
//  LottieDemoViewController.swift
//  LottieDemo
//
//  Created by txooo on 2019/5/7.
//  Copyright © 2019 txooo. All rights reserved.
//

import UIKit

class LottieDemoViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        
        self.configAnimation()
    }
    
    @objc func configAnimation() {
        let animationView = LOTAnimationView.init(name: "data.json")
        animationView.loopAnimation = true
        animationView.frame = self.view.frame
        animationView.contentMode = .scaleAspectFit
        self.view.addSubview(animationView)
        
        animationView.play()
        
        let topButton = UIButton.init(type: .custom)
        topButton.setTitle("上一页", for: .normal)
        topButton.setTitleColor(UIColor.red, for: .normal)
        topButton.addTarget(self, action: #selector(self.topPage), for: .touchUpInside)
        topButton.frame = CGRect(x: self.view.frame.midX - 50, y: self.view.frame.maxY - 100, width: 100, height: 50)
        self.view.addSubview(topButton)
        self.view.bringSubviewToFront(topButton)
    }
    
    @objc func topPage() -> () {
        self.dismiss(animated: true, completion: nil)
    }
    
}
