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
        self.alpha = 0.5
        
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
    let coverLayer = CALayer()
    var problem : Problem?
    var pageIndex: Int?
    var animator : UIDynamicAnimator?
    func render( button : UIButton){
        button.layer.cornerRadius = 10.0
        button.layer.masksToBounds = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let parent = self.parentViewController as! QuizViewController
        self.animator = UIDynamicAnimator()
        self.animator?.delegate = self

        let variationAnswer =  parent.currentQuiz!.type == .Spelling ? self.problem!.variationsAnswer?.spells : self.problem!.variationsAnswer?.meanings
        
        let correctAnswer =  parent.currentQuiz!.type == .Spelling ? self.problem!.spell : self.problem!.meaning
        let arr : [UIButton] = shuffle([self.buttonA,self.buttonB,self.buttonC])
        for button in arr{
            render(button)
        }
        
        self.kanjiLabel.text = self.problem!.kanji
        self.kanjiLabel.layer.cornerRadius = 15.0
        self.kanjiLabel.layer.masksToBounds = true
        arr[0].setTitle(correctAnswer, forState: .Normal)
        arr[0].tag = 1
        
        arr[1].setTitle(variationAnswer?.0, forState: .Normal)
        arr[2].setTitle(variationAnswer?.1, forState: .Normal)
        let kanjiFrame = kanjiLabel.bounds
        coverLayer.frame = CGRectMake(0, 0, kanjiFrame.width, kanjiFrame.height)
        coverLayer.cornerRadius = 15.0
        coverLayer.masksToBounds = true
        coverLayer.backgroundColor = UIColor.whiteColor().CGColor
        self.kanjiLabel.layer.mask = self.coverLayer
        
    }

    @IBAction func answerAction(sender: UIButton) {
        animate()
        
        disableButtons()
        sender.cover()
        let parent = self.parentViewController as! QuizViewController
        parent.currentQuiz.addAnswer(self.pageIndex!, isCorrect: sender.isCorrectAnswer(), answeredValue: sender.currentTitle!)
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(animated: Bool) {
        let parent = self.parentViewController as! QuizViewController
        if (parent.currentQuiz.getAnswered(self.pageIndex!) != nil) {
            self.disableButtons()
        }
    }
    override func viewDidAppear(animated: Bool) {
        self.coverLayer.removeFromSuperlayer()
        animate()
        
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    func disableButtons(){
        let buttons = [buttonA,buttonB,buttonC]
        for button in buttons {
            button.setTitleColor(UIColor.whiteColor(), forState: .Disabled)
            if button.isCorrectAnswer(){
                button.backgroundColor = UIColor.blueColor()
            }else{
                button.backgroundColor = UIColor.redColor()
            }
            button.enabled = false
        }
    }
    func animate(){
        let hub = DynamicHub()
        
        let snapBehavior = UISnapBehavior(item: hub, snapToPoint: CGPointMake(self.leftConstraint.constant, self.topConstraint.constant))
        snapBehavior.damping = 0.1
        snapBehavior.action = { () -> Void in
            self.leftConstraint.constant = hub.center.x
            self.topConstraint.constant = hub.center.y
            self.bottomConstraint.constant = hub.center.y
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
