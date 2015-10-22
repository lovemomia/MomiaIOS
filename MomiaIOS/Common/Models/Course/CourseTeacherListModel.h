//
//  CourseTeacherListModel.h
//  MomiaIOS
//
//  Created by Deng Jun on 15/10/22.
//  Copyright © 2015年 Deng Jun. All rights reserved.
//

#import "BaseModel.h"

@interface CourseTeacher : JSONModel
@property (nonatomic, strong) NSNumber *ids;
@property (nonatomic, strong) NSString *avatar;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *education;
@property (nonatomic, strong) NSString *experience;
@end

@protocol CourseTeacher <NSObject>
@end

@interface CourseTeacherListData : JSONModel
@property (nonatomic, strong) NSArray<CourseTeacher> *list;
@property (nonatomic, strong) NSNumber<Optional> *nextIndex;
@property (nonatomic, strong) NSNumber *totalCount;
@end

@interface CourseTeacherListModel : BaseModel
@property (nonatomic, strong) CourseTeacherListData *data;
@end
