//
//  ChatGroupMemberViewController.m
//  MomiaIOS
//
//  Created by Deng Jun on 15/12/7.
//  Copyright © 2015年 Deng Jun. All rights reserved.
//

#import "ChatGroupMemberViewController.h"
#import "IMGroupMemberModel.h"
#import "GroupMemberItemCell.h"
#import "CommonHeaderView.h"

static NSString *identifierGroupMemberItemCell = @"GroupMemberItemCell";

@interface ChatGroupMemberViewController ()

@property (nonatomic, strong) NSString *ids;
@property (nonatomic, strong) IMGroupMemberModel *model;

@end

@implementation ChatGroupMemberViewController

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
    [CommonHeaderView registerCellFromNibWithTableView:self.tableView];
    
    self.navigationItem.title = @"群成员";
    
    [self requestData];
}

- (void)requestData {
    if (self.model == nil) {
        [self.view showLoadingBee];
    }
    
    [[HttpService defaultService] GET:URL_APPEND_PATH(@"/im/group/member") parameters:@{@"id":self.ids} cacheType:CacheTypeDisable JSONModelClass:[IMGroupMemberModel class] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (self.model == nil) {
            [self.view removeLoadingBee];
        }
        
        self.model = responseObject;
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    User *user;
    if (indexPath.section == 0) {
        user = self.model.data.teachers[indexPath.row];
    } else {
        user = self.model.data.customers[indexPath.row];
    }
    NSString *url = [NSString stringWithFormat:@"userinfo?uid=%@", user.uid];
    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:MOURL_STRING(url)]];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.model) {
        return 2;
    }
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return self.model.data.teachers.count;
        
    } else {
        return self.model.data.customers.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GroupMemberItemCell *cell = [GroupMemberItemCell cellWithTableView:tableView forIndexPath:indexPath withIdentifier:identifierGroupMemberItemCell];
    User *user;
    if (indexPath.section == 0) {
        user = self.model.data.teachers[indexPath.row];
    } else {
        user = self.model.data.customers[indexPath.row];
    }
    cell.data = user;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 65;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    CommonHeaderView *header = [CommonHeaderView cellWithTableView:self.tableView];
    if (section == 0) {
        header.data = @"老师";
    } else {
        header.data = @"群成员";
    }
    return header;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}

@end
