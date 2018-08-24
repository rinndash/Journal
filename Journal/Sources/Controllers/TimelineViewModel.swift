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
    
    private func entries(for day: Date) -> [EntryType] {
        return entries.filter { $0.createdAt.hmsRemoved == day }
    }
    private func entry(for indexPath: IndexPath) -> EntryType {
        return entries(for: dates[indexPath.section])[indexPath.row]
    }
    
    init(environment: Environment) {
        self.environment = environment
        self.dates = environment.entryRepository.uniqueDates
    }
    
    var title: String { return "Journal" }
    
    var numberOfDates: Int { return dates.count }
    
    func entryTableViewCellModel(contains string: String) -> [EntryTableViewCellModel] {
        let entries = environment.entryRepository.entries(contains: string)
            .map { EntryTableViewCellModel(entry: $0, environment: environment) }
        return entries
    }
    
    func headerTitle(of section: Int) -> String {
        let df = DateFormatter.formatter(with: environment.settings.dateFormat.rawValue)
        return df.string(from: dates[section])
    }
    
    func numberOfItems(of section: Int) -> Int {
        return entries(for: dates[section]).count
    }
    
    func removeEntry(at indexPath: IndexPath) {
        let isLastEntryInSection = numberOfItems(of: indexPath.section) == 1
        let entryToRemove = entry(for: indexPath)
        self.environment.entryRepository.remove(entryToRemove)
        if isLastEntryInSection { self.dates = self.dates.filter { $0 != entryToRemove.createdAt.hmsRemoved } }
    }
    
    lazy var settingsViewModel: SettingsTableViewViewModel = SettingsTableViewViewModel(environment: environment)
}

extension TimelineViewControllerModel {
    func entryTableViewCellModel(for indexPath: IndexPath) -> EntryTableViewCellModel {
        let entry = self.entry(for: indexPath)
        return EntryTableViewCellModel(entry: entry, environment: environment)
    }
    
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
