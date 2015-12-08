//
//  ChatViewController.m
//  MomiaIOS
//
//  Created by Deng Jun on 15/12/2.
//  Copyright © 2015年 Deng Jun. All rights reserved.
//

#import "ChatViewController.h"

@interface ChatViewController ()

@end

@implementation ChatViewController

- (instancetype)initWithParams:(NSDictionary *)params {
    if (self = [super init]) {
        self.conversationType = [self convertType:[params objectForKey:@"type"]];
        self.targetId = [params objectForKey:@"targetid"];
        self.userName = [params objectForKey:@"username"];
        self.title = [params objectForKey:@"title"];
        if (self.conversationType == ConversationType_PRIVATE) {
            self.displayUserNameInCell = NO;
        }
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"TitleCamera"] style:UIBarButtonItemStylePlain target:self action:@selector(onTitleButtonClicked)];
}

- (void)onTitleButtonClicked {
    if (self.conversationType == ConversationType_GROUP) {
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:[NSString stringWithFormat:@"duola://groupmember?id=%@", self.targetId]]];
    }
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

@end
