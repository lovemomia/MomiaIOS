//
//  CourseListModel.h
//  MomiaIOS
//
//  Created by Deng Jun on 15/10/19.
//  Copyright © 2015年 Deng Jun. All rights reserved.
//

#import "BaseModel.h"
#import "CourseList.h"

@interface Filter : JSONModel
@property (nonatomic, strong) NSNumber *ids;
@property (nonatomic, strong) NSString *text;
@end

@protocol Filter <NSObject>
@end

@interface CourseListData : JSONModel
@property (nonatomic, strong) NSArray<Filter, Optional> *ages;
@property (nonatomic, strong) NSArray<Filter, Optional> *sorts;
@property (nonatomic, strong) NSNumber *currentAge;
@property (nonatomic, strong) NSNumber *currentSort;
@property (nonatomic, strong) CourseList *courses;
@end

@interface CourseListModel : BaseModel
@property (nonatomic, strong) CourseListData *data;
@end
