//
//  Functions.swift
//  KanjiQuiz
//
//  Created by Syah Riza on 3/17/15.
//  Copyright (c) 2015 Kii. All rights reserved.
//

import UIKit
import DataLogic


public func shuffle<C: MutableCollectionType where C.Index == Int>(var list: C) -> C {
    let mCount = count(list)
    for i in 0..<(mCount - 1) {
        let j = Int(arc4random_uniform(UInt32(mCount - i))) + i
        swap(&list[i], &list[j])
    }
    return list
}

public func testProblem() -> Problem {
    
    let problem = Problem(kanjiSet: ("今",("コン",("のち","ナン")),("now",("seven","yesterday"))))
    
    return problem
}

public func pickData(rawString :String, field :KanjiField) -> String {
    
    switch field {
    case .Spellings:
        let spells : [String] = rawString.componentsSeparatedByString(" ・ ")
        if spells.count == 1
        {
            return rawString
        }
        return shuffle(spells).first!
        
    case .Meanings:
        let meanings : [String] = rawString.componentsSeparatedByString("; ")
        if meanings.count == 1
        {
            return rawString
        }
        return shuffle(meanings).first!
        
    default :
        return rawString
    }
    
}
func removeObject<T : Equatable>(object: T, inout fromArray array: [T])
{
    var index = find(array, object)
    array.removeAtIndex(index!)
}
func pickWrongData(data: [(String,String,String)]) -> (wrongSpells: (String,String),wrongMeanings :(String,String)){
    let shuffleData = shuffle(data)
    let wrongSpells = (pickData(shuffleData[0].1, .Spellings),pickData(shuffleData[1].1, .Spellings))
    let wrongMeanings = (pickData(shuffleData[0].2, .Meanings),pickData(shuffleData[1].2, .Meanings))
    return (wrongSpells,wrongMeanings)
}
private let dummyKanjiData = [QuizLevel.N5:[
    ("語","ゴ ・ かた.る ・ かた.らう","word; speech; language"),
    ("西","セイ ・ サイ ・ ス ・ にし","west; Spain"),
    ("書","ショ ・ か.く ・ -が.き ・ -がき","write"),
    ("下","カ ・ ゲ ・ した ・ しも ・ もと ・ さ.げる ・ さ.がる ・ くだ.る ・ くだ.り ・ くだ.す ・ -くだ.す ・ くだ.さる ・ お.ろす ・ お.りる","below; down; descend; give; low; inferior"),
    ("後","ゴ ・ コウ ・ のち ・ うし.ろ ・ うしろ ・ あと ・ おく.れる","behind; back; later"),
    ("見","ケン ・ み.る ・ み.える ・ み.せる","see; hopes; chances; idea; opinion; look at; visible"),
    ("八","ハチ ・ や ・ や.つ ・ やっ.つ ・ よう","eight; eight radical (no. 12)"),
    ("南","ナン ・ ナ ・ みなみ","south")
]];

private func kanjiData(level : String, series : UInt) ->[(String,String,String)]{
    let data : NSArray = QuizData.kanjiCardsForLevel(level ?? "N5", andSeries: series ) ?? []
    var result : [(String,String,String)] = []
    typealias myData = (String,String,String)
    for val in data{
        let aData : myData = (val["kanji"] as! String,val["spells"] as! String,val["meanings"] as! String)
        result.append(aData)
        
    }
    return result;
}

public func generateProblems(quiz : Quiz) -> [Problem]{
    let data = kanjiData(quiz.level.rawValue,UInt(quiz.series))
    var problems : [Problem] = []
    let shuffleData : Array = shuffle(data)
    
    for (index,value) in enumerate(shuffleData){
        let kanji = value.0
        let meaning = pickData(value.2, .Meanings)
        let spell = pickData(value.1, .Spellings)
        var wrongs = shuffleData
        wrongs.removeAtIndex(index)
        let wrongData = pickWrongData(wrongs)
        let problem = Problem(kanjiSet: (kanji,(spell,wrongData.wrongSpells),(meaning,wrongData.wrongMeanings)))
        problems.append(problem)
    }

    return problems
}
public func setCurrentQuiz(aQuiz : Quiz!){
    QuizManager.sharedInstance.currentQuiz = aQuiz
}
public func getCurrentQuiz() -> Quiz?{
    return QuizManager.sharedInstance.currentQuiz
}

public func setupKii(){
    KiiLogic.setup()
}

public func userDisplayName() ->NSString{
    return KiiLogic.shared().userDisplayName()
}

public var currentProblemSet : (level: QuizLevel, series : Int)
{
  get
  {
    return (level : QuizManager.sharedInstance.selectedLevel,
      series : QuizManager.sharedInstance.selectedSeries)
  }
  set(setCurrentProblemSet)
  {
    
    QuizManager.sharedInstance.selectedLevel = setCurrentProblemSet.level
    QuizManager.sharedInstance.selectedSeries = setCurrentProblemSet.series
    QuizManager.sharedInstance.updateSharedProblemSet()
  }
}



