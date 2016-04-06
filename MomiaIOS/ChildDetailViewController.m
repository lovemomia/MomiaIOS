//
//  ChildDetailViewController.m
//  MomiaIOS
//
//  Created by mosl on 16/4/5.
//  Copyright © 2016年 Deng Jun. All rights reserved.
//

#import "ChildDetailViewController.h"
#import "DatePickerSheet.h"
#import "Child.h"
#import "AccountModel.h"

@interface ChildDetailViewController ()<UIActionSheetDelegate,DatePickerSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property(nonatomic,weak) UIImageView *avaorImageView;
@property(nonatomic,weak) UILabel *sexCellItem;
@property(nonatomic,weak) UILabel *dateCellItem;
@property(nonatomic,strong) NSString *action;
@property(nonatomic,assign) NSInteger *childId;
@property(nonatomic,strong) Child *child;
@property(nonatomic,weak) UITextField *childNameField;
@property(nonatomic,assign) BOOL isAvatarSet;
@property(nonatomic,assign) BOOL isNameSet;
@property(nonatomic,assign) BOOL isSexSet;
@property(nonatomic,assign) BOOL isBirthdaySet;

@end

enum TagForActionSheet{
    TagForImagePicker,
    TagForSexPicker,
    TagForDatePicker
}TagForActionSheet;

@implementation ChildDetailViewController


- (instancetype)initWithParams:(NSDictionary *)params {
    if (self = [super initWithParams:params]) {
        self.action = [params objectForKey:@"action"];
        NSNumber *number = (NSNumber *)[params objectForKey:@"me"];
        _childId = (NSInteger *)number.integerValue;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"宝宝信息";
    if ([self.action isEqualToString:@"add"]) {
        _child = [[Child alloc]init];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0 && indexPath.row == 0) {
        return 80;
    }
    return 48;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section == 0) {
        return 4;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        
        return 10;
    }
    return 80;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0) {
        
        [self takePictureClick];
    }
    else if (indexPath.row == 2) {
        [self showSexPicker:2];
    }else if(indexPath.row == 3){
        [self showDatePicker:3];
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view = [UIView new];
    if (section == [self numberOfSectionsInTableView:tableView] - 1) {
        UIButton *button = [[UIButton alloc]init];
        button.height = 40;
        button.width = 280;
        button.left = (SCREEN_WIDTH - button.width) / 2;
        button.top = 30;
        if ([self.action isEqualToString:@"update"]) {
         
            [button setTitle:@"确认修改" forState:UIControlStateNormal];
            [button addTarget:self action:@selector(confirmUpdate:) forControlEvents:UIControlEventTouchUpInside];
        }else if([self.action isEqualToString:@"add"]){

        [button addTarget:self action:@selector(confirmAdd:) forControlEvents:UIControlEventTouchUpInside];
        }
        [button setTitle:@"确认添加" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
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

-(void)confirmUpdate:(id)sender{
    
}

//新增孩子信息
-(void)confirmAdd:(id)sender{
    
    if (_childNameField.text != nil && ![_childNameField.text isEqualToString:@""]) {
        _isNameSet = YES;
    }
    if (!(_isNameSet && _isSexSet && _isBirthdaySet)) {
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"信息不完整" message:nil delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSMutableArray *babyArray = [[NSMutableArray alloc] init];
    _child.name = _childNameField.text;
    [babyArray addObject:[_child toNSDictionary]];
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:babyArray options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    NSDictionary *params = @{@"children" : jsonString};
    [[HttpService defaultService]POST:URL_APPEND_PATH(@"/user/child")
                           parameters:params JSONModelClass:[AccountModel class]
                              success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                  [MBProgressHUD hideHUDForView:self.view animated:YES];
                                  AccountModel *result = (AccountModel *)responseObject;
                                  [AccountService defaultService].account = result.data;
                                  
                                  //[self.tableView reloadData];
                                  
                                  //广播出去
                                  [[NSNotificationCenter defaultCenter] postNotificationName:@"Notification_UpdateUserInfo" object:nil userInfo:nil];
                                  //新增完信息，跳转到上一页
                                  [self popToPrev];
                              }
     
                              failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                  [MBProgressHUD hideHUDForView:self.view animated:YES];
                                  [self showDialogWithTitle:nil message:error.message];
                              }];
}

-(void)popToPrev{
    
    [self.navigationController popViewControllerAnimated:YES];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    static NSString *CellDefault = @"DefaultCell";
    static NSString *CellLogo = @"LogoCell";
    static NSString *childName = @"ChildNameCellIdentifer";
    UITableViewCell *cell;
    
    if ((section == 0) && row == 0) {
        cell = [tableView dequeueReusableCellWithIdentifier:CellLogo];
        if (cell == nil) {
            NSArray *arr = [[NSBundle mainBundle] loadNibNamed:@"PersonLogoCell" owner:self options:nil];
            cell = [arr objectAtIndex:0];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            UILabel *titleLabel = (UILabel *)[cell viewWithTag:2];
            titleLabel.text = @"宝宝靓照";
            
            UIImageView *imageView = (UIImageView *)[cell viewWithTag:1];
            _avaorImageView = imageView;
        }
        
    } else if(section == 0 && row == 1){
        cell = [tableView dequeueReusableCellWithIdentifier:childName];
        if(cell == nil){
            NSArray *arr = [[NSBundle mainBundle] loadNibNamed:@"MineInfoCell" owner:self options:nil];
            cell = [arr objectAtIndex:2];
            UILabel *titleLabel = (UILabel *)[cell viewWithTag:1];
            titleLabel.text = @"姓名";
            
            _childNameField = (UITextField *)[cell viewWithTag:2];
        }
    }else {
        
        cell = [tableView dequeueReusableCellWithIdentifier:CellDefault];
        if (cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellDefault];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        
        cell.textLabel.textColor = UIColorFromRGB(0x333333);
        cell.textLabel.font = [UIFont systemFontOfSize: 15.0];
        cell.detailTextLabel.textColor = UIColorFromRGB(0x999999);
        cell.detailTextLabel.font = [UIFont systemFontOfSize: 15.0];
        
        if(section == 0 && row == 2){
            cell.textLabel.text = @"性别";
            _sexCellItem = cell.detailTextLabel;
        }else if(section == 0 && row ==3){
            cell.textLabel.text = @"生日";
            _dateCellItem = cell.detailTextLabel;
        }
    }
    return cell;
}

-(void)showSexPicker:(NSInteger)tag {
    UIActionSheet *sexSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"男",@"女",nil];
    sexSheet.tag = TagForSexPicker;
    [sexSheet showInView:[[UIApplication sharedApplication].delegate window]];
}

- (void)showDatePicker:(NSInteger)tag {
    DatePickerSheet * datePickerSheet = [DatePickerSheet getInstance];
    [datePickerSheet initializationWithMaxDate:nil
                                   withMinDate:nil
                            withDatePickerMode:UIDatePickerModeDate
                                  withDelegate:self];
    datePickerSheet.tag = TagForDatePicker;
    [datePickerSheet showDatePickerSheet];
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
    actionSheet.tag = TagForImagePicker;
    [actionSheet showInView:self.view];
}

#pragma mark -
#pragma UIActionSheet Delegate
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == TagForImagePicker) {
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
    
    else if(actionSheet.tag == TagForSexPicker){
        
        if(buttonIndex > 1){
            return;
        }
        //选择性别
        NSString * sex = buttonIndex == 0 ? @"男" : @"女";
        [_sexCellItem setText:sex];
        _child.sex = sex;
        _isSexSet = YES;
    }
//    else if (actionSheet.tag == 1) {
//        if(buttonIndex > 1) {
//            return;
//        }
//        
//        NSString * sex = buttonIndex == 0 ? @"男" : @"女";
//        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//        NSDictionary *params = @{@"sex" : sex};
//        [[HttpService defaultService]POST:URL_APPEND_PATH(@"/user/sex") parameters:params JSONModelClass:[AccountModel class] success:^(AFHTTPRequestOperation *operation, id responseObject) {
//            [MBProgressHUD hideHUDForView:self.view animated:YES];
//            AccountModel *result = (AccountModel *)responseObject;
//            [AccountService defaultService].account = result.data;
//            [self.tableView reloadData];
//            
//        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//            [MBProgressHUD hideHUDForView:self.view animated:YES];
//            [self showDialogWithTitle:nil message:error.message];
//        }];
//        
//    } else {
//        if(buttonIndex > 1) {
//            return;
//        }
//        Child *child = [self childAtIndex:(actionSheet.tag - 2)];
//        NSString * sex = buttonIndex == 0 ? @"男" : @"女";
//        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//        NSDictionary *params = @{@"cid":child.ids, @"sex" : sex};
//        [[HttpService defaultService]POST:URL_APPEND_PATH(@"/user/child/sex") parameters:params JSONModelClass:[AccountModel class] success:^(AFHTTPRequestOperation *operation, id responseObject) {
//            [MBProgressHUD hideHUDForView:self.view animated:YES];
//            AccountModel *result = (AccountModel *)responseObject;
//            [AccountService defaultService].account = result.data;
//            [self.tableView reloadData];
//            
//        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//            [MBProgressHUD hideHUDForView:self.view animated:YES];
//            [self showDialogWithTitle:nil message:error.message];
//        }];
//    }
}

