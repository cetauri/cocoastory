//
//  CoreDataTests.h
//  Cocoastory
//
//  Created by cetauri on 13. 5. 9..
//  Copyright (c) 2013년 KT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SenTestingKit/SenTestingKit.h>

@interface CoreDataTests : SenTestCase{
    NSManagedObjectContext *context;
    NSFetchRequest *request ;
}

@end
