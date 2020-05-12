//
//  DreamServiceTests.swift
//  DreamBookTests
//
//  Created by moesmoesie on 29/04/2020.
//  Copyright © 2020 moesmoesie. All rights reserved.
//

import XCTest
@testable import DreamBook
class DreamServiceTests: XCTestCase {
    var coreDataStack : InMemoryCoreDataStack!
    var sut : DreamService!
    var sampleDream : Dream!
    let sampleID = UUID()
    let sampleText = "Text"
    let sampleTitle = "Title"
    let sampleIsBookmarked = false
    let sampleDate = Date()
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        coreDataStack = InMemoryCoreDataStack()
        sut = DreamService(managedObjectContext: coreDataStack.managedObjectContext)
        sampleDream = Dream(entity: Dream.entity(), insertInto: coreDataStack.managedObjectContext)
        sampleDream.id = sampleID
        sampleDream.title = sampleTitle
        sampleDream.text = sampleText
        sampleDream.isBookmarked = sampleIsBookmarked
        sampleDream.date = sampleDate
        coreDataStack.saveContext()
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        coreDataStack = nil
        sut = nil
        sampleDream = nil
    }
    
    func testValidDreamRead() throws {
        let dream = self.sut.getDream(id: self.sampleID)
        XCTAssertNotNil(dream, "Dream should not be nil!")
        XCTAssertEqual(dream?.title!, self.sampleTitle)
        XCTAssertEqual(dream?.text!, self.sampleText)
        XCTAssertEqual(dream?.isBookmarked, self.sampleIsBookmarked)
        XCTAssertEqual(dream?.date, self.sampleDate)

    }
    
    func testInValidDreamRead() throws{
        let id = UUID()
        let dream : Dream? = self.sut.getDream(id: id)
        XCTAssertNil(dream, "Dream should be nil!")
    }
    
    func testDreamDelete() throws{
        let context = self.coreDataStack.managedObjectContext
        XCTAssertNoThrow(try context.existingObject(with: self.sampleDream.objectID))
        try sut.deleteDream(sampleDream)
        XCTAssertThrowsError(try context.existingObject(with: self.sampleDream.objectID))
    }
    
    func testDreamUpdate() throws{
        let newText = "NewText"
        let newTitle = "NewTitle"
        let newIsBookmarked = true
        let newDate = Date()
        XCTAssertNoThrow(try sut.updateDream(self.sampleDream, title: newTitle, text: newText, isBookmarked: newIsBookmarked, date: newDate))
        XCTAssertEqual(sampleDream.text, newText)
        XCTAssertEqual(sampleDream.title, newTitle)
        XCTAssertEqual(sampleDream.isBookmarked, newIsBookmarked)
        XCTAssertEqual(sampleDream.date, newDate)
        XCTAssertFalse(coreDataStack.managedObjectContext.hasChanges)
    }
    
    func testValidDreamSave() throws{
        let text = "Dream Text"
        let title = "Dream Title"
        let isBookmarked = false
        let date = Date()
        let id = UUID()
        XCTAssertNil(sut.getDream(id: id))
        XCTAssertNoThrow(try sut.saveDream(id: id, title: title, text: text, isBookmarked: isBookmarked, date: date))
        let dream = try XCTUnwrap(sut.getDream(id: id))
        XCTAssertEqual(dream.text, text)
        XCTAssertEqual(dream.title, title)
        XCTAssertEqual(dream.isBookmarked, isBookmarked)
        XCTAssertEqual(dream.date, date)
    }
}
