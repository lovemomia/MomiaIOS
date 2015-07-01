//
//  OrderAddPersonFillCell.m
//  MomiaIOS
//
//  Created by Owen on 15/6/25.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import "OrderAddPersonFillCell.h"

@interface OrderAddPersonFillCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITextField *contentField;

@end

@implementation OrderAddPersonFillCell

-(void)setData:(AddPersonModel *)model withIndex:(NSInteger) index
{
    if(index == 0) {
        self.titleLabel.text = @"姓名";
        self.contentField.placeholder = @"请输入真实姓名";
        self.contentField.text = model.name;
    } else if(index == 4) {
        self.titleLabel.text = @"证件号码";
        self.contentField.placeholder = @"请输入证件号码";
        self.contentField.text = model.idNo;
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

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
