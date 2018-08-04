//
//  JournalTests.swift
//  JournalTests
//
//  Created by JinSeo Yoon on 2018. 7. 28..
//  Copyright © 2018년 Jinseo Yoon. All rights reserved.
//

import XCTest
@testable import Journal

class JournalTests: XCTestCase {
    func testEditEntryText() {
        // Setup
        let entry = Entry(id: 0, createdAt: Date(), text: "첫 번째 일기")
        
        // Run
        entry.text = "첫 번째 테스트"
        
        // Verify
        XCTAssertEqual(entry.text, "첫 번째 테스트")
    }
    
    func testAddEntryToJournal() {
        // Setup
        let journal = InMemoryJournal()
        let newEntry = Entry(id: 1, createdAt: Date(), text: "일기")
        
        // Run
        journal.add(newEntry)
        
        // Verify
        let entryInJournal: Entry? = journal.entry(with: 1)
        
        XCTAssertEqual(entryInJournal, .some(newEntry))
        // XCTAssertTrue(entryInJournal === newEntry)
        XCTAssertTrue(entryInJournal?.isIdentical(to: newEntry) == true)
    }
    
    func testGetEntryWithId() {
        // Setup
        let oldEntry = Entry(id: 1, createdAt: Date(), text: "일기")
        let journal = InMemoryJournal(entries: [oldEntry])
        
        // Run
        let entry = journal.entry(with: 1)
        
        // Verify
        XCTAssertEqual(entry, .some(oldEntry))
        XCTAssertTrue(entry?.isIdentical(to: oldEntry) == true)
    }
    
    func testUpdateEntry() {
        // Setup
        let oldEntry = Entry(id: 1, createdAt: Date(), text: "일기")
        let journal = InMemoryJournal(entries: [oldEntry])
        
        // Run
        oldEntry.text = "일기 내용을 수정했습니다"
        journal.update(oldEntry)
        
        // Verify
        let entry = journal.entry(with: 1)
        XCTAssertEqual(entry, .some(oldEntry))
        XCTAssertTrue(entry?.isIdentical(to: oldEntry) == true)
        XCTAssertEqual(entry?.text, .some("일기 내용을 수정했습니다"))
    }
    
    func testRemoveEntryFromJournal() {
        // Setup
        let oldEntry = Entry(id: 1, createdAt: Date(), text: "일기")
        let journal = InMemoryJournal(entries: [oldEntry])
        
        // Run
        journal.remove(oldEntry)
        
        // Verify
        let entry = journal.entry(with: 1) 
        XCTAssertEqual(entry, nil)
    }
}
