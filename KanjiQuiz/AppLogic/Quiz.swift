//
//  Quiz.swift
//  KanjiQuizz
//
//  Created by Syah Riza on 3/16/15.
//  Copyright (c) 2015 Kii. All rights reserved.
//

import UIKit

public class Quiz: Serializable {
    private(set) public var problems : Array<Problem>?
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
    
    public override func toDictionary() -> NSDictionary {
        var dict = super.toDictionary() as NSMutableDictionary
        dict["type"] = self.type.rawValue
        dict["level"] = self.level.rawValue
        var mAnswers = NSMutableArray()
        
        for (key,value) in answers {
            mAnswers[key] = ["isCorrect":value.isCorrect,"answeredValue":value.answeredValue]
        }
        dict["answers"] = mAnswers
        
        return dict
    }

    init(dictionary: NSDictionary){
        self.type = (dictionary["type"]? as? String) == "Spelling" ? QuizType.Spelling : QuizType.Meaning
        self.level = .N5
        let dProblems : NSArray = dictionary["problems"]? as NSArray
        self.problems = []
        for problem in dProblems{
            let aProblem = Problem(dictionary: problem as NSDictionary)
            self.problems?.append(aProblem)
        }
        
        let dAnswers : NSArray = dictionary["answers"]? as NSArray
        var i = 0;
        for answer in dAnswers{
            let isCorrect : Bool = answer["isCorrect"] as Bool
            let answeredValue : String = answer["answeredValue"] as String
            
            self.answers[i] = (isCorrect,answeredValue)
            i++
        }
        
    }
}
