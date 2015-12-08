//
//  ChatUserViewController.m
//  MomiaIOS
//
//  Created by Deng Jun on 15/12/7.
//  Copyright © 2015年 Deng Jun. All rights reserved.
//

#import "ChatUserViewController.h"
#import "IMUserModel.h"
#import "AppDelegate.h"
#import "GroupMemberItemCell.h"

static NSString *identifierGroupMemberItemCell = @"GroupMemberItemCell";

@interface ChatUserViewController ()

@property (nonatomic, strong) NSString *ids;
@property (nonatomic, strong) User *user;

@end

@implementation ChatUserViewController

- (instancetype)initWithParams:(NSDictionary *)params {
    if (self = [super initWithParams:params]) {
        self.ids = [params objectForKey:@"id"];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [GroupMemberItemCell registerCellFromNibWithTableView:self.tableView withIdentifier:identifierGroupMemberItemCell];
    
    NSDictionary *dic = ((AppDelegate *)[UIApplication sharedApplication].delegate).imUserDic;
    User *user;
    if (dic) {
        user = [dic objectForKey:self.ids];
    }
    if (user) {
        self.user = user;
        [self.tableView reloadData];
    } else {
        [self requestData];
    }
}

- (void)requestData {
    if (self.user == nil) {
        [self.view showLoadingBee];
    }
    
    [[HttpService defaultService] GET:URL_APPEND_PATH(@"/im/user") parameters:@{@"uid":self.ids} cacheType:CacheTypeDisable JSONModelClass:[IMUserModel class] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (self.user == nil) {
            [self.view removeLoadingBee];
        }
        
        self.user = ((IMUserModel *)responseObject).data;
        [self.tableView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.view removeLoadingBee];
        [self showDialogWithTitle:nil message:error.message];
    }];
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.user) {
        
    }
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 0;
}

@end
