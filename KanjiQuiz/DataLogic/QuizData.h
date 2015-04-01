//
//  QuizData.h
//  KanjiQuiz
//
//  Created by Syah Riza on 3/29/15.
//  Copyright (c) 2015 Kii. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QuizData : NSObject
+(void)setup;
+(void) setupData:(NSString*) defaultPath;
+(NSUInteger) totalSeriesForLevel: (NSString*) level;
+(NSArray*) kanjiCardsForLevel : (NSString*) level andSeries : (NSUInteger) seriesIndex;
@end
