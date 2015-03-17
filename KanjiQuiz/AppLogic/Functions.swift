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

func generateProblems(quiz : Quiz) -> [Problem]{
    
    return []
}