//
//  PhotoTitleHeaderCell.m
//  MomiaIOS
//
//  Created by Deng Jun on 15/10/8.
//  Copyright © 2015年 Deng Jun. All rights reserved.
//

#import "PhotoTitleHeaderCell.h"
#import "MONetworkPhotoView.h"

@interface PhotoTitleHeaderCell()

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UILabel *pageLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;


@end

@implementation PhotoTitleHeaderCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (CGFloat)heightWithTableView:(UITableView *)tableView withIdentifier:(NSString *)identifier forIndexPath:(NSIndexPath *)indexPath data:(id)data {
    return SCREEN_WIDTH * 225 / 320;
}

- (void)setData:(id)data {
    MONetworkPhotoView * imgView = [[MONetworkPhotoView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH * 225 / 320)];
    [imgView sd_setImageWithURL:[NSURL URLWithString:@"http://s.duolaqinzi.com/2015-07-10/58b05875a09ab90e1da44eee10ca1144.jpg"] placeholderImage:nil];
    imgView.clipsToBounds = YES;
    imgView.contentMode = UIViewContentModeScaleAspectFill;
    
    [self.scrollView addSubview:imgView];
}

@end
