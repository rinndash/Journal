//
//  EntryTableViewCell.swift
//  Journal
//
//  Created by 윤진서 on 2018. 8. 11..
//  Copyright © 2018년 Jinseo Yoon. All rights reserved.
//

import UIKit

struct EntryTableViewCellModel {
    let entry: EntryType
    let environment: Environment
    
    var entryText: String { return entry.text }
    var entryTextFont: UIFont { return UIFont.systemFont(ofSize: environment.settings.fontSize.rawValue) }
    var createdDateText: String { return DateFormatter.timeFormatter.string(from: entry.createdAt) }
    var ampmText: String { return DateFormatter.ampmFormatter.string(from: entry.createdAt) }
    
    var entryViewModel: EntryViewControllerModel {
        return EntryViewControllerModel(environment: environment, entry: entry)
    }
}

class EntryTableViewCell: UITableViewCell {
    @IBOutlet weak var entryTextLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var ampmLabel: UILabel!
    
    var viewModel: EntryTableViewCellModel? {
        didSet {
            entryTextLabel.text = viewModel?.entryText
            entryTextLabel.font = viewModel?.entryTextFont
            timeLabel.text = viewModel?.createdDateText
            ampmLabel.text = viewModel?.ampmText
        }
    }
}
