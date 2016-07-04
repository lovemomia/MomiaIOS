//
//  MyWendaData.h
//  MomiaIOS
//
//  Created by mosl on 16/7/1.
//  Copyright © 2016年 Deng Jun. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface MineData : JSONModel

@property (nonatomic, strong) NSNumber *answerNumber;
@property (nonatomic, strong) NSNumber *assetNumber;
@property (nonatomic, strong) NSNumber *questionNumber;

@end

@interface MyWendaData : BaseModel

@property (nonatomic, strong) MineData *data;

@end
