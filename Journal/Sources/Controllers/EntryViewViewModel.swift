//
//  EntryViewViewModel.swift
//  Journal
//
//  Created by JinSeo Yoon on 2018. 8. 25..
//  Copyright © 2018년 Jinseo Yoon. All rights reserved.
//

import UIKit
import RxSwift

protocol EntryViewViewModelDelegate: class {
    func didAddEntry(_ entry: EntryType)
    func didRemoveEntry(_ entry: EntryType)
}

class EntryViewViewModel {
    enum Event {
        case didTapEdit
        case didTapSave(String)
        case didTapRemove
    }
    
    let environment: Environment
    weak var delegate: EntryViewViewModelDelegate? 
    
    private let _entry: Variable<EntryType?>
    private let _isEditing: Variable<Bool>
    
    private let _event: PublishSubject<Event> = PublishSubject()
    
    init(environment: Environment, entry: EntryType? = nil) {
        self.environment = environment
        _entry = Variable(entry)
        _isEditing = Variable(entry == nil)
    }
}

extension EntryViewViewModel {
    var isEditing: Observable<Bool> { return _isEditing.asObservable() }
    
    var textViewEditiable: Observable<Bool> { return isEditing }
    var buttonImage: Observable<UIImage> { return isEditing.map { $0 ? #imageLiteral(resourceName: "baseline_save_white_24pt") : #imageLiteral(resourceName: "baseline_edit_white_24pt") } }
    var removeButtonEnabled: Observable<Bool> {
        return _entry.asObservable().map { $0 != nil }
    }
}

extension EntryViewViewModel {
    var textViewText: String? {
        return _entry.value?.text
    }
    
    var textViewFont: UIFont {
        return UIFont.systemFont(ofSize: environment.settings.fontSizeOption.rawValue)
    }
    
    var title: String {
        let date: Date = _entry.value?.createdAt ?? environment.now()
        return DateFormatter.formatter(with: environment.settings.dateFormatOption.rawValue)
            .string(from: date)
    }
}

extension EntryViewViewModel {
    func startEditing() {
        _isEditing.value = true
    }
    
    func completeEditing(with text: String) {
        _isEditing.value = false
        
        if let editingEntry = _entry.value {
            environment.entryRepository.update(editingEntry, text: text)
        } else {
            let newEntry = environment.entryFactory(text)
            environment.entryRepository.add(newEntry)
            delegate?.didAddEntry(newEntry)
        }
    }
    
    func removeEntry() -> EntryType? {
        guard let entryToRemove = _entry.value else { return nil }
        environment.entryRepository.remove(entryToRemove)
        _entry.value = nil
        delegate?.didRemoveEntry(entryToRemove)
        return entryToRemove
    }
}
