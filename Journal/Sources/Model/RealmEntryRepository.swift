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
    private let realm: Realm
    
    init(realm: Realm) {
        self.realm = realm
    }
    
    func add(_ entry: EntryType) {
        guard let realmEntry = entry as? RealmEntry else { fatalError() }
        try! realm.write {
            realm.add(realmEntry)
        }
    }
    
    func update(_ entry: EntryType) {
        guard let realmEntry = entry as? RealmEntry else { fatalError() }
        try! realm.write {
            realm.add(realmEntry, update: true)
        }
    }
    
    func remove(_ entry: EntryType) {
        guard let realmEntry = entry as? RealmEntry else { fatalError() }
        try! realm.write {
            realm.delete(realmEntry)
        }
    }
    
    func entries(contains string: String, completion: @escaping ([EntryType]) -> Void) {
        let results = realm.objects(RealmEntry.self)
            .filter("text CONTAINS[c] '\(string)'")
            .sorted(byKeyPath: "createdAt", ascending: false)
        
        completion(Array(results))
    }
    
    func recentEntries(max: Int, completion: @escaping ([EntryType]) -> Void) {
        let results = realm.objects(RealmEntry.self)
            .sorted(byKeyPath: "createdAt", ascending: false)
            .prefix(max)
        completion(Array(results))
    }
}
