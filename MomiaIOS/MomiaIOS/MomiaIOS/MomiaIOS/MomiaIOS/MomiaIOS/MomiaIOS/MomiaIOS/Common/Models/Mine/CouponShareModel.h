//
//  CouponShareModel.h
//  MomiaIOS
//
//  Created by Deng Jun on 15/11/18.
//  Copyright © 2015年 Deng Jun. All rights reserved.
//

#import "BaseModel.h"

@interface CouponShareData : JSONModel
@property (nonatomic, strong) NSString *img;
@property (nonatomic, strong) NSString *desc;
@property (nonatomic, strong) NSString *cover;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *abstracts;
@property (nonatomic, strong) NSString *url;
@end

@interface CouponShareModel : BaseModel
@property (nonatomic, strong) CouponShareData *data;
@end
