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
    @IBOutlet weak var button: UIButton!
    
    private let journal: Journal = InMemoryJournal()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textView.text = "첫 번째 일기"
        dateLabel.text = DateFormatter.entryDateFormatter.string(from: Date())
        
        button.addTarget(self, action: #selector(saveEntry), for: .touchUpInside)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        textView.becomeFirstResponder()
    }
    
    @objc func saveEntry() {
        let entry: Entry = Entry(text: textView.text)
        journal.add(entry)
        
        textView.resignFirstResponder()
        textView.isUserInteractionEnabled = false
        button.setTitle("수정하기", for: .normal)
        button.removeTarget(self, action: nil, for: .touchUpInside)
        button.addTarget(self, action: #selector(editEntry), for: .touchUpInside)
    }
    
    @objc func editEntry() {
        textView.isUserInteractionEnabled = true
        button.setTitle("저장하기", for: .normal)
        button.removeTarget(self, action: nil, for: .touchUpInside)
        button.addTarget(self, action: #selector(saveEntry), for: .touchUpInside)
        
        textView.becomeFirstResponder()
    }
}

