//
//  Journal.swift
//  Journal
//
//  Created by JinSeo Yoon on 2018. 8. 3..
//  Copyright © 2018년 Jinseo Yoon. All rights reserved.
//

import Foundation

protocol Journal {
    func add(_ entry: Entry)
    func update(_ entry: Entry)
    func remove(_ entry: Entry)
    func entry(with id: Int) -> Entry?
    func recentEntries(max: Int) -> [Entry]
}

// 메모리에 없는 Journal도 있을것, 데이터베이스나 서버... 인터페이스에서 약속한대로 데이터를 주고받는지를 확인하는 작업
class InMemoryJournal: Journal {
    
    private var entries: [Int: Entry] = [:] // 빈 딕셔너리로 구현
    
    func add(_ entry: Entry) {
        entries[entry.id] = entry
    }
    func update(_ entry: Entry) {
        
    }
    func remove(_ entry: Entry) {
        
    }
    
    func entry(with id: Int) -> Entry? {
        return entries[id]
    }
    
    func recentEntries(max: Int) -> [Entry] {
        return []
    }
}
