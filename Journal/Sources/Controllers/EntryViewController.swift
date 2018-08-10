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

private let code = """
class EntryViewController: UIViewController {
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var button: UIButton!

    private let journal: Journal = InMemoryJournal()
    private var editingEntry: Entry?

    override func viewDidLoad() {
        super.viewDidLoad()

        textView.text = loremIpsum
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
"""

class EntryViewController: UIViewController {
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var textViewBottomConstraint: NSLayoutConstraint!
    
    private let journal: Journal = InMemoryJournal()
    private var editingEntry: Entry?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textView.text = code
        dateLabel.text = DateFormatter.entryDateFormatter.string(from: Date())
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(note:)), name: Notification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(note:)), name: Notification.Name.UIKeyboardWillHide, object: nil)
        
        updateSubviews(for: true)
    }
    
    @objc private func keyboardWillShow(note: Notification) {
        guard
            let userInfo = note.userInfo,
            let keyboardFrameValue = userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue
            else { return }
        
        let keyboardHeight: CGFloat = keyboardFrameValue.cgRectValue.height
        textViewBottomConstraint.constant = -keyboardHeight
    }
    
    @objc private func keyboardWillHide(note: Notification) {
        textViewBottomConstraint.constant = 0
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
            textView.isEditable = true
            textView.becomeFirstResponder()
            
            button.setTitle("저장하기", for: .normal)
            button.removeTarget(self, action: nil, for: .touchUpInside)
            button.addTarget(self, action: #selector(saveEntry), for: .touchUpInside)
            
        } else {
            textView.isEditable = false
            textView.resignFirstResponder()
            
            button.setTitle("수정하기", for: .normal)
            button.removeTarget(self, action: nil, for: .touchUpInside)
            button.addTarget(self, action: #selector(editEntry), for: .touchUpInside)
        }
    }
}

