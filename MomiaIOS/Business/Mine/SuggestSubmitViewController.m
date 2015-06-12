//
//  SuggestSubmitViewController.m
//  MomiaIOS
//
//  Created by Deng Jun on 15/5/18.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import "SuggestSubmitViewController.h"
#import "SugSubmitProductNameCell.h"
#import "SugSubmitProductContentCell.h"
#import "MONavigationController.h"
#import "UploadImageModel.h"
#import "BaseModel.h"
#import "SuggestTagsViewController.h"
#import "URLMappingManager.h"
#import "SugTagsModel.h"

typedef enum {
    UploadStatusFail   = -1,
    UploadStatusIdle   = 0,
    UploadStatusGoing  = 1,
    UploadStatusFinish = 2
} UploadStatus; // 图片上传状态

@interface SelectImage : NSObject

@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) NSString *filePath;
@property (strong, nonatomic) NSString *fileName;
@property (assign, nonatomic) UploadStatus uploadStatus;
@property (strong, nonatomic) UploadImageData *respData;

@end
@implementation SelectImage
@end

@interface SuggestSubmitViewController ()

@property (strong, nonatomic) SugSubmitProductNameCell *nameCell;
@property (strong, nonatomic) SugSubmitProductContentCell *contentCell;
@property (strong, nonatomic) UITableViewCell *tagsCell;
@property (strong, nonatomic) NSMutableArray *uploadImages;

@property (strong, nonatomic) UITextView *nameTextView;
@property (strong, nonatomic) UITextView *contentTextView;
@property (strong, nonatomic) SelectImage *selectImage;

@property (strong, nonatomic) NSArray *assortArray;
@property (strong, nonatomic) NSArray *crowdArray;

@property (assign, nonatomic) BOOL isSubmitSuccess;

@end

@implementation SuggestSubmitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"我要推荐";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"发布" style:UIBarButtonItemStylePlain target:self action:@selector(onSubmitClicked)];
}

- (void)viewWillAppear:(BOOL)animated {
    [((MONavigationController *)self.navigationController) setTitleTextStyle];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)onSubmitClicked {
    // 参数判断
    if (self.nameCell.nameTv.text.length == 0) {
        [self showDialogWithTitle:nil message:@"请输入商品名称！"];
        return;
    }
    
    if (self.contentCell.contentTv.text.length == 0) {
        [self showDialogWithTitle:nil message:@"请输入商品简介！"];
        return;
    }
    
    if (self.uploadImages == nil || ([self.uploadImages count] == 1 && ((SelectImage *)[self.uploadImages objectAtIndex:0]).filePath == nil)) {
        [self showDialogWithTitle:nil message:@"请至少上传一张商品图片！"];
        return;
    }
    
    
    if (self.assortArray == nil || ![self isTagsSelected:self.assortArray]) {
        [self showDialogWithTitle:nil message:@"您还未选择标签分类！"];
        return;
    }
    
    if (self.crowdArray == nil || ![self isTagsSelected:self.crowdArray]) {
        [self showDialogWithTitle:nil message:@"您还未选择标签适用人群！"];
        return;
    }
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    BOOL imagesUploaded = YES;
    for (SelectImage *si in self.uploadImages) {
        if (si.uploadStatus <= UploadStatusIdle) {
            [self uploadImage:si];
            imagesUploaded = NO;
            break;
        }
    }
    if (imagesUploaded) {
        [self submit];
    }
}

