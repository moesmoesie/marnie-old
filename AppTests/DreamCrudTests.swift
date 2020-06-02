//
//  AppTests.swift
//  AppTests
//
//  Created by moesmoesie on 02/06/2020.
//  Copyright © 2020 moesmoesie. All rights reserved.
//

import XCTest
@testable import Dreaming_Journals

class DreamCrudTests: XCTestCase {
    var coreDataStack: InMemoryCoreDataStack!
    var testDream : Dream!
    var testTitle = "Hello World"
    var testID  = UUID()

    override func setUpWithError() throws {
        self.coreDataStack = InMemoryCoreDataStack()
        testDream = Dream(context: coreDataStack.managedObjectContext)
        testDream.title = testTitle
        testDream.id = testID
        try? coreDataStack.managedObjectContext.save()
    }

    override func tearDownWithError() throws {
        self.coreDataStack = nil
    }
    
    func testValidRead() throws{
        XCTAssertEqual(Dream.fetchDream(id: testID, context: coreDataStack.managedObjectContext), testDream)
    }

    func testValidSave() throws {
        let dreamViewModel = sampleData[1]
        XCTAssertNotNil(try? Dream.saveDream(dreamViewModel, context: coreDataStack.managedObjectContext))
        
        let dream = Dream.fetchDream(id: dreamViewModel.id, context: coreDataStack.managedObjectContext)
        XCTAssertNotNil(dream)
        
        XCTAssertTrue(dreamViewModel.isEqualTo(DreamViewModel(dream: dream!)))
    }
    
    func testValidUpdate() throws {
        let dream = DreamViewModel(dream: testDream)
        XCTAssertTrue(dream.title == testTitle)
        dream.title = "Bye World"
        XCTAssertNotNil(try? Dream.updateDream(dream, context: coreDataStack.managedObjectContext))
        
        let updatedDream = Dream.fetchDream(id: testID, context: coreDataStack.managedObjectContext)
        XCTAssertNotNil(updatedDream)
        
        let updatedDreamViewModel = DreamViewModel(dream: updatedDream!)
        XCTAssertTrue(updatedDreamViewModel.title == "Bye World")
    }
    
    func testInValidSave() throws {
        let dreamViewModel = DreamViewModel()
        dreamViewModel.title = ""
        XCTAssertNil(try? Dream.saveDream(dreamViewModel, context: coreDataStack.managedObjectContext))
        let dream = Dream.fetchDream(id: dreamViewModel.id, context: coreDataStack.managedObjectContext)
        XCTAssertNil(dream)
    }
    
    func testInValidUpdate() throws {
        let dream = DreamViewModel(dream: testDream)
        dream.title = ""
        XCTAssertNil(try? Dream.updateDream(dream, context: coreDataStack.managedObjectContext))
        
        let updatedDream = Dream.fetchDream(id: testID, context: coreDataStack.managedObjectContext)
        XCTAssertNotNil(updatedDream)
        
        let updatedDreamViewModel = DreamViewModel(dream: updatedDream!)
        XCTAssertTrue(updatedDreamViewModel.title == testTitle)
    }
    
    func testValidDelete() throws{
        let dream = DreamViewModel(dream: testDream)
        XCTAssertNotNil(Dream.fetchDream(id: dream.id, context: coreDataStack.managedObjectContext))
        XCTAssertNotNil(try? Dream.deleteDream(dream, context: coreDataStack.managedObjectContext))
        XCTAssertNil(Dream.fetchDream(id: dream.id, context: coreDataStack.managedObjectContext))
    }
}
