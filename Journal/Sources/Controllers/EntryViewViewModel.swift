//
//  EntryViewViewModel.swift
//  Journal
//
//  Created by JinSeo Yoon on 2018. 8. 25..
//  Copyright © 2018년 Jinseo Yoon. All rights reserved.
//

import UIKit

protocol EntryViewViewModelDelegate: class {
    func didAddEntry(_ entry: EntryType)
    func didRemoveEntry(_ entry: EntryType)
}

class EntryViewViewModel {
    let environment: Environment
    weak var delegate: EntryViewViewModelDelegate? 
    
    private var entry: EntryType?
    private(set) var isEditing: Bool = false
    var hasEntry: Bool { return entry != nil }
    
    init(environment: Environment, entry: EntryType? = nil) {
        self.environment = environment
        self.entry = entry
        self.isEditing = entry == nil
    }
}

extension EntryViewViewModel {
    var textViewText: String? {
        return entry?.text
    }
    
    var textViewFont: UIFont {
        return UIFont.systemFont(ofSize: environment.settings.fontSizeOption.rawValue)
    }
    
    var title: String {
        let date: Date = entry?.createdAt ?? environment.now()
        return DateFormatter.formatter(with: environment.settings.dateFormatOption.rawValue)
            .string(from: date)
    }
    
    var textViewEditiable: Bool {
        return isEditing
    }
    
    var buttonImage: UIImage {
        return isEditing ? #imageLiteral(resourceName: "baseline_save_white_24pt") : #imageLiteral(resourceName: "baseline_edit_white_24pt")
    }
    
    var removeButtonEnabled: Bool {
        return hasEntry
    }
}

extension EntryViewViewModel {
    func startEditing() {
        isEditing = true
    }
    
    func completeEditing(with text: String) {
        isEditing = false
        
        if let editingEntry = entry {
            environment.entryRepository.update(editingEntry, text: text)
        } else {
            let newEntry = environment.entryFactory(text)
            environment.entryRepository.add(newEntry)
            delegate?.didAddEntry(newEntry)
        }
    }
    
    func removeEntry() -> EntryType? {
        guard let entryToRemove = entry else { return nil }
        environment.entryRepository.remove(entryToRemove)
        self.entry = nil
        delegate?.didRemoveEntry(entryToRemove)
        return entryToRemove
    }
}
