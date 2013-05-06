//
//  ViewController.m
//  Cocoabook
//
//  Created by cetauri on 13. 5. 6..
//  Copyright (c) 2013년 KT. All rights reserved.
//

#import "ViewController.h"

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
    [composeViewController dismissViewControllerAnimated:YES completion:nil];
    
    if (result == REComposeResultCancelled) {
        NSLog(@"Cancelled");
    }
    
    if (result == REComposeResultPosted) {
        NSLog(@"Text: %@", composeViewController.text);
    }
}
@end
