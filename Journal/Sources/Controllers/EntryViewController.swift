//
//  ViewController.swift
//  Journal
//
//  Created by JinSeo Yoon on 2018. 7. 21..
//  Copyright © 2018년 Jinseo Yoon. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class EntryViewController: UIViewController {
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var textViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var button: UIBarButtonItem!
    @IBOutlet weak var removeButton: UIBarButtonItem!
    
    var viewModel: EntryViewViewModel!
    private let disposeBag: DisposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = viewModel.title
        textView.text = viewModel.textViewText
        textView.font = viewModel.textViewFont
        
        updateSubviews()
        
        button.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let `self` = self else { return }
                if self.viewModel.isEditing {
                    self.saveEntry(self)
                } else {
                    self.editEntry(self)
                }
            })
            .disposed(by: disposeBag)
        
        Observable.merge(
            NotificationCenter.default.rx.notification(.UIKeyboardWillShow),
            NotificationCenter.default.rx.notification(.UIKeyboardWillHide)
            ).subscribe(onNext: { [weak self] note in
                self?.handleKeyboardAppearance(note)
            })
            .disposed(by: disposeBag)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if viewModel.isEditing { textView.becomeFirstResponder() }
    }
    
    @objc func saveEntry(_ sender: Any) {
        viewModel.completeEditing(with: textView.text)        
        updateSubviews()
        textView.resignFirstResponder()
    }
    
    @objc func editEntry(_ sender: Any) {
        viewModel.startEditing()
        updateSubviews()
        textView.becomeFirstResponder()
    }
    
    @IBAction func removeEntry(_ sender: Any) {
        guard viewModel.hasEntry else { return }
        
        let alertController = UIAlertController(
            title: "현재 일기를 삭제할까요?", 
            message: "이 동작은 되돌릴 수 없습니다", 
            preferredStyle: .actionSheet
        )
        
        let removeAction: UIAlertAction = UIAlertAction(
            title: "삭제", 
            style: .destructive) { (_) in
                guard 
                    let _ = self.viewModel.removeEntry() 
                    else { return }
                // pop
                self.navigationController?.popViewController(animated: true)
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
    
    fileprivate func updateSubviews() {
        textView.isEditable = viewModel.textViewEditiable
        removeButton.isEnabled = viewModel.removeButtonEnabled
        button.image = viewModel.buttonImage
    }
}

// MARK - Keyboard 컨트롤

extension EntryViewController {
    private func handleKeyboardAppearance(_ note: Notification) {
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
}
