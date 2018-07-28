//
//  JournalTests.swift
//  JournalTests
//
//  Created by JinSeo Yoon on 2018. 7. 28..
//  Copyright © 2018년 Jinseo Yoon. All rights reserved.
//

import XCTest

class Entry {
    let id: Int
    let createdAt: Date
    var text: String
    
    init(id: Int, createdAt: Date, text: String) {
        self.id = id
        self.createdAt = createdAt
        self.text = text
    }
}

class JournalTests: XCTestCase {
    func test_엔트리의_테스트를_수정한다() {
        // Setup
        let entry = Entry(id: 0, createdAt: Date(), text: "첫 번째 일기") 
        
        // Run
        entry.text = "첫 번째 수정"
        
        // Verify
        XCTAssertEqual(entry.text, "첫 번째 수정")
    }
    
    func test_한글로_테스트가_가능한가요() {
        
    }
}
