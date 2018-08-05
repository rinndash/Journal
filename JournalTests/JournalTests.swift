//
//  JournalTests.swift
//  JournalTests
//
//  Created by JinSeo Yoon on 2018. 7. 28..
//  Copyright © 2018년 Jinseo Yoon. All rights reserved.
//

import XCTest
import Nimble
@testable import Journal

extension Entry {
    static var dayBeforeYesterday: Entry { return Entry(id: 1, createdAt: Date.distantPast, text: "그저께 일기") }
    static var yesterDay: Entry { return Entry(id: 2, createdAt: Date(), text: "어제 일기") }
    static var today: Entry { return Entry(id: 3, createdAt: Date.distantFuture, text: "오늘 일기") }
}

class JournalTests: XCTestCase {
    var newEntry: Entry!
    
    func testEditEntryText() {
        // Setup
        let entry = Entry(id: 0, createdAt: Date(), text: "첫 번째 일기")
        
        // Run
        entry.text = "첫 번째 테스트"
        
        // Verify
        expect(entry.text).to(equal("첫 번째 테스트"))
    }
    
    func testAddEntryToJournal() {
        // Setup
        let journal = InMemoryJournal()
        let newEntry = Entry.today
        
        // Run
        journal.add(newEntry)
        
        // Verify
        let entryInJournal: Entry? = journal.entry(with: newEntry.id)
        
        expect(entryInJournal).to(equal(newEntry))
        expect(entryInJournal).to(beIdenticalTo(newEntry))
        expect(entryInJournal?.isIdentical(to: newEntry)).to(beTruthy())
    }
    
    func testGetEntryWithId() {
        // Setup
        let oldEntry = Entry.yesterDay
        let journal = InMemoryJournal(entries: [oldEntry])
        
        // Run
        let entry = journal.entry(with: oldEntry.id)
        
        // Verify
        expect(entry).to(equal(oldEntry))
        expect(entry?.isIdentical(to: oldEntry)).to(beTruthy())
    }
    
    func testUpdateEntry() {
        // Setup
        let oldEntry = Entry.yesterDay
        let journal = InMemoryJournal(entries: [oldEntry])
        
        // Run
        oldEntry.text = "일기 내용을 수정했습니다"
        journal.update(oldEntry)
        
        // Verify
        let entry = journal.entry(with: oldEntry.id)
        expect(entry).to(equal(oldEntry))
        expect(entry?.isIdentical(to: oldEntry)).to(beTruthy())
        expect(entry?.text).to(equal("일기 내용을 수정했습니다"))
    }
    
    func testRemoveEntryFromJournal() {
        // Setup
        let oldEntry = Entry.yesterDay
        let journal = InMemoryJournal(entries: [oldEntry])
        
        // Run
        journal.remove(oldEntry)
        
        // Verify
        let entry = journal.entry(with: oldEntry.id)
        expect(entry).to(beNil())
    }
    
    func test_최근_순으로_엔트리를_불러올_수_있다() {
        // Setup
        let dayBeforeYesterday = Entry.dayBeforeYesterday
        let yesterDay = Entry.yesterDay
        let today = Entry.today
        
        let journal = InMemoryJournal(entries: [dayBeforeYesterday, yesterDay, today])
        
        // Run
        let entries = journal.recentEntries(max: 3)
        
        // Verify
        expect(entries.count).to(equal(3))
        expect(entries).to(equal([today, yesterDay, dayBeforeYesterday]))
    }
    
    func test_요청한_엔트리의_수만큼_최신_순으로_반환한다() {
        // Setup
        let dayBeforeYesterday = Entry.dayBeforeYesterday
        let yesterDay = Entry.yesterDay
        let today = Entry.today
        
        let journal = InMemoryJournal(entries: [dayBeforeYesterday, yesterDay, today])
        
        // Run
        let entries = journal.recentEntries(max: 1)
        
        // Verify
        expect(entries.count).to(equal(1))
        expect(entries).to(equal([today]))
    }
    
    func test_존재하는_엔트리보다_많은_수를_요청하면_존재하는_엔트리만큼만_반환한다() {
        // Setup
        let dayBeforeYesterday = Entry.dayBeforeYesterday
        let yesterDay = Entry.yesterDay
        let today = Entry.today
        
        let journal = InMemoryJournal(entries: [dayBeforeYesterday, yesterDay, today])
        
        // Run
        let entries = journal.recentEntries(max: 10)
        
        // Verify 
        expect(entries.count).to(equal(3))
        expect(entries).to(equal([today, yesterDay, dayBeforeYesterday]))
    }
}
