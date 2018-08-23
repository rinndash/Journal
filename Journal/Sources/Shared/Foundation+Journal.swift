//
//  Foundation+Journal.swift
//  Journal
//
//  Created by 윤진서 on 2018. 8. 11..
//  Copyright © 2018년 Jinseo Yoon. All rights reserved.
//

import Foundation

extension DateFormatter {
    static func formatter(with format: String) -> DateFormatter {
        let df = DateFormatter.init()
        df.dateFormat = format
        return df
    }
    
    static var timeFormatter: DateFormatter = formatter(with: "h:mm")
    static var ampmFormatter: DateFormatter = formatter(with: "a")
}

extension Date {
    static func before(_ days: Int) -> Date {
        let timeInterval = Double(days) * 24 * 60 * 60
        return Date(timeIntervalSinceNow: -timeInterval)
    }
}

extension Date {
    var hmsRemoved: Date? {
        return Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: self)
    }
}

extension Array where Element: Hashable {
    func unique() -> [Element] {
        var set: Set<Element> = []
        var result: [Element] = []
        
        for element in self where set.contains(element) == false {
            set.insert(element)
            result.append(element)
        }
        
        return result
    }
}
