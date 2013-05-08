//
//  AsyncPostManagerTests.m
//  imin-ios
//
//  Created by cetauri on 07/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AsyncPostManagerTests.h"
#import "AsyncPostManager.h"
#import "TestSemaphor.h"

@implementation AsyncPostManagerTests

-(void) setUp{
    
}
//
//-(void) testQeueue{
//    AsyncPostManager *manager = [AsyncPostManager getSharedInstance];
//    [manager startThread];
//
//    NSDictionary *dictionary = @{@"key":@"1"};
//    [manager putPost:dictionary];
//
//    dictionary = @{@"key":@"2"};;
//    [manager putPost:dictionary];
//
//    dictionary = @{@"key":@"3"};;
//    [manager putPost:dictionary];
//
//    dictionary = @{@"key":@"4"};;
//    [manager putPost:dictionary];
//
//    dictionary = @{@"key":@"5"};;
//    [manager putPost:dictionary];
//
//    dictionary = @{@"key":@"6"};;
//    [manager putPost:dictionary];
//
//    [NSThread sleepForTimeInterval:15];
//
//}
//-(void) testBaseic{
//    AsyncPostManager *manager = [AsyncPostManager getSharedInstance];
//    [manager deleteAllPost];
//    NSDictionary *dictionary = @{@"key":@"1"};
//    [manager putPost:dictionary];
//
//    dictionary = @{@"key":@"2"};;
//    [manager putPost:dictionary];
//
//    dictionary = [manager popOldestPost];
//    STAssertEqualObjects([dictionary objectForKey:@"key"], @"1",nil);
//    [manager deleteOldestPost];
//
//    dictionary = [manager popOldestPost];
//    STAssertEqualObjects([dictionary objectForKey:@"key"], @"2",nil);
//    [manager deleteOldestPost];
//}
@end
