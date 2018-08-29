//
//  RealmEntry.swift
//  Journal
//
//  Created by 윤진서 on 2018. 8. 30..
//  Copyright © 2018년 Jinseo Yoon. All rights reserved.
//

import Foundation
import RealmSwift

class RealmEntry: Object, EntryType {
    var id: UUID {
        guard let uuid = UUID.init(uuidString: uuidString) else { fatalError() }
        return uuid
    }
    
    @objc dynamic var uuidString: String = ""
    @objc dynamic var createdAt: Date = Date()
    @objc dynamic var text: String = ""
    
    override static func primaryKey() -> String? {
        return "uuidString"
    }
    
    static func newEntry(with text: String) -> RealmEntry {
        let entry = RealmEntry()
        entry.uuidString = UUID().uuidString
        entry.createdAt = Date()
        entry.text = text
        return entry
    }
}
