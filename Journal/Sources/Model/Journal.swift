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
    func recentEntries(max: Int) -> [Entry]
}
