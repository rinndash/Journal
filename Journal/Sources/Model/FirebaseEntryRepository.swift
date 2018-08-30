//
//  FirebaseEntryRepository.swift
//  Journal
//
//  Created by JinSeo Yoon on 2018. 8. 30..
//  Copyright © 2018년 Jinseo Yoon. All rights reserved.
//

import Foundation
import FirebaseDatabase

class FirebaseEntryRepository: EntryRepository {
    private let reference: DatabaseReference
    
    init(reference: DatabaseReference) {
        self.reference = reference.child("entries")
    }
    
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
        reference.child("\(entry.id.uuidString)/text").setValue(entry.text)
    }
    
    func remove(_ entry: EntryType) { 
        reference.child(entry.id.uuidString).removeValue()
    }
    
    var numberOfEntries: Int { 
        return 0
    }
    
    func entry(with id: UUID) -> EntryType? { 
        return nil 
    }
    
    func recentEntries(max: Int) -> [EntryType] { 
        return [] 
    }
}
