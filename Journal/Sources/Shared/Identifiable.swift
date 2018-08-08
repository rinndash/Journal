//
//  Identifiable.swift
//  Journal
//
//  Created by JinSeo Yoon on 2018. 8. 4..
//  Copyright © 2018년 Jinseo Yoon. All rights reserved.
//

import Foundation

protocol Identifiable {
    var id: UUID { get }
}

extension Identifiable {
    func isIdentical(to other: Self) -> Bool {
        return id == other.id
    }
}