- (BOOL)isTagsSelected:(NSArray *)tags {
    for (Tag *tag in tags) {
        if (tag.isSelected) {
            return YES;
        }
    }
    return NO;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        if (self.isSubmitSuccess) {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

// 提交
- (void)submit {
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    [params setObject:self.nameCell.nameTv.text forKey:@"name"];
    [params setObject:self.contentCell.contentTv.text forKey:@"content"];
    [params setObject:[self makePhotosJsonString] forKey:@"photos"];
    [params setObject:[self makeAssortsString] forKey:@"assorts"];
    [params setObject:[self makeCrowdsString] forKey:@"crowds"];
    [[HttpService defaultService] POST:URL_APPEND_PATH(@"/goods") parameters:params JSONModelClass:[BaseModel class] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self showDialogWithTitle:nil message:@"发布成功！"];
        self.isSubmitSuccess = YES;
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self showDialogWithTitle:nil message:@"发布失败，请稍后再试"];
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}

- (NSString *)makePhotosJsonString {
    NSMutableString *jsonStr = [[NSMutableString alloc]init];
    [jsonStr appendString:@"["];
    int i = 0;
    for (SelectImage *si in self.uploadImages) {
        if (si.uploadStatus == UploadStatusFinish) {
            if (i != 0) {
                [jsonStr appendString:@","];
            }

            [jsonStr appendString:[si.respData toJSONString]];
            i++;
        }
    }
    [jsonStr appendString:@"]"];
    return jsonStr;
}

- (NSString *)makeAssortsString {
    NSMutableString *jsonStr = [[NSMutableString alloc]init];
    int i = 0;
    for (Tag *tag in self.assortArray) {
        if (tag.isSelected) {
            if (i != 0) {
                [jsonStr appendString:@","];
            }
            [jsonStr appendString:[NSString stringWithFormat:@"%d",tag.pairID]];
            i++;
        }
    }
    return jsonStr;
}

- (NSString *)makeCrowdsString {
    NSMutableString *jsonStr = [[NSMutableString alloc]init];
    int i = 0;
    for (Tag *tag in self.crowdArray) {
        if (tag.isSelected) {
            if (i != 0) {
                [jsonStr appendString:@","];
            }
            [jsonStr appendString:[NSString stringWithFormat:@"%d",tag.pairID]];
            i++;
        }
    }
    return jsonStr;
}

- (void)uploadImage:(SelectImage *)image {
    if (image.fileName == nil || image.filePath == nil) {
        return;
    }
    
    image.uploadStatus = UploadStatusGoing;
    [[HttpService defaultService] uploadImageWithFilePath:image.filePath fileName:image.fileName handler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (error) {
            image.uploadStatus = UploadStatusFail;
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [self showDialogWithTitle:nil message:@"图片上传失败，请稍后重新尝试"];
            
        } else {
            image.uploadStatus = UploadStatusFinish;
            image.respData = ((UploadImageModel *)responseObject).data;
            if ([self isAllImagesUploadFinish]) {
                [self submit];
            }
        }
    }];
}

- (BOOL)isAllImagesUploadFinish {
    for (SelectImage *si in self.uploadImages) {
        if (si.uploadStatus != UploadStatusFinish) {
            [self uploadImage:si];
            return NO;
        }
    }
    return YES;
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        SuggestTagsViewController *controller = (SuggestTagsViewController *)[[URLMappingManager sharedManager]createControllerFromURL:[NSURL URLWithString:@"tq://sugtags"]];
        controller.delegate = self;
        if (self.assortArray && self.crowdArray) {
            controller.assorts = self.assortArray;
            controller.crowds = self.crowdArray;
        }
        
        MONavigationController *navController = [[MONavigationController alloc]initWithRootViewController:controller];
        [self presentViewController:navController animated:YES completion:nil];
        
//        [self openURL:@"tq://sugtags"];

    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    if (indexPath.section == 0) {
        if (row == 0) {
            return [SugSubmitProductNameCell height];
            
        } else {
            return [SugSubmitProductContentCell height];
        }
    }
    return 44;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 2;
    }
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellTags = @"CellTags";
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    UITableViewCell *cell;
    if (section == 0) {
        if (row == 0) {
            SugSubmitProductNameCell *nameCell = [SugSubmitProductNameCell cellWithTableView:tableView];
            cell = self.nameCell = nameCell;
            
        } else {
            SugSubmitProductContentCell *contentCell = [SugSubmitProductContentCell cellWithTableView:tableView];
            contentCell.delegate = self;
            cell = self.contentCell = contentCell;
        }
        
    } else {
        cell = [tableView dequeueReusableCellWithIdentifier:CellTags];
        if (cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellTags];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.textLabel.text = @"添加标签";
        }
        self.tagsCell = cell;
    }
    return cell;
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
            imagePicker.allowsEditing = NO;
            imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
            //            [self presentModalViewController:imagePicker animated:YES];
            [self presentViewController:imagePicker animated:YES completion:nil];
        }
            break;
            
        case 1://本地相簿
        {
            UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
            imagePicker.delegate = self;
            imagePicker.allowsEditing = NO;
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
        UIImage *img = [info objectForKey:UIImagePickerControllerOriginalImage];
        [self performSelector:@selector(saveImage:)  withObject:img afterDelay:0.5];
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
    [self.contentCell addNextPhotoView];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    //    [picker dismissModalViewControllerAnimated:YES];
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)saveImage:(UIImage *)image {
    //    NSLog(@"保存头像！");
    //    [userPhotoButton setImage:image forState:UIControlStateNormal];
    BOOL success;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *imageFilePath = [documentsDirectory stringByAppendingPathComponent:@"selfPhoto.jpg"];
    NSLog(@"imageFile->>%@",imageFilePath);
    success = [fileManager fileExistsAtPath:imageFilePath];
    if(success) {
        success = [fileManager removeItemAtPath:imageFilePath error:&error];
    }
    
    UIImage *smallImage = [self thumbnailWithImageWithoutScale:[self croppImage:image] size:CGSizeMake(self.selectImage.imageView.size.width, self.selectImage.imageView.size.height)];
    
    self.selectImage.imageView.image = smallImage;
    
    NSString *uploadImageName = [NSString stringWithFormat:@"upload_%d.jpg", (int)self.uploadImages.count];
    NSString *uploadImagePath = [documentsDirectory stringByAppendingPathComponent:uploadImageName];
    UIImage *uploadImage=[self scaleFromImage:image];
    [UIImageJPEGRepresentation(uploadImage, 1.0f) writeToFile:uploadImagePath atomically:YES];//写入文件
    self.selectImage.fileName = uploadImageName;
    self.selectImage.filePath = uploadImagePath;
}

