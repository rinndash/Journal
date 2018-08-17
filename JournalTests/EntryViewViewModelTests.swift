//
//  EntryViewViewModelTests.swift
//  JournalTests
//
//  Created by 윤진서 on 2018. 8. 18..
//  Copyright © 2018년 Jinseo Yoon. All rights reserved.
//

import XCTest
import Nimble
@testable import Journal

class MockEntryRepository: EntryRepository {
    var numberOfEntries: Int { return 0 }
    
    var addedEntry: Entry?
    var updatedEntry: Entry?
    var removedEntry: Entry?
    
    func add(_ entry: Entry) {
        addedEntry = entry
    }
    
    func update(_ entry: Entry) {
        updatedEntry = entry
    }
    
    func remove(_ entry: Entry) {
        removedEntry = entry
    }
    
    func entry(with id: UUID) -> Entry? {
        return nil
    }
    
    func recentEntries(max: Int) -> [Entry] {
        return []
    }
}

class EntryViewViewModelTests: XCTestCase {
    func testHasEntry() {
        // Setup
        let environment = Environment()
        let entry = Entry(text: "일기")
        
        // Run
        let entryHasViewModel = EntryViewControllerModel(environment: environment, entry: entry)
        let noEntryViewModel = EntryViewControllerModel(environment: environment)
        
        // Verify
        expect(entryHasViewModel.hasEntry) == true
        expect(noEntryViewModel.hasEntry) == false
    }
    
    func testTextViewTextReturnsEntryText() {
        // Setup
        let environment = Environment()
        let entry = Entry(text: "일기")
        
        // Run
        let entryHasViewModel = EntryViewControllerModel(environment: environment, entry: entry)
        let noEntryViewModel = EntryViewControllerModel(environment: environment)
        
        // Verify
        expect(entryHasViewModel.textViewText) == "일기"
        expect(noEntryViewModel.textViewText).to(beNil())
    }
    
    func testTitleWhenEntryExists() {
        // Setup
        let environment = Environment()
        let createdAt: Date = Date()
        let entry = Entry(createdAt: createdAt, text: "일기")
        
        // Run
        let viewModel = EntryViewControllerModel(environment: environment, entry: entry)
        
        // Verify
        expect(viewModel.title) == DateFormatter.entryDateFormatter.string(from: createdAt)
    }
    
    func testTitleWhenEntryIsNil() {
        let now: Date = Date()
        let environment = Environment(now: { now })
        
        // Run
        let viewModel = EntryViewControllerModel(environment: environment)
        
        // Verify
        expect(viewModel.title) == DateFormatter.entryDateFormatter.string(from: now)
    }
    
    func testTrashIconEnabledWhenEntryExists() {
        let environment = Environment()
        let entry = Entry(text: "일기")
        
        // Run
        let viewModel = EntryViewControllerModel(environment: environment, entry: entry)
        
        // Verify
        expect(viewModel.trashIconEnabled) == true
    }
    
    func testTrashIconDisabledWhenEntryIsNil() {
        let environment = Environment()
        
        // Run
        let viewModel = EntryViewControllerModel(environment: environment)
        
        // Verify
        expect(viewModel.trashIconEnabled) == false
    }
    
    func testUpdateOfEditingPropertiesWhenStartEditing() {
        // Setup
        let viewModel = EntryViewControllerModel(environment: Environment())
        
        expect(viewModel.isEditing) == false
        expect(viewModel.textViewEditable) == false
        expect(viewModel.buttonImage) == #imageLiteral(resourceName: "baseline_edit_white_24pt")
        
        // Run
        viewModel.startEditing()
        
        // Verify
        expect(viewModel.isEditing) == true
        expect(viewModel.textViewEditable) == true
        expect(viewModel.buttonImage) == #imageLiteral(resourceName: "baseline_save_white_24pt")
    }
    
    func testUpdateOfEditingPropertiesWhenCompleteEditing() {
        // Setup
        let viewModel = EntryViewControllerModel(environment: Environment())
        viewModel.startEditing()
        
        // Run
        viewModel.completeEditing(with: "수정 끝")
        
        // Verify
        expect(viewModel.isEditing) == false
        expect(viewModel.textViewEditable) == false
        expect(viewModel.buttonImage) == #imageLiteral(resourceName: "baseline_edit_white_24pt")
    }
    
    func testAddEntryToRepositoryWhenEntryPropertyIsNil() {
        let mockRepo = MockEntryRepository()
        let environment = Environment(entryRepository: mockRepo)
        let viewModel = EntryViewControllerModel(environment: environment)
        
        // Run
        viewModel.completeEditing(with: "첫 번째 생성")
        
        // Verify
        expect(mockRepo.addedEntry?.text) == "첫 번째 생성"
        expect(mockRepo.updatedEntry).to(beNil())
        expect(viewModel.hasEntry) == true
    }
    
    func testUpdateEntryInRepositoryWhenEntryExists() {
        let mockRepo = MockEntryRepository()
        let environment = Environment(entryRepository: mockRepo)
        let entry = Entry(text: "처음 작성한 일기")
        let viewModel = EntryViewControllerModel(environment: environment, entry: entry)
        
        // Run
        viewModel.completeEditing(with: "첫 번째 수정")
        
        // Verify
        expect(mockRepo.updatedEntry?.text) == "첫 번째 수정"
        expect(mockRepo.updatedEntry?.isIdentical(to: entry)).to(beTrue())
        expect(mockRepo.addedEntry).to(beNil())
    }
    
    func testRemoveEntry() {
        // Setup
        let mockRepo = MockEntryRepository()
        let environment = Environment(entryRepository: mockRepo)
        let entry = Entry(text: "제거할 일기")
        let viewModel = EntryViewControllerModel(environment: environment, entry: entry)
        
        // Run
        let removedEntry = viewModel.removeEntry()
        
        // Verify
        expect(removedEntry) == entry
        expect(mockRepo.removedEntry) == entry
        expect(viewModel.hasEntry) == false
    }
}
