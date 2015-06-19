//
//  ActivityDetailViewController.m
//  MomiaIOS
//
//  Created by Owen on 15/6/16.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import "ActivityDetailViewController.h"
#import "ActivityDetailCarouselCell.h"
#import "ActivityDetailEnrollCell.h"
#import "ActivityDetailBasicInfoCell.h"
#import "ActivityDetailTeacherCell.h"
#import "ActivityDetailContentCell.h"
#import "ActivityDetailLinkCell.h"
#import "ActivityDetailModel.h"

static NSString * activityDetailCarouselIdentifier = @"CellActivityDetailCarousel";
static NSString * activityDetailEnrollIdentifier = @"CellActivityDetailEnroll";
static NSString * activityDetailBasicInfoIdentifier = @"CellActivityDetailBasicInfo";
static NSString * activityDetailTeacherIdentifier = @"CellActivityDetailTeacher";
static NSString * activityDetailContentIdentifier = @"CellActivityDetailContent";
static NSString * activityDetailLinkIdentifier = @"CellActivityDetailLink";

typedef enum
{
    CellStyleContent,
    CellStyleImage,
    CellStyleLink
} CellStyle;

@interface ActivityDetailViewController ()


@property(nonatomic,strong) ActivityDetailModel * model;

@end

@implementation ActivityDetailViewController


-(CellStyle)judgeCellStyleWithContentModel:(ProductContentModel *)model
{
    NSArray * array = model.body;
    CellStyle style = CellStyleContent;
    for (int i = 0; i < array.count; i++) {
        ProductBodyModel * model = array[i];
        if(model.link) {
            style = CellStyleLink;
            break;
        } else if(model.img) {
            style = CellStyleImage;
            break;
        }
    }
    return style;
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3 + self.model.data.content.count;
}




-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0) {
        return 1;
    } else if(section == 1) {
        if(self.model.data.imgs.count > 0)
            return 1;
        else return 0;
    } else if(section == 2) {
        return 3;
    } else {
        ProductContentModel * model = self.model.data.content[section - 3];
        if([self judgeCellStyleWithContentModel:model] == CellStyleLink) {
            return 2;
        } else {
            return 1;
        }
        
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 0;
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    if(section == 0) {
        height = [ActivityDetailCarouselCell heightWithTableView:tableView withIdentifier:activityDetailCarouselIdentifier forIndexPath:indexPath data:self.model.data];
    } else if(section == 1) {
        height = [ActivityDetailEnrollCell heightWithTableView:tableView withIdentifier:activityDetailEnrollIdentifier forIndexPath:indexPath data:self.model.data.customers];
    } else if(section == 2) {
        height = [ActivityDetailBasicInfoCell heightWithTableView:tableView withIdentifier:activityDetailBasicInfoIdentifier forIndexPath:indexPath data:@"蛮好哦"];
    } else {
        ProductContentModel * model = self.model.data.content[section - 3];
        if([self judgeCellStyleWithContentModel:model] == CellStyleLink) {
            
            if(row == 0) {//第一个cell是content
                
                height = [ActivityDetailContentCell heightWithTableView:self.tableView withIdentifier:activityDetailContentIdentifier forIndexPath:indexPath data:model];
                
            } else {//第二个cell是link
                height = [ActivityDetailLinkCell heightWithTableView:self.tableView withIdentifier:activityDetailLinkIdentifier forIndexPath:indexPath data:model];
            }
            
        } else if([self judgeCellStyleWithContentModel:model] == CellStyleImage) {
            
            height = [ActivityDetailTeacherCell heightWithTableView:self.tableView withIdentifier:activityDetailTeacherIdentifier forIndexPath:indexPath data:model];
            
        } else {
            height = [ActivityDetailContentCell heightWithTableView:self.tableView withIdentifier:activityDetailContentIdentifier forIndexPath:indexPath data:model];
        }
    }
    return height;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell;
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    if(section == 0) {
        ActivityDetailCarouselCell * carousel = [ActivityDetailCarouselCell cellWithTableView:tableView forIndexPath:indexPath withIdentifier:activityDetailCarouselIdentifier];
        carousel.data = self.model.data;
        cell = carousel;
    } else if(section == 1) {
        ActivityDetailEnrollCell * enroll = [ActivityDetailEnrollCell cellWithTableView:tableView forIndexPath:indexPath withIdentifier:activityDetailEnrollIdentifier];
        enroll.data = self.model.data.customers;
        cell = enroll;
    } else if(section == 2) {
        ActivityDetailBasicInfoCell * basicInfo = [ActivityDetailBasicInfoCell cellWithTableView:tableView forIndexPath:indexPath withIdentifier:activityDetailBasicInfoIdentifier];
        [basicInfo setData:self.model.data withIndex:row];
        cell = basicInfo;
    } else {
        ProductContentModel * model = self.model.data.content[section - 3];
        if([self judgeCellStyleWithContentModel:model] == CellStyleLink) {
            if(row == 0) {//第一个cell是content
                ActivityDetailContentCell * content = [ActivityDetailContentCell cellWithTableView:self.tableView forIndexPath:indexPath withIdentifier:activityDetailContentIdentifier];
                content.data = model;
                cell = content;
                
            } else {//第二个cell是link
                ActivityDetailLinkCell * link = [ActivityDetailLinkCell cellWithTableView:self.tableView forIndexPath:indexPath withIdentifier:activityDetailLinkIdentifier];
                link.data = model;
                cell = link;
            }
            
        } else if([self judgeCellStyleWithContentModel:model] == CellStyleImage) {
            ActivityDetailTeacherCell * teacher = [ActivityDetailTeacherCell cellWithTableView:self.tableView forIndexPath:indexPath withIdentifier:activityDetailTeacherIdentifier];
            teacher.data = model;
            cell = teacher;
            
        } else {
            ActivityDetailContentCell * content = [ActivityDetailContentCell cellWithTableView:self.tableView forIndexPath:indexPath withIdentifier:activityDetailContentIdentifier];
            content.data = model;
            cell = content;
        }

    }
    return cell;
}


