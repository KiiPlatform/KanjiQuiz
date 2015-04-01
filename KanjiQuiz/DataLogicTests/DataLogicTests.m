//
//  DataLogicTests.m
//  DataLogicTests
//
//  Created by Syah Riza on 3/23/15.
//  Copyright (c) 2015 Kii. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "QuizData.h"
#import "KanjiCard.h"

@interface DataLogicTests : XCTestCase

@end

@implementation DataLogicTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testPopulateKanji {
    
    
//    RLMRealm *realm = [RLMRealm realmWithPath:@"/Users/syahriza/Documents/tutorials/kanjiquiz/kanji.realm"];
//    [realm beginWriteTransaction];
//    NSArray* files = @[@"N1.json",@"N2.json",@"N3.json",@"N4.json",@"N5.json"];
//    for(NSString* filename in files){
//        NSString *filePath = [[[NSBundle bundleForClass:[self class]] resourcePath] stringByAppendingPathComponent:filename];
//        NSError* error = nil;
//        NSArray* n5=[NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:filePath] options:NSJSONReadingAllowFragments error:&error];
//        for(NSDictionary* kanjiDict in n5){
//            KanjiCard* kanji =[[KanjiCard alloc] init];
//            kanji.kanji = kanjiDict[@"kanji"];
//            kanji.spells = kanjiDict[@"spells"];
//            kanji.meanings = kanjiDict[@"meanings"];
//            kanji.jlptLevel = [filename substringToIndex:2];
//            [realm addObject:kanji];
//        }
//    }
//    [realm commitWriteTransaction];
    // This is an example of a functional test case.
    
    NSString *filePath = [[[NSBundle bundleForClass:[self class]] resourcePath] stringByAppendingPathComponent:@"kanji.realm"];
    RLMRealm *realm = [RLMRealm realmWithPath:filePath];
    RLMResults* allKanji = [KanjiCard objectsInRealm:realm where:@"jlptLevel='N5'"];
    NSLog(@"%lu",allKanji.count);
    
}

-(void) testKanji{
    NSString *filePath = [[[NSBundle bundleForClass:[self class]] resourcePath] stringByAppendingPathComponent:@"kanji.realm"];
    [RLMRealm setDefaultRealmPath:filePath];
    
    NSUInteger total =[QuizData totalSeriesForLevel:@"N5"];
    NSLog(@"Total : %lu",total);
    
    for (NSDictionary* dict in [QuizData kanjiCardsForLevel:@"N5" andSeries:10]){
        NSLog(@"%@",dict);
    }
    
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
