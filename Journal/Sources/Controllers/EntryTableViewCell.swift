//
//  EntryTableViewCell.swift
//  Journal
//
//  Created by JinSeo Yoon on 2018. 8. 18..
//  Copyright © 2018년 Jinseo Yoon. All rights reserved.
//

import UIKit

class EntryTableViewCellViewModel {
    let environment: Environment
    let entry: EntryType
    
    init(entry: EntryType, environment: Environment) {
        self.entry = entry
        self.environment = environment
    }
    
    var entryText: String { return entry.text }
    var entryTextFont: UIFont { 
        return UIFont.systemFont(ofSize: environment.settings.fontSizeOption.rawValue)
    }
    var timeText: String { return DateFormatter.entryTimeFormatter.string(from: entry.createdAt) }
    var ampmText: String { return DateFormatter.ampmFormatter.string(from: entry.createdAt) }
} 

class EntryTableViewCell: UITableViewCell {
    @IBOutlet weak var entryTextLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var ampmLabel: UILabel!
    
    var viewModel: EntryTableViewCellViewModel? {
        didSet {
            guard let vm = viewModel else { return }
            entryTextLabel.text = vm.entryText
            entryTextLabel.font = vm.entryTextFont
            timeLabel.text = vm.timeText
            ampmLabel.text = vm.ampmText
        }
    }
}
