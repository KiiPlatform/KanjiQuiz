//
//  ResultInterfaceController.swift
//  KanjiQuiz
//
//  Created by Syah Riza on 3/20/15.
//  Copyright (c) 2015 Kii. All rights reserved.
//

import WatchKit
import Foundation
import AppLogic

class ResultInterfaceController: WKInterfaceController {

    @IBOutlet weak var totalLabel: WKInterfaceLabel!
    @IBOutlet weak var answeredLabel: WKInterfaceLabel!
    @IBOutlet weak var correctLabel: WKInterfaceLabel!
    
    var result : (totalProblem: Int,answered: Int,correctAnswer: Int)!
    
    @IBAction func submit() {
        let quiz = getCurrentQuiz()!
        QuizManager.sharedInstance.submitQuiz(quiz)
        self.dismissController()
    }
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        // Configure interface objects here.
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        let quiz = getCurrentQuiz()!
        result = quiz.countResult()
        
        totalLabel.setText("\(result!.totalProblem)")
        answeredLabel.setText("\(result!.answered)")
        correctLabel.setText("\(result!.correctAnswer)")
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

}
