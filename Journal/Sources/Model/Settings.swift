//
//  Settings.swift
//  Journal
//
//  Created by JinSeo Yoon on 2018. 8. 25..
//  Copyright © 2018년 Jinseo Yoon. All rights reserved.
//

import UIKit

protocol SettingOption {
    static var name: String { get }
    static var `default`: Self { get }
    static var all: [Self] { get }
}

enum DateFormatOption: String, SettingOption {
    case yearFirst = "yyyy. MM. dd. EEE"
    case dayOfWeekFirst = "EEE, MMM d, yyyy"
    
    static var name: String { return "날짜 표현" }
    static var `default`: DateFormatOption { return .yearFirst }
    static var all: [DateFormatOption] { return [.yearFirst, .dayOfWeekFirst] }
}

enum FontSizeOption: CGFloat, SettingOption, CustomStringConvertible {
    case small = 12
    case medium = 16
    case large = 20
    
    static var name: String { return "글자 크기" }
    static var `default`: FontSizeOption { return .medium }
    static var all: [FontSizeOption] { return [.small, .medium, .large] }
    
    var description: String {
        switch self {
        case .small: return "Small"
        case .medium: return "Medium"
        case .large: return "Large"
        }
    }
}

protocol Settings {
    var dateFormatOption: DateFormatOption { get set }
    var fontSizeOption: FontSizeOption { get set }
}

class InMemorySettings: Settings {
    var dateFormatOption: DateFormatOption = .default
    var fontSizeOption: FontSizeOption = .default
}
