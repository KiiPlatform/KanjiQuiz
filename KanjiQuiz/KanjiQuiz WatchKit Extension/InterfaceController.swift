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
import DataLogic

class InterfaceController: WKInterfaceController {
  
  @IBOutlet weak var pSetLabel: WKInterfaceLabel!
  @IBOutlet weak var displayName: WKInterfaceLabel!
  override func awakeWithContext(context: AnyObject?) {
    super.awakeWithContext(context)
    setupKii()
    QuizData.setup()
    QuizManager.sharedInstance.loadSharedProblemSet()
    var val = userDisplayName() as String
    
    self.displayName.setText(val)
    self.pSetLabel.setText( "JLPT \(currentProblemSet.level.rawValue) #\(currentProblemSet.series)")
    
    // Configure interface objects here.
  }
  func startQuiz(quiz: Quiz){
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
  @IBAction func startSpellingQuiz() {
    let quiz = Quiz(type: QuizType.Spelling, level: currentProblemSet.level)
    quiz.series = currentProblemSet.series
    quiz.setup()
    setCurrentQuiz(quiz)
    self.startQuiz(quiz)
  }
  @IBAction func startMeaningQuiz() {
    let quiz = Quiz(type: QuizType.Meaning, level: currentProblemSet.level)
    quiz.series = currentProblemSet.series
    quiz.setup()
    setCurrentQuiz(quiz)
    self.startQuiz(quiz)
    
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
