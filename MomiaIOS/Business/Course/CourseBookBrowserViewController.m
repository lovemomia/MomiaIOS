//
//  CourseBookBrowserViewController.m
//  MomiaIOS
//
//  Created by Deng Jun on 15/10/22.
//  Copyright © 2015年 Deng Jun. All rights reserved.
//

#import "CourseBookBrowserViewController.h"
#import "CourseBookListModel.h"
#import "MJPhoto.h"
#import "MJPhotoBrowser.h"

@interface CourseBookBrowserViewController ()
@property (nonatomic, strong) NSString *ids;
@end

@implementation CourseBookBrowserViewController

- (instancetype)initWithParams:(NSDictionary *)params {
    if (self = [super initWithParams:params]) {
        self.ids = [params objectForKey:@"id"];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"课前绘本";
    // Do any additional setup after loading the view.
    [self requestData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)requestData {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSDictionary *params = @{@"id":self.ids, @"start":@"0"};
    [[HttpService defaultService]GET:URL_APPEND_PATH(@"/m/course/book")
                          parameters:params cacheType:CacheTypeDisable JSONModelClass:[CourseBookListModel class]
                              success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                  [MBProgressHUD hideHUDForView:self.view animated:YES];
                                  CourseBookListModel *result = (CourseBookListModel *)responseObject;
                                  
                                  NSMutableArray *photos = [NSMutableArray arrayWithCapacity:result.data.list.count];
                                  for (int i = 0; i < result.data.list.count; i++) {
                                      NSString *url = [result.data.list objectAtIndex:i];
                                      MJPhoto *photo = [[MJPhoto alloc] init];
                                      photo.url = [NSURL URLWithString:url];
                                      [photos addObject:photo];
                                  }
                                  
                                  MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
                                  browser.photos = photos;
                                  [self.view addSubview:browser.view];
                                  [self addChildViewController:browser];
                                  [browser showPhotos];
                              }
     
                              failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                  [MBProgressHUD hideHUDForView:self.view animated:YES];
                                  [self showDialogWithTitle:nil message:error.message];
                              }];
}

@end
