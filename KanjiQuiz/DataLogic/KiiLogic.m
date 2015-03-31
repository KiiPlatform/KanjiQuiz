//
//  KiiLogic.m
//  KanjiQuiz
//
//  Created by Syah Riza on 3/23/15.
//  Copyright (c) 2015 Kii. All rights reserved.
//

#import "KiiLogic.h"
#import <KiiSDK/Kii.h>
#import "Keychain.h"
#define SERVICE_NAME @"KiiService"
#define ACCESS_TOKEN_KEY @"access_token"

@implementation KiiLogic
+(instancetype) shared{
    static KiiLogic* instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[KiiLogic alloc] init];
        [Kii beginWithID:@"app_id" andKey:@"app_key" andSite:kiiSiteJP];
    });
    return instance;
}
+(void) setup{
    [[KiiLogic shared] login];
}
-(BOOL) login{
    NSError* error = nil;
    Keychain * keychain =[[Keychain alloc] initWithService:SERVICE_NAME withGroup:nil];
    NSData* accessToken=[keychain find:ACCESS_TOKEN_KEY];
    if(accessToken){
        [KiiUser authenticateWithToken:[NSString stringWithUTF8String:accessToken.bytes]
                              andBlock:^(KiiUser *currentUser, NSError *error) {
                                  if (currentUser) {
                                      
                                      [keychain update:@"displayName"
                                                      :[currentUser.displayName dataUsingEncoding:NSUTF8StringEncoding]];
                                  }
                              }];
    }else{
        KiiUser* currentUser = [KiiUser authenticateSynchronous:@"watchuser"
                                                   withPassword:@"kii12345"
                                                       andError:&error];
        [keychain insert:ACCESS_TOKEN_KEY
                        :[currentUser.accessToken dataUsingEncoding:NSUTF8StringEncoding]];
        [keychain insert:@"displayName"
                        :[currentUser.displayName dataUsingEncoding:NSUTF8StringEncoding]];
        
    }
    
    return error==nil;
}
-(NSString*) userDisplayName{
    NSString* displayName = nil;
    if ([KiiUser currentUser]) {
        displayName=[KiiUser currentUser].displayName;
    }else{
        Keychain * keychain =[[Keychain alloc] initWithService:SERVICE_NAME withGroup:nil];
        NSData* data=[keychain find:@"displayName"];
        if (data) {
            displayName=[NSString stringWithUTF8String:data.bytes];
        }
    }
    return displayName;
}
-(void) saveQuizToCloud:(NSDictionary*) dict
           totalProblem:(int) total
               answered:(int) answered
                correct:(int) correct{
    
    KiiUser* user = [KiiUser currentUser];
    if (!user || !dict || !dict[@"level"]) {
        return;
    }
    
    KiiObject* quizobject= [[user bucketWithName:dict[@"level"]] createObject];
    [quizobject setObject:@(total) forKey:@"total"];
    [quizobject setObject:@(answered) forKey:@"answered"];
    [quizobject setObject:@(correct) forKey:@"correct"];
    
    [quizobject saveWithBlock:^(KiiObject *object, NSError *error) {
        if (object) {
            if (error) {
                NSLog(@"save failed :%@", error.description);
                return;
            }
            
            NSError* jsonError = nil;
            NSData* json =[NSJSONSerialization dataWithJSONObject:dict
                                                          options:NSJSONWritingPrettyPrinted
                                                            error:&jsonError];
            
            if (json) {
                [object uploadBodyWithData:json andContentType:@"application/json" andCompletion:^(KiiObject *obj, NSError *error) {
                    if (error) {
                        NSLog(@"Upload body failed :%@", error.description);
                    }
                }];
            }
            
        }
    }];
}
@end
