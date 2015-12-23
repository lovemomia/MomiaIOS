//
//  ThirdPersonViewController.m
//  MomiaIOS
//
//  Created by Deng Jun on 15/11/11.
//  Copyright © 2015年 Deng Jun. All rights reserved.
//

#import "UserInfoViewController.h"
#import "UserInfoHeaderView.h"
#import "UserTimelineModel.h"
#import "UploadImageModel.h"
#import "AccountModel.h"

#import "UserTimelineCell.h"


static NSString *identifierUserTimelineCell = @"UserTimelineCell";

@interface UserInfoViewController ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate>

@property (nonatomic, strong) NSNumber *uid;
@property (nonatomic, assign) BOOL isMe;

@property(nonatomic,strong) NSMutableDictionary * contentCellHeightCacheDic;
@property (nonatomic, strong) User *user;
@property (nonatomic, strong) NSMutableArray *list;
@property (nonatomic, assign) BOOL isLoading;
@property (nonatomic, assign) BOOL isEmpty;
@property (nonatomic, assign) NSInteger totalCount;
@property (nonatomic, strong) NSNumber *nextIndex;
@property (nonatomic, strong) AFHTTPRequestOperation * curOperation;

@end

@implementation UserInfoViewController

- (instancetype)initWithParams:(NSDictionary *)params {
    if (self = [super initWithParams:params]) {
        self.uid = [params objectForKey:@"uid"];
        self.isMe = [[params objectForKey:@"me"]boolValue];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = self.isMe ? @"我的评价" : @"Ta的动态";
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    
    [UserTimelineCell registerCellFromNibWithTableView:self.tableView withIdentifier:identifierUserTimelineCell];
    
    self.list = [NSMutableArray new];
    self.nextIndex = 0;
    [self requestData:true];
}

- (void)requestData:(BOOL)refresh {
    if(self.curOperation) {
        [self.curOperation pause];
    }
    
    if ([self.list count] == 0) {
        [self.view showLoadingBee];
    }
    
    if (refresh) {
        self.nextIndex = [NSNumber numberWithInt:0];
        self.isLoading = NO;
        [self.view removeEmptyView];
    }
    
    NSString *path = self.isMe ? @"/user/comment/timeline" : @"/user/timeline";
    NSDictionary * paramDic = @{@"uid":self.uid, @"start":[NSString stringWithFormat:@"%@", self.nextIndex]};
    self.curOperation = [[HttpService defaultService]GET:URL_APPEND_PATH(path)
                                              parameters:paramDic cacheType:CacheTypeDisable JSONModelClass:[UserTimelineModel class]
                                                 success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                                     if ([self.list count] == 0) {
                                                         [self.view removeLoadingBee];
                                                     }
                                                     
                                                     UserTimelineModel *model = (UserTimelineModel *)responseObject;
                                                     if (model.data.timeline.nextIndex) {
                                                         self.nextIndex = model.data.timeline.nextIndex;
                                                     } else {
                                                         self.nextIndex = [NSNumber numberWithInt:-1];
                                                     }
                                                     
                                                     if (model.data.user) {
                                                         self.user = model.data.user;
                                                         [self setTitleBtn];
                                                     }
                                                     
                                                     if ([model.data.timeline.totalCount isEqualToNumber:[NSNumber numberWithInt:0]]) {
                                                         self.isEmpty = YES;
                                                         [self.tableView reloadData];
                                                         return;
                                                     }
                                                     
                                                     if (refresh) {
                                                         [self.list removeAllObjects];
                                                     }
                                                     for (UserTimelineItem *tl in model.data.timeline.list) {
                                                         [self.list addObject:tl];
                                                     }
                                                     [self.tableView reloadData];
                                                     self.isLoading = NO;
                                                 }
                         
                                                 failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                                     if ([self.list count] == 0) {
                                                         [self.view removeLoadingBee];
                                                     }
                                                     [self showDialogWithTitle:nil message:error.message];
                                                     self.isLoading = NO;
                                                 }];
}

- (void)setTitleBtn {
    BOOL hasRole = (self.user && [self.user.role intValue] > 1) || ([[AccountService defaultService].account.role intValue] > 1);
    BOOL isMe = [self.user.uid intValue] == [[AccountService defaultService].account.uid intValue];
    
    if (!isMe && hasRole) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"发起对话" style:UIBarButtonItemStylePlain target:self action:@selector(onChatClicked)];
    }
}

