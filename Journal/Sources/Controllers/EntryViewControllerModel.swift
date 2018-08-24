//
//  EntryViewControllerModel.swift
//  Journal
//
//  Created by 윤진서 on 2018. 8. 16..
//  Copyright © 2018년 Jinseo Yoon. All rights reserved.
//

import UIKit

protocol EntryViewViewModelDelegate: class {
    func didAddEntry(_ entry: Entry)
    func didRemoveEntry(_ entry: Entry)
}

class EntryViewControllerModel {
    private let environment: Environment
    private var entry: Entry?
    
    weak var delegate: EntryViewViewModelDelegate?
    
    init(environment: Environment, entry: Entry? = nil) {
        self.environment = environment
        self.entry = entry
    }
    
    var hasEntry: Bool { return entry != nil }
    var trashIconEnabled: Bool { return hasEntry }
    
    var title: String {
        let date = entry?.createdAt ?? environment.now()
        return DateFormatter.entryDateFormatter.string(from: date)
    }
    
    var textViewText: String? { return entry?.text }
    
    private(set) var isEditing: Bool = false
    var textViewEditable: Bool { return isEditing }
    var buttonImage: UIImage { return isEditing ? #imageLiteral(resourceName: "baseline_save_white_24pt") : #imageLiteral(resourceName: "baseline_edit_white_24pt") }
    
    func startEditing() {
        isEditing = true
    }
    
    func completeEditing(with text: String) {
        if let oldEntry = self.entry {
            oldEntry.text = text
            environment.entryRepository.update(oldEntry)
        } else {
            let newEntry: Entry = Entry(text: text)
            environment.entryRepository.add(newEntry)
            delegate?.didAddEntry(newEntry)
            entry = newEntry
        }
        isEditing = false
    }
    
    func removeEntry() -> Entry? {
        guard let entryToRemove = entry else { return nil }
        self.environment.entryRepository.remove(entryToRemove)
        self.entry = nil
        self.delegate?.didRemoveEntry(entryToRemove)
        return entryToRemove
    }
}
