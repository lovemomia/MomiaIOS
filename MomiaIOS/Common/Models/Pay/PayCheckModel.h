//
//  PayModel.h
//  MomiaIOS
//
//  Created by Deng Jun on 15/7/8.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import "BaseModel.h"

@interface PayCheckData : JSONModel

@property (nonatomic, strong) NSString<Optional> *thumb;
@property (nonatomic, strong) NSString<Optional> *title;
@property (nonatomic, strong) NSString<Optional> *abstracts;
@property (nonatomic, strong) NSString<Optional> *url;

@property (nonatomic, assign) BOOL payed;

@end

@interface PayCheckModel : BaseModel

@property (nonatomic, strong) PayCheckData *data;

@end
