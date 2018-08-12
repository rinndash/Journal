//
//  ViewController.swift
//  Journal
//
//  Created by JinSeo Yoon on 2018. 7. 21..
//  Copyright © 2018년 Jinseo Yoon. All rights reserved.
//

import UIKit
import SnapKit

extension DateFormatter {
    static var entryDateFormatter: DateFormatter = { () -> DateFormatter in
        let df = DateFormatter()
        df.dateFormat = "yyyy. MM. dd. EEE"
        return df 
    }()
}

let code = """
class EntryViewController: UIViewController {
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var button: UIButton!

    let journal: Journal = InMemoryJournal()
    private var editingEntry: Entry?

    override func viewDidLoad() {
        super.viewDidLoad()

        dateLabel.text = DateFormatter.entryDateFormatter.string(from: Date())
        textView.text = "IBOutlet으로 연결한 TextView"

        button.addTarget(self, 
            action: #selector(saveEntry(_:)), 
            for: .touchUpInside
        )
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        textView.becomeFirstResponder()
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

        print("저장")
        updateSubviews(for: false)
    }

    @objc func editEntry(_ sender: Any) {
        print("수정")
        updateSubviews(for: true)
    }

    fileprivate func updateSubviews(for isEditing: Bool) {
        if isEditing {
            textView.isEditable = true
            textView.becomeFirstResponder()

            button.setTitle("저장하기", for: .normal)
            button.removeTarget(self, action: nil, for: .touchUpInside)
            button.addTarget(self, 
                action: #selector(saveEntry(_:)), 
                for: .touchUpInside)
        } else {
            textView.isEditable = false
            textView.resignFirstResponder()

            button.setTitle("수정하기", for: .normal)
            button.removeTarget(self, action: nil, for: .touchUpInside)
            button.addTarget(self, 
                action: #selector(editEntry(_:)), 
                for: .touchUpInside)
        }        
    }
}
"""

class EntryViewController: UIViewController {
    let headerView: UIView = UIView()
    let dateLabel: UILabel = UILabel()
    let textView: UITextView = UITextView()
    let button: UIButton = UIButton(type: .system)
    var headerViewHeightConstraint: Constraint!
    var textViewBottomConstraint: Constraint!
    
    let journal: Journal = InMemoryJournal()
    private var editingEntry: Entry?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        addSubviews()
        layout()
        
        headerView.backgroundColor = UIColor.yellow
        dateLabel.text = DateFormatter.entryDateFormatter.string(from: Date())
        textView.text = code
        
        updateSubviews(for: true)
        
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        textView.becomeFirstResponder()
    }
    
    private func addSubviews() {
        headerView.addSubview(dateLabel)
        headerView.addSubview(button)
        view.addSubview(headerView)
        view.addSubview(textView)
    }
    
    private func layout() {
        dateLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(8)
            $0.bottom.equalToSuperview().inset(8)
            $0.trailing.lessThanOrEqualTo(button.snp.leading).inset(8)
        }
        
        button.snp.makeConstraints {
            $0.centerY.equalTo(dateLabel)
            $0.trailing.equalToSuperview().inset(8)
        }
        
        headerView.snp.makeConstraints {
            $0.leading.top.trailing.equalToSuperview()
            headerViewHeightConstraint = $0.height.equalTo(100).constraint
        }
        
        textView.snp.makeConstraints {
            $0.top.equalTo(headerView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            textViewBottomConstraint = $0.bottom.equalToSuperview().constraint
        }
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
        let headerHeight = isKeyboardWillShow
            ? 50
            : 100
        
        let animationOption = UIViewAnimationOptions.init(rawValue: curve)
        
        UIView.animate(
            withDuration: duration, 
            delay: 0.0, 
            options: animationOption, 
            animations: {
                self.headerViewHeightConstraint.update(offset: headerHeight)
                self.textViewBottomConstraint.update(offset: -keyboardHeight) 
                self.view.layoutIfNeeded()
            }, 
            completion: nil
        )
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
    
    fileprivate func updateSubviews(for isEditing: Bool) {
        if isEditing {
            textView.isEditable = true
            
            button.setTitle("저장하기", for: .normal)
            button.removeTarget(self, action: nil, for: .touchUpInside)
            button.addTarget(self, 
                             action: #selector(saveEntry(_:)), 
                             for: .touchUpInside)
        } else {
            textView.isEditable = false
            
            button.setTitle("수정하기", for: .normal)
            button.removeTarget(self, action: nil, for: .touchUpInside)
            button.addTarget(self, 
                             action: #selector(editEntry(_:)), 
                             for: .touchUpInside)
        }        
    }
}

