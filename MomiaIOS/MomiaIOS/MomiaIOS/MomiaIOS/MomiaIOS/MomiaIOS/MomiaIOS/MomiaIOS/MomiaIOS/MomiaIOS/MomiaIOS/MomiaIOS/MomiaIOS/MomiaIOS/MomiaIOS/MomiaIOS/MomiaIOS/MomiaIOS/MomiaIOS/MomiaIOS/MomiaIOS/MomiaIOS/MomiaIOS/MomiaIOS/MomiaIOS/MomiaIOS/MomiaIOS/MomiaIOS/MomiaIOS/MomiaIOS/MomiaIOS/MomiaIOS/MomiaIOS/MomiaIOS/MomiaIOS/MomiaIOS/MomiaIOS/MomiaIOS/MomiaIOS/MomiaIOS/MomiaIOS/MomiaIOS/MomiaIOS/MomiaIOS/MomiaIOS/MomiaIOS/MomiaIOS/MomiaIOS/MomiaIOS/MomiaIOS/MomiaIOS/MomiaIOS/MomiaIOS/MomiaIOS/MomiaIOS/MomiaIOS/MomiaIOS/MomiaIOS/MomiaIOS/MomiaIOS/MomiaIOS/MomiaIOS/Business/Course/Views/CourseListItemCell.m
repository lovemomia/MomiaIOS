//
//  CourseListItemCell.m
//  MomiaIOS
//
//  Created by Deng Jun on 15/10/10.
//  Copyright © 2015年 Deng Jun. All rights reserved.
//

#import "CourseListItemCell.h"
#import "Course.h"
#import "StringUtils.h"

@interface CourseListItemCell()

@property (weak, nonatomic) IBOutlet UIImageView *iconIv;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *placeLabel;

@end

@implementation CourseListItemCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setData:(Course *) model {
    [self.iconIv sd_setImageWithURL:[NSURL URLWithString:model.cover]];
    self.titleLabel.text = model.title;
    self.dateLabel.text = [NSString stringWithFormat:@"%@ | %@", model.age, model.scheduler];
    if (model.place && model.place.name.length > 0) {
        self.placeLabel.text = model.place.name;
    } else {
        self.placeLabel.text = model.region;
    }
}

+ (CGFloat)heightWithTableView:(UITableView *)tableView withIdentifier:(NSString *)identifier forIndexPath:(NSIndexPath *)indexPath data:(id)data {
    return 97;
}

@end
