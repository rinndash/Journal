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

protocol EntryViewControllerDelegate: class {
    func didRemoveEntry(_ entry: Entry)
}

class EntryViewController: UIViewController {
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var textViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var button: UIBarButtonItem!
    @IBOutlet weak var removeButton: UIBarButtonItem!
    
    var environment: Environment!
    weak var delegate: EntryViewControllerDelegate?
    
    var journal: EntryRepository { return environment.entryRepository }
    var editingEntry: Entry?
    var hasEntry: Bool {
        return editingEntry != nil
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let date: Date = editingEntry?.createdAt ?? Date()
        
        title = DateFormatter.entryDateFormatter.string(from: date)
        textView.text = editingEntry?.text
        
        updateSubviews(for: hasEntry == false)
                        
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
        if hasEntry == false { textView.becomeFirstResponder() }
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
        textView.resignFirstResponder()
    }
    
    @objc func editEntry(_ sender: Any) {
        updateSubviews(for: true)
        textView.becomeFirstResponder()
    }
    
    @IBAction func removeEntry(_ sender: Any) {
        guard let entryToRemove = editingEntry else { return }
        
        let alertController = UIAlertController(
            title: "현재 일기를 삭제할까요?", 
            message: "이 동작은 되돌릴 수 없습니다", 
            preferredStyle: .actionSheet
        )
        
        let removeAction: UIAlertAction = UIAlertAction(
            title: "삭제", 
            style: .destructive) { (_) in
                self.environment.entryRepository.remove(entryToRemove)
                self.editingEntry = nil
                
                // pop
                self.delegate?.didRemoveEntry(entryToRemove)
        }
        alertController.addAction(removeAction)
        
        let cancelAction: UIAlertAction = UIAlertAction(
            title: "취소", 
            style: .cancel, 
            handler: nil
        )
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }    
    
    fileprivate func updateSubviews(for isEditing: Bool) {
        textView.isEditable = true
        
        removeButton.isEnabled = hasEntry
        
        button.image = isEditing ? #imageLiteral(resourceName: "baseline_save_white_24pt") : #imageLiteral(resourceName: "baseline_edit_white_24pt")
        button.target = self
        button.action = isEditing 
            ? #selector(saveEntry(_:))
            : #selector(editEntry(_:))       
    }
}

