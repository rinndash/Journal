//
//  UserDefaultsSettings.swift
//  Journal
//
//  Created by JinSeo Yoon on 2018. 8. 25..
//  Copyright © 2018년 Jinseo Yoon. All rights reserved.
//

import UIKit

private let dateFormatOptionKey: String = "dateFormatOptionKey"
private let fontSizeOptionKey: String = "fontSizeOptionKey"

extension UserDefaults: Settings {
    var dateFormatOption: DateFormatOption {
        get {
            let rawValue = object(forKey: dateFormatOptionKey) as? String
            print("dateFormatOption rawValue: ", rawValue)
            return rawValue.flatMap(DateFormatOption.init) ?? .default
        }
        set {
            set(newValue.rawValue, forKey: dateFormatOptionKey)
            print("-----")
            print("save dateFormatOption: \(newValue)")
            print(synchronize())
        }
    }
    
    var fontSizeOption: FontSizeOption {
        get {
            let rawValue = object(forKey: fontSizeOptionKey) as? CGFloat
            print("fontSizeOption rawValue: ", rawValue)
            if 
                let rawValue = rawValue,
                let option = FontSizeOption(rawValue: rawValue)
            {
                return option
            } else {
                return FontSizeOption.default
            }
        }
        set {
            set(newValue.rawValue, forKey: fontSizeOptionKey)
            
            print("-----")
            print("save fontSizeOption: \(newValue)")
            print(synchronize())
        }
    }
}
