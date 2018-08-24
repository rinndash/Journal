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
    
    var numberOfEntries: Int {
        return realm.objects(RealmEntry.self).count
    }
    
    func add(_ entry: EntryType) {
        guard let realmEntry = entry as? RealmEntry else { return }
        try! realm.write {
            realm.add(realmEntry)
        }
    }
    
    func update(_ entry: EntryType) {
        guard let realmEntry = entry as? RealmEntry else { return }
        try! realm.write {
            realm.add(realmEntry, update: true)
        }
    }
    
    func remove(_ entry: EntryType) {
        guard let realmEntry = entry as? RealmEntry else { return }
        try! realm.write {
            realm.delete(realmEntry)
        }
    }
    
    func entry(with id: UUID) -> EntryType? {
        return realm.objects(RealmEntry.self)
            .filter("uuidString == '\(id.uuidString)'")
            .first
    }
    
    func recentEntries(max: Int) -> [EntryType] {
        let results = realm.objects(RealmEntry.self)
            .sorted(byKeyPath: "createdAt", ascending: true)
            .prefix(max)
        
        return Array(results)
        
    }
}
