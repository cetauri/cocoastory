//
//  Created by cetauri on 12. 4. 24..
//
// To change the template use AppCode | Preferences | File Templates.
//

#define NSErrorLog(error) if(error)[NSException raise:[error localizedDescription] format:@"%@ ", NSStringFromSelector(_cmd)];
#import "CoreDataManager.h"
#import <objc/message.h>
//#import "Utils.h"

static CoreDataManager *_manager;

@interface CoreDataManager ()
-(void) deleteWithName:(NSString *)entityName;
@end

@implementation CoreDataManager {
    NSManagedObjectContext *context;
}

+ (CoreDataManager *)sharedInstance
{
    static dispatch_once_t pred;
    dispatch_once(&pred, ^{
        _manager = [[CoreDataManager alloc] init];
    });
    return _manager;
}

- (id) init{
    self = [super init];
    if (self){
        id<UIApplicationDelegate> delegate = [[UIApplication sharedApplication] delegate];
        SEL sel = @selector(managedObjectContext);
        if ([delegate respondsToSelector:sel]){
            context = objc_msgSend(delegate, sel);
        }else{
            [NSException raise:@"ImplementNotFound" format:@"managedObjectContext do not found in UIApplicationDelegate"];
        }
    }
    return self;
}

- (void) insert:(BaasioEntity *)entity
    entityName:(NSString *)entityName{

//    if ([NSStringFromClass([entity class]) isEqualToString:@"__NSCFDictionary"]){

    if ([entity isKindOfClass:[NSDictionary class]]){
        BaasioEntity *_entity = [[BaasioEntity alloc] init];
        [_entity set:(NSDictionary *)entity];
        entity = _entity;
    }
    [context lock];

    NSError *error;

    //delete
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:entityName
                                                         inManagedObjectContext:context];
    [request setEntity:entityDescription];

    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"uuid == %@", entity.uuid];
    [request setPredicate:predicate];

    NSArray *array = [context executeFetchRequest:request error:&error];
    NSErrorLog(error);

    BOOL willSave = false;
    NSString *modified = [NSString stringWithFormat:@"%i", entity.modified];
    // TODO : XXXX  문제 있음
//    NSLog(@"modified  : %@", entity.dictionary);
    if(array.count == 0){
        willSave = true;
    } else{
        for (NSManagedObject *object in array){
            if ([modified isEqualToString:[object valueForKey:@"modified"]]){
                //skip
            } else{
                [context deleteObject:object];
//                NSLog(@"deleteObject, %i, %@", modified, object.description);
                willSave = true;
            }
        }
    }

    if (willSave){
        //insert
        NSManagedObject *managedObject = [NSEntityDescription insertNewObjectForEntityForName:entityName
                                                                       inManagedObjectContext:context];
//        NSLog(@"saved entity.modified : %i\n\n", entity.modified);
        [managedObject setValue:entity.uuid forKey:@"uuid"];
        [managedObject setValue:modified forKey:@"modified"];
        [managedObject setValue:entity.dictionary forKey:@"object"];

        [context save:&error];
        NSErrorLog(error);
    }

    [context unlock];
}

- (void) inserts:(NSArray *)entities
      entityName:(NSString*)entityName{
    for (BaasioEntity *entity in entities){
        @autoreleasepool {
            [self insert:entity entityName:entityName];
        }
    }
}

- (void) delete:(NSString *)uuid{
    NSString *entityName = @"PlazaFeed";

    [context lock];

    NSError *error;
    @autoreleasepool {

        //delete
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        NSEntityDescription *entityDescription = [NSEntityDescription entityForName:entityName inManagedObjectContext:context];
        [request setEntity:entityDescription];

        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"id == %@", uuid];
        [request setPredicate:predicate];

        NSArray *array = [context executeFetchRequest:request error:&error];
        NSErrorLog(error);

        for (NSManagedObject *object in array){
            [context deleteObject:object];
        }
    }
    [context save:&error];
    [context unlock];
}

-(void) deleteWithName:(NSString *)entityName{

    [context lock];

    NSError *error;
    @autoreleasepool {

        //delete
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        NSEntityDescription *entityDescription = [NSEntityDescription entityForName:entityName inManagedObjectContext:context];
        [request setEntity:entityDescription];

        NSArray *array = [context executeFetchRequest:request error:&error];
        NSErrorLog(error);

        for (NSManagedObject *object in array){
            [context deleteObject:object];
        }
    }
    [context save:&error];
    [context unlock];
}

- (void) editPost:(NSString *)uuid
          entity:(BaasioEntity *)entity
      entityName:(NSString*)entityName {

    [context lock];

    NSError *error;
    @autoreleasepool {

        //delete
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        NSEntityDescription *entityDescription = [NSEntityDescription entityForName:entityName inManagedObjectContext:context];
        [request setEntity:entityDescription];

        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"id == %@", uuid];
        [request setPredicate:predicate];

        NSArray *array = [context executeFetchRequest:request error:&error];
        NSErrorLog(error);

        for (NSManagedObject *object in array){
            NSMutableDictionary *_object = [NSMutableDictionary dictionaryWithDictionary:[object valueForKey:@"object"]];
            [_object setValue:entity.dictionary forKey:@"object"];
        }
    }
    [context save:&error];
    [context unlock];
}
@end