//
//  NSDate+MKAdditions.swift
//  MK100-Swift
//
//  Created by txooo on 2019/8/5.
//  Copyright © 2019 txooo. All rights reserved.
//

import Foundation

extension NSDate {
    class func todayDate() -> String {
        return self.dateFromTodayWithDays(days: 0)
    }
    
    class func yesterdayDate() -> String {
        return self.dateFromTodayWithDays(days: -1)
    }
    
    class func dateFromTodayWithDays(days: Int) -> String {
        let today = NSDate()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy.MM.dd"
        
        let calendar = NSCalendar(calendarIdentifier: .gregorian)
        let adcomps = NSDateComponents()
        adcomps.year = 0
        adcomps.month = 0
        adcomps.day = days
        guard let newDate = calendar!.date(byAdding: adcomps as DateComponents, to: today as Date, options: []) else { return "" }
        let result = dateFormatter.string(from: newDate)
        return result
    }
}
