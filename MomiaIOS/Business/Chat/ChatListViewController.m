//
//  ChatListViewController.m
//  MomiaIOS
//
//  Created by Deng Jun on 15/12/2.
//  Copyright © 2015年 Deng Jun. All rights reserved.
//

#import "ChatListViewController.h"
#import "NSString+MOURLEncode.h"
#import "UIImage+Color.h"
#import "IMUserGroupListModel.h"

@interface ChatListViewController ()
@property (nonatomic, strong) IMUserGroupListModel *groupList;
@end

@implementation ChatListViewController

- (instancetype)initWithParams:(NSDictionary *)params {
    if (self = [super init]) {
        self.hidesBottomBarWhenPushed = YES;
        
        //设置要显示的会话类型
        [self setDisplayConversationTypes:@[@(ConversationType_PRIVATE), @(ConversationType_GROUP)]];
        
        //聚合会话类型
//        [self setCollectionConversationType:@[@(ConversationType_GROUP),@(ConversationType_DISCUSSION)]];
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.conversationListTableView.separatorColor = MO_APP_SeparatorColor;
    self.conversationListTableView.tableFooterView = [UIView new];
    
    self.emptyConversationView = [self createEmptyView];
    self.emptyConversationView.hidden = YES;
    
    self.navigationItem.title = @"我的群组";
//    NSArray *segmentedArray = @[@"消息",@"群组"];
//    UISegmentedControl *segmentedControl = [[UISegmentedControl alloc]initWithItems:segmentedArray];
//    segmentedControl.frame = CGRectMake(0.0, 0.0, 150, 30.0);
//    segmentedControl.selectedSegmentIndex = 0;
//    segmentedControl.tintColor = MO_APP_ThemeColor;
//    segmentedControl.segmentedControlStyle = UISegmentedControlStyleBar;
//    [segmentedControl addTarget:self  action:@selector(indexDidChangeForSegmentedControl:)
//               forControlEvents:UIControlEventValueChanged];
//    [self.navigationItem setTitleView:segmentedControl];
    
    [self syncGroupList];
    [self.view showLoadingBee];
}

- (UIView *)createEmptyView {
    UIView *emptyView = [[UIView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH - 200)/2, 150, 200, 80)];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 140, 80)];
    label.text = @"还没有开通群组哦，快去选课吧~";
    label.textColor =  UIColorFromRGB(0x999999);
    label.font = [UIFont systemFontOfSize:14];
    label.textAlignment = NSTextAlignmentLeft;
    label.numberOfLines = 0;
    
    UIImageView *logoIv = [[UIImageView alloc]initWithFrame:CGRectMake(0, 10, 60, 60)];
    logoIv.image = [UIImage imageNamed:@"IconCircleLogo"];
    
    [emptyView addSubview:logoIv];
    [emptyView addSubview:label];
    
    [logoIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@60);
        make.height.equalTo(@60);
        make.left.equalTo(emptyView.mas_left);
        make.centerY.equalTo(emptyView.mas_centerY);
    }];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(logoIv.mas_right).offset(10);
        make.right.equalTo(emptyView.mas_right);
        make.centerY.equalTo(logoIv.mas_centerY);
    }];
    
    return emptyView;
}

- (void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBar.shadowImage = [UIImage imageNamed:@"BgTitleShadow"];
}

- (void)didReceiveMessageNotification:(NSNotification *)notification {
    [self refreshConversationTableViewIfNeeded];
}

- (void)indexDidChangeForSegmentedControl:(UISegmentedControl *)paramSender {
    //获得索引位置
//    NSInteger selectedSegmentIndex = [paramSender selectedSegmentIndex];
}

- (void)syncGroupList {
    [[HttpService defaultService] GET:URL_APPEND_PATH(@"/im/user/group") parameters:nil cacheType:CacheTypeDisable JSONModelClass:[IMUserGroupListModel class] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        self.groupList = responseObject;
        [self.view removeLoadingBee];
        if (self.groupList.data.count == 0) {
            self.emptyConversationView.hidden = NO;
        }
        [self refreshConversationTableViewIfNeeded];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    }];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

