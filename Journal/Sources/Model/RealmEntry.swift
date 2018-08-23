//
//  RealmEntry.swift
//  Journal
//
//  Created by 윤진서 on 2018. 8. 24..
//  Copyright © 2018년 Jinseo Yoon. All rights reserved.
//

import Foundation
import RealmSwift

class RealmEntry: Object {
    @objc dynamic var uuidString: String = ""
    @objc dynamic var createdAt: Date = Date()
    @objc dynamic var text: String = ""
    
    override static func primaryKey() -> String? {
        return "uuidString"
    }
}

extension Entry {
    func toRealmObject() -> RealmEntry {
        let realmObject = RealmEntry()
        realmObject.uuidString = id.uuidString
        realmObject.createdAt = createdAt
        realmObject.text = text
        return realmObject
    }
}

extension RealmEntry {
    func toEntry() -> Entry {
        return Entry(
            id: UUID(uuidString: uuidString) ?? UUID(),
            createdAt: createdAt,
            text: text
        )
    }
}
