//
//  AddFeedViewController.m
//  MomiaIOS
//
//  Created by Deng Jun on 15/9/22.
//  Copyright © 2015年 Deng Jun. All rights reserved.
//

#import "AddFeedViewController.h"
#import "MONavigationController.h"
#import "SelectImage.h"
#import "BaseModel.h"
#import "URLMappingManager.h"
#import "AddFeed.h"
#import "MLSelectPhotoAssets.h"
#import "MLSelectPhotoPickerAssetsViewController.h"
#import "MLSelectPhotoBrowserViewController.h"


@interface AddFeedViewController ()

@property (strong, nonatomic) AddFeedContentCell *contentCell;
@property (strong, nonatomic) UITableViewCell *tagsCell;

@property (strong, nonatomic) NSString *content;
@property (strong, nonatomic) NSMutableArray *uploadImages;
@property (strong, nonatomic) NSNumber *productId;
@property (strong, nonatomic) NSNumber *topicId;
@property (strong, nonatomic) NSString *topic;

@property (strong, nonatomic) UITextView *contentTextView;

@property (assign, nonatomic) BOOL isSubmitSuccess;

@end

@implementation AddFeedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"成长日记";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"发布" style:UIBarButtonItemStylePlain target:self action:@selector(onSubmitClicked)];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)onSubmitClicked {
    // 参数判断
    
//    if (self.contentCell.contentTv.text.length == 0) {
//        [self showDialogWithTitle:nil message:@"请输入参加活动的感受"];
//        return;
//    }
    
    if (self.topicId == nil) {
        [self showDialogWithTitle:nil message:@"您还未选择主题"];
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


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        if (self.isSubmitSuccess) {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

// 提交
- (void)submit {
    AddFeed *addFeed = [[AddFeed alloc]init];
    BaseFeed *baseFeed = [[BaseFeed alloc]init];
    baseFeed.content = self.contentCell.contentTv.text;
    baseFeed.topicId = self.topicId;
    baseFeed.type = [NSNumber numberWithInt:1];
    addFeed.baseFeed = baseFeed;
    
    NSMutableArray *imageArray = [[NSMutableArray alloc]init];
    for (SelectImage *si in self.uploadImages) {
        if (si.uploadStatus == UploadStatusFinish) {
            [imageArray addObject:si.respData];
        }
    }
    addFeed.imgs = (NSArray<UploadImageData> *)imageArray;
    
    [[HttpService defaultService] POST:URL_APPEND_PATH(@"/feed/add") parameters:@{@"feed":[addFeed toJSONString]} JSONModelClass:[BaseModel class] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self showDialogWithTitle:nil message:@"发布成功！"];
        self.isSubmitSuccess = YES;
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        [[NSNotificationCenter defaultCenter]postNotificationName:@"onDataChanged" object:nil];
        
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
    if (indexPath.section == 0 && indexPath.row == 1) {
        TopicListViewController *controller = [[TopicListViewController alloc]init];
        controller.delegate = self;
        
        MONavigationController *navController = [[MONavigationController alloc]initWithRootViewController:controller];
        [self presentViewController:navController animated:YES completion:nil];
        
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    if (indexPath.section == 0) {
        if (row == 0) {
            return [AddFeedContentCell heightWithImageCount:(int)self.uploadImages.count];
            
        } else {
            return 44;
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
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellTags = @"CellTags";
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    UITableViewCell *cell;
    if (section == 0) {
        if (row == 0) {
            AddFeedContentCell *contentCell = [AddFeedContentCell cellWithTableView:tableView];
            contentCell.delegate = self;
            [contentCell setData:self.content andImages:self.uploadImages];
            cell = self.contentCell = contentCell;
            
        } else {
            cell = [tableView dequeueReusableCellWithIdentifier:CellTags];
            if (cell == nil) {
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellTags];
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.textLabel.textColor = UIColorFromRGB(0x333333);
                cell.textLabel.font = [UIFont systemFontOfSize: 15.0];
                cell.imageView.image = [UIImage imageNamed:@"IconTag"];
            }
            cell.textLabel.text = self.topic ? self.topic : @"选择一个主题";
            self.tagsCell = cell;
        }
        
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
//            UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
//            imagePicker.delegate = self;
//            imagePicker.allowsEditing = NO;
//            imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
//            [self presentViewController:imagePicker animated:YES completion:nil];
            
            // 创建控制器
            MLSelectPhotoPickerViewController *pickerVc = [[MLSelectPhotoPickerViewController alloc] init];
            // 默认显示相册里面的内容SavePhotos
            // 默认最多能选9张图片
            pickerVc.maxCount = 9 - self.uploadImages.count;
            pickerVc.status = PickerViewShowStatusCameraRoll;
            [pickerVc showPickerVc:self];
            pickerVc.callBack = ^(NSArray *assets){
                NSMutableArray *images = [[NSMutableArray alloc]init];
                for (MLSelectPhotoAssets *asset in assets) {
                    [images addObject:[asset originImage]];
                }
                [self saveImage:images];
            };
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
        NSArray *imgs = [[NSArray alloc]initWithObjects:img, nil];
        [self performSelector:@selector(saveImage:)  withObject:imgs afterDelay:0.5];
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    //    [picker dismissModalViewControllerAnimated:YES];
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)saveImage:(NSArray *)images {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    // 异步任务
    dispatch_queue_t queue = dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        
        for (UIImage *image in images) {
            UIImage *smallImage = [self thumbnailWithImageWithoutScale:[self croppImage:image] size:[AddFeedContentCell sizeOfImage]];
            NSString *uploadImageName = [NSString stringWithFormat:@"upload_%d.jpg", (int)self.uploadImages.count];
            NSString *uploadImagePath = [documentsDirectory stringByAppendingPathComponent:uploadImageName];
            UIImage *uploadImage=[self scaleFromImage:image];
            [UIImageJPEGRepresentation(uploadImage, 1.0f) writeToFile:uploadImagePath atomically:YES];//写入文件
            
            SelectImage *si = [[SelectImage alloc]init];
            si.image = image;
            si.thumb = smallImage;
            si.fileName = uploadImageName;
            si.filePath = uploadImagePath;
            if (self.uploadImages == nil) {
                self.uploadImages = [[NSMutableArray alloc]init];
            }
            [self.uploadImages addObject:si];
        }
        
        // tell the main thread
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            self.content = self.contentCell.contentTv.text;
            [self.tableView reloadData];
        });
        
    });
}

// 改变图像的尺寸，方便上传服务器
- (UIImage *)scaleFromImage: (UIImage *) image
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
    [self takePictureClick];
}

#pragma mark - topic tags choose delegate

-(void)onChooseFinish:(Topic *)topic {
    self.topicId = topic.ids;
    self.topic = topic.title;
    
    self.content = self.contentCell.contentTv.text;
    [self.tableView reloadData];
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)onCancel {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
