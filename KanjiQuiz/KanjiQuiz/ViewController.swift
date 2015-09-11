//
//  ViewController.swift
//  KanjiQuizz
//
//  Created by Syah Riza on 3/16/15.
//  Copyright (c) 2015 Kii. All rights reserved.
//

import UIKit
import AppLogic
import GameKit

class ViewController: UITableViewController,UIPickerViewDataSource,UIPickerViewDelegate,UIGestureRecognizerDelegate {
    lazy var problemSetData : [(level:String,series:Int)] = QuizManager.quizCatalog
    lazy var selectedLevel : QuizLevel = currentProblemSet.level
    lazy var selectedSeriesNum : Int = currentProblemSet.series
    
    @IBOutlet weak var meaningBestScoreLabel: UILabel!
    @IBOutlet weak var spellBestScoreLabel: UILabel!
    @IBOutlet weak var pSetLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        authenticateLocalPlayer(showAuthenticationDialogWhenReasonable, authenticatedPlayer: authenticatedPlayer,disableGameCenter: disableGameCenter)
        
    }
    override func viewDidAppear(animated: Bool) {
        self.navigationController?.interactivePopGestureRecognizer!.delegate = self
        self.updatePsetLabel()
    }
    func updatePsetLabel(){
        self.pSetLabel.text = "JLPT Level \(self.selectedLevel.rawValue) #\(self.selectedSeriesNum)"
        currentProblemSet.level = self.selectedLevel
        currentProblemSet.series = self.selectedSeriesNum
        let pSetSpellString = "\(self.selectedLevel.rawValue):\(QuizType.Spelling.rawValue)#\(self.selectedSeriesNum)"
        let pSetMeaningString = "\(self.selectedLevel.rawValue):\(QuizType.Meaning.rawValue)#\(self.selectedSeriesNum)"
        self.spellBestScoreLabel.text = "Best score : \(QuizManager.sharedInstance.bestScoreForProblemSet(pSetSpellString))"
        self.meaningBestScoreLabel.text = "Best score : \(QuizManager.sharedInstance.bestScoreForProblemSet(pSetMeaningString))"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == nil {
            return
        }
        
        func prepareQuiz(type : QuizType){
            let destination = segue.destinationViewController as! QuizViewController
            
            let quiz = Quiz(type: type, level: self.selectedLevel)
            quiz.series = self.selectedSeriesNum
            quiz.setup()
            destination.currentQuiz = quiz
            destination.problems = quiz.problems
            setCurrentQuiz(quiz)
            
        }
        
        if let segueID = segue.identifier {
            switch segueID {
            case "Meaning":
                prepareQuiz(QuizType.Meaning)
            case "Spelling":
                prepareQuiz(QuizType.Spelling)
                
            default:
                break
            }
        }
    }
    @IBAction func addAlert(sender: AnyObject){
        
        // create the alert
        let title = "Select Problem Set"
        let message = "Please pick level and series"
        var alert = self.storyboard?.instantiateViewControllerWithIdentifier("PickerViewController") as! PickerViewController
        alert.view.layer.cornerRadius = 15.0
        alert.view.layer.masksToBounds = true
        let selectedLevelIndex : Int = QuizLevel.allRawValues.indexOfObject(self.selectedLevel.rawValue) ?? 0
        // present with our view controller
        self.presentViewController(alert, animated: true) { () -> Void in
            alert.pickerView.delegate = self;
            alert.pickerView.dataSource = self;
            alert.pickerView.selectRow(selectedLevelIndex, inComponent: 0, animated: true)
            alert.pickerView.reloadAllComponents()
            alert.pickerView.selectRow(self.selectedSeriesNum-1, inComponent: 1, animated: true)
            alert.selectButton.addTarget(self, action: Selector("dismiss"), forControlEvents: UIControlEvents.TouchUpInside)
        }
        
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 2
    }
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if(component == 0){
            return problemSetData.count
        }else{
            let idx = pickerView.selectedRowInComponent(0)
            return problemSetData[idx].series
        }
    }
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        if(component == 0){
            return "JLPT \(problemSetData[row].level)"
        }else{
            return "#\(row + 1)"
        }
        
    }
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if(component == 0){
            self.selectedLevel = QuizLevel(rawValue: problemSetData[row].level)!
            pickerView.reloadComponent(1)
        }else{
            self.selectedSeriesNum = row + 1
        }
    }
    func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
        
        return gestureRecognizer !== self.navigationController?.interactivePopGestureRecognizer;
    }
    func dismiss() {
        self.updatePsetLabel()
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func showAuthenticationDialogWhenReasonable(vc:UIViewController) -> Void{
        self.presentViewController(vc, animated: true, completion: nil)
    }
    func authenticatedPlayer(local :GKLocalPlayer) -> Void{
        gameKitLogin(local)
        print("\(local.playerID)", terminator: "")
    }
    func disableGameCenter(){
        print("disabled", terminator: "")
    }

}

