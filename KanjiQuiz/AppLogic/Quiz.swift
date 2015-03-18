//
//  Quiz.swift
//  KanjiQuizz
//
//  Created by Syah Riza on 3/16/15.
//  Copyright (c) 2015 Kii. All rights reserved.
//

import UIKit

public class Quiz: NSObject {
    private(set) public var problems : [Problem]?
    var type : QuizType
    var level : QuizLevel
    public init(type: QuizType, level :QuizLevel){
        self.level = level
        self.type = type
    }
    
    public func setup(){
        self.problems = generateProblems(self)
        
    }

}