- (void)onChatClicked {
    [self openURL:[NSString stringWithFormat:@"chat?type=1&targetid=%@&username=%@&title=%@", self.user.uid, self.user.nickName, self.user.nickName]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)isNavTransparent {
    return NO;
}

- (BOOL)isNavDarkStyle {
    return NO;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (UITableViewStyle)tableViewStyle {
    return UITableViewStyleGrouped;
}

- (UITableViewCellSeparatorStyle)tableViewCellSeparatorStyle {
    return UITableViewCellSeparatorStyleNone;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.user) {
        return 1;
    }
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.list.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    UserTimelineItem *tl = self.list[indexPath.row];
    return [UserTimelineCell heightWithTableView:tableView withIdentifier:identifierUserTimelineCell forIndexPath:indexPath data:tl];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return SCREEN_WIDTH * 2 / 3;
    }
    return 0.1f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        NSArray *arr = [[NSBundle mainBundle] loadNibNamed:@"UserInfoHeaderView" owner:self options:nil];
        UserInfoHeaderView *headerView = [arr objectAtIndex:0];
        [headerView setData:self.user];
        if (self.isMe) {
            UITapGestureRecognizer *singleTap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onCoverClicked:)];
            [headerView addGestureRecognizer:singleTap];
        }
        return headerView;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (self.isEmpty) {
        return 50;
    }
    return 0.1;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
    if (self.isEmpty) {
        [view showEmptyView:@"还没有任何状态哦~"];
        return view;
    }
    if ([self.nextIndex intValue] > 0) {
        [view showLoadingBee];
        if(!self.isLoading) {
            [self requestData:false];
            self.isLoading = YES;
        }
        return view;
    }
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    UserTimelineItem *tl = [self.list objectAtIndex:indexPath.row];
    UserTimelineCell *tlCell = [UserTimelineCell cellWithTableView:tableView forIndexPath:indexPath withIdentifier:identifierUserTimelineCell];
    tlCell.data = tl;
    cell = tlCell;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

#pragma mark - cover select

- (void)onCoverClicked:(UITapGestureRecognizer *)tap  {
    UIActionSheet* actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:@"更改封面"
                                  delegate:self
                                  cancelButtonTitle:@"取消"
                                  destructiveButtonTitle:nil
                                  otherButtonTitles:@"照相机", @"本地相簿",nil];
    [actionSheet showInView:self.view];
}

#pragma mark -
#pragma UIActionSheet Delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == 0) {
        switch (buttonIndex) {
            case 0://照相机
            {
                UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
                imagePicker.delegate = self;
                imagePicker.allowsEditing = YES;
                imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
                //            [self presentModalViewController:imagePicker animated:YES];
                [self presentViewController:imagePicker animated:YES completion:nil];
            }
                break;
                
            case 1://本地相簿
            {
                UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
                imagePicker.delegate = self;
                imagePicker.allowsEditing = YES;
                imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                //            [self presentModalViewController:imagePicker animated:YES];
                [self presentViewController:imagePicker animated:YES completion:nil];
            }
                break;
                
            default:
                break;
        }
    }
}

#pragma mark -
#pragma UIImagePickerController Delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    if ([[info objectForKey:UIImagePickerControllerMediaType] isEqualToString:(__bridge NSString *)kUTTypeImage]) {
        UIImage *img = [info objectForKey:UIImagePickerControllerEditedImage];
        [self performSelector:@selector(saveImage:)  withObject:img afterDelay:0.5];
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    //    [picker dismissModalViewControllerAnimated:YES];
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)saveImage:(UIImage *)image {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *imageFilePath = [documentsDirectory stringByAppendingPathComponent:@"selfPhoto.jpg"];
    
    //scale
    CGSize size = image.size;
    if (image.size.width > 640) {
        size.width = 640;
    }
    if (image.size.height > 640 * image.size.height / image.size.width) {
        size.height = 640 * image.size.height / image.size.width;
    }
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0,0,size.width,size.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    [UIImageJPEGRepresentation(newImage, 1.0f) writeToFile:imageFilePath atomically:YES];
    
    //上传
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [[HttpService defaultService] uploadImageWithFilePath:imageFilePath fileName:@"selfPhoto.jpg" handler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (error) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [self showDialogWithTitle:nil message:@""];
            
        } else {
            UploadImageData *data = ((UploadImageModel *)responseObject).data;
            NSDictionary *params = @{@"cover":data.path};
            [[HttpService defaultService]POST:URL_APPEND_PATH(@"/user/cover") parameters:params JSONModelClass:[AccountModel class] success:^(AFHTTPRequestOperation *operation, id responseObject) {
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                
                AccountModel *result = (AccountModel *)responseObject;
                [AccountService defaultService].account = result.data;
//                [self.tableView reloadData];
                [self requestData:YES];
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                [self showDialogWithTitle:nil message:error.message];
            }];
        }
    }];
    
}


@end
