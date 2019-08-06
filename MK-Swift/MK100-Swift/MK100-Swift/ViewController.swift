//
//  ViewController.swift
//  MK100-Swift
//
//  Created by txooo on 2019/7/31.
//  Copyright © 2019 txooo. All rights reserved.
//

import UIKit


class ViewController: UIViewController {
    final var name: String!
    lazy var subTitle: String = {
        let sss = ""
        return sss
    }()
    var no1 = 0.0, no2 = 0.0
    var middle: (Double, Double) {
        get {
            return (no1, no2)
        }
        set(axis) {
            no1  = axis.0 - 1
            no2 = axis.1 - 1
        }
    }
    
    var counter: Int = (1){
        willSet(newTotal) {
            print("willSet:\(newTotal)")
        }
        didSet{
            if counter > oldValue {
                print("新增：\(counter - oldValue)")
            }
        }
    }
    
    var metaInfo: [String: String] {
        return [
            "head": "head",
            "duration": "Duration"
        ]
    }
    
    deinit {
        print("析构")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        name = "name"
        print(name!)
        // Do any additional setup after loading the view.
        var dictionary: [Int: String] = [1:"at", 3: "3"]
        print(dictionary, dictionary[3]!)
        let index = dictionary.index(dictionary.startIndex, offsetBy: 1)
        dictionary.remove(at: index)
        print(dictionary)
        self.middle = (2, 3)
        print(self.middle, no1, no2)
        print(metaInfo)
        
        self.counter = 100
        self.counter = 200
    }


}

