//
//  Problem.swift
//  KanjiQuiz
//
//  Created by Syah Riza on 3/17/15.
//  Copyright (c) 2015 Kii. All rights reserved.
//

import UIKit

public class Problem: Serializable {
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
    init(dictionary: NSDictionary){
        self.kanji = String(dictionary["kanji"] as! NSString)
        
        self.spell = String(dictionary["spell"] as! NSString)
        self.meaning = String(dictionary["meaning"] as! NSString)
        let varAns = dictionary["variationAnswers"] as! NSArray

        let wrongSpells : NSArray = (varAns[0] as! NSDictionary)["spells"] as! NSArray
        let wrongMeanings : NSArray = (varAns[1] as! NSDictionary)["meanings"] as! NSArray
        self.variationsAnswer = ((wrongSpells[0] as! String,wrongSpells[1] as! String),(wrongMeanings[0] as! String,wrongMeanings[1] as! String))
        
    }
    public override func toDictionary() -> NSDictionary {
        let dict = super.toDictionary() as! NSMutableDictionary
        dict["variationAnswers"] = [
            ["spells":[variationsAnswer!.spells.0,variationsAnswer!.spells.1]],
            ["meanings":[variationsAnswer!.meanings.0,variationsAnswer!.meanings.1]]
        ]
        return dict
    }
    
}
