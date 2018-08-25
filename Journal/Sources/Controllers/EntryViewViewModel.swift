//
//  EntryViewViewModel.swift
//  Journal
//
//  Created by JinSeo Yoon on 2018. 8. 25..
//  Copyright © 2018년 Jinseo Yoon. All rights reserved.
//

import UIKit

protocol EntryViewViewModelDelegate: class {
    func didAddEntry(_ entry: Entry)
    func didRemoveEntry(_ entry: Entry)
}

class EntryViewViewModel {
    let environment: Environment
    
    weak var delegate: EntryViewViewModelDelegate? 
    
    private var entry: Entry?
    
    var hasEntry: Bool {
        return entry != nil
    }
    
    var textViewText: String? { 
        return entry?.text
    }
    
    var title: String {
        let date: Date = entry?.createdAt ?? environment.now()
        return DateFormatter.entryDateFormatter.string(from: date)
    }
    
    var removeButtonEnabled: Bool {
        return hasEntry
    }
    
    init(environment: Environment, entry: Entry? = nil) {
        self.environment = environment
        self.entry = entry
    }
    
    private(set) var isEditing: Bool = false
    
    func startEditing() {
        isEditing = true
    }
    
    func completeEditing(with text: String) {
        isEditing = false
        
        if let editingEntry = entry {
            editingEntry.text = text
            environment.entryRepository.update(editingEntry)
        } else {
            let newEntry = Entry(text: text)
            environment.entryRepository.add(newEntry)
            delegate?.didAddEntry(newEntry)
        }
    }
    
    func removeEntry() -> Entry? {
        guard let entryToRemove = entry else { return nil }
        environment.entryRepository.remove(entryToRemove)
        self.entry = nil
        delegate?.didRemoveEntry(entryToRemove)
        return entryToRemove
    }
    
    var textViewEditiable: Bool {
        return isEditing
    }
    
    var buttonImage: UIImage {
        return isEditing ? #imageLiteral(resourceName: "baseline_save_white_24pt") : #imageLiteral(resourceName: "baseline_edit_white_24pt")
    }
}
