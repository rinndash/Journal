//
//  Identifiable.swift
//  Journal
//
//  Created by 이의현 on 2018. 8. 4..
//  Copyright © 2018년 Jinseo Yoon. All rights reserved.
//

import Foundation

protocol Identifiable {
    var id: Int { get }
}

extension Identifiable {
    func isIdentical(to other: Self) -> Bool {
        return id == other.id
    }
}
