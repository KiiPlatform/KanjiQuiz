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
    
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        index = context as Int
        //let problem = getCurrentQuiz()!.problems?[index]
        
        // Configure interface objects here.
    }

    @IBAction func answerA() {
    }
    @IBAction func answerB() {
    }
    @IBAction func answerC() {
    }
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        let menloFont = UIFont.systemFontOfSize(50.0)
        var fontAttrs = [NSFontAttributeName : menloFont]
        var attrString = NSAttributedString(string: dummy[self.index], attributes: fontAttrs)
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
