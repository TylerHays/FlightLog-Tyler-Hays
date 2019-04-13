//
//  FlightViewViewController.h
//  FlightLog-Tyler-Hays
//
//  Created by Tyler Hays on 4/12/19.
//  Copyright © 2019 Tyler Hays. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FlightLog;

NS_ASSUME_NONNULL_BEGIN

@interface FlightViewViewController : UIViewController
@property (nonatomic, strong) FlightLog *flightLog;

- (void)setupViewWithLog:(FlightLog *)flightLog;
@end

NS_ASSUME_NONNULL_END
