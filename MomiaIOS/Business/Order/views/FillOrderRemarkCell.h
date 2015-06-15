//
//  FillOrderRemarkCell.h
//  MomiaIOS
//
//  Created by Owen on 15/6/9.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import "MOTableCell.h"

@interface FillOrderRemarkCell : MOTableCell
@property (weak, nonatomic) IBOutlet UITextView *remarkTextView;

+(CGFloat)height;

-(void)setPlaceHolder:(NSString *)placeHolder;

@end
