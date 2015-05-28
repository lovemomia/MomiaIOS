//
//  PersonInfoViewController.m
//  MomiaIOS
//
//  Created by Owen on 15/5/12.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import "PersonInfoViewController.h"
#import "UploadImageModel.h"
#import "AccountModel.h"
#import "DatePickerSheet.h"

@interface PersonInfoViewController ()<UIAlertViewDelegate, DatePickerSheetDelegate>

@property (nonatomic, strong) UIImageView *userIcon;
@property (nonatomic, strong) UITableViewCell *nickCell;
@property (nonatomic, strong) UITableViewCell *babyAgeCell;
@property (nonatomic, strong) UITableViewCell *addressCell;

@end

@implementation PersonInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"个人信息";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"退出登录" style:UIBarButtonItemStyleDone target:self action:@selector(onLogoutClicked:)];
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

#pragma mark - tableview delegate & datasource

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if (indexPath.section == 0) {
//        return 59;
//    }
//    return 44;
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0 || section == 2) {
        return 1;
    } else if (section == 1) {
        return 3;
    } else return 2;
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view = [super tableView:tableView viewForFooterInSection:section];
    if (section == 2) {
        UIButton *logoutButton = [[UIButton alloc]init];
        logoutButton.height = 45;
        logoutButton.width = SCREEN_WIDTH - 2 * 18;
        logoutButton.left = 18;
        logoutButton.top = 30;
        [logoutButton setTitle:@"退出登录" forState:UIControlStateNormal];
        [logoutButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [logoutButton addTarget:self action:@selector(onLogoutClicked:) forControlEvents:UIControlEventTouchUpInside];
        [logoutButton setBackgroundImage:[UIImage imageNamed:@"bg_button"] forState:UIControlStateNormal];
        [view addSubview:logoutButton];
    }
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 3) {
        return 80;
    }
    return [super tableView:tableView heightForFooterInSection:section];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0) {
        [self takePictureClick];
        
    } else if (indexPath.section == 1) {
        NSString *title;
        int tag;
        if (indexPath.row == 0) {
            title = @"昵称";
            tag = 0;
            
        } else if (indexPath.row == 1) {
            title = @"宝宝年龄";
            tag = 1;
            [self showDatePicker];
            return;
            
        } else if (indexPath.row == 2) {
            title = @"常住地";
            tag = 2;
            
        }
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:[NSString stringWithFormat:@"修改%@", title] message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认修改", nil];
        alert.alertViewStyle = UIAlertViewStylePlainTextInput;
        alert.tag = tag;
        [alert show];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    Account *account = [AccountService defaultService].account;
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    static NSString *CellDefault = @"DefaultCell";
    static NSString *CellLogo = @"LogoCell";
    UITableViewCell *cell;
    if (section == 0) {
        cell = [tableView dequeueReusableCellWithIdentifier:CellLogo];
        if (cell == nil) {
            NSArray *arr = [[NSBundle mainBundle] loadNibNamed:@"PersonLogoCell" owner:self options:nil];
            cell = [arr objectAtIndex:0];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        
        self.userIcon = (UIImageView *)[cell viewWithTag:1];
        [self.userIcon sd_setImageWithURL:[NSURL URLWithString:account.picUrl]];
        
    } else {
        cell = [tableView dequeueReusableCellWithIdentifier:CellDefault];
        if (cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellDefault];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        
        switch (section) {
            case 1:
                if (row == 0) {
                    cell.textLabel.text = @"昵称";
                    cell.detailTextLabel.text = account.nickName;
                    self.nickCell = cell;
                    
                } else if(row == 1){
                    cell.textLabel.text = @"宝宝年龄";
                    cell.detailTextLabel.text = account.babyAge;
                    self.babyAgeCell = cell;
                    
                } else {
                    cell.textLabel.text = @"常住地";
                    cell.detailTextLabel.text = account.address;
                    self.addressCell = cell;
                }
                break;
            case 2:
                if (row == 0) {
                    cell.textLabel.text = @"手机号";
                    cell.detailTextLabel.text = account.phone;
                    cell.accessoryType = UITableViewCellAccessoryNone;
                    
                } else {
                    cell.textLabel.text = @"第三方账号绑定";
                    cell.detailTextLabel.text = account.wechatNo;
                }
                break;
            case 3:
                cell.textLabel.text = @"修改密码";
            default:
                break;
        }
    }
    return cell;
}


- (IBAction)onLogoutClicked:(id)sender {
    [AccountService defaultService].account = nil;
    [self.navigationController popToRootViewControllerAnimated:YES];
}

//弹出actionsheet。选择获取头像的方式
//从相册获取图片
-(void)takePictureClick
{
    UIActionSheet* actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:@"请选择图片来源"
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
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *imageFilePath = [documentsDirectory stringByAppendingPathComponent:@"selfPhoto.jpg"];
    NSLog(@"imageFile->>%@",imageFilePath);
    BOOL exists = [fileManager fileExistsAtPath:imageFilePath];
    if(exists) {
        exists = [fileManager removeItemAtPath:imageFilePath error:&error];
    }
    
    //scale
    CGSize size = CGSizeMake(100, 100);
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
            NSDictionary *params = @{@"picurl":data.path};
            [[HttpService defaultService]POST:URL_APPEND_PATH(@"/user/pic") parameters:params JSONModelClass:[AccountModel class] success:^(AFHTTPRequestOperation *operation, id responseObject) {
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                
                AccountModel *result = (AccountModel *)responseObject;
                [AccountService defaultService].account = result.data;
                [self.tableView reloadData];
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                [self showDialogWithTitle:nil message:@"更新用户头像失败，请稍后再试"];
            }];
        }
    }];

}

