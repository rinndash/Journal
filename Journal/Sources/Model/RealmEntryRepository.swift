//
//  RealmEntryRepository.swift
//  Journal
//
//  Created by 윤진서 on 2018. 8. 27..
//  Copyright © 2018년 Jinseo Yoon. All rights reserved.
//

import Foundation
import RealmSwift

class RealmEntryRepository: EntryRepository {
    init() {
    
    }
    
    var numberOfEntries: Int {
        return 0
    }
    
    func add(_ entry: EntryType) {
        
    }
    
    func update(_ entry: EntryType) {
        
    }
    
    func remove(_ entry: EntryType) {
        
    }
    
    func entry(with id: UUID) -> EntryType? {
        return nil
    }
    
    func recentEntries(max: Int) -> [EntryType] {
        return []
    }
}
