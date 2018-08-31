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
    
    private func entries(for date: Date) -> [EntryType] {
        return entries
            .filter { $0.createdAt.hmsRemoved == date }
    }
    
    private func entry(for indexPath: IndexPath) -> EntryType {
        let date = dates[indexPath.section]
        let entriesOfDate = entries(for: date)
        let entry = entriesOfDate[indexPath.row]
        return entry
    }

    init(environment: Environment) {
        self.environment = environment
        dates = environment.entryRepository.uniqueDates
    }
    
    var searchText: String?
    
    func removeEntry(at indexPath: IndexPath) {
        let date = dates[indexPath.section]
        let entries = self.entries(for: date)
        let entry = entries[indexPath.row]
        environment.entryRepository.remove(entry)
        
        if entries.count == 1 { 
            dates = self.dates.filter { $0 != date }                 
        }
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
    
    func entryTableViewCellViewModel(for indexPath: IndexPath) -> EntryTableViewCellViewModel {
        let entry = self.entry(for: indexPath)
        
        return EntryTableViewCellViewModel(
            entry: entry, 
            environment: environment
        )
    }
    
    lazy var settingsViewModel: SettingsTableViewViewModel = SettingsTableViewViewModel(environment: environment)
}

extension TimelineViewViewModel {
    var numberOfSections: Int { return dates.count }
    
    func title(for section: Int) -> String {
        let date = dates[section]
        return DateFormatter.formatter(with: environment.settings.dateFormatOption.rawValue)
            .string(from: date)
    }
    
    func numberOfRows(in section: Int) -> Int {
        let date = dates[section] 
        return entries(for: date).count
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
