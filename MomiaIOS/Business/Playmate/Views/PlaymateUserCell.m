//
//  PlaymateUserCell.m
//  MomiaIOS
//
//  Created by Deng Jun on 15/6/26.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import "PlaymateUserCell.h"

@interface PlaymateUserCell()
@end

@implementation PlaymateUserCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (instancetype)cellWithTableView:(UITableView *)tableView data:(id)data {
    static NSString *identifier = @"CellPlaymateUser";
    PlaymateUserCell  *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
//        cell = [[PlaymateUserCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        NSArray *arr = [[NSBundle mainBundle] loadNibNamed:@"PlaymateCell" owner:self options:nil];
        cell = [arr objectAtIndex:0];
    }
    [cell setData:data];
    return cell;
}

- (void)setData:(id)data {
    
}

+ (CGFloat)height {
    return 56;
}

@end
