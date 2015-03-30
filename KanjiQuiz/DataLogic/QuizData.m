//
//  QuizData.m
//  KanjiQuiz
//
//  Created by Syah Riza on 3/29/15.
//  Copyright (c) 2015 Kii. All rights reserved.
//

#import "QuizData.h"
#import <Realm/Realm.h>

@implementation QuizData
+(void) setup{

    [RLMRealm setDefaultRealmPath:[[[NSFileManager defaultManager] containerURLForSecurityApplicationGroupIdentifier:@"group.kanjiquiz"] URLByAppendingPathComponent:@"kanjiquiz.realm"].path];
}
+(void) setupData:(NSString*) defaultPath{
    if (![self isDataAvailable]) {
        NSError* error = nil;
        NSString* path = [[[NSFileManager defaultManager] containerURLForSecurityApplicationGroupIdentifier:@"group.kanjiquiz"] URLByAppendingPathComponent:@"kanjiquiz.realm"].path ;
        [[NSFileManager defaultManager] copyItemAtPath:defaultPath toPath:path error:&error];
         
    }
    [RLMRealm setDefaultRealmPath:[[[NSFileManager defaultManager] containerURLForSecurityApplicationGroupIdentifier:@"group.kanjiquiz"] URLByAppendingPathComponent:@"kanjiquiz.realm"].path];
}
+(BOOL)isDataAvailable {
   NSString* path = [[[NSFileManager defaultManager] containerURLForSecurityApplicationGroupIdentifier:@"group.kanjiquiz"] URLByAppendingPathComponent:@"kanjiquiz.realm"].path ;
    
    return [[NSFileManager defaultManager] fileExistsAtPath:path];
}
@end
