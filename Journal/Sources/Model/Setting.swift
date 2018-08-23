//
//  Setting.swift
//  Journal
//
//  Created by 윤진서 on 2018. 8. 21..
//  Copyright © 2018년 Jinseo Yoon. All rights reserved.
//

import UIKit

protocol SettingOption {
    static var name: String { get }
}

enum DateFormatOption: String, SettingOption {
    case `default` = "yyyy. M. dd. EEE"
    case western = "EEE, MMM d, yyyy"
    
    static var name: String { return "날짜 표시" }
    static var all: [DateFormatOption] { return [.default, .western] }
}

enum FontSizeOption: CGFloat, SettingOption, CustomStringConvertible {
    case small = 14
    case medium = 16
    case large = 18
    
    var description: String {
        switch self {
        case .small: return "Small"
        case .medium: return "Medium"
        case .large: return "Large"
        }
    }
    
    static var name: String { return "글자 크기" }
    static var `default`: FontSizeOption { return .medium }
    static var all: [FontSizeOption] { return [.small, .medium, .large] }
}

protocol Settings {
    var dateFormat: DateFormatOption { get set }
    var fontSize: FontSizeOption { get set }
}

extension Settings {
    var dateFormatter: DateFormatter {
        let df = DateFormatter()
        df.dateFormat = dateFormat.rawValue
        return df
    }
}
