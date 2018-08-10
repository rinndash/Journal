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
    private var editingEntry: Entry?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textView.text = "첫 번째 일기"
        dateLabel.text = DateFormatter.entryDateFormatter.string(from: Date())
        
        updateSubviews(for: true)
    }
    
    @objc private func saveEntry() {
        if let oldEntry = self.editingEntry {
            oldEntry.text = textView.text
            journal.update(oldEntry)
        } else {
            let newEntry: Entry = Entry(text: textView.text)
            journal.add(newEntry)
            editingEntry = newEntry
        }
        
        updateSubviews(for: false)
    }
    
    @objc private func editEntry() {
        updateSubviews(for: true)
    }
    
    private func updateSubviews(for isEditing: Bool) {
        if isEditing {
            textView.isUserInteractionEnabled = true
            textView.becomeFirstResponder()
            
            button.setTitle("저장하기", for: .normal)
            button.removeTarget(self, action: nil, for: .touchUpInside)
            button.addTarget(self, action: #selector(saveEntry), for: .touchUpInside)
            
        } else {
            textView.isUserInteractionEnabled = false
            textView.resignFirstResponder()
            
            button.setTitle("수정하기", for: .normal)
            button.removeTarget(self, action: nil, for: .touchUpInside)
            button.addTarget(self, action: #selector(editEntry), for: .touchUpInside)
        }
    }
}
