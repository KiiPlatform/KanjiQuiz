//
//  QuizData.m
//  KanjiQuiz
//
//  Created by Syah Riza on 3/29/15.
//  Copyright (c) 2015 Kii. All rights reserved.
//

#import "QuizData.h"
#import <Realm/Realm.h>
#import "KanjiCard.h"

@interface RLMResults (Paging)
-(NSUInteger) totalSeries;
-(NSArray*) resultsForSeriesIndex:(NSUInteger) seriesIndex;
@end

@implementation RLMResults (Paging)
static const NSUInteger DEFAULT_SERIES_NUM = 8;

-(NSUInteger) totalSeries{
    NSUInteger result = self.count / DEFAULT_SERIES_NUM ;
    if (self.count % DEFAULT_SERIES_NUM > 0) {
        result++;
    }
    return result;
}
-(NSArray*) resultsForSeriesIndex:(NSUInteger) seriesIndex{
    if (seriesIndex<1&&seriesIndex>[self totalSeries]) {
        return @[];
    }
    NSMutableArray* result = [NSMutableArray array];
    NSUInteger end = (seriesIndex*DEFAULT_SERIES_NUM);
    NSUInteger start = ((seriesIndex - 1)*DEFAULT_SERIES_NUM);
    for (NSUInteger i = start; i < end; i ++) {
        if (i >= self.count) {
            break;
        }
        [result addObject:self[i]];
    }
    return result;
}

@end

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
+(NSUInteger) totalSeriesForLevel: (NSString*) level{
    RLMResults* cards = [KanjiCard objectsWhere:@"jlptLevel=%@",level];
    
    return [cards totalSeries];
}
+(NSArray*) kanjiCardsForLevel : (NSString*) level andSeries : (NSUInteger) seriesIndex{
    RLMResults* cards = [KanjiCard objectsWhere:@"jlptLevel=%@",level];
    NSMutableArray* results = [NSMutableArray array];
    for (KanjiCard* kanji in [cards resultsForSeriesIndex:seriesIndex]){
        NSMutableDictionary* dict = [NSMutableDictionary dictionary];
        dict[@"kanji"] = kanji.kanji;
        dict[@"spells"] = kanji.spells;
        dict[@"meanings"] = kanji.meanings;
        [results addObject:dict];
    }
    return results;
}
+(NSArray*) quizCatalog{
    static NSArray* catalog = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{

        catalog = @[@[@"N5",@([self totalSeriesForLevel:@"N5"])],
                 @[@"N4",@([self totalSeriesForLevel:@"N4"])],
                 @[@"N3",@([self totalSeriesForLevel:@"N3"])],
                 @[@"N2",@([self totalSeriesForLevel:@"N2"])],
                 @[@"N1",@([self totalSeriesForLevel:@"N1"])]
                 ];
    });
    return catalog;
}
@end
