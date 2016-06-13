//
//  OrderContactCell.m
//  MomiaIOS
//
//  Created by Owen on 15/7/1.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import "OrderContactCell.h"

@interface OrderContactCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITextField *contentField;

@end


@implementation OrderContactCell

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)setData:(FillOrderContactsModel *)model withIndex:(NSInteger) index
{
    if(index == 0) {
        self.titleLabel.text = @"姓名";
        self.contentField.placeholder = @"请输入真实姓名";
        self.contentField.text = model.name;
    } else if(index == 1) {
        self.titleLabel.text = @"手机号";
        self.contentField.placeholder = @"请输入手机号码";
        self.contentField.text = model.mobile;
    }

}

-(IBAction)editingChanged:(id)sender
{
    UITextField * txtField = sender;
    self.editingChanged(txtField);
}


-(void)awakeFromNib
{
    [self.contentField addTarget:self action:@selector(editingChanged:) forControlEvents:UIControlEventEditingChanged];
}



@end
