//
//  ChatUserViewController.m
//  MomiaIOS
//
//  Created by Deng Jun on 15/12/7.
//  Copyright © 2015年 Deng Jun. All rights reserved.
//

#import "ChatUserViewController.h"
#import "IMUserModel.h"
#import "GroupMemberItemCell.h"
#import "ChatUserFeedPhotoCell.h"

static NSString *identifierGroupMemberItemCell = @"GroupMemberItemCell";
static NSString *identifierChatUserFeedPhotoCell = @"ChatUserFeedPhotoCell";

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
    
    self.navigationItem.title = @"用户信息";
    
    [GroupMemberItemCell registerCellFromNibWithTableView:self.tableView withIdentifier:identifierGroupMemberItemCell];
    [ChatUserFeedPhotoCell registerCellFromClassWithTableView:self.tableView withIdentifier:identifierChatUserFeedPhotoCell];
    
    [self requestData];
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

- (void)onSendMsgClicked:(id)sender {
    [self openURL:[NSString stringWithFormat:@"chat?type=1&targetid=%@&username=%@&title=%@", self.user.uid, self.user.nickName, self.user.nickName]];
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
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 1) {
        [self openURL:[NSString stringWithFormat:@"userinfo?uid=%@", self.user.uid]];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.user) {
        return 2;
    }
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 65;
    } else {
        return [ChatUserFeedPhotoCell heightWithTableView:tableView withIdentifier:identifierChatUserFeedPhotoCell forIndexPath:indexPath data:nil];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    if (indexPath.section == 0) {
        GroupMemberItemCell *userCell = [GroupMemberItemCell cellWithTableView:tableView forIndexPath:indexPath withIdentifier:identifierGroupMemberItemCell];
        userCell.data = self.user;
        cell = userCell;
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    } else {
        ChatUserFeedPhotoCell *feedCell = [ChatUserFeedPhotoCell cellWithTableView:tableView forIndexPath:indexPath withIdentifier:identifierChatUserFeedPhotoCell];
        feedCell.data = self.user.imgs;
        cell = feedCell;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view = [UIView new];
    BOOL hasRole = (self.user && [self.user.role intValue] > 1) || ([[AccountService defaultService].account.role intValue] > 1);
    BOOL isMe = [self.user.uid intValue] == [[AccountService defaultService].account.uid intValue];
    
    if (!isMe && hasRole && section == [self numberOfSectionsInTableView:tableView] - 1) {
        UIButton *button = [[UIButton alloc]init];
        button.height = 40;
        button.width = 280;
        button.left = (SCREEN_WIDTH - button.width) / 2;
        button.top = 30;
        [button setTitle:@"发起会话" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(onSendMsgClicked:) forControlEvents:UIControlEventTouchUpInside];
        [button setBackgroundImage:[UIImage imageNamed:@"BgLargeButtonNormal"] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"BgLargeButtonDisable"] forState:UIControlStateDisabled];
        
        [view addSubview:button];
    }
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == [self numberOfSectionsInTableView:tableView] - 1) {
        return 80;
    }
    return 0.1;
}

@end
