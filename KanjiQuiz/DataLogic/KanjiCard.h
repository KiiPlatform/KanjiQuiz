//
//  KanjiCard.h
//  KanjiQuiz
//
//  Created by Syah Riza on 3/29/15.
//  Copyright (c) 2015 Kii. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Realm/Realm.h>

@interface KanjiCard : RLMObject

@property NSString* kanji;
@property NSString* spells;
@property NSString* meanings;
@property NSString* jlptLevel;
@end
