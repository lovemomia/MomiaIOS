//
//  CourseBookListModel.h
//  MomiaIOS
//
//  Created by Deng Jun on 15/10/22.
//  Copyright © 2015年 Deng Jun. All rights reserved.
//

#import "BaseModel.h"

@interface CourseBookListData : JSONModel
@property (nonatomic, strong) NSArray *list;
@property (nonatomic, strong) NSNumber<Optional> *nextIndex;
@property (nonatomic, strong) NSNumber *totalCount;
@end

@interface CourseBookListModel : BaseModel
@property (nonatomic, strong) CourseBookListData *data;
@end
