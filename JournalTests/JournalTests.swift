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
        XCTAssertTrue(entryInJournal === newEntry) // ===는 클래스만 사용할 수 있는 
        XCTAssertTrue(entryInJournal?.isIdentical(to: newEntry) == true)
    }
    
    // 일기장에서 일기 가져오기 테스트
    func testGetEntrywithId() {
        // Setup
        let oldEntry = Entry(id: 1, createdAt: Date(), text: "일기")
        let journal = InMemoryJournal(entries: [oldEntry])
        
        // Run
        let entry = journal.entry(with: 1)
        
        // Verify
        XCTAssertEqual(entry, .some(oldEntry))
        XCTAssertTrue(entry?.isIdentical(to: oldEntry) == true)
    }
    
    // 일기장에 일기 업데이트 하기
    func testUpdateEntry() {
        //Setup
        let oldEntry = Entry(id: 1, createdAt: Date(), text: "일기")
        let journal = InMemoryJournal(entries: [oldEntry])
        
        //Run
        oldEntry.text = "수정된 일기 내용"
        journal.update(oldEntry)
        
        //verify
        let entry = journal.entry(with: 1)
        XCTAssertEqual(entry, .some(oldEntry))
        XCTAssertTrue(entry?.isIdentical(to: oldEntry) == true)
        XCTAssertEqual(entry?.text, .some("수정된 일기 내용"))
    }
    
    // 일기장에서 일기 지우기
    func testRemoveEntryFromJournal() {
        let oldEntry = Entry(id: 1, createdAt: Date(), text: "일기")
        let journal = InMemoryJournal(entries: [oldEntry])
        
        journal.remove(oldEntry)
        
        let entry = journal.entry(with: 1)
        XCTAssertEqual(entry, nil)
    }
    
    // 일기장에서 최근 작성된 순으로 일기 가져오기
    func testRecentEntryOrder() {
        let bYesterday = Entry(id: 1, createdAt: Date.distantPast, text: "1")
        let yesterday = Entry(id: 2, createdAt: Date(), text: "2")
        let today = Entry(id: 3, createdAt: Date.distantFuture, text: "3")
        let journal = InMemoryJournal(entries: [bYesterday, yesterday, today])
        
        let entries = journal.recentEntries(max: 3)
        
        XCTAssertEqual(entries.count, 3)
        XCTAssertEqual(entries, [today, yesterday, bYesterday])
    }
    
}


