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
@property (nonatomic, strong) NSMutableArray *photos;
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
                                  
                                 self.photos = [NSMutableArray arrayWithCapacity:result.data.list.count];
                                  for (int i = 0; i < result.data.list.count; i++) {
                                      NSString *url = [result.data.list objectAtIndex:i];
                                      MJPhoto *photo = [[MJPhoto alloc] init];
                                      photo.url = [NSURL URLWithString:url];
                                      [self.photos addObject:photo];
                                  }
                                  [self.tableView reloadData];
                                  
                                  
                              }
     
                              failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                  [MBProgressHUD hideHUDForView:self.view animated:YES];
                                  [self showDialogWithTitle:nil message:error.message];
                              }];
}

#pragma mark - uitableview delegate & datasourse

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
    browser.currentPhotoIndex = indexPath.section;
    browser.photos = self.photos;
    [browser show];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.photos.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *TAG = @"ItemTag";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:TAG];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:TAG];
        UIImageView *photoView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH * 3 / 4)];
        photoView.contentMode = UIViewContentModeScaleAspectFill;
        photoView.clipsToBounds = YES;
        photoView.tag = 1001;
        [cell.contentView addSubview:photoView];
    }
    MJPhoto *photo = self.photos[indexPath.section];
    UIImageView *photoView = [cell.contentView viewWithTag:1001];
    [photoView sd_setImageWithURL:photo.url];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return SCREEN_WIDTH * 3 / 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1f;
}

@end