- (void)datePickerSheet:(DatePickerSheet*)datePickerSheet chosenDate:(NSDate*)date
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd";
    NSString *dateString = [formatter stringFromDate:date];
    
    //设置生日
    [_dateCellItem setText:dateString];
    _child.birthday = dateString;
    _isBirthdaySet = YES;
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
    CGSize size = CGSizeMake(100, 100);
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0,0,size.width,size.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    [_avaorImageView setImage:newImage];
    [UIImageJPEGRepresentation(newImage, 1.0f) writeToFile:imageFilePath atomically:YES];
    
//    //上传
//    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    
//    [[HttpService defaultService] uploadImageWithFilePath:imageFilePath fileName:@"selfPhoto.jpg" handler:^(NSURLResponse *response, id responseObject, NSError *error) {
//        if (error) {
//            [MBProgressHUD hideHUDForView:self.view animated:YES];
//            [self showDialogWithTitle:nil message:@""];
//            
//        } else {
//            UploadImageData *data = ((UploadImageModel *)responseObject).data;
//            NSDictionary *params;
//            NSString *path;
//            if (self.uploadBabyAvatarIndex == -1) {
//                path = @"/user/avatar";
//                params = @{@"avatar":data.path};
//            } else {
//                path = @"/user/child/avatar";
//                params = @{@"cid":[self childAtIndex:(self.uploadBabyAvatarIndex)].ids, @"avatar":data.path};
//            }
//            [[HttpService defaultService]POST:URL_APPEND_PATH(path) parameters:params JSONModelClass:[AccountModel class] success:^(AFHTTPRequestOperation *operation, id responseObject) {
//                [MBProgressHUD hideHUDForView:self.view animated:YES];
//                
//                AccountModel *result = (AccountModel *)responseObject;
//                [AccountService defaultService].account = result.data;
//                [self.tableView reloadData];
//                
//            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//                [MBProgressHUD hideHUDForView:self.view animated:YES];
//                [self showDialogWithTitle:nil message:error.message];
//            }];
//        }
//    }];
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
