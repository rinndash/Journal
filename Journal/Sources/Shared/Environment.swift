//
//  Environment.swift
//  Journal
//
//  Created by JinSeo Yoon on 2018. 8. 18..
//  Copyright © 2018년 Jinseo Yoon. All rights reserved.
//

import Foundation

class Environment {
    let entryRepository: EntryRepository
    let entryFactory: (String) -> EntryType
    var settings: Settings
    let now: () -> Date
    
    init(
        entryRepository: EntryRepository = InMemoryEntryRepository(),
        entryFactory: @escaping (String) -> EntryType = { (text: String) -> EntryType in Entry(text: text) },
        settings: Settings = InMemorySettings(),
        now: @escaping () -> Date = Date.init
        ) {
        self.entryRepository = entryRepository
        self.entryFactory = entryFactory
        self.settings = settings
        self.now = now
    }
}
