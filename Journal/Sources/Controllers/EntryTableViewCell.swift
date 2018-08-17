//
//  EntryTableViewCell.swift
//  Journal
//
//  Created by 윤진서 on 2018. 8. 11..
//  Copyright © 2018년 Jinseo Yoon. All rights reserved.
//

import UIKit

struct EntryTableViewCellModel {
    let entry: Entry
    
    var entryText: String { return entry.text }
    var createdDateText: String { return DateFormatter.timeFormatter.string(from: entry.createdAt) }
    var ampmText: String { return DateFormatter.ampmFormatter.string(from: entry.createdAt) }
}

class EntryTableViewCell: UITableViewCell {
    @IBOutlet weak var entryTextLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var ampmLabel: UILabel!
    
    var viewModel: EntryTableViewCellModel? {
        didSet {
            entryTextLabel.text = viewModel?.entryText
            timeLabel.text = viewModel?.createdDateText
            ampmLabel.text = viewModel?.ampmText
        }
    }
}
