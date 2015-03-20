//
//  ProblemInterfaceController.swift
//  KanjiQuiz
//
//  Created by Riza Alaudin Syah on 3/20/15.
//  Copyright (c) 2015 Kii. All rights reserved.
//

import WatchKit
import Foundation


class ProblemInterfaceController: WKInterfaceController {

    @IBOutlet weak var buttonA: WKInterfaceButton!
    @IBOutlet weak var buttonB: WKInterfaceButton!
    @IBOutlet weak var buttonC: WKInterfaceButton!
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
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
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

}
