//
//  ViewController.m
//  Cocoabook
//
//  Created by cetauri on 13. 5. 6..
//  Copyright (c) 2013년 KT. All rights reserved.
//

#import "ViewController.h"
#import <baas.io/Baas.h>

@interface ViewController ()

@end


@implementation ViewController
- (void)loadView{
    [super loadView];
    [button addTarget:self action:@selector(write:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)write:(id)sender
{
    REComposeViewController *composeViewController = [[REComposeViewController alloc] init];
    composeViewController.title = @"Cocoa Story";
    composeViewController.hasAttachment = YES;
    composeViewController.delegate = self;
    composeViewController.text = @"Test";
    [composeViewController presentFromRootViewController];
}



#pragma mark -
#pragma mark REComposeViewControllerDelegate

- (void)composeViewController:(REComposeViewController *)composeViewController didFinishWithResult:(REComposeResult)result
{
    
    switch (result) {
        case REComposeResultCancelled:
            NSLog(@"Cancelled");
            break;
            
        default:{
            [self.view setUserInteractionEnabled:NO];
            
            BaasioFile *file = [[BaasioFile alloc] init];
            file.data = UIImageJPEGRepresentation(composeViewController.attachmentImage, 1.0);;
            file.filename = @"image.png";
            [file fileUploadInBackground:^(BaasioFile *file) {
                BaasioEntity *timelineEntity = [BaasioEntity entitytWithName:@"timeline"];
                [timelineEntity setObject:composeViewController.text forKey:@"text"];
                [timelineEntity setObject:file.uuid forKey:@"file"];
                
                // USER
                BaasioUser *user = [BaasioUser currentUser];
                [timelineEntity setObject:user.uuid forKey:@"user"];
                [timelineEntity setObject:user.username forKey:@"username"];

                // Location
                if (composeViewController.locDictionary != nil){
                    [timelineEntity setObject:composeViewController.locDictionary forKey:@"location"];
                }
                
                [timelineEntity saveInBackground:^(BaasioEntity *entity) {
                    [self.view setUserInteractionEnabled:YES];
                    [composeViewController dismissViewControllerAnimated:YES completion:nil];
                } failureBlock:^(NSError *error) {
                    [self errorHandler:error];
                }];
            }
            failureBlock:^(NSError *error) {
                [self errorHandler:error];
            }
            progressBlock:^(float progress) {
                NSLog(@"progress : %f", progress);
            }];
        }
    }
}

- (void)errorHandler:(NSError *)error {
    [self.view setUserInteractionEnabled:YES];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:error.localizedDescription
                                                                message:nil
                                                               delegate:nil
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
    [alertView show];
}
@end
