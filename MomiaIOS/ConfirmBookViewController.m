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
#import "ChildDetailViewController.h"
#import "UploadImageModel.h"

typedef void (^uploadSuccess)(NSString *filePath);
typedef void (^uploadFail)(void);

@interface ConfirmBookViewController ()<UIActionSheetDelegate,DatePickerSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (nonatomic,weak  ) UIImageView *avaorImageView;
@property (nonatomic,weak  ) UILabel     *sexCellItem;
@property (nonatomic,weak  ) UILabel     *dateCellItem;
@property (nonatomic,weak  ) UITextField *childNameField;
@property (nonatomic,strong) NSString    *action;
@property (nonatomic,strong) NSString    *filePath;
@property (nonatomic,strong) Child       *child;

@end

@implementation ConfirmBookViewController

-(instancetype)initWithParams:(NSDictionary *)params{
    self = [super initWithParams:params];
    if (self) {
        
        self.selectSkuIds = [params objectForKey:@"skuIds"];
        self.pid = [params objectForKey:@"pid"];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"确认约课";
    if ([AccountService defaultService].account.children && [AccountService defaultService].account.children.count > 0) {
        self.child = [AccountService defaultService].account.children[0];
    }else{
        _child = [[Child alloc]init];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
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
    
    static NSString *reuseHeaderIdentifer = @"reuseHeaderIdentifer";
    UIView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:reuseHeaderIdentifer];
    if (view == nil) {
        view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
    }
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
    sexSheet.tag = tag;
    [sexSheet showInView:[[UIApplication sharedApplication].delegate window]];
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
-(void)takePictureClick{
    UIActionSheet* actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:@"请选择图片来源"
                                  delegate:self
                                  cancelButtonTitle:@"取消"
                                  destructiveButtonTitle:nil
                                  otherButtonTitles:@"照相机", @"本地相簿",nil];
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

//--确认预约
-(void)onConfirmBook:(id)sender{
    if ([AccountService defaultService].account.children.count == 0) {
        //先新增孩子
        [self addChild];
    }else if (self.child) {
        [self commitToServer:self.selectSkuIds.integerValue pid:self.pid cid:self.child.ids.integerValue];
    }
    
}
//提交到服务器
-(void)commitToServer:(NSInteger)skuId pid:(NSString *)pid
                  cid:(NSInteger)cid{
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSDictionary *params = @{@"sid":[NSNumber numberWithInteger:skuId], @"pid":pid,@"cid":[NSNumber numberWithInteger:cid]};
    [[HttpService defaultService]POST:URL_APPEND_PATH(@"/course/booking")
                           parameters:params JSONModelClass:[BaseModel class]
                              success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                  [MBProgressHUD hideHUDForView:self.view animated:YES];
                                  [self showDialogWithTitle:nil message:@"预约成功，您已被拉入该课群组，猛戳 “我的—我的群组” 就可以随意调戏我们的老师啦~" tag:1];
                                  [[NSNotificationCenter defaultCenter]postNotificationName:@"onMineDotChanged" object:nil];
                    
                              }
                              failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                  [MBProgressHUD hideHUDForView:self.view animated:YES];
                                  [self showDialogWithTitle:nil message:error.message];
                              }];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (alertView.tag == 88) {
        return;
    }
    [self.navigationController popToRootViewControllerAnimated:YES];
}

//新增孩子
-(void)addChild{
    //1.检查参数
    if (![self checkInput]) {
        return;
    }
    //2.添加数据
    [self addChildData];
    //3.上传文件
    [self uploadFile:self.filePath fileName:@"selfPhoto.jpg" success:^(NSString *filePath) {
        //4.增加孩子
        _child.avatar = filePath;
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        NSMutableArray *babyArray = [[NSMutableArray alloc] init];
        [babyArray addObject:[_child toNSDictionary]];
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:babyArray options:NSJSONWritingPrettyPrinted error:nil];
        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        NSLog(@"%@",jsonString);
        NSDictionary *params = @{@"children" : jsonString};
        [[HttpService defaultService]POST:URL_APPEND_PATH(@"/user/child")
                               parameters:params JSONModelClass:[AccountModel class]
                                  success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                      [MBProgressHUD hideHUDForView:self.view animated:YES];
                                      AccountModel *result = (AccountModel *)responseObject;
                                      [AccountService defaultService].account = result.data;
                                      self.child = [[AccountService defaultService].account.children lastObject];
                                      //广播出去
                                      [[NSNotificationCenter defaultCenter] postNotificationName:@"Notification_UpdateUserInfo" object:nil userInfo:nil];
                                       //提交预约
                                      [self commitToServer:self.selectSkuIds.integerValue pid:self.pid cid:self.child.ids.integerValue];
                                      
                                  }
         
                                  failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                      [MBProgressHUD hideHUDForView:self.view animated:YES];
                                      [self showDialogWithTitle:nil message:error.message];
                                  }];
    } fail:^{
        [UIAlertController alertControllerWithTitle:@"上传出错" message:nil preferredStyle:UIAlertControllerStyleAlert];
    }];
}
//上传文件
-(void)uploadFile:(NSString *)filePath fileName:(NSString *)fileName success:(uploadSuccess)success fail:(uploadFail)fail{
    
    [[HttpService defaultService] uploadImageWithFilePath:filePath fileName:fileName handler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (error) {
            [self showDialogWithTitle:nil message:@"error"];
            fail();
        }else{
            UploadImageData *data = ((UploadImageModel *)responseObject).data;
            success(data.path);
        }
    }];
}

-(BOOL)checkInput{
    
    if (_avaorImageView.image == nil ) {
        [self alertMessage:@"头像没有设置"];
        return NO;
    }else if(_childNameField.text == nil || [_childNameField.text isEqualToString:@""]){
        [self alertMessage:@"姓名没有设置"];
        return NO;
    }else if(_sexCellItem.text == nil || [ _sexCellItem.text isEqualToString:@""]){
        [self alertMessage:@"性别没有设置"];
        return NO;
    }else if(_dateCellItem.text == nil || [_dateCellItem.text isEqualToString:@""]){
        [self alertMessage:@"生日没有设置"];
        return NO;
    }
    return YES;
}

-(void)addChildData{
    _child.name = _childNameField.text;
    _child.sex = _sexCellItem.text;
    _child.birthday = _dateCellItem.text;
}

-(void)alertMessage:(NSString *)message{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:message message:nil delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
    alert.tag = 88;
    [alert show];
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
            UILabel *label = [cell viewWithTag:14];
            [label setText:@"选择宝宝"];
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
    
    else if(actionSheet.tag == 2){
        
        if(buttonIndex > 1){
            return;
        }
        //选择性别
        NSString * sex = buttonIndex == 0 ? @"男" : @"女";
        [_sexCellItem setText:sex];
    }

}
- (void)datePickerSheet:(DatePickerSheet*)datePickerSheet chosenDate:(NSDate*)date{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd";
    NSString *dateString = [formatter stringFromDate:date];
    
    //设置生日
    [_dateCellItem setText:dateString];
}

#pragma mark -
#pragma UIImagePickerController Delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    if ([[info objectForKey:UIImagePickerControllerMediaType] isEqualToString:(__bridge NSString *)kUTTypeImage]) {
        UIImage *img = [info objectForKey:UIImagePickerControllerEditedImage];
        [self performSelector:@selector(saveImage:)  withObject:img afterDelay:0.5];
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
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
    
    self.filePath = imageFilePath;
}
@end
