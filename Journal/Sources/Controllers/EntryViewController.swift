//
//  ViewController.swift
//  Journal
//
//  Created by JinSeo Yoon on 2018. 7. 21..
//  Copyright © 2018년 Jinseo Yoon. All rights reserved.
//

import UIKit

protocol EntryViewControllerDelegate: class {
    func didRemoveEntry(_ entry: Entry)
}

class EntryViewController: UIViewController {
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var button: UIBarButtonItem!
    @IBOutlet weak var textViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var trashIcon: UIBarButtonItem!
    
    weak var delegate: EntryViewControllerDelegate?
    
    var viewModel: EntryViewControllerModel!
    
    private func updateSubviews() {
        trashIcon.isEnabled = viewModel.trashIconEnabled
        
        button.image = viewModel.buttonImage
        button.target = self
        button.action = viewModel.isEditing ? #selector(saveEntry(_:)) : #selector(editEntry)
        
        textView.isEditable = viewModel.textViewEditable
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textView.text = viewModel.textViewText
        title = viewModel.title
        
        if viewModel.hasEntry == false { viewModel.startEditing() }
        updateSubviews()
        
        registerNotifications()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if viewModel.isEditing { textView.becomeFirstResponder() }
    }
    
    @objc private func saveEntry(_ sender: Any) {
        viewModel.completeEditing(with: textView.text)
        updateSubviews()
        textView.resignFirstResponder()
    }
    
    @objc private func editEntry() {
        viewModel.startEditing()
        updateSubviews()
        textView.becomeFirstResponder()
    }
    
    @IBAction func removeEntry(_ sender: Any) {
        guard viewModel.hasEntry else { return }
        
        let alertController = UIAlertController.init(title: "일기를 제거하겠습니까?", message: "이 작업은 되돌릴 수 없습니다", preferredStyle: .alert)
        let deleteAction = UIAlertAction(title: "확인", style: .destructive) { (action) in
            if let removedEntry = self.viewModel.removeEntry() {
                self.delegate?.didRemoveEntry(removedEntry)
            }
        }
        alertController.addAction(deleteAction)
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
}

extension EntryViewController {
    private func registerNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardAppearance(note:)), name: Notification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardAppearance(note:)), name: Notification.Name.UIKeyboardWillHide, object: nil)
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
}
