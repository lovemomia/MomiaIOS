//
//  ActivityDetailContentCell.m
//  MomiaIOS
//
//  Created by Owen on 15/6/16.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import "ActivityDetailContentCell.h"
#import "ProductModel.h"
#import "NSString+MOAttribuedString.h"

typedef enum {
    StyleStatusNum,
    StyleStatusDot,
    StyleStatusNone
} StyleStatus;

@interface ActivityDetailContentCell ()
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@end

@implementation ActivityDetailContentCell

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(NSAttributedString *)attributedStringOfArray:(NSArray *)array andStyle:(StyleStatus) status
{
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 13.0f;
    
    NSMutableAttributedString * s = [[NSMutableAttributedString alloc] init];

    
    for(int i = 0 ; i < array.count ; i++) {
        NSString * content = @"";
        NSMutableAttributedString * as = [[NSMutableAttributedString alloc] init];
        switch (status) {
            case StyleStatusDot:
                content = @"·";
                break;
            case StyleStatusNum:
                content = [NSString stringWithFormat:@"%d、",i + 1];
                break;
            default:
                break;
        }
        
        ProductBodyModel * model = array[i];
        if(model.text && !model.link && !model.img) {
            if(i != 0) [as appendAttributedString:[[NSAttributedString alloc] initWithString:@"\n"]];

            if(model.label) {
                content = [[content stringByAppendingString:model.label] stringByAppendingString:@": "];
                NSAttributedString * as1 = [content attributedStringWithColor:UIColorFromRGB(0xf67531) andFont:self.contentLabel.font];
                NSAttributedString * as2 = [model.text attributedStringWithColor:self.contentLabel.textColor andFont:self.contentLabel.font];
                [as appendAttributedString:as1]; [as appendAttributedString:as2];
            } else {
                content = [content stringByAppendingString:model.text];
                NSAttributedString * as3 = [content attributedStringWithColor:self.contentLabel.textColor andFont:self.contentLabel.font];
                [as appendAttributedString:as3];
            }
            
        }
        [s appendAttributedString:as];
        
    }
    
    return s;
    
}

-(void)setData:(ProductContentModel *)model
{
    //设置行间距
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 13.0f;
    
    NSMutableAttributedString * as;
    //样式，ul：无序列表（用 . ）,ol：有序列表（用数字），none：没有样式，按顺序从上往下排
    if([model.style isEqualToString:@"ol"]) {
        as = [[NSMutableAttributedString alloc] initWithAttributedString:[self attributedStringOfArray:model.body andStyle:StyleStatusNum]];
    } else if([model.style isEqualToString:@"ul"]){
         as = [[NSMutableAttributedString alloc] initWithAttributedString:[self attributedStringOfArray:model.body andStyle:StyleStatusDot]];
    } else if([model.style isEqualToString:@"none"]) {
         as = [[NSMutableAttributedString alloc] initWithAttributedString:[self attributedStringOfArray:model.body andStyle:StyleStatusNone]];
    }
    [as addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, as.length)];
    
    self.contentLabel.attributedText = as;
    
}

@end