- (IBAction)dateFriend:(id)sender {
    
}

- (IBAction)signUp:(id)sender {
    
}

-(void)onCollectClick
{
    
}


#pragma mark - webData Request

- (void)requestData {
    if (self.model == nil) {
        [self.view showLoadingBee];
    }
    
    NSDictionary * dic = @{@"id":@37};
    [[HttpService defaultService] GET:URL_APPEND_PATH(@"/product") parameters:dic cacheType:CacheTypeDisable JSONModelClass:[ActivityDetailModel class] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (self.model == nil) {
            [self.view removeLoadingBee];
        }
        
        self.model = responseObject;
        [self.tableView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"活动详情";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"a_d_collect"] style:UIBarButtonItemStylePlain target:self action:@selector(onCollectClick)];
    
    [ActivityDetailCarouselCell registerCellWithTableView:self.tableView withIdentifier:activityDetailCarouselIdentifier];
    [ActivityDetailEnrollCell registerCellWithTableView:self.tableView withIdentifier:activityDetailEnrollIdentifier];
    [ActivityDetailBasicInfoCell registerCellWithTableView:self.tableView withIdentifier:activityDetailBasicInfoIdentifier];
    [ActivityDetailContentCell registerCellWithTableView:self.tableView withIdentifier:activityDetailContentIdentifier];
    [ActivityDetailTeacherCell registerCellWithTableView:self.tableView withIdentifier:activityDetailTeacherIdentifier];
    [ActivityDetailLinkCell registerCellWithTableView:self.tableView withIdentifier:activityDetailLinkIdentifier];

    
    self.tableView.backgroundView = [[UIView alloc] init];
    self.tableView.backgroundView.backgroundColor = UIColorFromRGB(0xf1f1f1);
    
    [self requestData];
    
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

@end
