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
    var vc: TimelineViewController!
    
    override func setUp() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        vc = storyboard.instantiateViewController(withIdentifier: "TimelineViewController") as! TimelineViewController
        _ = vc.view // loadView()와 viewDidLoad()를 강제로 호출
    }
}
