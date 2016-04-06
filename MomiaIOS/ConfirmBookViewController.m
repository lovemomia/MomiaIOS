//
//  ConfirmBookViewController.m
//  MomiaIOS
//
//  Created by mosl on 16/4/5.
//  Copyright © 2016年 Deng Jun. All rights reserved.
//

#import "ConfirmBookViewController.h"
#import "Masonry.h"
#import "CourseLocationTimeCell.h"
#import "Account.h"
#import "AccountModel.h"
#import "WalkChildsViewController.h"
#import "DatePickerSheet.h"
#import "WalkChildCellTableViewCell.h"

enum TagForActionSheet{
    TagForImagePicker,
    TagForSexPicker,
    TagForDatePicker
}TagForActionSheet;

//确认约课
@interface ConfirmBookViewController ()<UIActionSheetDelegate,DatePickerSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

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

@implementation ConfirmBookViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"确认约课";
    //由于本地没存孩子信息，需要从服务端拿
//    [self fromServerGetAccount];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)viewWillAppear:(BOOL)animated{
    if ([AccountService defaultService].account.children.count > 0 ) {
        _child = [AccountService defaultService].account.children[_choosedChildItem];
        [self.tableView reloadData];
    }
    
}

#pragma tableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 2;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section == 0) {
        return 1;
    }else if(section == 1 && [AccountService defaultService].account.children.count == 0){
        return 4;
    }
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    if (section == [self numberOfSectionsInTableView:self.tableView] - 1) {
        return 80;
    }
    return 0.1f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0 && indexPath.row == 0) {
        return 120;
    }
    else if (indexPath.section == 1 && [AccountService defaultService].account.children.count == 0 ) {
        if (indexPath.row == 0) {
            
            return 80;
        }
        else return 46;
    }
    return 80;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
}

//section 头部
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
    UILabel *label = [[UILabel alloc]init];
    
    if (section == 0) {
        label.text = @"上课时间地点";
    }else{
        label.text = @"出行宝宝";
    }
    
    label.font = [UIFont systemFontOfSize:15.0];
    [view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(view).offset(10);
        make.centerY.equalTo(view);
    }];
    
    return view;
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //选择宝宝
    if (indexPath.section == 1 && [AccountService defaultService].account.children.count != 0) {
        
        WalkChildsViewController *walkChildsVC = [[WalkChildsViewController alloc]initWithParams:@{@"action":@"chooseChild",@"choosedChildItem":[[NSNumber alloc] initWithInteger:_choosedChildItem]}];
        [self.navigationController pushViewController:walkChildsVC animated:YES];
    }
    if (indexPath.section == 1 && [AccountService defaultService].account.children.count == 0) {
        if (indexPath.row == 0) {
            
            [self takePictureClick];
        }
        else if (indexPath.row == 2) {
            [self showSexPicker:2];
        }else if(indexPath.row == 3){
            [self showDatePicker:3];
        }    }
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

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view = [UIView new];
    if (section == [self numberOfSectionsInTableView:tableView] - 1) {
        UIButton *button = [[UIButton alloc]init];
        button.height = 40;
        button.width = 280;
        button.left = (SCREEN_WIDTH - button.width) / 2;
        button.top = 30;
        [button setTitle:@"确认预约" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(onConfirmBook:) forControlEvents:UIControlEventTouchUpInside];
        [button setBackgroundImage:[UIImage imageNamed:@"BgLargeButtonNormal"] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"BgLargeButtonDisable"] forState:UIControlStateDisabled];
        
        [view addSubview:button];
    }
    return view;
}

//提交到服务器--确认预约
-(void)onConfirmBook:(id)sender{
    
    if ([AccountService defaultService].account.children.count == 0) {
        //先新增孩子
        [self confirmAdd];
    }
}

//新增孩子信息
-(void)confirmAdd{
    
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
//                                  [self popToPrev];
                              }
     
                              failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                  [MBProgressHUD hideHUDForView:self.view animated:YES];
                                  [self showDialogWithTitle:nil message:error.message];
                              }];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if (indexPath.section == 0 && indexPath.row == 0 ) {
        
        CourseLocationTimeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CourseLocationTimeCell"];
        if (cell == nil) {
            cell = [[CourseLocationTimeCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CourseLocationTimeCell"];
            
        }
        return cell;
        
    }
    
    UITableViewCell *cell;
    if (indexPath.section == 1 && [AccountService defaultService].account.children.count == 0) {

        static NSString *CellDefault = @"DefaultCell";
        static NSString *CellLogo = @"LogoCell";
        static NSString *childName = @"ChildNameCellIdentifer";
        
        if (indexPath.row == 0) {
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
            
        } else if( indexPath.row == 1){
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
            
            if(indexPath.row == 2){
                cell.textLabel.text = @"性别";
                _sexCellItem = cell.detailTextLabel;
            }else if(indexPath.row ==3){
                cell.textLabel.text = @"生日";
                _dateCellItem = cell.detailTextLabel;
            }
        }
    }else{
        
        WalkChildCellTableViewCell *cell;
        cell = [tableView dequeueReusableCellWithIdentifier:@"WalkChildsCellIdentifer"];
        if(cell == nil){
            cell = [[[NSBundle mainBundle]loadNibNamed:@"WalkChildCellTableViewCell" owner:self options:nil]lastObject];
            [cell setData:_child];
            [[cell viewWithTag:13]removeFromSuperview];
            UIButton *button = [cell viewWithTag:14];
            [button setTitle:@"选择宝宝" forState:UIControlStateNormal];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        return cell;
    }
    return cell;
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
}
@end
