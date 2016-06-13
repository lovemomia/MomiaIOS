//
//  BookedCourseListModel.h
//  MomiaIOS
//
//  Created by Deng Jun on 15/10/21.
//  Copyright © 2015年 Deng Jun. All rights reserved.
//

#import "BaseModel.h"
#import "CourseList.h"

@interface BookedCourseListModel : BaseModel
@property (nonatomic, strong) CourseList *data;
@end
