//
//  FlightLogTableViewCell.h
//  FlightLog-Tyler-Hays
//
//  Created by Tyler Hays on 4/9/19.
//  Copyright © 2019 Tyler Hays. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FlightLog;

NS_ASSUME_NONNULL_BEGIN

@interface FlightLogTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *aircraftLabel;
@property (weak, nonatomic) IBOutlet UILabel *flightDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *flightTimeLabel;


- (void)setupCellwithFlightLog:(FlightLog *)flightLog;
@end

NS_ASSUME_NONNULL_END
