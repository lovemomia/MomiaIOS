//
//  BookCourseListItemCell.m
//  MomiaIOS
//
//  Created by Deng Jun on 15/10/23.
//  Copyright © 2015年 Deng Jun. All rights reserved.
//

#import "BookCourseListItemCell.h"
#import "StringUtils.h"

@interface BookCourseListItemCell()

@property (nonatomic, strong) Course *course;

@end

@implementation BookCourseListItemCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

-(void)setData:(Course *) model {
    self.course = model;
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

- (IBAction)onBookBtnClicked:(id)sender {
    if (self.delegate) {
        [self.delegate onBookBtnClick:self.course];
    }
}

@end
