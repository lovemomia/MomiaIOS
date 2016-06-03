//
//  HomeViewControllerV2.m
//  MomiaIOS
//
//  Created by Deng Jun on 16/6/3.
//  Copyright © 2016年 Deng Jun. All rights reserved.
//

#import "HomeViewControllerV2.h"
#import "RCTRootView.h"
#import "RNCommon.h"

@interface HomeViewControllerV2 ()<AccountChangeListener>

@property (nonatomic, strong) UILabel                *cityLabel;
@property (nonatomic, strong) UIImageView            *childAvatarIv;
@property (nonatomic, strong) UILabel                *childNameLabel;

@end

@implementation HomeViewControllerV2


- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSArray * array = [[NSBundle mainBundle] loadNibNamed:@"TitleView" owner:self options:nil];
    UIView * cityView = array[0];
    self.cityLabel = (UILabel *)[cityView viewWithTag:2001];
    NSString *city = [CityManager shareManager].choosedCity.name;
    [self.cityLabel setText:city];
    
    cityView.size = [cityView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    
    UIView *childView = array[1];
    self.childAvatarIv = [childView viewWithTag:1001];
    self.childNameLabel = [childView viewWithTag:1002];
    [self setupTitleChild];
    
    [cityView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTitleCityClick:)]];
    [childView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTitleChildClick:)]];
    
    UIBarButtonItem *cityItem = [[UIBarButtonItem alloc] initWithCustomView:cityView];
    UIBarButtonItem *childItem = [[UIBarButtonItem alloc] initWithCustomView:childView];
    
    if (isCurrentDeviceSystemVersionLater(7.0)) {
        UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        negativeSpacer.width = -10;
        self.navigationItem.leftBarButtonItems = @[negativeSpacer, childItem];
        self.navigationItem.rightBarButtonItems = @[negativeSpacer, cityItem];
        
    } else {
        self.navigationItem.leftBarButtonItem = childItem;
        self.navigationItem.rightBarButtonItem = cityItem;
    }
    
    [[AccountService defaultService] addListener:self];
    
    NSURL *jsCodeLocation = [NSURL URLWithString:@"http://localhost:8081/home/home.bundle?platform=ios"];
    // For production use, this `NSURL` could instead point to a pre-bundled file on disk: //
    //    NSURL *jsCodeLocation = [[NSBundle mainBundle] URLForResource:@"main" withExtension:@"jsbundle"];
    // To generate that file, run the curl command and add the output to your main Xcode build target: //
    // curl http://localhost:8081/home/home.ios.bundle -o ./ReactComponent/output/main.jsbundle
    RCTRootView *rootView = [RNCommon createRCTViewWithBundleURL:jsCodeLocation moduleName:@"HomeComponent" initialProperties:nil launchOptions:nil];
    rootView.frame = self.view.bounds;
    [self.view addSubview:rootView];
}

- (void)setupTitleChild {
    if ([AccountService defaultService].isLogin) {
        [self.childAvatarIv sd_setImageWithURL:[NSURL URLWithString:[AccountService defaultService].account.avatar]];
        if ([[AccountService defaultService].account getBigChild]) {
            self.childNameLabel.text = [NSString stringWithFormat:@"%@ %@", [AccountService defaultService].account.nickName, [[AccountService defaultService].account ageWithDateOfBirth]];
        } else {
            self.childNameLabel.text = [AccountService defaultService].account.nickName;
        }
        
    } else {
        [self.childAvatarIv sd_setImageWithURL:nil];
        self.childNameLabel.text = @"松果亲子／点击登录";
    }
}

- (void)onAccountChange {
    [self setupTitleChild];
}

- (void)onCityChanged:(City *)newCity {
    [self.cityLabel setText:newCity.name];
}

- (BOOL)isNavDarkStyle {
    return true;
}


-(void)onTitleChildClick:(UITapGestureRecognizer *)recognizer
{
    [self openURL:@"personinfo"];
    
}

-(void)onTitleCityClick:(UITapGestureRecognizer *)recognizer
{
    [[CityManager shareManager]chooseCity:self];
    [[CityManager shareManager]addCityChangeListener:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    [[CityManager shareManager] removeCityChangeListener:self];
    [[AccountService defaultService] removeListener:self];
}

@end
