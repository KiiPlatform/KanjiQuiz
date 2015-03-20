//
//  QuizManager.swift
//  KanjiQuiz
//
//  Created by Riza Alaudin Syah on 3/20/15.
//  Copyright (c) 2015 Kii. All rights reserved.
//

import UIKit

public class QuizManager: NSObject {
    var takenQuiz : [Quiz]
    override init() {
        takenQuiz = []
    }
    
    public class var sharedInstance: QuizManager {
        struct Static {
            static let instance: QuizManager = QuizManager()
        }
        return Static.instance
    }
    func submitQuiz(quiz: Quiz){
        self.takenQuiz.append(quiz)
    }
}
