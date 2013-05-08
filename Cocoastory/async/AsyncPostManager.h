//
// Created by cetauri on 12. 7. 16..
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>


@interface AsyncPostManager : NSObject

+ (id)getSharedInstance;

- (void)putPost:(NSDictionary*)postData;
- (NSMutableDictionary *)popOldestPost;
- (void)removeOldestPost;
- (void)removeAllPost;
- (int)queueCount;

- (void)startThread;
@end