// 改变图像的尺寸，方便上传服务器
- (UIImage *) scaleFromImage: (UIImage *) image
{
    CGSize size = CGSizeMake(800, 800);
    int scaleWidth = 800;
    if (image.size.width < size.width) {
        return image;
    }
    size.height = scaleWidth * image.size.height / image.size.width;
    
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (UIImage *)croppImage:(UIImage *)imageToCrop
{
    UIImage *sourceImage = imageToCrop;
    
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    
    //crop
    CGRect cropRect;
    if (width > height) {
        cropRect = CGRectMake((width-height)/2, 0, height, height);
    } else {
        cropRect = CGRectMake(0, (height-width)/2, width, width);
    }
    CGImageRef imageRef = CGImageCreateWithImageInRect([imageToCrop CGImage], cropRect);
    UIImage *cropped = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    
    return cropped;
}

//2.保持原来的长宽比，生成一个缩略图
- (UIImage *)thumbnailWithImageWithoutScale:(UIImage *)image size:(CGSize)targetSize
{
    if (nil == image) {
        return nil;
    }
    
    CGSize newSize = CGSizeMake(targetSize.width, targetSize.height);
    CGFloat widthRatio = newSize.width/image.size.width;
    CGFloat heightRatio = newSize.height/image.size.height;
    
    if(widthRatio > heightRatio)
    {
        newSize=CGSizeMake(image.size.width*heightRatio,image.size.height*heightRatio);
    }
    else
    {
        newSize=CGSizeMake(image.size.width*widthRatio,image.size.height*widthRatio);
    }
    
    
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

-(void)onPhotoViewClick:(UIImageView *)photoView {
    if (self.selectImage == nil || self.selectImage.imageView != photoView) {
        SelectImage *si = [[SelectImage alloc]init];
        si.imageView = photoView;
        self.selectImage = si;
        if (self.uploadImages == nil) {
            self.uploadImages = [[NSMutableArray alloc]init];
        }
        [self.uploadImages addObject:si];
    }
    
    [self takePictureClick];
}

#pragma mark - suggest tags choose delegate

-(void)onChooseFinishWithAssorts:(NSArray *)assorts andCrowds:(NSArray *)crowds {
    self.assortArray = assorts;
    self.crowdArray = crowds;
    
    NSMutableString *ms = [[NSMutableString alloc]init];
    for (Tag *tag in assorts) {
        if (tag.isSelected) {
            [ms appendString:tag.name];
            [ms appendString:@" "];
        }
    }
    for (Tag *tag in crowds) {
        if (tag.isSelected) {
            [ms appendString:tag.name];
            [ms appendString:@" "];
        }
    }
    self.tagsCell.textLabel.text = ms;
    
    [self dismissViewControllerAnimated:NO completion:nil];
}

-(void)onCancel {
    [self dismissViewControllerAnimated:NO completion:nil];
}

@end
