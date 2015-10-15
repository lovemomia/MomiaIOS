//
//  PackageList.h
//  MomiaIOS
//
//  Created by Deng Jun on 15/10/14.
//  Copyright © 2015年 Deng Jun. All rights reserved.
//

#import "JSONModel.h"
#import "Package.h"

@protocol Package <NSObject>
@end

@interface PackageList : JSONModel
@property (nonatomic, strong) NSArray<Package> *list;
@property (nonatomic, strong) NSNumber<Optional> *nextIndex;
@property (nonatomic, strong) NSNumber *totalCount;
@end
