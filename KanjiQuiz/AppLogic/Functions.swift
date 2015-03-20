//
//  Functions.swift
//  KanjiQuiz
//
//  Created by Syah Riza on 3/17/15.
//  Copyright (c) 2015 Kii. All rights reserved.
//

import UIKit

public func shuffle<C: MutableCollectionType where C.Index == Int>(var list: C) -> C {
    let count = countElements(list)
    for i in 0..<(count - 1) {
        let j = Int(arc4random_uniform(UInt32(count - i))) + i
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

public func generateProblems(quiz : Quiz) -> [Problem]{
    let data = dummyKanjiData[quiz.level]
    var problems : [Problem] = []
    let shuffleData : Array = shuffle(data!)
    
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





