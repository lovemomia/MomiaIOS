//
//  CityManager.m
//  MomiaIOS
//
//  Created by Deng Jun on 15/6/29.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import "CityManager.h"
#import "MONavigationController.h"
#import "CityListViewController.h"

@interface CityManager()

@property (nonatomic, strong) NSMutableArray *listeners;

@end

@implementation CityManager
@synthesize choosedCity = _choosedCity;

+ (instancetype)shareManager {
    static CityManager *__manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __manager = [[self alloc] init];
    });
    return __manager;
}

- (City *)choosedCity {
    if (_choosedCity == nil) {
        City *ac;
        NSData *myEncodedObject = [[NSUserDefaults standardUserDefaults] objectForKey:@"choosedCity"];
        if (myEncodedObject != nil) {
            ac = [NSKeyedUnarchiver unarchiveObjectWithData: myEncodedObject];
            _choosedCity = ac;
        }
    }
    if (_choosedCity == nil) {
        _choosedCity = [City new];
        _choosedCity.ids = [[NSNumber alloc]initWithInt:1];
        _choosedCity.name = @"上海";
    }
    return _choosedCity;
}

- (void)setChoosedCity:(City *)choosedCity {
    if ([_choosedCity.ids compare:choosedCity.ids] == NSOrderedSame) {
        return;
    }
    _choosedCity = choosedCity;
    if (self.listeners) {
        for (id<CityChangeListener> listener in self.listeners) {
            [listener onCityChanged:choosedCity];
        }
    }
    [self save:choosedCity];
}

- (void)save:(City *)city {
    NSData *archiveData = [NSKeyedArchiver archivedDataWithRootObject:city];
    NSUserDefaults *myDefault =[NSUserDefaults standardUserDefaults];
    [myDefault setObject:archiveData forKey:@"choosedCity"];
}

- (void)addCityChangeListener:(id<CityChangeListener>)listener {
    if (self.listeners == nil) {
        self.listeners = [NSMutableArray new];
    }
    [self.listeners addObject:listener];
}

- (void)removeCityChangeListener:(id<CityChangeListener>)listener {
    if (self.listeners) {
        [self.listeners removeObject:listener];
    }
}

- (void)chooseCity:(UIViewController *)currentController {
    CityListViewController *controller = [[CityListViewController alloc]initWithParams:nil];
    MONavigationController *navController = [[MONavigationController alloc]initWithRootViewController:controller];
    [currentController presentViewController:navController animated:YES completion:nil];
}

@end
