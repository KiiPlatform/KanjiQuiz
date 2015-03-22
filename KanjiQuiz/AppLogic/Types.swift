//
//  Types.swift
//  KanjiQuiz
//
//  Created by Syah Riza on 3/17/15.
//  Copyright (c) 2015 Kii. All rights reserved.
//

import UIKit

public enum KanjiField{
    case Char, Meanings, Spellings, Level
}

public enum QuizType : String{
    case Spelling = "Spelling"
    case Meaning = "Meaning"
    
}

public enum QuizLevel{
    case N1,N2,N3,N4,N5
}
