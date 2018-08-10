//
//  TimelineViewControllerTests.swift
//  JournalTests
//
//  Created by 윤진서 on 2018. 8. 11..
//  Copyright © 2018년 Jinseo Yoon. All rights reserved.
//

import XCTest
import Nimble
@testable import Journal

class TimelineViewControllerTests: XCTestCase {
    var vc: UIViewController!
    
    override func setUp() {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.init(for: self.classForCoder))
        vc = storyboard.instantiateViewController(withIdentifier: "TimelineViewController")
    }
    
    func testEntryCountLabelTextWhenNoEntry() {
        // Setup
        //vc.environment = Environment()
        
        // Run
        print(vc.view) // 내부적으로 viewDidLoad를 호출
        
        // Verify
        //expect(self.vc.entryCountLabel.text) == "엔트리 없음"
    }
    
//    func testEntryCountLabelTextWhenEntryExists() {
//        // Run
//        print(self.vc.view) // 내부적으로 viewDidLoad를 호출
//
//        // Verify
//        expect(self.vc.entryCountLabel.text) == "엔트리 수: 3"
//    }
}

