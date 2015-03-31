//
//  QuizManager.swift
//  KanjiQuiz
//
//  Created by Riza Alaudin Syah on 3/20/15.
//  Copyright (c) 2015 Kii. All rights reserved.
//

import UIKit
import DataLogic
public class QuizManager: NSObject {
    var takenQuiz : [Quiz]!
    var currentQuiz : Quiz?
    
    override init() {
        takenQuiz = []
    }
    
    public class var sharedInstance: QuizManager {
        struct Static {
            static let instance: QuizManager = QuizManager()
        }
        return Static.instance
    }
    public func loadTakenQuiz(){
        let defaults = NSUserDefaults(suiteName: "group.kanjiquiz")
        var takenQuizes : NSArray = defaults!.objectForKey("takenQuizes") as? NSArray ?? NSArray()
        for tQuiz in takenQuizes {
            let aQuiz = Quiz(dictionary: tQuiz as NSDictionary)
            self.takenQuiz.append(aQuiz)
        }
        
    }
    public func submitQuiz(quiz: Quiz){
        self.takenQuiz.insert(quiz, atIndex: 0)
        var tQuiz = NSMutableArray()
        let quizDict = quiz.toDictionary()
        tQuiz.addObject(quizDict)
        //save to cloud
        let result = quiz.countResult()
        
        KiiLogic.shared().saveQuizToCloud(quizDict, totalProblem: Int32(result.totalProblem), answered: Int32(result.answered), correct: Int32(result.correctAnswer))
        
        let defaults = NSUserDefaults(suiteName: "group.kanjiquiz")
        if defaults?.objectForKey("takenQuizes") != nil {
            var takenQuizes : NSArray = defaults?.objectForKey("takenQuizes") as NSArray
            tQuiz.addObjectsFromArray(takenQuizes)
        }
        
        defaults?.setObject(tQuiz, forKey: "takenQuizes")
        defaults?.synchronize()
    }
    public func getAllTakenQuiz() -> [Quiz]{
        return takenQuiz
    }
}
