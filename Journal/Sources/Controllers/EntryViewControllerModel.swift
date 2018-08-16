//
//  EntryViewControllerModel.swift
//  Journal
//
//  Created by 윤진서 on 2018. 8. 16..
//  Copyright © 2018년 Jinseo Yoon. All rights reserved.
//

import Foundation

class EntryViewControllerModel {
    private let environment: Environment
    private var entry: Entry?
    
    init(environment: Environment, entry: Entry? = nil) {
        self.environment = environment
        self.entry = entry
    }
}
