//
//  Entry.swift
//  Journal
//
//  Created by JinSeo Yoon on 2018. 7. 28..
//  Copyright © 2018년 Jinseo Yoon. All rights reserved.
//

import Foundation

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
