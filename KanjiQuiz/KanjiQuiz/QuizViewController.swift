//
//  QuizViewController.swift
//  KanjiQuiz
//
//  Created by Syah Riza on 3/17/15.
//  Copyright (c) 2015 Kii. All rights reserved.
//

import UIKit
import AppLogic

class QuizViewController: UIPageViewController,UIPageViewControllerDataSource,UIPageViewControllerDelegate, UIGestureRecognizerDelegate {
    var problemViewControllers : [UIViewController] = []
    var problems : [Problem]?
    var currentQuiz : Quiz!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dataSource = self
        self.delegate = self
        let pageContentViewController = self.viewControllerAtIndex(0)
        self.setViewControllers([pageContentViewController!], direction: UIPageViewControllerNavigationDirection.Forward, animated: true, completion: nil)
    }

    var count = 0
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        
        var index = (viewController as ProblemViewController).pageIndex!
        index++
        if(index >= problems!.count){
            return nil
        }
        return self.viewControllerAtIndex(index)
        
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        
        var index = (viewController as ProblemViewController).pageIndex!
        if(index <= 0){
            return nil
        }
        index--
        return self.viewControllerAtIndex(index)
        
    }
    
    func viewControllerAtIndex(index : Int) -> UIViewController? {
        if((self.problems!.count == 0) || (index >= self.problems!.count)) {
            return nil
        }
        let pageContentViewController = self.storyboard?.instantiateViewControllerWithIdentifier("ProblemViewController") as ProblemViewController

        pageContentViewController.problem = self.problems![index]
        pageContentViewController.pageIndex = index
        
        func addSubmitButton(){
            let submitBtn = UIBarButtonItem(title: "Submit", style: UIBarButtonItemStyle.Bordered, target: self, action: Selector("submitQuiz"))
            self.navigationItem.rightBarButtonItem = submitBtn
        }
        addSubmitButton()
        if index == (self.problems!.count-1) {
            addSubmitButton()
        }
        
        return pageContentViewController
    }
    func submitQuiz() {
        println(self.currentQuiz.countResult())
        let result = self.currentQuiz.countResult()
        let message = "Total Problems : \(result.totalProblem) \n Answered : \(result.answered) \n Correct Answer : \(result.correctAnswer) \n";
        
        func displayAlert(){
            //Create the AlertController
            let actionSheetController: UIAlertController = UIAlertController(title: "Your Result ", message: message, preferredStyle: .Alert)
            
            //Create and add the Cancel action
            let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .Cancel) { action -> Void in
                //Do some stuff
            }
            actionSheetController.addAction(cancelAction)
            //Create and an option action
            let nextAction: UIAlertAction = UIAlertAction(title: "Submit", style: .Default) { action -> Void in
                
                QuizManager.sharedInstance.submitQuiz(self.currentQuiz)
                
                self.navigationController!.popToRootViewControllerAnimated(true)
            }
            actionSheetController.addAction(nextAction)
            
            self.presentViewController(actionSheetController, animated: true, completion: nil)
        }
        
        displayAlert()
    }
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        return problems!.count
    }

    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        return 0
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        println(segue.identifier)
    }
    func pageViewController(pageViewController: UIPageViewController, willTransitionToViewControllers pendingViewControllers: [AnyObject]) {
        let pending = pendingViewControllers.first as ProblemViewController
        func animate(){
            
            let keyFrameAnimation = CAKeyframeAnimation(keyPath: "bounds")
            keyFrameAnimation.duration = 1
            keyFrameAnimation.timingFunctions = [CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut), CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)]
            let initalBounds = NSValue(CGRect: pending.coverLayer.bounds)
            let secondBounds = NSValue(CGRect: CGRect(x: pending.coverLayer.bounds.width/2, y: 0, width: 30, height: 30))
            let finalBounds = NSValue(CGRect: CGRect(x: 0, y: 0, width: 1500, height: 1500))
            keyFrameAnimation.values = [initalBounds, secondBounds, finalBounds]
            keyFrameAnimation.keyTimes = [0, 0.3, 1]
            pending.coverLayer.addAnimation(keyFrameAnimation, forKey: "flash");
        }
        if (self.currentQuiz.getAnswered(pending.pageIndex!) == nil) {
            animate()
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        //let alertAction = UIAlertAction(
        self.navigationController!.interactivePopGestureRecognizer.delegate = self
    }
    
    
    func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool{
        return false
    }
    
}