//插入自定义会话model
-(NSMutableArray *)willReloadTableData:(NSMutableArray *)dataSource
{
    if(self.groupList) {
        for (IMUserGroup *group in self.groupList.data) {
            BOOL hasGroup = NO;
            for (int i = 0; i < dataSource.count; i++) {
                RCConversationModel *model = dataSource[i];
                if (model.conversationType == ConversationType_GROUP && [model.targetId isEqualToString:[group.groupId stringValue]]) {
                    hasGroup = YES;
                    continue;
                }
            }
            
            if (!hasGroup) {
                RCConversation *con = [[RCConversation alloc] init];
                con.targetId = [group.groupId stringValue];
                con.conversationTitle = group.groupName;
//                con.lastestMessage = [RCTextMessage messageWithContent:group.tips];
                
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                NSDate *date = [dateFormatter dateFromString:group.addTime];
                NSTimeZone *zone = [NSTimeZone systemTimeZone];
                NSInteger interval = [zone secondsFromGMTForDate: date];
                NSDate *localeDate = [date  dateByAddingTimeInterval: interval];
                
                con.sentTime = [localeDate timeIntervalSince1970] * 1000;
                con.receivedTime = [localeDate timeIntervalSince1970] * 1000;
                
                con.conversationType = ConversationType_GROUP;
                RCConversationModel *model = [[RCConversationModel alloc] init:RC_CONVERSATION_MODEL_TYPE_NORMAL conversation:con extend:@""];
                [dataSource addObject:model];
            }
        }
    }
    
    return dataSource;
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

//重载函数，onSelectedTableRow 是选择会话列表之后的事件，该接口开放是为了便于您自定义跳转事件。在快速集成过程中，您只需要复制这段代码。
-(void)onSelectedTableRow:(RCConversationModelType)conversationModelType conversationModel:(RCConversationModel *)model atIndexPath:(NSIndexPath *)indexPath
{
    NSNumber *type = [self convertType:model.conversationType];
    if (type && ([type intValue] == 6 || [type intValue] == 8 || [type intValue] == 9)) {
        NSString *uName = [model.senderUserName URLEncodedString];
        NSString *title = [model.conversationTitle URLEncodedString];
        
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:[NSString stringWithFormat:@"duola://chatpublic?type=%@&targetid=%@&username=%@&title=%@", [self convertType:model.conversationType], model.targetId, uName, title]]];
        
    } else if (type && ([type intValue] == 1 || [type intValue] == 3)) {
        NSString *uName = [model.senderUserName URLEncodedString];
        NSString *title = [model.conversationTitle URLEncodedString];
        
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:[NSString stringWithFormat:@"duola://chat?type=%@&targetid=%@&username=%@&title=%@&unread=%ld", [self convertType:model.conversationType], model.targetId, uName, title, (long)model.unreadMessageCount]]];
        
    } else {
        RCConversationViewController *_conversationVC = [[RCConversationViewController alloc]init];
        _conversationVC.conversationType = model.conversationType;
        _conversationVC.targetId = model.targetId;
        _conversationVC.userName = model.conversationTitle;
        _conversationVC.title = model.conversationTitle;
//        _conversationVC.conversation = model;
        _conversationVC.unReadMessage = model.unreadMessageCount;
        _conversationVC.enableNewComingMessageIcon=YES;//开启消息提醒
        _conversationVC.enableUnreadMessageIcon=YES;
        [self.navigationController pushViewController:_conversationVC animated:YES];
    }
    [self.conversationListTableView deselectRowAtIndexPath:indexPath animated:YES];
    
    // 清掉未读
    [[RCIMClient sharedRCIMClient] clearMessagesUnreadStatus:model.conversationType targetId:model.targetId];
    [self refreshConversationTableViewIfNeeded];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"onMineDotChanged" object:nil];
}

- (NSNumber *)convertType:(RCConversationType)type {
    if (type == ConversationType_PRIVATE) {
        return [NSNumber numberWithInt:1];
    }
    if (type == ConversationType_GROUP) {
        return [NSNumber numberWithInt:3];
    }
    if (type == ConversationType_SYSTEM) {
        return [NSNumber numberWithInt:6];
    }
    if (type == ConversationType_PUBLICSERVICE) {
        return [NSNumber numberWithInt:8];
    }
    if (type == ConversationType_PUSHSERVICE) {
        return [NSNumber numberWithInt:9];
    }
    
    return nil;
}

@end
