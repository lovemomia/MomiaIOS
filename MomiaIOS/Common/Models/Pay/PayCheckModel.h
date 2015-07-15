//
//  PayModel.h
//  MomiaIOS
//
//  Created by Deng Jun on 15/7/8.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import "BaseModel.h"

@interface PayCheckData : JSONModel

@property (nonatomic, strong) NSString *thumb;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *abstracts;
@property (nonatomic, strong) NSString *url;

@end

@interface PayCheckModel : BaseModel

@property (nonatomic, strong) PayCheckData *data;

@end
