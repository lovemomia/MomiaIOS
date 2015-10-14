//
//  CourseList.h
//  MomiaIOS
//
//  Created by Deng Jun on 15/10/13.
//  Copyright © 2015年 Deng Jun. All rights reserved.
//

#import "JSONModel.h"

@protocol Course <NSObject>
@end

@interface CourseList : JSONModel
@property (nonatomic, strong) NSArray<Course> *list;
@property (nonatomic, strong) NSNumber<Optional> *nextIndex;
@property (nonatomic, strong) NSNumber *totalCount;
@end
