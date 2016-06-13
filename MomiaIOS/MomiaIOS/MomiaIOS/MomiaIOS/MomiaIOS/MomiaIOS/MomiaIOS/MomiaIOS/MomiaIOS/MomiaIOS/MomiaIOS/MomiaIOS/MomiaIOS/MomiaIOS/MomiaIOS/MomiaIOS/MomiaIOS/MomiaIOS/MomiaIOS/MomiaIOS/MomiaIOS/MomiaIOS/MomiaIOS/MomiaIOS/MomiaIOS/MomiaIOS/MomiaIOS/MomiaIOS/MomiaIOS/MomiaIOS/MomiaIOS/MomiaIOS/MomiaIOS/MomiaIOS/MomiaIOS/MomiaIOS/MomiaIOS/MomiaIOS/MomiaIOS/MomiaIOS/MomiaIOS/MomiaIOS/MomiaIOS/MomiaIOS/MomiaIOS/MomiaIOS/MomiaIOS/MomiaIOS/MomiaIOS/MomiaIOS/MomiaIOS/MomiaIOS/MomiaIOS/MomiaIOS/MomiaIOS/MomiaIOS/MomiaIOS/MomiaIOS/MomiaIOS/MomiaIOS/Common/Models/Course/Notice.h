//
//  Notice.h
//  MomiaIOS
//
//  Created by Deng Jun on 15/10/13.
//  Copyright © 2015年 Deng Jun. All rights reserved.
//

#import "JSONModel.h"

@interface Notice : JSONModel

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *content;

@end
