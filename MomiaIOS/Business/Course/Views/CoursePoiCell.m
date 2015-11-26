//
//  CoursePoiCell.m
//  MomiaIOS
//
//  Created by Deng Jun on 15/10/14.
//  Copyright © 2015年 Deng Jun. All rights reserved.
//

#import "CoursePoiCell.h"
#import "Course.h"

@interface CoursePoiCell()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@end

@implementation CoursePoiCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setData:(CoursePlace *)data {
    self.nameLabel.text = data.name;
    self.addressLabel.text = data.address;
    self.dateLabel.text = data.scheduler;
    
    if ([[LocationService defaultService]hasLocation]) {
        // distance
        CLLocation *location = [LocationService defaultService].location;
        BMKMapPoint point1 = BMKMapPointForCoordinate(CLLocationCoordinate2DMake(data.lat, data.lng));
        BMKMapPoint point2 = BMKMapPointForCoordinate(CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude));
        CLLocationDistance distance = BMKMetersBetweenMapPoints(point1, point2);
        NSString *distanceStr;
        if (distance < 100) {
            distanceStr = @"<100m";
        } else if (distance > 100000) {
            distanceStr = @">100km";
        } else if (distance > 1000) {
            distanceStr = [NSString stringWithFormat:@"%.1fkm", distance / 1000];
        } else {
            distanceStr = [NSString stringWithFormat:@"%dm", (int)distance];
        }
        self.distanceLabel.text = distanceStr;
    }
}

+ (CGFloat)heightWithTableView:(UITableView *)tableView withIdentifier:(NSString *)identifier forIndexPath:(NSIndexPath *)indexPath data:(id)data {
    return 105;
}


@end
