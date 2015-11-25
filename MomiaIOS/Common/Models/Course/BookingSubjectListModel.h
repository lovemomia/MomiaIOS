//
//  BookingSubjectListModel.h
//  MomiaIOS
//
//  Created by Deng Jun on 15/10/19.
//  Copyright © 2015年 Deng Jun. All rights reserved.
//

#import "BaseModel.h"

@interface BookingSubject : JSONModel
@property (nonatomic, strong) NSNumber *packageId;
@property (nonatomic, strong) NSNumber *subjectId;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *cover;
@property (nonatomic, strong) NSNumber *bookableCourseCount;
@property (nonatomic, strong) NSString<Optional> *expireTime;
@property (nonatomic, strong) NSNumber *courseId;
@end

@protocol BookingSubject <NSObject>
@end

@interface BookingSubjectListData : JSONModel
@property (nonatomic, strong) NSArray<BookingSubject> *list;
@property (nonatomic, strong) NSNumber<Optional> *nextIndex;
@property (nonatomic, strong) NSNumber *totalCount;
@end

@interface BookingSubjectListModel : BaseModel
@property (nonatomic, strong) BookingSubjectListData *data;
@end
