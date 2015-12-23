//
//  ChatViewController.m
//  MomiaIOS
//
//  Created by Deng Jun on 15/12/2.
//  Copyright © 2015年 Deng Jun. All rights reserved.
//

#import "ChatViewController.h"
#import "AppDelegate.h"
#import "IMGroupModel.h"
#import "UILabel+ContentSize.h"
#import "GroupNoticeView.h"

@interface ChatViewController ()
@property (nonatomic, assign) BOOL isNoticeShow;
@property (nonatomic, strong) UIView *noticeView;
@end

@implementation ChatViewController

- (instancetype)initWithParams:(NSDictionary *)params {
    if (self = [super init]) {
        self.hidesBottomBarWhenPushed = YES;
        
        self.conversationType = [self convertType:[params objectForKey:@"type"]];
        self.targetId = [params objectForKey:@"targetid"];
        self.userName = [params objectForKey:@"username"];
        self.title = [params objectForKey:@"title"];
        if (self.conversationType == ConversationType_PRIVATE) {
            self.displayUserNameInCell = NO;
        }
        
        int unread = [[params objectForKey:@"unread"] intValue];
        if (unread > 10) {
            self.unReadMessage = unread;
            self.enableUnreadMessageIcon = YES;
            self.enableNewComingMessageIcon = YES;
        }
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.unReadMessageLabel.textColor = MO_APP_ThemeColor;
    self.unReadButton.titleLabel.textColor = MO_APP_ThemeColor;
    BOOL isGroup = self.conversationType == ConversationType_GROUP;
    if (isGroup) {
        [self initTitleBtn];
        
        UITapGestureRecognizer *singleTap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onTableClicked)];
        [self.conversationMessageCollectionView addGestureRecognizer:singleTap];
        
    } else {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"TitleUser"] style:UIBarButtonItemStylePlain target:self action:@selector(onUserClicked)];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBar.shadowImage = [UIImage imageNamed:@"BgTitleShadow"];
}

- (void)initTitleBtn {
    UIView *filterBtnView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 22, 35)];
    UIImageView *filterBtn = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 22, 22)];

    UITapGestureRecognizer *groupTap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onGroupMemberClicked)];
    [filterBtnView addGestureRecognizer:groupTap];
    
    [filterBtn setImage:[UIImage imageNamed:@"TitleGroup"]];
    [filterBtnView addSubview:filterBtn];
    [filterBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(filterBtnView);
        make.right.equalTo(filterBtnView.mas_right);
    }];
    UIBarButtonItem *btnFilter = [[UIBarButtonItem alloc] initWithCustomView:filterBtnView];
    
    UIView *selectBtnView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 35, 35)];
    UIImageView *selectBtn = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 22, 22)];
    [selectBtn setImage:[UIImage imageNamed:@"TitleNotice"]];
    
    UITapGestureRecognizer *noticeTap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onGroupNoticeClicked)];
    [selectBtnView addGestureRecognizer:noticeTap];
    
    [selectBtnView addSubview:selectBtn];
    [selectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(selectBtnView);
        make.centerX.equalTo(selectBtnView);
    }];
    UIBarButtonItem *btnSelect = [[UIBarButtonItem alloc] initWithCustomView:selectBtnView];
    
    [self.navigationItem setRightBarButtonItems:@[btnFilter, btnSelect] animated:YES];
}

- (void)onTableClicked {
    if (self.isNoticeShow) {
        [self hideGroupNotice];
    }
}

- (void)onGroupNoticeClicked {
    if (self.isNoticeShow) {
        [self hideGroupNotice];
    } else {
        [self showGroupNotice];
    }
}

- (void)showGroupNotice {
    if (self.noticeView == nil) {
        NSArray *arr = [[NSBundle mainBundle] loadNibNamed:@"GroupNoticeView" owner:self options:nil];
        GroupNoticeView *noticeView = [arr objectAtIndex:0];
        NSDictionary *dic = MO_SharedAppDelegate.imGroupDic;
        IMGroup *group = [dic objectForKey:self.targetId];
        noticeView.data = group;
        [self.view addSubview:noticeView];
        
        CGRect textFrame = [UILabel heightForMutableString:group.tips withWidth:(SCREEN_WIDTH - 20)  lineSpace:0 andFontSize:13.0];
        noticeView.width = SCREEN_WIDTH;
        noticeView.height = 34 * 4 + textFrame.size.height + 10;
        self.noticeView = noticeView;
    }
    
    self.noticeView.top = - self.noticeView.height;
    self.noticeView.alpha = 0.0;
    [UIView beginAnimations:@"" context:nil];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(showNoticeAnimEnd)];
    self.noticeView.top = 62;
    self.noticeView.alpha = 1.0;
    [UIView commitAnimations];
}

