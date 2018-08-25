//
//  EntryViewViewModelTests.swift
//  JournalTests
//
//  Created by JinSeo Yoon on 2018. 8. 25..
//  Copyright © 2018년 Jinseo Yoon. All rights reserved.
//

import XCTest
import Nimble
@testable import Journal

class EntryViewViewModelTests: XCTestCase {
    func testHasEntry() {
        // Setup
        let environment = Environment()
        let entry = Entry(text: "일기")
        
        // Run
        let viewModelWithEntry = EntryViewViewModel(environment: environment, entry: entry)
        let viewModelWithoutEntry = EntryViewViewModel(environment: environment)
        
        // Verify
        expect(viewModelWithEntry.hasEntry) == true
        expect(viewModelWithoutEntry.hasEntry) == false
    }
    
    func testTextViewText() {
        // Setup
        let environment = Environment()
        let entry = Entry(text: "일기")
        
        // Run
        let viewModel = EntryViewViewModel(environment: environment, entry: entry)
        
        // Verify
        expect(viewModel.textViewText) == "일기"
    }
    
    func testTitleWhenEntryExists() {
        // Setup
        let environment = Environment()
        let createdAt: Date = Date()
        let entry = Entry(createdAt: createdAt, text: "일기")
        
        // Run
        let viewModel = EntryViewViewModel(environment: environment, entry: entry)
        
        // Verify
        expect(viewModel.title) == DateFormatter.entryDateFormatter.string(from: createdAt) 
    }
    
    func testTitleWhenNoEntry() {
        // Setup
        let now: Date = Date()
        let environment = Environment(now: { return now })
        
        // Run
        let viewModel = EntryViewViewModel(environment: environment)
        
        // Verify
        expect(viewModel.title) == DateFormatter.entryDateFormatter.string(from: now) 
    }
    
    func testRemoveButtonEnabledWhenEntryExists() {
        // Setup
        let environment = Environment()
        let createdAt: Date = Date()
        let entry = Entry(createdAt: createdAt, text: "일기")
        
        // Run
        let viewModel = EntryViewViewModel(environment: environment, entry: entry)
        
        // Verify
        expect(viewModel.removeButtonEnabled) == true
    }
    
    func testRemoveButtonDisabledWhenNoEntry() {
        // Setup
        let environment = Environment()
        
        // Run
        let viewModel = EntryViewViewModel(environment: environment)
        
        // Verify
        expect(viewModel.removeButtonEnabled) == false
    }
    
    func testUpdateOfEditingPropertiesWhenStartEditing() {
        // Setup
        let environment = Environment()
        let viewModel = EntryViewViewModel(environment: environment)
        
        expect(viewModel.isEditing) == false
        expect(viewModel.textViewEditiable) == false
        expect(viewModel.buttonImage) == #imageLiteral(resourceName: "baseline_edit_white_24pt")
        
        // Run
        viewModel.startEditing()
        
        // Verify
        expect(viewModel.isEditing) == true
        expect(viewModel.textViewEditiable) == true
        expect(viewModel.buttonImage) == #imageLiteral(resourceName: "baseline_save_white_24pt")
    }
    
    func testUpdateOfEditingPropertiesWhenCompleteEditing() {
        // Setup
        let environment = Environment()
        let viewModel = EntryViewViewModel(environment: environment)
        
        viewModel.startEditing()
        
        expect(viewModel.isEditing) == true
        expect(viewModel.textViewEditiable) == true
        expect(viewModel.buttonImage) == #imageLiteral(resourceName: "baseline_save_white_24pt")
                
        // Run
        viewModel.completeEditing(with: "수정 끝")
        
        // Verify
        expect(viewModel.isEditing) == false
        expect(viewModel.textViewEditiable) == false
        expect(viewModel.buttonImage) == #imageLiteral(resourceName: "baseline_edit_white_24pt")        
    }
    
    func testAddEntryToRepositoryWhenEntryPropertyIsNil() {
        // Setup
        let repo = InMemoryEntryRepository()
        let environment = Environment(entryRepository: repo)
        let viewModel = EntryViewViewModel(environment: environment)
        
        // Run
        viewModel.completeEditing(with: "일기 생성")
        
        // Verify
        let entry = repo.recentEntries(max: 1).first
        expect(entry?.text) == "일기 생성"
    }
}
