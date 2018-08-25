//
//  TimelineViewModel.swift
//  Journal
//
//  Created by 윤진서 on 2018. 8. 16..
//  Copyright © 2018년 Jinseo Yoon. All rights reserved.
//

import Foundation

extension EntryRepository {
    var allEntries: [EntryType] {
        return recentEntries(max: numberOfEntries)
    }
}

class TimelineViewControllerModel {
    let environment: Environment
    
    private var dates: [Date]
    private var entries: [EntryType] { return environment.entryRepository.allEntries }
    
    var searchText: String? {
        didSet {
            guard let text = searchText else {
                filteredEntries = []
                return
            }
            filteredEntries = environment.entryRepository.entries(contains: text)
        }
    }
    var isSearching: Bool {
        return searchText?.isEmpty == false
    }
    private var filteredEntries: [EntryType] = []
    
    private func entries(for day: Date) -> [EntryType] {
        return entries.filter { $0.createdAt.hmsRemoved == day }
    }
    private func entry(for indexPath: IndexPath) -> EntryType {
        return isSearching
            ? filteredEntries[indexPath.row]
            : entries(for: dates[indexPath.section])[indexPath.row]
    }
    
    init(environment: Environment) {
        self.environment = environment
        self.dates = environment.entryRepository.uniqueDates
    }
    
    var title: String { return "Journal" }
    
    var numberOfSections: Int {
        return isSearching ? 1 : dates.count
    }
    
    func headerTitle(of section: Int) -> String? {
        guard isSearching == false else { return nil }
        let df = DateFormatter.formatter(with: environment.settings.dateFormat.rawValue)
        return df.string(from: dates[section])
    }
    
    func numberOfItems(of section: Int) -> Int {
        return isSearching
            ? filteredEntries.count
            : entries(for: dates[section]).count
    }
    
    func entryTableViewCellModel(for indexPath: IndexPath) -> EntryTableViewCellModel {
        return EntryTableViewCellModel(entry: entry(for: indexPath), environment: environment)
    }
    
    func removeEntry(at indexPath: IndexPath) {
        let isLastEntryInSection = numberOfItems(of: indexPath.section) == 1
        let entryToRemove = entry(for: indexPath)
        let dateToFilter = entryToRemove.createdAt.hmsRemoved
        self.environment.entryRepository.remove(entryToRemove)
        if isLastEntryInSection { self.dates = self.dates.filter { $0 != dateToFilter } }
    }
    
    lazy var settingsViewModel: SettingsTableViewViewModel = SettingsTableViewViewModel(environment: environment)
}

extension TimelineViewControllerModel {
    func newEntryViewViewModel() -> EntryViewControllerModel {
        let entryVM = EntryViewControllerModel(environment: environment)
        entryVM.delegate = self
        return entryVM
    }
    
    func entryViewModel(for indexPath: IndexPath) -> EntryViewControllerModel {
        let entryVM = EntryViewControllerModel(environment: environment, entry: entry(for: indexPath))
        entryVM.delegate = self
        return entryVM
    }
}

extension TimelineViewControllerModel: EntryViewViewModelDelegate {
    func didAddEntry(_ entry: EntryType) {
        dates = environment.entryRepository.uniqueDates
    }
    
    func didRemoveEntry(_ entry: EntryType) {
        dates = environment.entryRepository.uniqueDates
    }
}

extension EntryRepository {
    var uniqueDates: [Date] {
        return allEntries
            .compactMap { $0.createdAt.hmsRemoved }
            .unique()
    }
}
