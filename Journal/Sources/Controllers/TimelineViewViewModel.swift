//
//  TimelineViewViewModel.swift
//  Journal
//
//  Created by JinSeo Yoon on 2018. 8. 25..
//  Copyright © 2018년 Jinseo Yoon. All rights reserved.
//

import Foundation

class TimelineViewViewModel {
    let environment: Environment
    
    private var dates: [Date] = []
    private var entries: [EntryType] {
        return environment.entryRepository.recentEntries(max: environment.entryRepository.numberOfEntries)
    }
    private var filteredEntries: [EntryType] = []
    
    private func entries(for date: Date) -> [EntryType] {
        return entries
            .filter { $0.createdAt.hmsRemoved == date }
    }
    
    private func entry(for indexPath: IndexPath) -> EntryType {
        guard isSearching == false else { return filteredEntries[indexPath.row] }
        
        let date = dates[indexPath.section]
        let entriesOfDate = entries(for: date)
        let entry = entriesOfDate[indexPath.row]
        
        return entry
    }

    init(environment: Environment) {
        self.environment = environment
        dates = environment.entryRepository.uniqueDates
    }
    
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
    
    func removeEntry(at indexPath: IndexPath) {
        let entry = self.entry(for: indexPath)
        environment.entryRepository.remove(entry)
        dates = environment.entryRepository.uniqueDates
    }
    
    var newEntryViewViewModel: EntryViewViewModel {
        let vm = EntryViewViewModel(environment: environment)
        vm.delegate = self
        return vm
    }
    
    func entryViewViewModel(for indexPath: IndexPath) -> EntryViewViewModel {
        let vm = EntryViewViewModel(environment: environment, entry: entry(for: indexPath))
        vm.delegate = self
        return vm
    }
    
    lazy var settingsViewModel: SettingsTableViewViewModel = SettingsTableViewViewModel(environment: environment)
}

extension TimelineViewViewModel {
    var numberOfSections: Int {
        return isSearching ? 1 : dates.count
    }
    
    func title(for section: Int) -> String? {
        guard isSearching == false else { return nil }
        let df = DateFormatter.formatter(with: environment.settings.dateFormatOption.rawValue)
        return df.string(from: dates[section])
    }
    
    func numberOfRows(in section: Int) -> Int {
        return isSearching
            ? filteredEntries.count
            : entries(for: dates[section]).count
    }
    
    func entryTableViewCellViewModel(for indexPath: IndexPath) -> EntryTableViewCellViewModel {
        let entry = self.entry(for: indexPath)
        
        return EntryTableViewCellViewModel(
            entry: entry,
            environment: environment
        )
    }
}

extension TimelineViewViewModel: EntryViewViewModelDelegate {
    func didAddEntry(_ entry: EntryType) {
        dates = environment.entryRepository.uniqueDates
    }
    
    func didRemoveEntry(_ entry: EntryType) {
        dates = environment.entryRepository.uniqueDates
    }
}

extension EntryRepository {
    var allEntries: [EntryType] {
        return recentEntries(max: numberOfEntries)
    }
    
    var uniqueDates: [Date] {
        return allEntries
            .compactMap { $0.createdAt.hmsRemoved }
            .unique()
    }
}

extension TimelineViewViewModel {
    func loadEntries(completion: @escaping () -> Void) {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .seconds(3), execute: {
            completion()
        })
    }
}
