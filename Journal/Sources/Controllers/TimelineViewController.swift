//
//  TimelineViewController.swift
//  Journal
//
//  Created by 윤진서 on 2018. 8. 11..
//  Copyright © 2018년 Jinseo Yoon. All rights reserved.
//

import UIKit

class TimelineViewController: UIViewController {
    @IBOutlet weak var entryCountLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Journal"
        
        let journal = InMemoryJournal()
        entryCountLabel.text = "엔트리 수: \(journal.numberOfEntries)"
    }
}