- (void)showNoticeAnimEnd {
    self.isNoticeShow = YES;
}

- (void)hideGroupNotice {
    if (self.noticeView == nil) {
        return;
    }
    [UIView beginAnimations:@"" context:nil];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(hideNoticeAnimEnd)];
    self.noticeView.top = - self.noticeView.height;
    self.noticeView.alpha = 0.0;
    [UIView commitAnimations];
}

- (void)hideNoticeAnimEnd {
    self.isNoticeShow = NO;
}

- (void)onGroupMemberClicked {
    NSString *url = [NSString stringWithFormat:@"groupmember?id=%@", self.targetId];
    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:MOURL_STRING(url)]];
}

- (void)onUserClicked {
    NSString *url = [NSString stringWithFormat:@"chatuser?id=%@", self.targetId];
    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:MOURL_STRING(url)]];
}

- (void)didTapCellPortrait:(NSString *)userId {
    NSString *url = [NSString stringWithFormat:@"chatuser?id=%@", userId];
    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:MOURL_STRING(url)]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (RCConversationType)convertType:(NSNumber *)type {
    if (type) {
        int typeInt = [type intValue];
        if (typeInt == 1) {
            return ConversationType_PRIVATE;
        }
    }
    return ConversationType_GROUP;
}

#pragma mark - Overwrite

/**
 *  打开大图。开发者可以重写，自己下载并且展示图片。默认使用内置controller
 *
 *  @param imageMessageContent 图片消息内容
 */
- (void)presentImagePreviewController:(RCMessageModel *)model;
{
    RCImagePreviewController *_imagePreviewVC =
    [[RCImagePreviewController alloc] init];
    _imagePreviewVC.messageModel = model;
    _imagePreviewVC.title = @"图片预览";
    
    UINavigationController *nav = [[UINavigationController alloc]
                                   initWithRootViewController:_imagePreviewVC];
    
    [self presentViewController:nav animated:YES completion:nil];
}

/**
 *  打开地理位置。开发者可以重写，自己根据经纬度打开地图显示位置。默认使用内置地图
 *
 *  @param locationMessageContent 位置消息
 */
- (void)presentLocationViewController:(RCLocationMessage *)locationMessageContent {
    [super presentLocationViewController:locationMessageContent];
}

/**
 *  点击pluginBoardView上item响应事件
 *
 *  @param pluginBoardView 功能模板
 *  @param tag             标记
 */
- (void)pluginBoardView:(RCPluginBoardView *)pluginBoardView clickedItemWithTag:(NSInteger)tag{
    switch (tag) {
        case PLUGIN_BOARD_ITEM_LOCATION_TAG: {
//            if (self.realTimeLocation) {
//                UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"发送位置", @"位置实时共享", nil];
//                [actionSheet showInView:self.view];
                
//                [super pluginBoardView:pluginBoardView clickedItemWithTag:tag];
//            } else {
//                [super pluginBoardView:pluginBoardView clickedItemWithTag:tag];
//            }
            [super pluginBoardView:pluginBoardView clickedItemWithTag:tag];
            
        } break;
        default:
            [super pluginBoardView:pluginBoardView clickedItemWithTag:tag];
            break;
    }
}

- (void)didTapMessageCell:(RCMessageModel *)model {
    [super didTapMessageCell:model];
    if ([model.content isKindOfClass:[RCTextMessage class]]) {
        NSString *pushData = ((RCTextMessage *)model.content).extra;
        if (pushData.length > 0 && [pushData containsString:MO_SCHEME]) {
            [[UIApplication sharedApplication]openURL:[NSURL URLWithString:pushData]];
        }
    }
}

@end
