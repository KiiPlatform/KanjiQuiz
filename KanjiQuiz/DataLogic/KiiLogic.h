//
//  KiiLogic.h
//  KanjiQuiz
//
//  Created by Syah Riza on 3/23/15.
//  Copyright (c) 2015 Kii. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface KiiLogic : NSObject
+(void) setup;
+(instancetype) shared;
-(BOOL) login;
-(NSString*) userDisplayName;
-(void) saveQuizToCloud:(NSDictionary*) dict
           totalProblem:(int) total
               answered:(int) answered
                correct:(int) correct;
@end
