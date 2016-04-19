//
//  CourseLocationTimeCell.m
//  MomiaIOS
//
//  Created by mosl on 16/4/5.
//  Copyright © 2016年 Deng Jun. All rights reserved.
//

#import "CourseLocationTimeCell.h"

@interface CourseLocationTimeCell()

@property(nonatomic,strong) UILabel *address;
@property(nonatomic,strong) UILabel *startTime;
@property(nonatomic,strong) UILabel *name;


@end
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
        self.startTime = timeLabel;
        timeLabel.font = [UIFont systemFontOfSize:15];
        
        [view addSubview:timeLabel];
        [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.centerY.equalTo(timeImage);
            make.left.equalTo(timeImage.mas_right).offset(10); //相对locImage偏移10个单位
        }];
        UIImageView *locImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"IconAddress"]];
        [view addSubview:locImage];
        [locImage mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.left.equalTo(view);
            make.top.mas_equalTo(timeLabel.mas_bottom).offset(15);
        }];
        
        UILabel *locLabel = [UILabel new];
        locLabel.font = [UIFont systemFontOfSize:15];
        
        self.name = locLabel;
        [view addSubview:locLabel];
        [locLabel mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.centerY.equalTo(locImage);
            make.left.equalTo(timeLabel);
        }];
        
        UILabel *detailLoc = [UILabel new];
        detailLoc.font = [UIFont systemFontOfSize:15];
        [view addSubview:detailLoc];
        [detailLoc mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.left.equalTo(locLabel);
            make.top.equalTo(locLabel.mas_bottom).offset(15);
        }];
        self.address = detailLoc;
    }
    
    return self;
}

-(void)setData:(CourseSku *)selectSku{
    if (selectSku) {
        self.startTime.text = selectSku.time;
        self.address.text = selectSku.place.address;
        self.name.text = selectSku.place.name;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
