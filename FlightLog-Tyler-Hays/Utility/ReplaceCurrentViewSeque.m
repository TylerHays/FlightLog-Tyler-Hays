//
//  ReplaceCurrentViewSeque.m
//  FlightLog-Tyler-Hays
//
//  Created by Tyler Hays on 4/9/19.
//  Copyright © 2019 Tyler Hays. All rights reserved.
//

#import "ReplaceCurrentViewSeque.h"

@implementation ReplaceCurrentViewSeque

-(void)perform {
    UINavigationController *controller = [self.sourceViewController navigationController];
    if (controller == nil) {
        return;
    }
    
    NSMutableArray <UIViewController *> *views = [[controller viewControllers] mutableCopy];
    
    if ([views count] > 0) {
        [views removeLastObject];
    }
    [views addObject:self.destinationViewController];
    [controller setViewControllers:[views copy] animated:YES];
}
@end
