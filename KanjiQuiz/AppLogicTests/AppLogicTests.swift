//
//  AppLogicTests.swift
//  AppLogicTests
//
//  Created by Syah Riza on 3/16/15.
//  Copyright (c) 2015 Kii. All rights reserved.
//

import UIKit
import XCTest
import AppLogic
extension Array {
    func contains<T where T : Equatable>(obj: T) -> Bool {
        return self.filter({$0 as? T == obj}).count > 0
    }
}
class AppLogicTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testPickData(){
        let data = ("後",spells :"ゴ ・ コウ ・ のち ・ うし.ろ ・ うしろ ・ あと ・ おく.れる",meanings: "behind; back; later")
        let spells : [String] = data.spells.componentsSeparatedByString(" ・ ")
        let meanings : [String] = data.meanings.componentsSeparatedByString("; ")
        let result1 = pickData(data.meanings,field: KanjiField.Meanings)
        let result2 = pickData(data.spells,field: KanjiField.Spellings)
        
        XCTAssertTrue(meanings.contains(result1), "")
        XCTAssertTrue(spells.contains(result2), "")
        
    }
    
    func testGenerateProblems(){
        let quiz = Quiz(type: .Spelling, level: .N5)

        quiz.setup()
        
        print(quiz.toDictionary())
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock() {
            // Put the code you want to measure the time of here.
        }
    }
    
}
