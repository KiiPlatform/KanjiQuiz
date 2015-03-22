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

extension WKInterfaceButton{
    func getText() -> String?{
        
        return self.interfaceProperty
    }
}

class ProblemInterfaceController: WKInterfaceController {

    @IBOutlet weak var kanjiLabel: WKInterfaceLabel!
    @IBOutlet weak var buttonA: WKInterfaceButton!
    @IBOutlet weak var buttonB: WKInterfaceButton!
    @IBOutlet weak var buttonC: WKInterfaceButton!
    
    var problem : Problem?
    internal var index = 0
    var buttons : [WKInterfaceButton]!
    var correctAnswerButton : WKInterfaceButton!
    var titleMap : [String:String]!
    
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
        var correctAnswer : String!
        var wrongAnswers : (String,String)!
        
        if quiz != nil {
            if quiz!.type == .Spelling {
                wrongAnswers = variation!.spells
                correctAnswer = self.problem?.spell
            }else {
                wrongAnswers = variation!.meanings
                correctAnswer = self.problem?.meaning
            }
        }
        titleMap = [correctAnswerButton.interfaceProperty:correctAnswer]
        
        func setWrongAnswerButton(buttons : (WKInterfaceButton,WKInterfaceButton)){
            buttons.0.setTitle(wrongAnswers.0)
            buttons.1.setTitle(wrongAnswers.1)
            titleMap[buttons.0.interfaceProperty] = wrongAnswers.0
            titleMap[buttons.1.interfaceProperty] = wrongAnswers.1
        }
        
        switch correctAnswerButton {
        case buttonA :
            buttonA.setTitle(correctAnswer)
            setWrongAnswerButton((buttonB,buttonC))
        case buttonB :
            buttonB.setTitle(correctAnswer)
            setWrongAnswerButton((buttonC,buttonA))
        case buttonC :
            buttonC.setTitle(correctAnswer)
            setWrongAnswerButton((buttonA,buttonB))
        default :
            break
        }
        
    }

    func checkAnswer(tappedButton : WKInterfaceButton) -> Bool{
        println("title : \(tappedButton.getText())")
        let result = tappedButton === correctAnswerButton
        for button in buttons {
            if button === correctAnswerButton {
                button.setBackgroundColor(UIColor.blueColor())
            }else{
                button.setBackgroundColor(UIColor.redColor())
            }
            button.setEnabled(false)
        }
        tappedButton.setAlpha(0.5)
        var quiz = getCurrentQuiz()?
        quiz!.addAnswer(self.index, isCorrect: result, answeredValue: titleMap[tappedButton.interfaceProperty]!)
        
        return result
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
