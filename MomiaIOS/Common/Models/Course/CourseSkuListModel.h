//
//  CourseSkuListModel.h
//  MomiaIOS
//
//  Created by Deng Jun on 15/10/19.
//  Copyright © 2015年 Deng Jun. All rights reserved.
//

#import "BaseModel.h"

@interface CourseSkuPlace : JSONModel
@property (nonatomic, strong) NSNumber *ids;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *address;
@property (nonatomic, assign) CGFloat lng;
@property (nonatomic, assign) CGFloat lat;
@end

@interface CourseSku: JSONModel
@property (nonatomic, strong) NSNumber *ids;
@property (nonatomic, strong) CourseSkuPlace *place;
@property (nonatomic, strong) NSNumber *stock;
@property (nonatomic, strong) NSString *time;
@property (nonatomic, strong) NSNumber *closed;
@end

@protocol CourseSku <NSObject>
@end

@interface DateSkuList: JSONModel
@property (nonatomic, strong) NSString *date;
@property (nonatomic, strong) NSArray<CourseSku> *skus;
@property (nonatomic, strong) NSNumber<Optional> *isShowMore;
@end

@protocol DateSkuList <NSObject>
@end

@interface CourseSkuListModel : BaseModel
@property (nonatomic, strong) NSArray<DateSkuList> *data;
@end
