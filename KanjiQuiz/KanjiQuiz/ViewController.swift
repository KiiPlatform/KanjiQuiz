//
//  ViewController.swift
//  KanjiQuizz
//
//  Created by Syah Riza on 3/16/15.
//  Copyright (c) 2015 Kii. All rights reserved.
//

import UIKit
import AppLogic


class ViewController: UITableViewController,UIPickerViewDataSource,UIPickerViewDelegate,UIGestureRecognizerDelegate {
  lazy var problemSetData : [(level:String,series:Int)] = QuizManager.quizCatalog
  lazy var selectedLevel : QuizLevel = currentProblemSet.level
  lazy var selectedSeriesNum : Int = currentProblemSet.series
  
  @IBOutlet weak var pSetLabel: UILabel!
  override func viewDidLoad() {
    super.viewDidLoad()
    self.updatePsetLabel()
    //self.navigationController?.rem
    
  }
  override func viewDidAppear(animated: Bool) {
    self.navigationController?.interactivePopGestureRecognizer.delegate = self
    
  }
  func updatePsetLabel(){
    self.pSetLabel.text = "JLPT Level \(self.selectedLevel.rawValue) #\(self.selectedSeriesNum)"
    currentProblemSet.level = self.selectedLevel
    currentProblemSet.series = self.selectedSeriesNum
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
      let destination = segue.destinationViewController as QuizViewController
      
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
    var alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert);
    alert.modalInPopover = true;
    
    // add an action button
    let nextAction: UIAlertAction = UIAlertAction(title: "OK", style: .Default){action->Void in
      self.updatePsetLabel()
    }
    alert.addAction(nextAction)
    
    // now create our custom view - we are using a container view which can contain other views
    let containerViewWidth = 250
    let containerViewHeight = 120
    var containerFrame = CGRectMake(10, 70, CGFloat(containerViewWidth), CGFloat(containerViewHeight));
    var containerView: UIPickerView = UIPickerView(frame: containerFrame)
    containerView.delegate = self;
    containerView.dataSource = self;
    let selectedLevelIndex : Int = QuizLevel.allRawValues.indexOfObject(self.selectedLevel.rawValue) ?? 0
    
    containerView.selectRow(selectedLevelIndex, inComponent: 0, animated: false)
    containerView.selectRow(self.selectedSeriesNum-1, inComponent: 1, animated: false)
    
    alert.view.addSubview(containerView)
    
    // now add some constraints to make sure that the alert resizes itself
    var cons:NSLayoutConstraint = NSLayoutConstraint(item: alert.view, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.GreaterThanOrEqual, toItem: containerView, attribute: NSLayoutAttribute.Height, multiplier: 1.00, constant: 130)
    
    alert.view.addConstraint(cons)
    
    var cons2:NSLayoutConstraint = NSLayoutConstraint(item: alert.view, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.GreaterThanOrEqual, toItem: containerView, attribute: NSLayoutAttribute.Width, multiplier: 1.00, constant: 20)
    
    alert.view.addConstraint(cons2)
    
    // present with our view controller
    presentViewController(alert, animated: true, completion: nil)
    
  }
  
  func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
    return 2
  }
  func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    if(component == 0){
      return problemSetData.count
    }else{
      var idx = pickerView.selectedRowInComponent(0)
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
  func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer!) -> Bool {
    
    return gestureRecognizer !== self.navigationController?.interactivePopGestureRecognizer;
  }
}

