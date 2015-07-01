//
//  ActivityDetailViewController.m
//  MomiaIOS
//
//  Created by Owen on 15/6/16.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import "ProductDetailViewController.h"
#import "ProductDetailCarouselCell.h"
#import "ProductDetailEnrollCell.h"
#import "ProductDetailBasicInfoCell.h"
#import "ProductDetailTeacherCell.h"
#import "ProductDetailContentCell.h"
#import "ProductDetailLinkCell.h"
#import "ProductDetailModel.h"
#import "CommonHeaderView.h"

static NSString * productDetailCarouselIdentifier = @"CellProductDetailCarousel";
static NSString * productDetailEnrollIdentifier = @"CellProductDetailEnroll";
static NSString * productDetailBasicInfoIdentifier = @"CellProductDetailBasicInfo";
static NSString * productDetailTeacherIdentifier = @"CellProductDetailTeacher";
static NSString * productDetailContentIdentifier = @"CellProductDetailContent";
static NSString * productDetailLinkIdentifier = @"CellProductDetailLink";

typedef enum
{
    CellStyleContent,
    CellStyleImage,
    CellStyleLink
} CellStyle;

@interface ProductDetailViewController ()


@property(nonatomic,strong) ProductDetailModel * model;
@property(nonatomic,strong) NSString * productId;

@end

@implementation ProductDetailViewController

//辅助方法，用来根据model判断cell的样式
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
    if(section >= 3) {
        ProductContentModel * model = self.model.data.content[section - 3];
        return [CommonHeaderView heightWithTableView:tableView data:model.title];
    }
    return 0.1;
}


-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if(section >= 3) return 0.1;
    else return 10.0;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if(self.model)
        return 3 + self.model.data.content.count;
    return 0;
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
        height = [ProductDetailCarouselCell heightWithTableView:tableView withIdentifier:productDetailCarouselIdentifier forIndexPath:indexPath data:self.model.data];
    } else if(section == 1) {
        height = [ProductDetailEnrollCell heightWithTableView:tableView withIdentifier:productDetailEnrollIdentifier forIndexPath:indexPath data:self.model.data.customers];
    } else if(section == 2) {
        height = [ProductDetailBasicInfoCell heightWithTableView:tableView withIdentifier:productDetailBasicInfoIdentifier forIndexPath:indexPath data:@"蛮好哦"];
    } else {
        ProductContentModel * model = self.model.data.content[section - 3];
        if([self judgeCellStyleWithContentModel:model] == CellStyleLink) {
            
            if(row == 0) {//第一个cell是content
                
                height = [ProductDetailContentCell heightWithTableView:self.tableView withIdentifier:productDetailContentIdentifier forIndexPath:indexPath data:model];
                
            } else {//第二个cell是link
                height = [ProductDetailLinkCell heightWithTableView:self.tableView withIdentifier:productDetailLinkIdentifier forIndexPath:indexPath data:model];
            }
            
        } else if([self judgeCellStyleWithContentModel:model] == CellStyleImage) {
            
            height = [ProductDetailTeacherCell heightWithTableView:self.tableView withIdentifier:productDetailTeacherIdentifier forIndexPath:indexPath data:model];
            
        } else {
            height = [ProductDetailContentCell heightWithTableView:self.tableView withIdentifier:productDetailContentIdentifier forIndexPath:indexPath data:model];
        }
    }
    return height;
}


