//
// Created by cetauri on 12. 7. 16..
//
// To change the template use AppCode | Preferences | File Templates.
//

#import "AsyncPostManager.h"
#import <baas.io/Baas.h>
//#import "Utils.h"
#import "PersistenceQueue.h"

//static AsyncPostManager *_manager;
//@implementation AsyncPostManager {
//    UIBackgroundTaskIdentifier bgTask;
//
//    NSThread *thread;
//    PersistenceQueue* queue;
//    NSCondition *beforeWorkCondition;
//    NSCondition *afterWorkCondition;
//    BOOL *isFinish;
//    NSObject *lock;
//}
//
//+ (AsyncPostManager *)getSharedInstance
//{
//    static dispatch_once_t pred;
//    dispatch_once(&pred, ^{
//        _manager = [[AsyncPostManager alloc] init];
//    });
//    return _manager;
//}
//
//-(id)init {
//    self = [super init];
//    if (self){
//        queue = [PersistenceQueue getSharedInstance];
//        beforeWorkCondition = [[NSCondition alloc] init];
//        afterWorkCondition = [[NSCondition alloc] init];
//        lock = [[NSObject alloc]init];
//    }
//    
//    return self;
//}
//
//#pragma mark for Queue
//
//-(void)putPost:(NSDictionary*)postData{
//    @synchronized (lock) {
//
//        CFUUIDRef uuid = CFUUIDCreate(kCFAllocatorDefault);
//        NSString *UUID = (__bridge NSString *)CFUUIDCreateString(kCFAllocatorDefault, uuid);
//
//        //광장
//        NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithDictionary:postData];
//        [dictionary setObject:UUID forKey:@"localID"];
//
//        if (![[postData objectForKey:@"acl"] isEqualToString:@"private"])  {
//            [PersistentManager insertAtNearBy:@[[self reArrangePostData:dictionary]]];
//        }
//
//        [queue push:dictionary];
//        [beforeWorkCondition signal];
//    }
//}
//
//-(void)removeOldestPost {
//    @synchronized (lock) {
//        if (self.queueCount != 0) {
//            NSLog(@"--------------- delete");
//            [queue removeOldest];
//        }
//    }
//}
//
//-(void)removeAllPost{
//    @synchronized (lock) {
//        [queue removeAll];
//    }
//}
//
//-(NSMutableDictionary *)popOldestPost {
//    @synchronized (lock) {
//        return (NSMutableDictionary *)[queue pop];
//    }
//}
//-(int)queueCount{
//    return queue.count;
//}
//#pragma mark for Thread
//- (void)startThread{
//    thread = [[NSThread alloc] initWithTarget:self
//                                     selector:@selector(run:)
//                                       object:nil];
//    [thread setThreadPriority:0.7];
//    [thread start];
//    NSLog(@"AsyncPostManager startThread");
//}
//
//- (void)run:(id)sender
//{
//    NSLog(@"%@", NSStringFromSelector(_cmd));
//    bgTask = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:NULL];
//
//    while (true) {
//        if (isFinish) break;
//        if (queue.count == 0) {
//            NSLog(@"AsyncPostManager sleep");
//            [beforeWorkCondition waitingLock];
//
//            NSLog(@"AsyncPostManager awake");
//            continue;
//        }
//
//        @autoreleasepool {
//
//            NSLog(@"-- task start");
//
//            NSMutableDictionary *dictionary = [self popOldestPost];
//            if (dictionary == nil) continue;
//
//            NSArray *pics = [dictionary objectForKey:@"pics"];
////            NSLog(@"pics : %i", pics.count);
//            if (pics.count != 0){
//                NSFileManager *fileManager = [NSFileManager defaultManager] ;
//                for (NSString *file in pics){
////                    NSLog(@"[fileManager fileExistsAtPath:file] : %i", [fileManager fileExistsAtPath:file]);
//
//                    //파일 생성시까지 기다림
//                    while (true){
//                        if([fileManager fileExistsAtPath:file]){
//                            break;
//                        }
//                        [NSThread sleepForTimeInterval:1];
//                    }
//                }
//            }
//            // image upload
//            {
//                NSArray *images = [dictionary objectForKey:@"_images"];
//                for (int i = [images count]; i < pics.count; i++) {
//                    if (i == pics.count) {
//                        continue;
//                    }
//                    NSData *data = [NSData dataWithContentsOfFile:[pics objectAtIndex:i]];
//                    NSDictionary *dict = [NSDictionary dictionaryWithObject:data forKey:PUT_DATA_FIELD];
//                    [NetworkManager uploadImage:dict delegate:self];
//
//                    [afterWorkCondition waitingLock];
//                }
//            }
//
//            //아이디가 없다면 아이디를 가져옴
//            if ([dictionary objectForKey:@"_id"] == nil){
//                [NetworkManager getPostTicket:self];
//                [afterWorkCondition waitingLock];
//            }
//
//            // posting
//            {
//                NSArray *_images = [dictionary objectForKey:@"_images"];
//                for (int i = 0; i < _images.count; i++) {
//                    [dictionary setObject:[_images objectAtIndex:i] forKey:[NSString stringWithFormat:@"pics[%i]", i]];
//                }
//
//                //필요 없는 images 객체들은 비운다.
//                [dictionary removeObjectForKey:@"_images"];
//                [dictionary removeObjectForKey:@"pics"];
////                NSLog(@"createPost dictionary : %@", dictionary.description);
//                [NetworkManager createPost:dictionary delegate:self];
//            }
//
//            [afterWorkCondition waitingLock];
//
//        }
//    }
//}
//
//#pragma mark ASIRequest Delegation
//- (void)requestDoneWithSuccess:(id)sender{
//    NSLog(@"%@", NSStringFromSelector(_cmd));
//
//    ASIHTTPRequest* request = (ASIHTTPRequest*)sender;
//    NSString *method = request.requestMethod;
//
//    if ([method isEqualToString:@"GET"]){
//        NSDictionary *response = [request.responseString objectFromJSONString];
//        NSString *ticketID = [[response objectForKey:@"post"] objectForKey:@"_id"];
//
//        if (![ticketID isEqualToString:@""]) {
//
//            NSLog(@"ticketID : %@", ticketID );
//
//            NSMutableDictionary *dictionary = [self  popOldestPost];
//            [dictionary setObject:ticketID forKey:@"_id"];
//            [queue snapshotSave];
//
////            NSLog(@"after ticket : [self popOldestPost] : %@", [self popOldestPost].description);
//        }
//
//    } else if ([method isEqualToString:@"POST"]){
//
//        NSString *localID = [[self popOldestPost] objectForKey:@"localID"];
//        [PersistentManager deletePostWithLocalID:localID];
//
//        NSDictionary *dictionary = [request.responseString objectFromJSONString];
//        [PersistentManager insertAtNearBy:@[[dictionary objectForKey:@"post"]]];
//
//        [self removeOldestPost];
//
//    } else if ([method isEqualToString:@"PUT"]){
//        NSDictionary *result = [request.responseString objectFromJSONString];
//        NSString *fileid = [result objectForKey:@"fileid"];
//        NSLog(@"image fileid ; %@", fileid);
//
//        if ( fileid.length > 0 ) {
//            NSMutableDictionary *dictionary = [self popOldestPost];
//            NSMutableArray *pics = [NSMutableArray arrayWithArray:[dictionary objectForKey:@"_images"]];
//            [pics addObject:fileid];
//            [dictionary setObject:pics forKey:@"_images"];
//
//            //queue 갱신
//            [queue snapshotSave];
////            NSLog(@"after save : [self popOldestPost] : %@", [self popOldestPost].description);
//        }
//    }
//
//    [afterWorkCondition signal];
//}
//- (void)requestDoneWithFail:(id)sender{
//    ASIHTTPRequest* request = (ASIHTTPRequest*)sender;
//    NSLog(@"%@ : %@", NSStringFromSelector(_cmd), [sender description]);
//
//    NSString *method = request.requestMethod;
//    // 실패 하지만 잠시 후 재시도
//    if ([method isEqualToString:@"GET"]){
//        [NSThread sleepForTimeInterval:5];
//    } else if ([method isEqualToString:@"POST"]){
//        [NSThread sleepForTimeInterval:60 * 5];
//    } else if ([method isEqualToString:@"PUT"]){
//        [NSThread sleepForTimeInterval:60 * 1];
//    }
//    [afterWorkCondition signal];
//}
//
//#pragma mark for data
//
//-(NSMutableDictionary *)reArrangePostData:(NSDictionary*)postData{
//
//    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:postData];
//
//    //location
//    NSArray *location = @[[dic objectForKey:@"location[0]"], [dic objectForKey:@"location[1]"]];
//    [dic setObject:location forKey:@"location"];
//
//    //user
//    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
//    NSDictionary *user = @{
//                            @"_id" : [userDefaults objectForKey:@"my_userid"],
//                            @"login_id" : [userDefaults objectForKey:@"login_id"],
//                            @"name" : [userDefaults objectForKey:@"my_name"],
//                            @"profile" : @""//todo profile 이미지 처리 해야 함
//                            // [userDefaults objectForKey:@"profile"]
//                         };
//    [dic setObject:user forKey:@"user"];
//
//    //place
//    NSDictionary *place = @{
//                            @"_id": [dic objectForKey:@"place_id"],
//                            //todo category 처리 해야 함
////                            @"category_title": [dic objectForKey:@"category_title"],
////                            @"category_key": [dic objectForKey:@"category_key"],
//                            @"address": [dic objectForKey:@"address"],
//                            @"title": [dic objectForKey:@"title"]
//                           };
//    [dic setObject:place forKey:@"place"];
//
//
//    [dic removeObjectsForKeys:@[
//                                @"location[0]", @"location[1]",
//                                @"place_id", @"category_title", @"category_key", @"address", @"title"]
//                              ];
//    return dic;
//}
//
//- (void)dealloc {
//    [[UIApplication sharedApplication] endBackgroundTask:bgTask];
//}


#pragma mark -
#pragma mark NSCondition+Custom
@interface NSCondition(Custom)
- (void)waitingLock;
@end

@implementation NSCondition(Custom)
- (void)waitingLock {
    [self lock];
    [self wait];
    [self unlock];
}

@end