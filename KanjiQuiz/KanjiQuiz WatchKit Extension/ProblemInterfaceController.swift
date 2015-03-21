//
//  ProblemInterfaceController.swift
//  KanjiQuiz
//
//  Created by Riza Alaudin Syah on 3/20/15.
//  Copyright (c) 2015 Kii. All rights reserved.
//

import WatchKit
import Foundation
import AppLogic
internal var pageIndex : Int = 0
internal let dummy = ["私","後","八","書","下"]


class ProblemInterfaceController: WKInterfaceController {

    @IBOutlet weak var kanjiLabel: WKInterfaceLabel!
    @IBOutlet weak var buttonA: WKInterfaceButton!
    @IBOutlet weak var buttonB: WKInterfaceButton!
    @IBOutlet weak var buttonC: WKInterfaceButton!
    
    var problem : Problem?
    internal var index = 0
    var buttons : [WKInterfaceButton]!
    var correctAnswerButton : WKInterfaceButton!
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        let dict = context as NSDictionary
        index = dict["index"] as Int
        self.problem = dict["problem"] as? Problem
        buttons = [buttonA,buttonB,buttonC]
        let rand = Int(arc4random_uniform(2))
        correctAnswerButton = buttons[rand]
        let variation = self.problem?.variationsAnswer
        var quiz = getCurrentQuiz()?
        
        var wrongAnswers : (String,String)!
        
        if quiz != nil {
            if quiz!.type == .Spelling {
                wrongAnswers = variation!.spells
            }else {
                wrongAnswers = variation!.meanings
            }
        }
        
        switch correctAnswerButton {
        case buttonA :
            buttonA.setTitle(self.problem?.spell)
            buttonB.setTitle(wrongAnswers.0)
            buttonC.setTitle(wrongAnswers.1)
        case buttonB :
            buttonB.setTitle(self.problem?.spell)
            buttonA.setTitle(wrongAnswers.0)
            buttonC.setTitle(wrongAnswers.1)
        case buttonC :
            buttonC.setTitle(self.problem?.spell)
            buttonB.setTitle(wrongAnswers.0)
            buttonA.setTitle(wrongAnswers.1)
        default :
            print()
        }
        
        
    }

    func checkAnswer(button : WKInterfaceButton) -> Bool{
        return button === correctAnswerButton
    }
    
    @IBAction func answerA() {
        checkAnswer(buttonA) ? println("Correct") : println("wrong")
    }
    @IBAction func answerB() {
        checkAnswer(buttonB) ? println("Correct") : println("wrong")
    }
    @IBAction func answerC() {
        checkAnswer(buttonC) ? println("Correct") : println("wrong")
    }
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        let kanji = self.problem?.kanji
        let font = UIFont.systemFontOfSize(40.0)
        var fontAttrs = [NSFontAttributeName : font]
        var attrString = NSAttributedString(string: kanji!, attributes: fontAttrs)
        self.kanjiLabel.setAttributedText(attrString)
        
        
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
