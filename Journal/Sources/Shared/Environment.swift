//
//  Environment.swift
//  Journal
//
//  Created by 윤진서 on 2018. 8. 11..
//  Copyright © 2018년 Jinseo Yoon. All rights reserved.
//

import Foundation

class Environment {
    let entryRepository: EntryRepository
    let entryFactory: EntryFactory
    var settings: Settings
    let now: () -> Date
    
    init(
        entryRepository: EntryRepository = InMemoryEntryRepository(),
        entryFactory: @escaping EntryFactory = { Entry(text: $0) },
        settings: Settings = InMemorySettings(),
        now: @escaping () -> Date = { Date.before(3) }
        ) {
        self.entryRepository = entryRepository
        self.entryFactory = entryFactory
        self.settings = settings
        self.now = now
    }
}