- (void)alertView:(UIAlertView*)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 0) {
        if (buttonIndex == 1) { //修改昵称
            //得到输入框
            UITextField *tf=[alertView textFieldAtIndex:0];
            
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            NSDictionary *params = @{@"nickname" : tf.text};
            [[HttpService defaultService]POST:URL_APPEND_PATH(@"/user/nickname") parameters:params JSONModelClass:[AccountModel class] success:^(AFHTTPRequestOperation *operation, id responseObject) {
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                AccountModel *result = (AccountModel *)responseObject;
                [AccountService defaultService].account = result.data;
                [self.tableView reloadData];
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                [self showDialogWithTitle:nil message:error.message];
            }];
        }
        
    } else if (alertView.tag == 2) { //修改常住地
        if (buttonIndex == 1) {
            //得到输入框
            UITextField *tf=[alertView textFieldAtIndex:0];
            
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            NSDictionary *params = @{@"address" : tf.text};
            [[HttpService defaultService]POST:URL_APPEND_PATH(@"/user/address") parameters:params JSONModelClass:[AccountModel class] success:^(AFHTTPRequestOperation *operation, id responseObject) {
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                AccountModel *result = (AccountModel *)responseObject;
                [AccountService defaultService].account = result.data;
                [self.tableView reloadData];
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                [self showDialogWithTitle:nil message:error.message];
            }];
        }
    }
}

- (void)showDatePicker {
    DatePickerSheet * datePickerSheet = [DatePickerSheet getInstance];
    [datePickerSheet initializationWithMaxDate:nil
                                   withMinDate:nil
                            withDatePickerMode:UIDatePickerModeDate
                                  withDelegate:self];
    [datePickerSheet showDatePickerSheet];
}

#pragma mark - DatePickerSheetDelegate method
- (void) datePickerSheet:(DatePickerSheet*)datePickerSheet chosenDate:(NSDate*)date
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd";
    NSString *dateString = [formatter stringFromDate:date];
    NSLog(@"dateString:%@", dateString);
    
    [self updateBabyDate:dateString];
}

- (void)updateBabyDate:(NSString *)date {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSDictionary *params = @{@"babydate" : (date == nil ? @"":date)};
    [[HttpService defaultService]POST:URL_APPEND_PATH(@"/user/babydate")
                           parameters:params JSONModelClass:[AccountModel class]
                              success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                  [MBProgressHUD hideHUDForView:self.view animated:YES];
                                  AccountModel *result = (AccountModel *)responseObject;
                                  [AccountService defaultService].account = result.data;
                                  [self.tableView reloadData];
                              }
     
                              failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                  [MBProgressHUD hideHUDForView:self.view animated:YES];
                                  [self showDialogWithTitle:nil message:error.message];
                              }];
}

@end
