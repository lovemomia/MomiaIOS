//
//  HomeModel.h
//  MomiaIOS
//
//  Created by Deng Jun on 15/5/8.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import "BaseModel.h"

@interface HomeCarouselItem : JSONModel

@property(nonatomic,strong) NSString * url;

@end

@protocol HomeCarouselItem

@end

@interface HomeCarouselData : JSONModel

@property(nonatomic,strong) NSArray<HomeCarouselItem> * list;

@end

@interface HomeCarouselModel : BaseModel

@property (nonatomic,strong) HomeCarouselData * data;

@end

@interface HomeDataItem : JSONModel

@property (strong, nonatomic) NSString* url;
@property (strong, nonatomic) NSString* title;
@property (strong, nonatomic) NSString* desc;
@property (strong, nonatomic) NSString* time;
@property (assign, nonatomic) NSInteger enrollmentNum;
@property (assign, nonatomic) CGFloat price;

@end

@protocol HomeDataItem
@end

@interface HomeData : JSONModel

@property (strong, nonatomic) NSArray<HomeDataItem>* list;

@end

@interface HomeModel : BaseModel

@property (strong, nonatomic) HomeData *data;

@end
