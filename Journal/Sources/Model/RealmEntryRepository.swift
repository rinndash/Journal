//
//  Journal.swift
//  Journal
//
//  Created by JinSeo Yoon on 2018. 8. 3..
//  Copyright © 2018년 Jinseo Yoon. All rights reserved.
//

import Foundation
import RealmSwift

class RealmEntryRepository: EntryRepository {
    private let realm: Realm
    
    init(realm: Realm) {
        self.realm = realm
    }
    
    var numberOfEntries: Int { return 0 }
    
    func add(_ entry: Entry) {
        
    }
    
    func update(_ entry: Entry) {
        
    }
    
    func remove(_ entry: Entry) {
        
    }
    
    func entry(with id: UUID) -> Entry? {
        return nil
    }
    
    func recentEntries(max: Int) -> [Entry] {
        return []
    }
}
