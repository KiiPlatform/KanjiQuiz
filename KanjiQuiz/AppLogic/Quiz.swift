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
    private(set) public var type : QuizType
    private(set) public var level : QuizLevel
    var answers : [Int:(isCorrect : Bool,answeredValue : String)] = Dictionary<Int,(isCorrect : Bool,answeredValue : String)>()
    public init(type: QuizType, level :QuizLevel){
        self.level = level
        self.type = type
    }
    
    public func setup(){
        self.problems = generateProblems(self)
        
    }
    
    public func addAnswer(problemIndex: Int,isCorrect : Bool,answeredValue : String){
        if problems!.count<problemIndex{
            return
        }
        answers[problemIndex] = (isCorrect,answeredValue)
        
    }
    
    public func getAnswered(problemIndex : Int) ->(Bool,String)?{
        
        return answers[problemIndex]
    }
    public func countResult() -> (totalProblem : Int, answered : Int, correctAnswer : Int){
        var result : (totalProblem : Int, answered : Int, correctAnswer : Int) = (problems!.count,answers.count,0)
        
        for (key,value) in answers {
            if value.isCorrect {
                result.correctAnswer++
            }
        }
        
        return result
    }

}
