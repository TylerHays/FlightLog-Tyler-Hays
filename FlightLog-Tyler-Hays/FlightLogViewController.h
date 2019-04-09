//
//  FlightLogViewController.h
//  FlightLog-Tyler-Hays
//
//  Created by Tyler Hays on 4/8/19.
//  Copyright © 2019 Tyler Hays. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FlightLog;

@interface FlightLogViewController : UIViewController <UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray<FlightLog *> *flightLogs;


@end

