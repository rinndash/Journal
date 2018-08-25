//
//  SettingsTableViewViewModel.swift
//  Journal
//
//  Created by JinSeo Yoon on 2018. 8. 25..
//  Copyright © 2018년 Jinseo Yoon. All rights reserved.
//

import UIKit

struct SettingItemSectionModel {
    let title: String
    let cellModels: [SettingOptionCellModel]
}

struct SettingOptionCellModel {
    let title: String
    let font: UIFont
    let isChecked: Bool
}

class SettingsTableViewViewModel {
    let environment: Environment
    
    init(environment: Environment) {
        self.environment = environment
    }
    
    var sectionModels: [SettingItemSectionModel] {
        let now = environment.now()
        return environment.settings.sectionModels(now: now)
    }
    
    func selectOption(for indexPath: IndexPath) {
        switch indexPath.section {
        case 0: // 날짜 포맷을 변경했음
            let newOption = DateFormatOption.all[indexPath.row]
            environment.settings.dateFormatOption = newOption
            
        case 1: // 폰트 크기를 변경했음
            let newOption = FontSizeOption.all[indexPath.row]
            environment.settings.fontSizeOption = newOption
            
        default:
            break
        }
    }
}

extension Settings {
    func sectionModels(now: Date) -> [SettingItemSectionModel] {
        return [
            SettingItemSectionModel(
                title: DateFormatOption.name, 
                cellModels: DateFormatOption.all.map { option in
                    SettingOptionCellModel(
                        title: DateFormatter.formatter(with: option.rawValue).string(from: now), 
                        font: UIFont.systemFont(ofSize: UIFont.systemFontSize), 
                        isChecked: option == dateFormatOption
                    )
                }
            ),
            SettingItemSectionModel(
                title: FontSizeOption.name, 
                cellModels: FontSizeOption.all.map { option in
                    SettingOptionCellModel(
                        title: "\(option)", 
                        font: UIFont.systemFont(ofSize: option.rawValue), 
                        isChecked: option == fontSizeOption
                    )
                }
            )
        ]
    }
}
