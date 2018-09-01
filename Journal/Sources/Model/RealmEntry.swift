//
//  RealmEntry.swift
//  Journal
//
//  Created by JinSeo Yoon on 2018. 9. 1..
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
}

extension RealmEntry {
    static func entry(with text: String) -> RealmEntry {
        let realmEntry = RealmEntry()
        
        realmEntry.uuidString = UUID().uuidString
        realmEntry.text = text
        realmEntry.createdAt = Date()
        
        return realmEntry
    }
}
