//
//  MSPeople.swift
//  Kiwi
//
//  Created by txooo on 2018/7/18.
//

import UIKit

public class MSPeople: NSObject {
    @objc open class func show() {
        print(NSStringFromClass(self));
        print(self.self);
        print(MSPeople.self);
        print(self.self == MSPeople.self);
        print(self.self.isKind(of: MSPeople.self));
        print(self.self.isEqual(MSPeople.self));
    }
}
