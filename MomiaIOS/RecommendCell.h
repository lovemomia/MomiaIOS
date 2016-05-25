//
//  RecommendCell.h
//  MomiaIOS
//
//  Created by mosl on 16/5/25.
//  Copyright © 2016年 Deng Jun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MOTableCell.h"

@interface RecommendCell : MOTableCell

@property (weak, nonatomic) IBOutlet UIImageView *img;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *desc;

@property (strong, nonatomic) id data;

@end
