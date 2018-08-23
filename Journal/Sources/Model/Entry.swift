//
//  Entry.swift
//  Journal
//
//  Created by JinSeo Yoon on 2018. 7. 28..
//  Copyright © 2018년 Jinseo Yoon. All rights reserved.
//

import Foundation

class Entry: Identifiable, Equatable {
    let id: UUID
    let createdAt: Date
    var text: String
    
    init(id: UUID = UUID(), createdAt: Date = Date(), text: String) {
        self.id = id
        self.createdAt = createdAt
        self.text = text
    }
}

extension Entry {
    static func ==(lhs: Entry, rhs: Entry) -> Bool {
        return lhs.id == rhs.id
            && lhs.createdAt == rhs.createdAt
            && lhs.text == rhs.text
    }
}

