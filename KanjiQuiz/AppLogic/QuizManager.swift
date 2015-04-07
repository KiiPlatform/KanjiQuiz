//
//  QuizManager.swift
//  KanjiQuiz
//
//  Created by Riza Alaudin Syah on 3/20/15.
//  Copyright (c) 2015 Kii. All rights reserved.
//

import UIKit
import DataLogic
public class QuizManager: NSObject {
  var takenQuiz : [Quiz]!
  var currentQuiz : Quiz?
  public lazy var selectedLevel : QuizLevel = .N5
  public lazy var selectedSeries : Int = 1
  
  override init() {
    takenQuiz = []
  }
  public typealias Catalog = (level: String,series: Int)
  public typealias CatalogList = [Catalog]
  
  public class var quizCatalog : CatalogList {
    func generateCatalog() -> CatalogList {
      let data : NSArray = QuizData.quizCatalog() ?? []
      var result : CatalogList = []
      
      for val in data{
        let series : NSNumber = val[1] as NSNumber
        
        let aData : Catalog = (val[0] as String,val[1] as Int)
        result.append(aData)
        
      }
      return result
    }
    struct Static {
      static let instance : CatalogList = generateCatalog()
    }
    return Static.instance
  }
  
  public class var sharedInstance: QuizManager {
    struct Static {
      static let instance: QuizManager = QuizManager()
    }
    return Static.instance
  }
  public func loadTakenQuiz(){
    let defaults = NSUserDefaults(suiteName: "group.kanjiquiz")
    var takenQuizes : NSArray = defaults!.objectForKey("takenQuizes") as? NSArray ?? NSArray()
    for tQuiz in takenQuizes {
      let aQuiz = Quiz(dictionary: tQuiz as NSDictionary)
      self.takenQuiz.append(aQuiz)
    }
    
  }
  public func submitQuiz(quiz: Quiz){
    self.takenQuiz.insert(quiz, atIndex: 0)
    var tQuiz = NSMutableArray()
    let quizDict = quiz.toDictionary()
    tQuiz.addObject(quizDict)
    //save to cloud
    let result = quiz.countResult()
    let score : Float = Float((Float(result.correctAnswer) / Float(result.totalProblem)) * 100)
    
    KiiLogic.shared().saveQuizToCloud(quizDict, totalProblem: Int32(result.totalProblem), answered: Int32(result.answered), correct: Int32(result.correctAnswer))
    
    let defaults = NSUserDefaults(suiteName: "group.kanjiquiz")
    if defaults?.objectForKey("takenQuizes") != nil {
      var takenQuizes : NSArray = defaults?.objectForKey("takenQuizes") as NSArray
      tQuiz.addObjectsFromArray(takenQuizes)
    }
    let dict : NSDictionary? = defaults?.objectForKey("quizScores")? as? NSDictionary ?? NSDictionary()

    var quizScores : NSMutableDictionary =  (dict?.mutableCopy() as NSMutableDictionary) ?? [quiz.description:NSNumber(float: score)]
    if (quizScores[quiz.description] as? NSNumber)?.floatValue < score  {
      quizScores[quiz.description] = NSNumber(float: score)
    
    }
    
    defaults?.setObject(quizScores, forKey: "quizScores")
    defaults?.setObject(tQuiz, forKey: "takenQuizes")
    defaults?.synchronize()
  }
  public func bestScoreForProblemSet(problemSet : String!) -> Float{
    let defaults = NSUserDefaults(suiteName: "group.kanjiquiz")
    
    let quizScore  = (defaults?.objectForKey("quizScores")?[problemSet]? as NSNumber?) ?? NSNumber(float: 0.0)
    
    return quizScore.floatValue
  }
  public func getAllTakenQuiz() -> [Quiz]{
    return takenQuiz
  }
  public func updateSharedProblemSet(){
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), { () -> Void in
      let defaults = NSUserDefaults(suiteName: "group.kanjiquiz")
      let sharedProblemSet : NSDictionary = ["level":self.selectedLevel.rawValue,
        "series":NSNumber(integer: self.selectedSeries)]
      defaults!.setObject(sharedProblemSet, forKey: "shared_problem_set")
      defaults!.synchronize()
    })
  }
  public func loadSharedProblemSet(){
    let defaults = NSUserDefaults(suiteName: "group.kanjiquiz")
    if let sharedProblemSet : NSDictionary = defaults?.objectForKey("shared_problem_set") as? NSDictionary{
      self.selectedSeries = (sharedProblemSet["series"] as NSNumber).integerValue
      self.selectedLevel = QuizLevel(rawValue: sharedProblemSet["level"] as? String ?? "N5")!
      
    }
    
  }
}
