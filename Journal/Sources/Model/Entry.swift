//
//  Entry.swift
//  Journal
//
//  Created by JinSeo Yoon on 2018. 7. 28..
//  Copyright © 2018년 Jinseo Yoon. All rights reserved.
//

import Foundation

protocol EntryType: Identifiable {
    var createdAt: Date { get }
    var text: String { get set }
}

extension EntryType {
    static func ==(lhs: EntryType, rhs: EntryType) -> Bool {
        return lhs.id == rhs.id
            && lhs.createdAt == rhs.createdAt
            && lhs.text == rhs.text
    }
}

class Entry: EntryType, Encodable {
    let id: UUID
    let createdAt: Date
    var text: String
    
    init(id: UUID = UUID(), createdAt: Date = Date(), text: String) {
        self.id = id
        self.createdAt = createdAt
        self.text = text
    }
    
    init?(dictionary: [String: Any]) {
        guard
            let uuidString = dictionary["uuidString"] as? String,
            let uuid = UUID(uuidString: uuidString),
            let createdAtTimeInterval = dictionary["createdAt"] as? Double,
            let text = dictionary["text"] as? String
            else { return nil }
        
        self.id = uuid
        self.createdAt = Date(timeIntervalSince1970: createdAtTimeInterval)
        self.text = text
    }
}

extension Entry {
    func toDitionary() -> [String: Any] {
        return [
            "uuidString": id.uuidString,
            "createdAt": createdAt.timeIntervalSince1970,
            "text": text
        ]
    }
}
