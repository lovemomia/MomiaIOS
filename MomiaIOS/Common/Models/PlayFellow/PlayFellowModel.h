//
//  PlayFellowModel.h
//  MomiaIOS
//
//  Created by Owen on 15/7/7.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import "BaseModel.h"

@interface PlayFellowChildrenModel : JSONModel

@property(nonatomic,strong) NSString * birthday;
@property(nonatomic,assign) NSInteger childrenId;
@property(nonatomic,strong) NSString  * name;
@property(nonatomic,strong) NSString * sex;
@property(nonatomic,strong) NSString * type;

@end

@protocol PlayFellowChildrenModel <NSObject>

@end

@interface PlayFellowCustomersModel : JSONModel

@property(nonatomic,strong) NSString * avatar;
@property(nonatomic,strong) NSArray<PlayFellowChildrenModel> * children;
@property(nonatomic,assign) NSInteger customersId;
@property(nonatomic,strong) NSString * nickname;

@end

@protocol PlayFellowCustomersModel <NSObject>

@end

@interface PlayFellowListModel : JSONModel

@property(nonatomic,strong) NSArray<PlayFellowCustomersModel> * customers;
@property(nonatomic,strong) NSString * date;
@property(nonatomic,strong) NSString * text;
@property(nonatomic,strong) NSNumber<Optional> * selected;//后台服务器没有的一个字段，额外添加上去，用来判断当前section是否选中

@end

@protocol PlayFellowListModel<NSObject>

@end

@interface PlayFellowDataModel : JSONModel

@property(nonatomic,strong) NSArray<PlayFellowListModel> * list;
@property(nonatomic,assign) NSInteger totalCount;



@end

@interface PlayFellowModel : BaseModel

@property(nonatomic,strong) PlayFellowDataModel * data;

@end
