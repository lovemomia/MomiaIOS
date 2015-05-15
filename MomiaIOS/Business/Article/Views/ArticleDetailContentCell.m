//
//  ArticleDetailContentCell.m
//  MomiaIOS
//
//  Created by Deng Jun on 15/5/7.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import "ArticleDetailContentCell.h"
#import "Constants.h"

@interface ArticleDetailContentCell()

@property (nonatomic, assign)BOOL hasGetWebHeight;


@end

@implementation ArticleDetailContentCell

- (void)awakeFromNib {
    // Initialization code

    [self.contentLabel setNumberOfLines:0];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setData:(ArticleDetailContentItem *)data {
    
    if(data.text && !data.image) {//只有文字的情况
        
        [(UILabel *)[self viewWithTag:1001] setText:data.text];
//        [self setBackgroundColor:[UIColor redColor]];
        
    } else if(data.text && data.image){//有文字有图片
        
        [self.contentLabel setText:data.text];
        self.contentLabel.hidden = NO;
        [self.photoImageView sd_setImageWithURL:[NSURL URLWithString:data.image]];
        self.photoImageView.hidden = NO;
        
//        [self setBackgroundColor:[UIColor greenColor]];

        
    } else if(!data.text && data.image){//只有图片
        
        [self.photoImageView sd_setImageWithURL:[NSURL URLWithString:data.image]];
        self.photoImageView.hidden = NO;
        self.contentLabel.hidden = YES;
        
//        [self setBackgroundColor:[UIColor blueColor]];

        
    } else {
    
    //        if (data.text) {
//            [self.contentLabel setText:data.text];
//            self.contentLabel.hidden = NO;
//            
//        } else {
//            self.contentLabel.hidden = YES;
//            //        self.photoImageView.top = 0;
//        }
//        
//        if (data.image) {
//            [self.photoImageView sd_setImageWithURL:[NSURL URLWithString:data.image]];
//            self.photoImageView.hidden = NO;
//            
//            
//        } else {
//            self.photoImageView.hidden = YES;
//            
//        }
        
        
    }
}

+ (instancetype)cellWithTableView:(UITableView *)tableView withData:(ArticleDetailContentItem *)data{
    static NSString *identifier = @"CellContent";
    static NSString * textIdentifier = @"CellContentText";
    ArticleDetailContentCell *cell;
    NSUInteger index;
    if(data.text&&!data.image) {
        cell = [tableView dequeueReusableCellWithIdentifier:textIdentifier];
        index = 5;

    } else {
        cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        index = 1;

    }
    
    if (cell == nil) {
        NSArray *arr = [[NSBundle mainBundle] loadNibNamed:@"ArticleDetailCells" owner:self options:nil];
        if(index < [arr count]) {
            cell = [arr objectAtIndex:index];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        } else {
            NSLog(@"无法从xib载入Cell");
        }
    }
    return cell;
}

+ (CGFloat)heightWithData:(ArticleDetailContentItem *)data {
    CGFloat height;
    
    if (data.text) {
        CGRect textFrame = [UILabel heightForMutableString:data.text withWidth:(SCREEN_WIDTH - 16) andFontSize:16.0];
        height += textFrame.size.height;

    }
    
    if (data.image) {
        height += 170;
        
    }
    return height + 25;
}

@end
