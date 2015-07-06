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
#import "UIImage+Color.h"
#import "CommonHeaderView.h"
#import "Child.h"
#import "PersonChildHeaderCell.h"

@interface PersonInfoViewController ()<UIAlertViewDelegate, DatePickerSheetDelegate, UIActionSheetDelegate>

@property (nonatomic, strong) UIImageView *userIcon;
@property (nonatomic, strong) UITableViewCell *nickCell;
@property (nonatomic, strong) UITableViewCell *babyAgeCell;
@property (nonatomic, strong) UITableViewCell *addressCell;

@property (nonatomic, strong) MOStepperView *stepperView;

@end

@implementation PersonInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"个人信息";
    
    [CommonHeaderView registerCellWithTableView:self.tableView];
    [PersonChildHeaderCell registerCellWithTableView:self.tableView];
    
    [self refreshAccount];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (Child *)childAtIndex:(NSInteger)index {
    Account *account = [AccountService defaultService].account;
    return [account.children objectAtIndex:index];
}

- (void)refreshAccount {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [[HttpService defaultService]GET:URL_APPEND_PATH(@"/user")
                          parameters:nil cacheType:CacheTypeDisable JSONModelClass:[AccountModel class]
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

- (void)addChild {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSMutableArray *babyArray = [[NSMutableArray alloc] init];
    Child *baby = [[Child alloc]init];
    baby.name = [self defaultChildName:[AccountService defaultService].account.children.count];
    baby.sex = @"男";
    baby.birthday = @"2015-07-01";
    [babyArray addObject:[baby toNSDictionary]];
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:babyArray options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];

    NSDictionary *params = @{@"children" : jsonString};
    [[HttpService defaultService]POST:URL_APPEND_PATH(@"/user/child")
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

- (void)deleteChild {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    Account *account = [AccountService defaultService].account;
    Child *child = [account.children objectAtIndexedSubscript:(account.children.count - 1)];
    
    NSDictionary *params = @{@"cid" : [NSString stringWithFormat:@"%@", child.ids]};
    [[HttpService defaultService]POST:URL_APPEND_PATH(@"/user/child/delete")
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - tableview delegate & datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 3;
    } else if (section == 1) {
        return 2;
    } else if (section == 2) {
        return 3;
    } else return 3;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    Account *account = [AccountService defaultService].account;
    return 2 + [account.children count];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *header;
    if (section == 0) {
        header = [CommonHeaderView cellWithTableView:self.tableView];
        ((CommonHeaderView * )header).data = @"个人信息";
    } else if (section == 2) {
        Account *account = [AccountService defaultService].account;
        header = [PersonChildHeaderCell cellWithTableView:self.tableView];
        
        ((PersonChildHeaderCell *)header).titleLabel.text = [NSString stringWithFormat:@"孩子信息（%d个）", (int)[account.children count]];
        ((PersonChildHeaderCell *)header).stepperView.currentValue = [account.children count];
        ((PersonChildHeaderCell *)header).stepperView.minValue = 1;
        ((PersonChildHeaderCell *)header).stepperView.maxValue = 5;
        ((PersonChildHeaderCell *)header).stepperView.onclickStepper = ^(NSUInteger currentValue){//单击+、-事件响应
            Account *account = [AccountService defaultService].account;
            if (currentValue < account.children.count) {
                [self deleteChild];
            } else {
                [self addChild];
            }
        };
    }
    return header;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0 || section == 2) {
        return 50;
    }
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view = [UIView new];
    if (section == [self numberOfSectionsInTableView:tableView] - 1) {
        UIButton *button = [[UIButton alloc]init];
        button.height = 40;
        button.width = 280;
        button.left = (SCREEN_WIDTH - button.width) / 2;
        button.top = 30;
        [button setTitle:@"退出登录" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(onLogoutClicked:) forControlEvents:UIControlEventTouchUpInside];
        [button setBackgroundImage:[UIImage imageNamed:@"cm_large_button_normal"] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"cm_large_button_disable"] forState:UIControlStateDisabled];
        
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSString *title;
    NSInteger tag;
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    if (indexPath.section == 0) {
        if (row == 0) {
            [self takePictureClick];
            return;
        } else if (row == 1) {
            title = @"昵称";
            tag = 0;
        }
        
    } else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            title = @"性别";
            [self showSexPicker:1];
            return;
            
        } else if (indexPath.row == 1) {
            title = @"常住地";
            tag = 1;
        }
        
    } else {
        if (indexPath.row == 0) {
            title = @"姓名";
            tag = section;
        } else if (indexPath.row == 1) {
            title = @"性别";
            [self showSexPicker:(section)];
            return;
        } else if (indexPath.row == 2) {
            title = @"生日";
            [self showDatePicker:(section)];
            return;
        }
    }
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:[NSString stringWithFormat:@"修改%@", title] message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认修改", nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    alert.tag = tag;
    [alert show];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    Account *account = [AccountService defaultService].account;
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    static NSString *CellDefault = @"DefaultCell";
    static NSString *CellLogo = @"LogoCell";
    UITableViewCell *cell;
    if (section == 0 && row == 0) {
        cell = [tableView dequeueReusableCellWithIdentifier:CellLogo];
        if (cell == nil) {
            NSArray *arr = [[NSBundle mainBundle] loadNibNamed:@"PersonLogoCell" owner:self options:nil];
            cell = [arr objectAtIndex:0];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        
        self.userIcon = (UIImageView *)[cell viewWithTag:1];
        [self.userIcon sd_setImageWithURL:[NSURL URLWithString:account.avatar]];
        
    } else {
        cell = [tableView dequeueReusableCellWithIdentifier:CellDefault];
        if (cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellDefault];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        
        if (section == 0) {
            if (row == 1) {
                cell.textLabel.text = @"昵称";
                cell.detailTextLabel.text = account.nickName;
                self.nickCell = cell;
                
            } else {
                cell.textLabel.text = @"手机号";
                cell.detailTextLabel.text = account.mobile;
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
            
        } else if (section == 1) {
            if (row == 0) {
                cell.textLabel.text = @"性别";
                cell.detailTextLabel.text = account.sex;
                
            } else {
                cell.textLabel.text = @"常住地";
                cell.detailTextLabel.text = account.address;
                self.addressCell = cell;
            }
            
        } else {
            Child *child = [self childAtIndex:(section - 2)];
            if (row == 0) {
                NSInteger index = section - 2;
                if (section == 2) {
                    cell.textLabel.text = [NSString stringWithFormat:@"%@姓名", [self defaultChildName:index]];
                    cell.detailTextLabel.text = child.name;
                }
                
            } else if (row == 1) {
                cell.textLabel.text = @"性别";
                cell.detailTextLabel.text = child.sex;
            } else if (row == 2) {
                cell.textLabel.text = @"生日";
                cell.detailTextLabel.text = child.birthday;
            }
        }
    }
    return cell;
}

- (NSString *)defaultChildName:(NSInteger)index {
    if (index < 0 || index > 4) {
        return @"宝宝";
    }
    NSArray *baby = [NSArray arrayWithObjects:@"大宝", @"二宝", @"三宝", @"四宝", @"五宝", nil];
    return [baby objectAtIndex:index];
}


- (void)onLogoutClicked:(id)sender {
    [[AccountService defaultService] logout:self];
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
    } else if (actionSheet.tag == 1) {
        NSString * sex = buttonIndex == 0 ? @"男" : @"女";
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        NSDictionary *params = @{@"sex" : sex};
        [[HttpService defaultService]POST:URL_APPEND_PATH(@"/user/sex") parameters:params JSONModelClass:[AccountModel class] success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            AccountModel *result = (AccountModel *)responseObject;
            [AccountService defaultService].account = result.data;
            [self.tableView reloadData];
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [self showDialogWithTitle:nil message:error.message];
        }];
        
    } else {
        Child *child = [self childAtIndex:(actionSheet.tag - 2)];
        NSString * sex = buttonIndex == 0 ? @"男" : @"女";
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        NSDictionary *params = @{@"cid":child.ids, @"sex" : sex};
        [[HttpService defaultService]POST:URL_APPEND_PATH(@"/user/child/sex") parameters:params JSONModelClass:[AccountModel class] success:^(AFHTTPRequestOperation *operation, id responseObject) {
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
            NSDictionary *params = @{@"avatar":data.path};
            [[HttpService defaultService]POST:URL_APPEND_PATH(@"/user/avatar") parameters:params JSONModelClass:[AccountModel class] success:^(AFHTTPRequestOperation *operation, id responseObject) {
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
        
    } else if (alertView.tag == 1) { //修改常住地
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
    } else {
        if (buttonIndex == 1) {
            //得到输入框
            UITextField *tf=[alertView textFieldAtIndex:0];
            
            Child *child = [self childAtIndex:(alertView.tag - 2)];
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            NSDictionary *params = @{@"cid":child.ids, @"name" : tf.text};
            [[HttpService defaultService]POST:URL_APPEND_PATH(@"/user/child/name") parameters:params JSONModelClass:[AccountModel class] success:^(AFHTTPRequestOperation *operation, id responseObject) {
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

- (void)showDatePicker:(NSInteger)tag {
    DatePickerSheet * datePickerSheet = [DatePickerSheet getInstance];
    [datePickerSheet initializationWithMaxDate:nil
                                   withMinDate:nil
                            withDatePickerMode:UIDatePickerModeDate
                                  withDelegate:self];
    datePickerSheet.tag = tag;
    [datePickerSheet showDatePickerSheet];
}

#pragma mark - sex picker

-(void)showSexPicker:(NSInteger)tag {
    UIActionSheet *sexSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:@"男",@"女",nil];
    sexSheet.tag = tag;
    [sexSheet showInView:[[UIApplication sharedApplication].delegate window]];
}

#pragma mark - DatePickerSheetDelegate method
- (void)datePickerSheet:(DatePickerSheet*)datePickerSheet chosenDate:(NSDate*)date
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd";
    NSString *dateString = [formatter stringFromDate:date];
    
    Child *child = [self childAtIndex:(datePickerSheet.tag - 2)];
    [self updateBabyDate:dateString childId:child.ids];
}

- (void)updateBabyDate:(NSString *)date childId:(NSNumber *)ids {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSDictionary *params = @{@"cid":ids, @"birthday" : (date == nil ? @"":date)};
    [[HttpService defaultService]POST:URL_APPEND_PATH(@"/user/child/birthday")
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
