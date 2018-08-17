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
    let now: () -> Date
    
    init(
        entryRepository: EntryRepository = InMemoryEntryRepository(),
        now: @escaping () -> Date = Date.init
        ) {
        self.entryRepository = entryRepository
        self.now = now
    }
}
