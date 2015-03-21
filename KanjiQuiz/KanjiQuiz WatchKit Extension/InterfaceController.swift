//
//  InterfaceController.swift
//  KanjiQuizz WatchKit Extension
//
//  Created by Syah Riza on 3/16/15.
//  Copyright (c) 2015 Kii. All rights reserved.
//

import WatchKit
import Foundation
import AppLogic

class InterfaceController: WKInterfaceController {
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        // Configure interface objects here.
    }
    
    @IBAction func startSpellingQuiz() {
        let quiz = Quiz(type: QuizType.Spelling, level: .N5)
        quiz.setup()
        setCurrentQuiz(quiz)

        var contexts = Array<AnyObject>()
        var pages = Array<AnyObject>()
        
        for (index,value) in enumerate(quiz.problems!) {
            let cont = ["index":index,"problem":value]
            contexts.append(cont)
            pages.append("ProblemInterface")
        }
        
        pages.append("ResultInterface")
        
        self.presentControllerWithNames(pages, contexts: contexts)
        
    }
    @IBAction func startMeaningQuiz() {
        
    }
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    
    override func contextForSegueWithIdentifier(segueIdentifier: String) -> AnyObject? {
        println(segueIdentifier)
        return nil
    }
}
