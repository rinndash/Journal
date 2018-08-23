//
//  Entry.swift
//  Journal
//
//  Created by JinSeo Yoon on 2018. 7. 28..
//  Copyright © 2018년 Jinseo Yoon. All rights reserved.
//

import Foundation

protocol EntryType: Identifiable, Equatable {
    var createdAt: Date { get }
    var text: String { get set }
}

extension EntryType {
    static func ==(lhs: Self, rhs: Self) -> Bool {
        return lhs.id == rhs.id
            && lhs.createdAt == rhs.createdAt
            && lhs.text == rhs.text
    }
}

class Entry: EntryType {
    let id: UUID
    let createdAt: Date
    var text: String
    
    init(id: UUID = UUID(), createdAt: Date = Date(), text: String) {
        self.id = id
        self.createdAt = createdAt
        self.text = text
    }
}
