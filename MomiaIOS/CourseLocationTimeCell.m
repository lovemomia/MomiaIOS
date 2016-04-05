//
//  CourseLocationTimeCell.m
//  MomiaIOS
//
//  Created by mosl on 16/4/5.
//  Copyright © 2016年 Deng Jun. All rights reserved.
//

#import "CourseLocationTimeCell.h"

@implementation CourseLocationTimeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        //init
        UIView *view = [UIView new];
        [self.contentView addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.edges.equalTo(self.contentView).with.insets(UIEdgeInsetsMake(20, 10, 10, 10));
        }];
        
        UIImageView *timeImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"IconAlarm"]];
        [view addSubview:timeImage];
        [timeImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(view).with.offset(0);
            make.top.mas_equalTo(view.top);
        }];
        
        UILabel *timeLabel = [[UILabel alloc]init];
        [view addSubview:timeLabel];
        [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.centerY.equalTo(timeImage);
            make.left.equalTo(timeImage.mas_right).offset(10); //相对locImage偏移10个单位
        }];
        timeLabel.text = @"1月1号(周六) 10:00 - 12:00";
        
        UIImageView *locImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"IconAddress"]];
        [view addSubview:locImage];
        [locImage mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.left.equalTo(view);
            make.top.mas_equalTo(timeLabel.mas_bottom).offset(15);
        }];
        
        UILabel *locLabel = [UILabel new];
        [view addSubview:locLabel];
        [locLabel mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.centerY.equalTo(locImage);
            make.left.equalTo(locImage.mas_right).offset(15);
        }];
        locLabel.text = @"瑞尔齿科（中山公园店)";
        
        UILabel *detailLoc = [UILabel new];
        [view addSubview:detailLoc];
        [detailLoc mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.left.equalTo(locLabel);
            make.top.equalTo(locLabel.mas_bottom).offset(15);
        }];
        detailLoc.text = @"长宁区长宁路999号龙之梦,200米";
    }
    
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
