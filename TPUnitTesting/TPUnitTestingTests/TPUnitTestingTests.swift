//
//  Project39UnitTestingTests.swift
//  Project39UnitTestingTests
//
//  Created by Anton Yaroshchuk on 01.07.2021.
//

import XCTest
@testable import TPUnitTesting

class TPUnitTestingTests: XCTestCase {

//    override func setUpWithError() throws {
//        // Put setup code here. This method is called before the invocation of each test method in the class.
//    }
//
//    override func tearDownWithError() throws {
//        // Put teardown code here. This method is called after the invocation of each test method in the class.
//    }
//
//    func testExample() throws {
//        // This is an example of a functional test case.
//        // Use XCTAssert and related functions to verify your tests produce the correct results.
//    }
//
//    func testPerformanceExample() throws {
//        // This is an example of a performance test case.
//        self.measure {
//            // Put the code you want to measure the time of here.
//        }
//    }
    
    func testAllWordsLoaded(){
        let playData = PlayData()
        XCTAssertEqual(playData.allWords.count, 18440, "allWords must be 0")
    }
    
    func testWordCountsAreCorrect(){
        let playData = PlayData()
        XCTAssertEqual(playData.wordCounts.count(for: "story"), 35, "story  does not appear 35 times.")
        XCTAssertEqual(playData.wordCounts.count(for: "pray"), 316, "pray does not appear 316 times.")
        XCTAssertEqual(playData.wordCounts.count(for: "men"), 304, "men does not appear 304 times.")
    }
    
    func testWordsLoadQuickly(){
        measure{
            _ = PlayData()
        }
    }
    
    func testUserFilterWorks(){
        let playData = PlayData()
        
        playData.applyUserFilter("100")
        XCTAssertEqual(playData.filteredWords.count, 495)
        
        playData.applyUserFilter("1000")
        XCTAssertEqual(playData.filteredWords.count, 55)
        
        playData.applyUserFilter("10000")
        XCTAssertEqual(playData.filteredWords.count, 1)
        
        playData.applyUserFilter("test")
        XCTAssertEqual(playData.filteredWords.count, 56)
        
        playData.applyUserFilter("swift")
        XCTAssertEqual(playData.filteredWords.count, 7)
        
        playData.applyUserFilter("objective-c")
        XCTAssertEqual(playData.filteredWords.count, 0, "Something goes wrong, Shakespeare do not like to write in objective-c at all!")
    }
    
}
