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
    
    init(entryRepository: EntryRepository = InMemoryEntryRepository()) {
        self.entryRepository = entryRepository
    }
}
