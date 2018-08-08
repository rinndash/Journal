//
//  ViewController.swift
//  Journal
//
//  Created by JinSeo Yoon on 2018. 7. 21..
//  Copyright © 2018년 Jinseo Yoon. All rights reserved.
//

import UIKit

extension DateFormatter {
    static var entryDateFormatter: DateFormatter = {
        let df = DateFormatter.init()
        df.dateFormat = "yyyy. M. dd. EEE"
        return df
    }()
}

class EntryViewController: UIViewController {
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var dateLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textView.text = "첫 번째 일기"
        dateLabel.text = DateFormatter.entryDateFormatter.string(from: Date())
    }
}

