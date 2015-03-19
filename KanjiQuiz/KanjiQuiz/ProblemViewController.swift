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
    func cover(){
        self.alpha = 0.8
        
    }
}
class ProblemViewController: UIViewController,UIDynamicAnimatorDelegate {

    @IBOutlet weak var buttonA: UIButton!
    @IBOutlet weak var buttonB: UIButton!
    @IBOutlet weak var buttonC: UIButton!
    @IBOutlet weak var kanjiLabel: UILabel!
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    @IBOutlet weak var leftConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    var problem : Problem?
    var pageIndex: Int?
    var animator : UIDynamicAnimator?
    func render( button : UIButton){
        button.layer.cornerRadius = 10.0
        button.layer.masksToBounds = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.animator = UIDynamicAnimator()
        self.animator?.delegate = self

        let anotherSpells = self.problem!.variationsAnswer?.spells
        
        let arr : [UIButton] = shuffle([self.buttonA,self.buttonB,self.buttonC])
        for button in arr{
            render(button)
        }
        
        self.kanjiLabel.text = self.problem!.kanji
        self.kanjiLabel.layer.cornerRadius = 15.0
        self.kanjiLabel.layer.masksToBounds = true
        arr[0].setTitle(self.problem!.spell, forState: .Normal)
        arr[0].tag = 1
        
        arr[1].setTitle(anotherSpells?.0, forState: .Normal)
        arr[2].setTitle(anotherSpells?.1, forState: .Normal)
    }

    @IBAction func answerAction(sender: UIButton) {
        animate()
        sender.cover()
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
    
    override func viewDidAppear(animated: Bool) {
        animate()
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    
    func animate(){
        let hub = DynamicHub()
        
        let snapBehavior = UISnapBehavior(item: hub, snapToPoint: CGPointMake(self.leftConstraint.constant, self.topConstraint.constant))
        snapBehavior.damping = 0.1
        snapBehavior.action = { () -> Void in
            self.leftConstraint.constant = hub.center.x
            self.topConstraint.constant = hub.center.y
            self.bottomConstraint.constant = hub.center.y
            self.buttonA.transform = hub.transform
            self.kanjiLabel.transform = hub.transform
        }
        
        self.animator?.addBehavior(snapBehavior)
        
    }
    func dynamicAnimatorDidPause(animator: UIDynamicAnimator) {
        animator.removeAllBehaviors()
    }

}
class DynamicHub: NSObject,UIDynamicItem {
    
    private(set) var  bounds : CGRect
    var  center : CGPoint
    var  transform : CGAffineTransform
    
    
    override init(){
        bounds = CGRectMake(0, 0, 100, 100)
        center = CGPointMake(0, 0)
        transform = CGAffineTransformMakeRotation(15)
        
    }
}
