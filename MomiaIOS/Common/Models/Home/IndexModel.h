//
//  IndexModel.h
//  MomiaIOS
//
//  Created by Deng Jun on 15/10/13.
//  Copyright © 2015年 Deng Jun. All rights reserved.
//

#import "BaseModel.h"
#import "SubjectList.h"

@interface IndexBanner : JSONModel
@property (nonatomic, strong) NSString *cover;
@property (nonatomic, strong) NSString *action;
@end

@interface IndexIcon : JSONModel
@property (nonatomic, strong) NSString *img;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *action;
@end

@interface IndexEvent : JSONModel
@property (nonatomic, strong) NSString *img;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *desc;
@property (nonatomic, strong) NSString *action;
@end

@protocol IndexBanner
@end

@protocol IndexIcon
@end

@protocol IndexEvent
@end

@interface IndexData : JSONModel
@property (nonatomic, strong) NSArray<IndexBanner> *banners;
@property (nonatomic, strong) NSArray<IndexIcon> *icons;
@property (nonatomic, strong) NSArray<IndexEvent> *events;
@property (nonatomic, strong) SubjectList *subjects;
@end

@interface IndexModel : BaseModel
@property (nonatomic, strong) IndexData *data;
@end
