//
//  TimelineViewModel.swift
//  Journal
//
//  Created by 윤진서 on 2018. 8. 16..
//  Copyright © 2018년 Jinseo Yoon. All rights reserved.
//

import Foundation

extension EntryRepository {
    var allEntries: [Entry] {
        return recentEntries(max: numberOfEntries)
    }
}

class TimelineViewControllerModel {
    let environment: Environment
    
    private var dates: [Date]
    private var entries: [Entry] { return environment.entryRepository.allEntries }
    
    private func entries(for day: Date) -> [Entry] {
        return entries.filter { $0.createdAt.hmsRemoved == day }
    }
    private func entry(for indexPath: IndexPath) -> Entry {
        return entries(for: dates[indexPath.section])[indexPath.row]
    }
    
    init(environment: Environment) {
        self.environment = environment
        self.dates = environment.entryRepository.allEntries
            .compactMap { $0.createdAt.hmsRemoved }
            .unique()
    }
    
    var title: String { return "Journal" }
    
    var numberOfDates: Int { return dates.count }
    
    func headerTitle(of section: Int) -> String {
        return DateFormatter.entryDateFormatter.string(from: dates[section])
    }
    
    func numberOfItems(of section: Int) -> Int {
        return entries(for: dates[section]).count
    }
    
    func entryTableViewCellModel(for indexPath: IndexPath) -> EntryTableViewCellModel {
        let entry = self.entry(for: indexPath)
        return EntryTableViewCellModel(entry: entry)
    }
    
    func newEntryViewViewModel() -> EntryViewControllerModel {
        return EntryViewControllerModel(environment: environment)
    }
    
    func entryViewModel(for indexPath: IndexPath) -> EntryViewControllerModel {
        return EntryViewControllerModel(environment: environment, entry: entry(for: indexPath))
    }
    
    func removeEntry(at indexPath: IndexPath) {
        let isLastEntryInSection = numberOfItems(of: indexPath.section) == 1
        let entryToRemove = entry(for: indexPath)
        self.environment.entryRepository.remove(entryToRemove)
        if isLastEntryInSection { self.dates = self.dates.filter { $0 != entryToRemove.createdAt.hmsRemoved } }
    }
}
