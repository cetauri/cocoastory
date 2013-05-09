//
//  Created by cetauri on 12. 4. 24..
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
@interface CoreDataManager : NSObject

+ (CoreDataManager *)sharedInstance;

- (void) insert:(BaasioEntity *)entity
    entityName:(NSString*)entityName;
- (void) inserts:(NSArray *)entities
     entityName:(NSString*)entityName;

- (void) delete:(NSString *)uuid;
- (void) deleteWithName:(NSString *)entityName;

- (void) editPost:(NSString *)uuid
           entity:(BaasioEntity *)entity
      entityName:(NSString*)entityName;
@end