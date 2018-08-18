//
//  TimelineViewControllerTests.swift
//  JournalTests
//
//  Created by JinSeo Yoon on 2018. 8. 18..
//  Copyright © 2018년 Jinseo Yoon. All rights reserved.
//

import XCTest
import Nimble

@testable import Journal

class TimelineViewControllerTests: XCTestCase {
    func testLabelTextWhenNoEntry() {
        // Setup
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard
            .instantiateViewController(withIdentifier: "TimelineViewController") as! TimelineViewController
        
        viewController.environment = Environment()
        
        print(viewController.view)
        
        // Run
        viewController.viewWillAppear(true)
        
        // Verify
        expect(viewController.entryCountLabel.text) == "엔트리 없음"
    }
    
    func testLabelTextWhenEntryExists() {
        // Setup
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard
            .instantiateViewController(withIdentifier: "TimelineViewController") as! TimelineViewController
        
        let repo = InMemoryEntryRepository(entries: [
            Entry(text: "일기 1"),
            Entry(text: "일기 2"),
            Entry(text: "일기 3"),
            ]
        )
        viewController.environment = Environment(entryRepository: repo)
        
        print(viewController.view)
        
        // Run
        viewController.viewWillAppear(true)
        
        // Verify
        expect(viewController.entryCountLabel.text) == "엔트리 갯수: 3"
    }
}
