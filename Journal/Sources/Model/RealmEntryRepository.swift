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
        try! realm.write {
            //realm.add(entry.toRealmObject())
        }
    }
    
    func update(_ entry: EntryType) {
        try! realm.write {
            //realm.add(entry.toRealmObject(), update: true)
        }
    }
    
    func remove(_ entry: EntryType) {
        guard let realmObject = realm.objects(RealmEntry.self)
            .filter("uuidString == '\(entry.id.uuidString)'")
            .first
            else { return }
        
        try! realm.write {
            realm.delete(realmObject)
        }
    }
    
    func entry(with id: UUID) -> EntryType? {
        return realm.objects(RealmEntry.self)
            .filter("uuidString == '\(id.uuidString)'")
            .first
            .map { $0.toEntry() }
    }
    
    func recentEntries(max: Int) -> [EntryType] {
        let results = realm.objects(RealmEntry.self)
            .sorted(byKeyPath: "createdAt", ascending: true)
            .prefix(max)
            .map { $0.toEntry() }
        
        return Array(results)
        
    }
}
