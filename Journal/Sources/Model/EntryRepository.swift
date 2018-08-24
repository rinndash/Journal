//
//  Journal.swift
//  Journal
//
//  Created by JinSeo Yoon on 2018. 8. 3..
//  Copyright © 2018년 Jinseo Yoon. All rights reserved.
//

import Foundation

protocol EntryRepository {
    var numberOfEntries: Int { get }
    
    func add(_ entry: EntryType)
    func update(_ entry: EntryType)
    func remove(_ entry: EntryType)
    func entry(with id: UUID) -> EntryType?
    func recentEntries(max: Int) -> [EntryType]
}

class InMemoryEntryRepository: EntryRepository {
    private var entries: [UUID: EntryType]
    
    init(entries: [Entry] = []) {
        var result: [UUID: Entry] = [:]
        
        entries.forEach { entry in
            result[entry.id] = entry
        }
        
        self.entries = result
    }
    
    var numberOfEntries: Int { return entries.count }
    
    func add(_ entry: EntryType) {
        entries[entry.id] = entry
    }
    
    func update(_ entry: EntryType) {
        // entries[entry.id] = entry
    }
    
    func remove(_ entry: EntryType) {
        entries[entry.id] = nil
    }
    
    func entry(with id: UUID) -> EntryType? {
        return entries[id]
    }
    
    func recentEntries(max: Int) -> [EntryType] {
        let result = entries
            .values
            .sorted { $0.createdAt > $1.createdAt  }
            .prefix(max)
        
        return Array(result) 
    }
}

extension InMemoryEntryRepository {
    static let shared: InMemoryEntryRepository = InMemoryEntryRepository()
}