-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UITableViewHeaderFooterView * view;
    if(section >= 3) {
        CommonHeaderView * header = [CommonHeaderView cellWithTableView:self.tableView];
        header.data = ((ProductContentModel *)self.model.data.content[section - 3]).title;
        view = header;
        
    }
    return view;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell;
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    if(section == 0) {
        ProductDetailCarouselCell * carousel = [ProductDetailCarouselCell cellWithTableView:tableView forIndexPath:indexPath withIdentifier:productDetailCarouselIdentifier];
        carousel.data = self.model.data;
        cell = carousel;
    } else if(section == 1) {
        ProductDetailEnrollCell * enroll = [ProductDetailEnrollCell cellWithTableView:tableView forIndexPath:indexPath withIdentifier:productDetailEnrollIdentifier];
        enroll.data = self.model.data.customers;
        cell = enroll;
    } else if(section == 2) {
        ProductDetailBasicInfoCell * basicInfo = [ProductDetailBasicInfoCell cellWithTableView:tableView forIndexPath:indexPath withIdentifier:productDetailBasicInfoIdentifier];
        [basicInfo setData:self.model.data withIndex:row];
        cell = basicInfo;
    } else {
        ProductContentModel * model = self.model.data.content[section - 3];
        if([self judgeCellStyleWithContentModel:model] == CellStyleLink) {
            if(row == 0) {//第一个cell是content
                ProductDetailContentCell * content = [ProductDetailContentCell cellWithTableView:self.tableView forIndexPath:indexPath withIdentifier:productDetailContentIdentifier];
                content.data = model;
                cell = content;
                
            } else {//第二个cell是link
                ProductDetailLinkCell * link = [ProductDetailLinkCell cellWithTableView:self.tableView forIndexPath:indexPath withIdentifier:productDetailLinkIdentifier];
                link.data = model;
                cell = link;
            }
            
        } else if([self judgeCellStyleWithContentModel:model] == CellStyleImage) {
            ProductDetailTeacherCell * teacher = [ProductDetailTeacherCell cellWithTableView:self.tableView forIndexPath:indexPath withIdentifier:productDetailTeacherIdentifier];
            teacher.data = model;
            cell = teacher;
            
        } else {
            ProductDetailContentCell * content = [ProductDetailContentCell cellWithTableView:self.tableView forIndexPath:indexPath withIdentifier:productDetailContentIdentifier];
            content.data = model;
            cell = content;
        }

    }
    return cell;
}


- (IBAction)dateFriend:(id)sender {
    
}

- (IBAction)signUp:(id)sender {
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"tq://fillorder?id=%@&utoken=%@", self.productId,@"123"]];
    
    [[UIApplication sharedApplication] openURL:url];

}

-(void)onCollectClick
{
    
}


#pragma mark - webData Request

- (void)requestData {
    if (self.model == nil) {
        [self.view showLoadingBee];
    }
    

    NSDictionary * dic = @{@"id":self.productId};
    [[HttpService defaultService] GET:URL_APPEND_PATH(@"/product") parameters:dic cacheType:CacheTypeNormal JSONModelClass:[ProductDetailModel class] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (self.model == nil) {
            [self.view removeLoadingBee];
        }
        
        self.model = responseObject;
        
        [self.tableView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}


-(instancetype)initWithParams:(NSDictionary *)params
{
    self = [super initWithParams:params];
    if(self) {
        self.productId =  [params objectForKey:@"id"];
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"活动详情";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"a_d_collect"] style:UIBarButtonItemStylePlain target:self action:@selector(onCollectClick)];
    
    [ProductDetailCarouselCell registerCellWithTableView:self.tableView withIdentifier:productDetailCarouselIdentifier];
    [ProductDetailEnrollCell registerCellWithTableView:self.tableView withIdentifier:productDetailEnrollIdentifier];
    [ProductDetailBasicInfoCell registerCellWithTableView:self.tableView withIdentifier:productDetailBasicInfoIdentifier];
    [ProductDetailContentCell registerCellWithTableView:self.tableView withIdentifier:productDetailContentIdentifier];
    [ProductDetailTeacherCell registerCellWithTableView:self.tableView withIdentifier:productDetailTeacherIdentifier];
    [ProductDetailLinkCell registerCellWithTableView:self.tableView withIdentifier:productDetailLinkIdentifier];

    [CommonHeaderView registerCellWithTableView:self.tableView];
    
    self.tableView.backgroundView = [[UIView alloc] init];
    self.tableView.backgroundView.backgroundColor = UIColorFromRGB(0xf1f1f1);
    
    self.tableView.width = SCREEN_WIDTH;
    
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
