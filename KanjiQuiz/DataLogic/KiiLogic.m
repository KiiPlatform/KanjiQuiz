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
                            if (currentUser && currentUser.displayName) {
                              
                              [keychain update:@"displayName"
                                              :[currentUser.displayName dataUsingEncoding:NSUTF8StringEncoding]];
                            }
                          }];
  }else{
      [Kii setLogLevel:3];
      KiiUser* currentUser = [KiiUser registerAsPseudoUserSynchronousWithUserFields:[[KiiUserFields alloc] init]

                                                                              error:&error];
      if (currentUser) {
          [keychain insert:ACCESS_TOKEN_KEY
                          :[currentUser.accessToken dataUsingEncoding:NSUTF8StringEncoding]];
          [keychain insert:@"displayName"
                          :[@"Player 1" dataUsingEncoding:NSUTF8StringEncoding]];

      }

    
  }
  
  return error==nil;
}
-(void) loginWithGameKitId:(NSString*) playerId andDisplayName:(NSString*) displayName{
    
    NSString* username = [@"user" stringByAppendingString:[playerId stringByReplacingOccurrencesOfString:@":" withString:@"_"]];
    NSString* password = [@"password" stringByAppendingString:playerId];
    
    [KiiUser findUserByUsername:username
                      withBlock:^(KiiUser *user, NSError *error) {
                          
        if (user) {
            [KiiUser logOut];
            
            [KiiUser authenticate:username
                     withPassword:password
                         andBlock:^(KiiUser *loggeduser, NSError *error) {
                             if (!error) {
                                 Keychain * keychain =[[Keychain alloc] initWithService:SERVICE_NAME withGroup:nil];
                                 [keychain update:ACCESS_TOKEN_KEY
                                                 :[loggeduser.accessToken dataUsingEncoding:NSUTF8StringEncoding]];
                                 if (displayName) {
                                     loggeduser.displayName = displayName;
                                     [loggeduser saveWithBlock:^(KiiUser *user, NSError *error) {
                                         
                                     }];
                                     [keychain update:@"displayName"
                                                     :[displayName dataUsingEncoding:NSUTF8StringEncoding]];
                                     
                                 }

                             }
                
            }];
        }else if([KiiUser currentUser] && [KiiUser currentUser].isPseudoUser){
            KiiIdentityDataBuilder *builder = [[KiiIdentityDataBuilder alloc] init];
            builder.userName = username;
            KiiUserFields* userFields = [[KiiUserFields alloc] init];
            
            [[KiiUser currentUser] putIdentityData:[builder build]
                                        userFields:userFields
                                          password:password
                                             block:^(KiiUser *loggeduser, NSError *error) {
                                                 if (!error) {
                                                     Keychain * keychain =[[Keychain alloc] initWithService:SERVICE_NAME withGroup:nil];
                                                     
                                                     if (displayName) {
                                                         loggeduser.displayName = displayName;
                                                         [loggeduser saveWithBlock:^(KiiUser *user, NSError *error) {
                                                             
                                                         }];
                                                         [keychain update:@"displayName"
                                                                         :[displayName dataUsingEncoding:NSUTF8StringEncoding]];
                                                         
                                                     }
                                                 }
                
            }];
        }
    }];
    
}
-(void) setUserDisplayName:(NSString*) displayName{
    if ([KiiUser currentUser] && displayName && ![@"" isEqualToString:displayName]) {
        [KiiUser currentUser].displayName = displayName;
    }
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
    return displayName ? displayName : @"User 1";
}
-(void) saveQuizToCloud:(NSDictionary*) dict
           totalProblem:(int) total
               answered:(int) answered
                correct:(int) correct{
  
  KiiUser* user = [KiiUser currentUser];
  if (!user || !dict || !dict[@"level"] || !dict[@"type"]) {
    return;
  }
  
  KiiObject* quizobject= [[user bucketWithName:dict[@"level"]] createObject];
  [quizobject setObject:@(total) forKey:@"total"];
  [quizobject setObject:@(answered) forKey:@"answered"];
  [quizobject setObject:@(correct) forKey:@"correct"];
  [quizobject setObject:dict[@"type"] forKey:@"type"];

  if (dict[@"series"]){
    [quizobject setObject:dict[@"series"] forKey:@"series"];
  }
  
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
        [object uploadBodyWithData:json
                    andContentType:@"application/json"
                     andCompletion:^(KiiObject *obj, NSError *error) {
          if (error) {
            NSLog(@"Upload body failed :%@", error.description);
          }
        }];
      }
      
    }
  }];
}
@end
