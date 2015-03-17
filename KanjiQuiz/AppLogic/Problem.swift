//
//  Problem.swift
//  KanjiQuiz
//
//  Created by Syah Riza on 3/17/15.
//  Copyright (c) 2015 Kii. All rights reserved.
//

import UIKit

public class Problem: NSObject {
    private(set) public var kanji : String?
    private(set) public var spell : String?
    private(set) public var meaning : String?
    private(set) public var variationsAnswer : (spells:(String,String),meanings:(String,String))?
    
    init(kanjiSet: (kanji :String,
        spells: (String,wrong: (String,String)) ,
        meanings: (String,wrong:(String,String)))){
        self.kanji = kanjiSet.kanji
        self.spell = kanjiSet.spells.0
        self.meaning = kanjiSet.meanings.0
        self.variationsAnswer = (kanjiSet.spells.wrong,kanjiSet.meanings.wrong)
        
    }
}
