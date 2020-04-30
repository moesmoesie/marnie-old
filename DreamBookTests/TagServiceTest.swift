//
//  TagServiceTest.swift
//  DreamBookTests
//
//  Created by moesmoesie on 30/04/2020.
//  Copyright © 2020 moesmoesie. All rights reserved.
//

import XCTest
@testable import DreamBook
class TagServiceTest: XCTestCase {
    var coreDataStack : InMemoryCoreDataStack!
    var sut : TagService!
    var sampleTag : Tag!
    let sampleText = "Text"
    

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        coreDataStack = InMemoryCoreDataStack()
        sut = TagService(managedObjectContext: coreDataStack.managedObjectContext)
        sampleTag = Tag(entity: Tag.entity(), insertInto: coreDataStack.managedObjectContext)
        sampleTag.text = sampleText
        coreDataStack.saveContext()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        sut = nil
        sampleTag = nil
        coreDataStack = nil
    }

    func testValidTagRead() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let tag = sut.getTag(text: sampleText)
        XCTAssertNotNil(tag, "Tag should not be nill")
        XCTAssertEqual(tag?.wrapperText, sampleText)
    }
    
    func testInvalidTagRead() throws {
         // This is an example of a functional test case.
         // Use XCTAssert and related functions to verify your tests produce the correct results.
         let tag = sut.getTag(text: "RandomTag")
         XCTAssertNil(tag, "Tag should be nill")
     }
    
    func testValidDreamCreate() throws {
        XCTAssertNoThrow(try sut.createTag(text: "Hello World!"))
        let tag = sut.getTag(text: "Hello World!")
        XCTAssertNotNil(tag, "Tag should not be nill")
        if let tag = tag{
            XCTAssertEqual(tag.wrapperText, "Hello World!")
        }
    }
    
    func testInvalidDreamCreate() throws {
        XCTAssertThrowsError(try sut.createTag(text: ""))
    }
}
