//
//  AddNewFlightViewController.h
//  FlightLog-Tyler-Hays
//
//  Created by Tyler Hays on 4/8/19.
//  Copyright © 2019 Tyler Hays. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FlightLog;

NS_ASSUME_NONNULL_BEGIN

@interface EditFlightViewController : UIViewController


-(void)setupWithFlightLog:(FlightLog *)flightLog;

@end

NS_ASSUME_NONNULL_END
