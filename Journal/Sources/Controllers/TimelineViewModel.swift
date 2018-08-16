//
//  TimelineViewModel.swift
//  Journal
//
//  Created by 윤진서 on 2018. 8. 16..
//  Copyright © 2018년 Jinseo Yoon. All rights reserved.
//

import Foundation

class TimelineViewControllerModel {
    let environment: Environment
    
    private var dates: [Date] = []
    private var entries: [Entry] {
        return environment.entryRepository.recentEntries(max: environment.entryRepository.numberOfEntries)
    }
    
    private func entries(for day: Date) -> [Entry] {
        return entries.filter { $0.createdAt.hmsRemoved == day }
    }
    private func entry(for indexPath: IndexPath) -> Entry {
        return entries(for: dates[indexPath.section])[indexPath.row]
    }
    
    init(environment: Environment) {
        self.environment = environment
    }
}
