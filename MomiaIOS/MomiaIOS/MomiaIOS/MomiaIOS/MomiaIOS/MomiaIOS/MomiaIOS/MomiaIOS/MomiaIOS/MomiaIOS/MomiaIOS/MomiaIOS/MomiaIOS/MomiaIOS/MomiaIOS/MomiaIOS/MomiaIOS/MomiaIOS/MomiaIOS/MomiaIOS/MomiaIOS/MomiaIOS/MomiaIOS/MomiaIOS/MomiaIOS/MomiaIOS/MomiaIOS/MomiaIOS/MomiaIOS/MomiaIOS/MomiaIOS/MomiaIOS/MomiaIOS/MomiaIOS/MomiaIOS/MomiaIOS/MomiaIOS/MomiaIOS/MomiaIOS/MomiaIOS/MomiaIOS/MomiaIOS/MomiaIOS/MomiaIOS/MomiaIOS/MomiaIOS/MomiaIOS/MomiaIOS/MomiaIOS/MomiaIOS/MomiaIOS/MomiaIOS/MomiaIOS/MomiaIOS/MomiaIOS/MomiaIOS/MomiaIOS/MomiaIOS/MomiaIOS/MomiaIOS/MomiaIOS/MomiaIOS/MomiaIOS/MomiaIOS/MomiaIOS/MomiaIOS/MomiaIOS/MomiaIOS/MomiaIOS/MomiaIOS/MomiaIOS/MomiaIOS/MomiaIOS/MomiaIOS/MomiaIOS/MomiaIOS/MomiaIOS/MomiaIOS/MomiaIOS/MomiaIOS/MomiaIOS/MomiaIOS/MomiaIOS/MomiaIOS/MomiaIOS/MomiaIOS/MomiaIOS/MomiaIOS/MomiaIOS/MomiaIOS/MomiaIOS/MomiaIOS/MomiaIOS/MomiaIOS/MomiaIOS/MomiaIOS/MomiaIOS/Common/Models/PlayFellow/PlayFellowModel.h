//
//  PlayFellowModel.h
//  MomiaIOS
//
//  Created by Owen on 15/7/7.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import "BaseModel.h"

@interface PlayFellowPlaymatesModel : JSONModel

@property(nonatomic,strong) NSString * avatar;
@property(nonatomic,strong) NSString * nickName;
@property(nonatomic,assign) NSInteger pId;
@property(nonatomic,strong) NSArray * children;

@end

@protocol PlayFellowPlaymatesModel <NSObject>

@end

@interface PlayFellowDataModel : JSONModel

@property(nonatomic,strong) NSString * joined;
@property(nonatomic,strong) NSString * time;
@property(nonatomic,strong) NSNumber<Optional> * selected;
@property(nonatomic,strong) NSArray<PlayFellowPlaymatesModel> * playmates;

@end

@protocol PlayFellowDataModel <NSObject>

@end

@interface PlayFellowModel : BaseModel

@property(nonatomic,strong) NSArray<PlayFellowDataModel> * data;

@end
