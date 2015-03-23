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
@end
