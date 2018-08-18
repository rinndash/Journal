//
//  ViewController.swift
//  Journal
//
//  Created by JinSeo Yoon on 2018. 7. 21..
//  Copyright © 2018년 Jinseo Yoon. All rights reserved.
//

import UIKit

extension DateFormatter {
    static var entryDateFormatter: DateFormatter = { () -> DateFormatter in
        let df = DateFormatter()
        df.dateFormat = "yyyy. MM. dd. EEE"
        return df 
    }()
}

class EntryViewController: UIViewController {
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var textViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var button: UIBarButtonItem!
    
    var environment: Environment!
    
    var journal: EntryRepository { return environment.entryRepository }
    var editingEntry: Entry?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let date: Date = editingEntry?.createdAt ?? Date()
        
        title = DateFormatter.entryDateFormatter.string(from: date)
        textView.text = editingEntry?.text
                        
        NotificationCenter.default
            .addObserver(self, 
                         selector: #selector(handleKeyboardAppearance(_:)), 
                         name: NSNotification.Name.UIKeyboardWillShow, 
                         object: nil)
        
        NotificationCenter.default
            .addObserver(self, 
                         selector: #selector(handleKeyboardAppearance(_:)), 
                         name: NSNotification.Name.UIKeyboardWillHide, 
                         object: nil)
    }
    
    @objc func handleKeyboardAppearance(_ note: Notification) {
        guard 
            let userInfo = note.userInfo,
            let keyboardFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue),
            let duration = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as? TimeInterval),
            let curve = (userInfo[UIKeyboardAnimationCurveUserInfoKey] as? UInt)
            else { return }
        
        let isKeyboardWillShow: Bool = note.name == Notification.Name.UIKeyboardWillShow 
        let keyboardHeight = isKeyboardWillShow  
            ? keyboardFrame.cgRectValue.height
            : 0
        
        let animationOption = UIViewAnimationOptions.init(rawValue: curve)
        
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
        
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        updateSubviews(for: true)
    }
    
    @objc func saveEntry(_ sender: Any) {
        if let editing = editingEntry {
            editing.text = textView.text
            journal.update(editing)
        } else {
            let entry: Entry = Entry(text: textView.text)
            journal.add(entry)
            editingEntry = entry
        }
        
        updateSubviews(for: false)
    }
    
    @objc func editEntry(_ sender: Any) {
        updateSubviews(for: true)
    }
    
    fileprivate func updateSubviews(for isEditing: Bool) {
        textView.isEditable = true
        _ = isEditing
            ? textView.becomeFirstResponder()
            : textView.resignFirstResponder()
        
        button.image = isEditing ? #imageLiteral(resourceName: "baseline_save_white_24pt") : #imageLiteral(resourceName: "baseline_edit_white_24pt")
        button.target = self
        button.action = isEditing 
            ? #selector(saveEntry(_:))
            : #selector(editEntry(_:))       
    }
}

