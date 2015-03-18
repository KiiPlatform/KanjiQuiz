//
//  ProblemViewController.swift
//  KanjiQuiz
//
//  Created by Syah Riza on 3/17/15.
//  Copyright (c) 2015 Kii. All rights reserved.
//

import UIKit
import AppLogic

extension UIButton{
    func isCorrectAnswer() -> Bool{
        return self.tag==1
    }
    
}
class ProblemViewController: UIViewController {

    @IBOutlet weak var buttonA: UIButton!
    @IBOutlet weak var buttonB: UIButton!
    @IBOutlet weak var buttonC: UIButton!
    @IBOutlet weak var kanjiLabel: UILabel!
    var problem : Problem?
    var pageIndex: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let anotherSpells = self.problem!.variationsAnswer?.spells
        
        let arr : [UIButton] = shuffle([self.buttonA,self.buttonB,self.buttonC])
        self.kanjiLabel.text = self.problem!.kanji
        
        arr[0].setTitle(self.problem!.spell, forState: .Normal)
        arr[0].tag = 1
        arr[1].setTitle(anotherSpells?.0, forState: .Normal)
        arr[2].setTitle(anotherSpells?.1, forState: .Normal)
    }

    @IBAction func answerAction(sender: UIButton) {
        
        if sender.isCorrectAnswer() {
            println("Correct")
        }else{
            println("Wrong !!")
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    

}
