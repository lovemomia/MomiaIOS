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
#import "UploadImageModel.h"

typedef void (^uploadSuccess)(NSString *filePath);
typedef void (^uploadFail)(void);

static NSString *tempImagePath = @"tempImage.jepg";
@interface ChildDetailViewController ()<UIActionSheetDelegate,DatePickerSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (nonatomic, strong) NSString    *action;
@property (nonatomic, strong) NSString    *filePath;
@property (nonatomic, assign) NSInteger   childId;
@property (nonatomic, strong) Child       *child;
@property (nonatomic, strong) Child       *oldChild; //更新的child
@property (nonatomic, weak  ) UIImageView *avaorImageView;
@property (nonatomic, weak  ) UILabel     *sexCellItem;
@property (nonatomic, weak  ) UILabel     *dateCellItem;
@property (nonatomic, weak  ) UITextField *childNameField;
@property (nonatomic, strong) UIButton    *confirmButton;

@end

@implementation ChildDetailViewController

- (instancetype)initWithParams:(NSDictionary *)params {
    if (self = [super initWithParams:params]) {
        self.action      = [params objectForKey:@"action"];
        NSNumber *number = (NSNumber *)[params objectForKey:@"childId"];
        _childId         = number.integerValue;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([self.action isEqualToString:@"add"]){
        self.title = @"添加宝宝";
        _child = [[Child alloc]init];
    }else if([self.action isEqualToString:@"update"]){
        self.title = @"宝宝信息";
        [[AccountService defaultService].account.children enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if(_childId == ((Child *)obj).ids.integerValue){
                _oldChild = obj;
                _child = [_oldChild copy];
                NSLog(@" ---- %@---",[_child toJSONString]);
            }
        }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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
            [button setTitle:@"确认添加" forState:UIControlStateNormal];
            [button addTarget:self action:@selector(confirmAdd:) forControlEvents:UIControlEventTouchUpInside];
        }
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"BgLargeButtonNormal"] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"BgLargeButtonDisable"] forState:UIControlStateDisabled];
        self.confirmButton = button;
        [view addSubview:button];
    }
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == [self numberOfSectionsInTableView:tableView] - 1){
        return 80;
    }
    return 0.1;
}
//确认修改
-(void)confirmUpdate:(id)sender{
 
    [self.confirmButton setUserInteractionEnabled:NO];
    [self addChildData];
    //1.判断头像是否修改  _filePath = nil （未修改)
    if (_filePath == nil ) {
        if (![_oldChild.name isEqualToString:_child.name] || ![_oldChild.sex isEqualToString: _child.sex] || ![_oldChild.birthday isEqualToString: _child.birthday]) {
            [self commitToServer:_child];
        }
    }else if(_filePath != nil){ //修改了头像  1.上传图片  2.提交孩子信息
        [self uploadFile:self.filePath fileName:@"selfPhoto.jpg" success:^(NSString *filePath) {
            _child.avatar = filePath;
            [self commitToServer:_child];
        } fail:^{
            [UIAlertController alertControllerWithTitle:@"上传出错" message:nil preferredStyle:UIAlertControllerStyleAlert];
        }];
    }
}
//新增孩子
-(void)confirmAdd:(id)sender{
    if([self checkInput]){
        [self addChildData];
        [self.confirmButton setUserInteractionEnabled:NO];
        [self uploadFile:self.filePath fileName:@"selfPhoto.jpg" success:^(NSString *filePath) {
            _child.avatar = filePath;
            [self commitToServer:_child];
        } fail:^{
            [UIAlertController alertControllerWithTitle:@"上传出错" message:nil preferredStyle:UIAlertControllerStyleAlert];
        }];
    }
    
}

-(BOOL)checkInput{
    
    if (_filePath == nil ) {
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
    [alert show];
}

-(void)commitToServer:(Child *)child{
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSMutableArray *babyArray = [[NSMutableArray alloc] init];
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
                                  //广播出去
                                  [[NSNotificationCenter defaultCenter] postNotificationName:@"Notification_UpdateUserInfo" object:nil userInfo:nil];
                                  //新增完信息，跳转到上一页
                                  [self.confirmButton setUserInteractionEnabled:YES];
                                  [self popToPrev];
                              }
     
                              failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                  [MBProgressHUD hideHUDForView:self.view animated:YES];
                                  [self showDialogWithTitle:nil message:error.message];
                                  [self.confirmButton setUserInteractionEnabled:YES];
                              }];
}

-(void)popToPrev{
    [self.navigationController popViewControllerAnimated:YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath{
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
            if (_child && _child.avatar) {
                NSURL *url = [[NSURL alloc]initWithString:_child.avatar];
                [imageView sd_setImageWithURL:url
                                    completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                    [imageView setImage:image];
                }];
            }
        }
        
    } else if(section == 0 && row == 1){
        cell = [tableView dequeueReusableCellWithIdentifier:childName];
        if(cell == nil){
            NSArray *arr = [[NSBundle mainBundle] loadNibNamed:@"MineInfoCell" owner:self options:nil];
            cell = [arr objectAtIndex:2];
            UILabel *titleLabel = (UILabel *)[cell viewWithTag:1];
            titleLabel.text = @"姓名";
            _childNameField = (UITextField *)[cell viewWithTag:2];
            
            if (_child) {
                [_childNameField setText:_child.name];
            }
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

            if (_child) {
                [_sexCellItem setText:_child.sex];
            }
        }else if(section == 0 && row ==3){
            cell.textLabel.text = @"生日";
            _dateCellItem = cell.detailTextLabel;
            
            if (_child) {
                [_dateCellItem setText:_child.birthday];
            }
        }
    }
    return cell;
}

-(void)showSexPicker:(NSInteger)tag {
    UIActionSheet *sexSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                          delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"男",@"女",nil];
    sexSheet.tag = tag;
    [sexSheet showInView:[[UIApplication sharedApplication].delegate window]];
}

- (void)showDatePicker:(NSInteger)tag {
    DatePickerSheet * datePickerSheet = [DatePickerSheet getInstance];
    [datePickerSheet initializationWithMaxDate:[NSDate date]
                                   withMinDate:[NSDate dateWithTimeIntervalSinceNow: -(24 * 60 * 60 * 30 * 12 * 20)]
                            withDatePickerMode:UIDatePickerModeDate
                                  withDelegate:self];
    datePickerSheet.tag = tag;
    [datePickerSheet showDatePickerSheet];

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

#pragma mark -
#pragma UIActionSheet Delegate
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
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

- (void)datePickerSheet:(DatePickerSheet*)datePickerSheet
             chosenDate:(NSDate*)date{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat       = @"yyyy-MM-dd";
    NSString *dateString       = [formatter stringFromDate:date];
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

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    //    [picker dismissModalViewControllerAnimated:YES];
    [picker dismissViewControllerAnimated:YES completion:nil];
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

- (void)saveImage:(UIImage *)image {
    
    CGSize size = CGSizeMake(100, 100);
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0,0,size.width,size.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    //scale
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *imageFilePath = [documentsDirectory stringByAppendingPathComponent:@"selfPhoto.jpg"];
    [UIImageJPEGRepresentation(newImage, 1.0f) writeToFile:imageFilePath atomically:YES];
    
    [_avaorImageView setImage:image];
    self.filePath = [NSString stringWithString:imageFilePath];
}


@end
