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
    @IBOutlet weak var button: UIBarButtonItem!
    @IBOutlet weak var textViewBottomConstraint: NSLayoutConstraint!
    
    var environment: Environment!
    private var editingEntry: Entry?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textView.text = code
        title = DateFormatter.entryDateFormatter.string(from: Date())
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardAppearance(note:)), name: Notification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardAppearance(note:)), name: Notification.Name.UIKeyboardWillHide, object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updateSubviews(for: true)
    }
    
    @objc private func handleKeyboardAppearance(note: Notification) {
        guard
            let userInfo = note.userInfo,
            let keyboardFrameValue = userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue,
            let duration = userInfo[UIKeyboardAnimationDurationUserInfoKey] as? TimeInterval,
            let animationCurve = userInfo[UIKeyboardAnimationCurveUserInfoKey] as? UInt
            else { return }
        
        let keyboardHeight: CGFloat = note.name == Notification.Name.UIKeyboardWillShow
            ? keyboardFrameValue.cgRectValue.height
            : 0
        let animationOption = UIViewAnimationOptions(rawValue: animationCurve)
        
        UIView.animate(
            withDuration: duration,
            delay: 0.0,
            options: animationOption,
            animations: {
                self.textViewBottomConstraint.constant = -keyboardHeight
                self.view.layoutIfNeeded()
            },
            completion: nil
        )
    }
    
    @objc private func saveEntry(_ sender: Any) {
        if let oldEntry = self.editingEntry {
            oldEntry.text = textView.text
            environment.entryRepository.update(oldEntry)
        } else {
            let newEntry: Entry = Entry(text: textView.text)
            environment.entryRepository.add(newEntry)
            editingEntry = newEntry
        }
        
        updateSubviews(for: false)
    }
    
    @objc private func editEntry() {
        updateSubviews(for: true)
    }
    
    private func updateSubviews(for isEditing: Bool) {
        button.image = isEditing ? #imageLiteral(resourceName: "baseline_save_white_24pt") : #imageLiteral(resourceName: "baseline_edit_white_24pt")
        button.target = self
        button.action = isEditing ? #selector(saveEntry(_:)) : #selector(editEntry)
        
        textView.isEditable = isEditing
        _ = isEditing ? textView.becomeFirstResponder() : textView.resignFirstResponder()
    }
}
