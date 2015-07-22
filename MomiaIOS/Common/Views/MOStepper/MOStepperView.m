//
//  MOStepper.m
//  MomiaIOS
//
//  Created by Owen on 15/6/24.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import "MOStepperView.h"

@interface MOStepperView ()
@property (weak, nonatomic) IBOutlet UIView *view;
@property (weak, nonatomic) IBOutlet UIButton *minusBtn;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UIButton *plusBtn;


@end

@implementation MOStepperView

-(void)setMaxValue:(NSUInteger)maxValue
{
    if(maxValue > self.minValue)
        _maxValue = maxValue;
}

-(void)setMinValue:(NSUInteger)minValue
{
    if(minValue < self.maxValue)
        _minValue = minValue;
}

- (IBAction)onMinusClick:(id)sender {
    self.currentValue --;
    self.onclickStepper(self.currentValue);
}

- (IBAction)onPlusClick:(id)sender {
    self.currentValue ++;
    self.onclickStepper(self.currentValue);
}

-(void)setCurrentValue:(NSUInteger)currentValue
{
    _currentValue = currentValue;
       
    if(_currentValue >= self.maxValue) {//表示不能再加了
        _currentValue = self.maxValue;
        self.plusEnabled = NO;
        [self.minusBtn setEnabled:YES];
    } else if(_currentValue <= self.minValue) {//表示不能再减了
        _currentValue = self.minValue;
        [self.minusBtn setEnabled:NO];
        self.plusEnabled = YES;
    } else {
        [self.minusBtn setEnabled:YES];
        self.plusEnabled = YES;
    }
    
    self.titleLabel.text = [NSString stringWithFormat:@"%ld",(unsigned long)_currentValue];
}



-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if(self) {
        
        [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil] firstObject];
    
        _view.layer.borderWidth = 1;
        _view.layer.borderColor = UIColorFromRGB(0xCCCCCC).CGColor;
        _view.layer.cornerRadius = 2;
        
        [self addSubview:_view];
        
        [_view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        
        _maxValue = 99;
        _minValue = 0;
        
        self.currentValue = 0;
        
        [_plusBtn setImage:[UIImage imageNamed:@"IconPlusDisable"] forState:UIControlStateDisabled];
        [_plusBtn setImage:[UIImage imageNamed:@"IconPlusNormal"] forState:UIControlStateNormal];
        
        [_minusBtn setImage:[UIImage imageNamed:@"IconMinusDisable"] forState:UIControlStateDisabled];
        [_minusBtn setImage:[UIImage imageNamed:@"IconMinusNormal"] forState:UIControlStateNormal];
        
    }
    return self;
}


-(void)setPlusEnabled:(BOOL) enabled
{
    _plusEnabled = enabled;
    [self.plusBtn setEnabled:_plusEnabled];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
