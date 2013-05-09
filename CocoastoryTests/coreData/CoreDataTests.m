//
//  CoreDataTests.m
//  Cocoastory
//
//  Created by cetauri on 13. 5. 9..
//  Copyright (c) 2013년 KT. All rights reserved.
//

#import "CoreDataTests.h"
#import "AppDelegate.h"
#import "CoreDataManager.h"
@implementation CoreDataTests


- (void)setUp
{
    [super setUp];

    AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    context = [delegate managedObjectContext];
    STAssertNotNil(context, @"Fail to find NSManagedObjectContext ", nil);

    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"Timeline"
                                                         inManagedObjectContext:context];
    request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDescription];
}

- (void)tearDown
{
    // Tear-down code here.
    [super tearDown];
}
- (void)testCase{
//    [self testDeleteAll];
//    [self testInsert];
//    [self testSelectCount];
//    [self testSelectAll];
//    [self testUpdateAll];
//    [self testInsert];
//    [self testSelect];
//    [self testDelete];
}

-(void) testInsert
{
    BaasioEntity *entity = [BaasioEntity entitytWithName:@"Timeline"];
    entity.uuid = @"12345";
    [entity setObject:[NSDate date] forKey:@"modified"];
    [entity setObject:@"test" forKey:@"type"];

    [[CoreDataManager sharedInstance] insert:entity entityName:@"Timeline"];

}

-(void) testSelectCount
{
    NSError *error;
    int count =  [context countForFetchRequest:request error:&error];

    NSLog(@"%@, count : %i", NSStringFromSelector(_cmd ), count) ;
    STAssertTrue(count > 0, @"%@", NSStringFromSelector(_cmd ));
}
//
-(void) testSelectAll
{
    NSError *error;
    NSArray *array = [context executeFetchRequest:request error:&error];
    for (NSManagedObject *object in array){
        NSLog(@"object : %@", object.description);
    }

    NSLog(@"%@, count : %i", NSStringFromSelector(_cmd ), [array count]) ;
    STAssertTrue([array count] > 0, @"%@", NSStringFromSelector(_cmd ));
}
//
////http://developer.apple.com/library/mac/#documentation/cocoa/conceptual/Predicates/Articles/pCreating.html#//apple_ref/doc/uid/TP40001793-CJBDBHCB
//-(void) testSelect
//{
//    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"title == %@", @"title"];
////    NSLog(@"predicate : %@", [predicate predicateFormat]);
//    [request setPredicate:predicate];
//    NSError *error;
//    NSArray *array = [context executeFetchRequest:request error:&error];
//
//    for (NSManagedObject *object in array){
//        NSLog(@"title : %@", [object valueForKey:@"title"]) ;
//        NSLog(@"name : %@", [object valueForKey:@"name"]) ;
//        NSLog(@"date : %@", [object valueForKey:@"date"]) ;
//    }
//
//    NSLog(@"%@, count : %i", NSStringFromSelector(_cmd ), [array count]) ;
//    STAssertTrue([array count] > 0, @"%@", NSStringFromSelector(_cmd ));
//}
//
//
//-(void) testDelete
//{
//    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"title == %@", @"title"];
//    [request setPredicate:predicate];
//    NSError *error;
//    NSArray *array = [context executeFetchRequest:request error:&error];
//
//    for (NSManagedObject *object in array){
//        [context deleteObject:object];
//    }
//    [context save:&error];
//
//    NSLog(@"%@, count : %i", NSStringFromSelector(_cmd ), [array count]) ;
////    STAssertTrue([array count] > 0, @"%@", NSStringFromSelector(_cmd ));
//}
//
-(void) testDeleteAll
{
    NSError *error;
    NSArray *array = [context executeFetchRequest:request error:&error];
    for (NSManagedObject *object in array){
        [context deleteObject:object];
    }
    [context save:&error];

    NSLog(@"%@, count : %i", NSStringFromSelector(_cmd ), [array count]) ;
}
//
//
//-(void) testUpdateAll
//{
//
//    NSError *error;
//    NSMutableArray *array = [context executeFetchRequest:request error:&error];
//    for (NSManagedObject *object in array){
//        [object setValue:@"updated text" forKey:@"title"];
//    }
//    [context save:&error];
//
//    NSLog(@"%@, count : %i", NSStringFromSelector(_cmd ), [array count]) ;
//}

@end
