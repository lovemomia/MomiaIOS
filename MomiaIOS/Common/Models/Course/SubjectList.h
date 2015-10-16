//
//  PackageList.h
//  MomiaIOS
//
//  Created by Deng Jun on 15/10/14.
//  Copyright © 2015年 Deng Jun. All rights reserved.
//

#import "JSONModel.h"
#import "Subject.h"

@protocol Subject <NSObject>
@end

@interface SubjectList : JSONModel
@property (nonatomic, strong) NSArray<Subject> *list;
@property (nonatomic, strong) NSNumber<Optional> *nextIndex;
@property (nonatomic, strong) NSNumber *totalCount;
@end
