//
//  FirebaseEntryRepository.swift
//  Journal
//
//  Created by 윤진서 on 2018. 8. 31..
//  Copyright © 2018년 Jinseo Yoon. All rights reserved.
//

import Foundation
import FirebaseDatabase

class FirebaseEntryRepository: EntryRepository {
    private let reference: DatabaseReference
    
    init(reference: DatabaseReference = Database.database().reference()) {
        self.reference = reference.child("entries")
        
        let query = self.reference
            .queryOrdered(byChild: "createdAt")
            .queryLimited(toFirst: 10)    
            .observeSingleEvent(of: .value) {
            print($0)
        }
    }
    
    var numberOfEntries: Int { return 0 }
    
    func add(_ entry: EntryType) {
        reference.child(entry.id.uuidString).setValue(
            [
                "uuidString": entry.id.uuidString,
                "createdAt": entry.createdAt.timeIntervalSince1970,
                "text": entry.text
            ]
        )
    }
    
    func update(_ entry: EntryType) {
        reference.child(entry.id.uuidString).child("text").setValue(entry.text)
    }
    
    func remove(_ entry: EntryType) {
        reference.child(entry.id.uuidString).removeValue()
    }
    
    func entries(contains string: String) -> [EntryType] {
        return []
    }
    
    func entry(with id: UUID) -> EntryType? {
        return nil
    }
    
    func recentEntries(max: Int) -> [EntryType] {
        return []
    }
}
