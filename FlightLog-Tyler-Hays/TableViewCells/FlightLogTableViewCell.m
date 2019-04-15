//
//  FlightLogTableViewCell.m
//  FlightLog-Tyler-Hays
//
//  Created by Tyler Hays on 4/9/19.
//  Copyright © 2019 Tyler Hays. All rights reserved.
//

#import "FlightLogTableViewCell.h"
#import "FlightLog.h"
#import "Utility.h"

@implementation FlightLogTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setupCellwithFlightLog:(FlightLog *)flightLog {
    self.aircraftLabel.text = flightLog.airCraftIdentifier;    self.flightTimeLabel.text =[Utility displayFlightHoursFormate:flightLog.flightTime]; 
    self.flightDateLabel.text = [flightLog flightDateWithMonthDayYear];
    
}

@end
