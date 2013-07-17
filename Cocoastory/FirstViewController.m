//
// Created by cetauri on 13. 5. 9..
//
// To change the template use AppCode | Preferences | File Templates.
//

#import "FirstViewController.h"
#import "AppDelegate.h"
#import "CoreDataManager.h"
//#import <baas.io/Baas.h>
@implementation FirstViewController {

    NSFetchedResultsController *fetchedResultsController;
    NSManagedObjectContext *managedObjectContext;

    UITableView *_tableView;
//    NSMutableArray *_array;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
//        self.title = @"Bropbox";
//        self.tabBarItem.image = [UIImage imageNamed:@"dropbox.png"];

        CGRect frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 49  - 44);
        _tableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.allowsSelection = NO;
        [self.view addSubview:_tableView];
    }
    return self;
}
- (void)loadView {
    [super loadView];

    NSError *error = nil;
    if (![[self fetchedResultsController] performFetch:&error]) {
        /*
            Replace this implementation with code to handle the error appropriately.
            abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
        */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }

//    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
//    [dictionary setValue:@"126.92359" forKey:@"lon"];
//    [dictionary setValue:@"37.49256" forKey:@"lat"];
//    [dictionary setValue:[Utils utcStringFromDate:[NSDate date]] forKey:@"before_at"];
//    [dictionary setValue:[NSString stringWithFormat:@"%d",TIMELINE_LIMIT] forKey:@"limit"];
//
//    id request = [[DataManager getSharedInstance] nearby:dictionary
//                                                 success:^(NSDictionary *result){
//                                                     [PersistentManager deleteAllPosts];
//                                                 }
//                                                 failure:^(NSError *error){
//
//                                                 }];
//    [requests addObject:request];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(contextChanged:)
                                                 name:NSManagedObjectContextDidSaveNotification
                                               object:nil];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    BaasioQuery *query = [BaasioQuery queryWithCollection:@"timeline"];
    [query setWheres:[NSString stringWithFormat:@"user = %@" ,[BaasioUser currentUser].uuid]];
    [query queryInBackground:^(NSArray *array){
        [[CoreDataManager sharedInstance] inserts:array entityName:@"Timeline"];
        [_tableView reloadData];;
    }
    failureBlock:nil];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%@", NSStringFromSelector(_cmd));
//    AppDelegate *delegate =  (AppDelegate *)[UIApplication sharedApplication].delegate;
//    [delegate.tabBarController setSelectedIndex:1];
//
//    UINavigationController *viewControllers = (UINavigationController *)[delegate.tabBarController selectedViewController];
//    DownloadViewController *downloadViewController  = [viewControllers.viewControllers objectAtIndex:0];
//    [downloadViewController download:_array[indexPath.row]];
}
//
//- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return UITableViewCellEditingStyleDelete;
//}
//
//- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
//{
//
//    NSDictionary *dic = _array[indexPath.row] ;
//    BaasioFile *file = [[BaasioFile alloc]init];
//    file.uuid = [dic objectForKey:@"uuid"];
//    [file deleteInBackground:^(void){
//
//        [_tableView beginUpdates];
//        [_tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
//        [_array removeObjectAtIndex:indexPath.row];
//        [_tableView endUpdates];
//        [_tableView reloadData];
//
//    }
//                failureBlock:^(NSError *error){
//                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"실패하였습니다.\n다시 시도해주세요."
//                                                                        message:error.localizedDescription
//                                                                       delegate:nil
//                                                              cancelButtonTitle:@"OK"
//                                                              otherButtonTitles:nil];
//                    [alertView show];
//                }];
//
//}

//- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return YES;
//}
#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    id <NSFetchedResultsSectionInfo> sectionInfo = [[fetchedResultsController sections] objectAtIndex:section];
    NSInteger count = [sectionInfo numberOfObjects];
    return count ;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    NSInteger count = [[fetchedResultsController sections] count];
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSManagedObject *object = [fetchedResultsController objectAtIndexPath:indexPath];
    NSDictionary *entity = [object valueForKey:@"object"];

    NSString *cellName = @"listCell";
    UITableViewCell *listCell = [tableView dequeueReusableCellWithIdentifier:cellName];
    if (listCell == nil) {
        listCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellName];
    }

    listCell.textLabel.text = entity[@"text"];
    listCell.textLabel.font = [UIFont boldSystemFontOfSize:17.];

    NSDictionary *location = [entity objectForKey:@"location"];
    if (location != nil) {
        
        listCell.detailTextLabel.text = [NSString stringWithFormat:@"%@, %@", location[@"longitude"], location[@"latitude"]];
    }else {
        listCell.detailTextLabel.text = entity[@"username"];
    }
    
    BaasioFile *file = [[BaasioFile alloc]init];
    file.uuid = entity[@"file"];
    [listCell.imageView imageWithBaasioFile:file
                           placeholderImage:[UIImage imageNamed:@"pin.png"]];
    return listCell;
}

#pragma mark -
#pragma mark Fetched results controller

- (NSFetchedResultsController *)fetchedResultsController {
    if (fetchedResultsController != nil) {
        return fetchedResultsController;
    }

    AppDelegate *delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];

    managedObjectContext = [delegate managedObjectContext];//[[NSManagedObjectContext alloc] init];

    /*
	 Set up the fetched results controller.
	*/
    // Create the fetch request for the entity.
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
//       NSPredicate *predicate = [NSPredicate predicateWithFormat:@"lon > %i and lat > %i", number, number];
//       [fetchRequest setPredicate:predicate];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Timeline" inManagedObjectContext:managedObjectContext];
    [fetchRequest setEntity:entity];

    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:25];
    // Sort using the timeStamp property..

    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:
            [[NSSortDescriptor alloc] initWithKey:@"modified" ascending:NO], nil];

    [fetchRequest setSortDescriptors:sortDescriptors];

    // Use the sectionIdentifier property to group into sections.
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                                                                managedObjectContext:managedObjectContext
                                                                                                  sectionNameKeyPath:nil
                                                                                                           cacheName:nil];

    aFetchedResultsController.delegate = self;
    fetchedResultsController = aFetchedResultsController;

    return fetchedResultsController;
}

#pragma mark - Fetched results controller delegate

- (void)controllerWillChangeContent:(NSFetchedResultsController*)controller
{
//    NSLog(@"method : %@", NSStringFromSelector(_cmd));
    [_tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController*)controller didChangeSection:(id)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{
//    NSLog(@"method : %@", NSStringFromSelector(_cmd));
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [_tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;

        case NSFetchedResultsChangeDelete:
            [_tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controller:(NSFetchedResultsController*)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath*)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath*)newIndexPath
{
//    NSLog(@"method : %@, %i", NSStringFromSelector(_cmd), type);
    UITableView *tableView = _tableView;

    switch (type) {

        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;

        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;

        case NSFetchedResultsChangeUpdate:
//            [self configureCell:[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
//            break;

        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
//    NSLog(@"method : %@", NSStringFromSelector(_cmd));
//    [_tableView reloadData];
    [_tableView endUpdates];
}

#pragma mark - notification
- (void)contextChanged:(NSNotification*)notification
{
//    NSLog(@"context Changed...");
//    NSLog(@"method : %@", NSStringFromSelector(_cmd));

    if ([notification object] == managedObjectContext) return;

    if (![NSThread isMainThread]) {
        [self performSelectorOnMainThread:@selector(contextChanged:) withObject:notification waitUntilDone:YES];
        return;
    }

    [managedObjectContext mergeChangesFromContextDidSaveNotification:notification];
}
@end