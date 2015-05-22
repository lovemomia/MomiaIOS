//
//  SugSubmitTagsCell.m
//  MomiaIOS
//
//  Created by Deng Jun on 15/5/18.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import "SugTagsCell.h"

@interface SugTagsCell()

@property (strong, nonatomic) NSArray* tags;

@end

@implementation SugTagsCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (id)initWithStyle:(UITableViewCellStyle)style
    reuseIdentifier:(NSString *)reuseIdentifier
           withData:(NSArray *)tags {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.tags = tags;
        
        int row = (int)tags.count/4;
        if (tags.count % 4 > 0) {
            row += 1;
        }
        
        CGFloat labelWidth = (SCREEN_WIDTH - 5 * 10) /4;
        CGFloat labelHeight = 40;
        self.height = (row + 1)*10 + row * labelHeight;
        
        for (int i = 0; i < tags.count; i++) {
            int curRow = i / 4;
            int curCol = i % 4;
            
            UILabel *label = [[UILabel alloc]init];
            label.font = [UIFont fontWithName:@"Arial" size:14];
            label.numberOfLines = 0;
            label.textAlignment = NSTextAlignmentCenter;
            label.width = labelWidth;
            label.height = labelHeight;
            label.top = 10 + curRow * (labelHeight + 10);
            label.left = 10 + curCol * (labelWidth + 10);
            
            Tag *tag = [tags objectAtIndex:i];
            if (tag.isSelected) {
                label.backgroundColor = [UIColor blueColor];
                label.textColor = [UIColor whiteColor];
                
            } else {
                label.textColor = [UIColor blackColor];
            }
            label.text = tag.name;
            
            label.tag = i;
            label.userInteractionEnabled = YES;
            UITapGestureRecognizer *singleTap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onClickTag:)];
            [label addGestureRecognizer:singleTap];
            
            [self addSubview:label];
        }
    }
    return self;
}

- (void)onClickTag:(UITapGestureRecognizer *)tap {
    Tag *tag = [self.tags objectAtIndex:tap.view.tag];
    UILabel *label = (UILabel *)tap.view;
    if (tag.isSelected) {
        tag.isSelected = NO;
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor blackColor];
        
    } else {
        tag.isSelected = YES;
        label.backgroundColor = [UIColor blueColor];
        label.textColor = [UIColor whiteColor];
    }
}

- (BOOL)isTag:(Tag *)tag selected:(NSArray *)selected {
    for (int i = 0; i < [selected count]; i++) {
        int pairID = (int)[[selected objectAtIndex:i] integerValue];
        if (pairID == tag.pairID) {
            return YES;
        }
    }
    return NO;
}

+ (instancetype)cellWithTableView:(UITableView *)tableView
                         withData:(NSArray *)tags {
    static NSString *identifier = @"CellTags";
    SugTagsCell  *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[SugTagsCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier withData:tags];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

@end
