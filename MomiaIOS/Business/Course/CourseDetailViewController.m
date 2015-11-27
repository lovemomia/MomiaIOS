//
//  CourseDetailViewController.m
//  MomiaIOS
//
//  Created by Deng Jun on 15/9/29.
//  Copyright © 2015年 Deng Jun. All rights reserved.
//

#import "CourseDetailViewController.h"
#import "CourseDetailModel.h"
#import "CourseList.h"
#import "MJRefreshHelper.h"
#import "NSString+MOURLEncode.h"

#import "PhotoTitleHeaderCell.h"
#import "CourseTitleCell.h"
#import "CoursePriceCell.h"
#import "CourseDiscCell.h"
#import "CourseSectionTitleCell.h"
#import "CourseListItemCell.h"
#import "CoursePoiCell.h"
#import "CourseBookCell.h"
#import "CourseTeacherCell.h"
#import "ReviewListItemCell.h"
#import "CourseDetailCell.h"
#import "CourseBuyCell.h"

static NSString *identifierPhotoTitleHeaderCell = @"PhotoTitleHeaderCell";
static NSString *identifierCoursePriceCell = @"CoursePriceCell";
static NSString *identifierCourseTitleCell = @"CourseTitleCell";
static NSString *identifierCourseDiscCell = @"CourseDiscCell";
static NSString *identifierCourseSectionTitleCell = @"CourseSectionTitleCell";
static NSString *identifierCourseListItemCell = @"CourseListItemCell";
static NSString *identifierCoursePoiCell = @"CoursePoiCell";
static NSString *identifierCourseBookCell = @"CourseBookCell";
static NSString *identifierCourseTeacherCell = @"CourseTeacherCell";
static NSString *identifierReviewListItemCell = @"ReviewListItemCell";
static NSString *identifierCourseDetailCell = @"CourseDetailCell";

typedef enum {
    CellPhotoHeader,
    CellTitle,
    CellPrice,
    
    CellTitleGoal, // 去除v1.2
    CellGoal, // 去除v1.2
    
    CellTitlePoi,
    CellPoi,
    
    CellTitleBook, // 去除v1.2
    CellBook, // 去除v1.2
    
    CellTitleDetail,
    CellDetail,
    
    CellTitleHomework, // 去除v1.2
    CellHomework, // 去除v1.2
    
    CellTitleComment,
    CellComment,
    
    CellTitleTeacher,
    CellTeacher,
    
    CellTitleNotice,
    CellNotice,
    
    CellTitleTips,
    CellTips,
    
    CellTitleOrg,
    CellOrg,
    
    CellDefault
    
} CellType;

@interface CourseDetailViewController ()

@property (nonatomic, strong) NSString *ids;
@property (nonatomic, assign) BOOL buyAble;
@property (nonatomic, strong) CourseDetailModel *model;

@end

@implementation CourseDetailViewController

- (instancetype)initWithParams:(NSDictionary *)params {
    if (self = [super initWithParams:params]) {
        self.ids = [params objectForKey:@"id"];
        if ([params objectForKey:@"buyable"]) {
            self.buyAble = [[params objectForKey:@"buyable"] intValue] == 1;
        } else {
            self.buyAble = YES;
        }
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationItem.title = @"课程详情";
    
    [PhotoTitleHeaderCell registerCellFromNibWithTableView:self.tableView withIdentifier:identifierPhotoTitleHeaderCell];
    [CoursePriceCell registerCellFromNibWithTableView:self.tableView withIdentifier:identifierCoursePriceCell];
    [CourseTitleCell registerCellFromNibWithTableView:self.tableView withIdentifier:identifierCourseTitleCell];
    [CourseSectionTitleCell registerCellFromNibWithTableView:self.tableView withIdentifier:identifierCourseSectionTitleCell];
    [CourseListItemCell registerCellFromNibWithTableView:self.tableView withIdentifier:identifierCourseListItemCell];
    [CoursePoiCell registerCellFromNibWithTableView:self.tableView withIdentifier:identifierCoursePoiCell];
    [CourseBookCell registerCellFromClassWithTableView:self.tableView withIdentifier:identifierCourseBookCell];
    [CourseTeacherCell registerCellFromClassWithTableView:self.tableView withIdentifier:identifierCourseTeacherCell];
    [CourseDiscCell registerCellFromClassWithTableView:self.tableView withIdentifier:identifierCourseDiscCell];
    [ReviewListItemCell registerCellFromNibWithTableView:self.tableView withIdentifier:identifierReviewListItemCell];
    [CourseDetailCell registerCellFromClassWithTableView:self.tableView withIdentifier:identifierCourseDetailCell];
    
    self.tableView.header = [MJRefreshHelper createGifHeaderWithRefreshingTarget:self refreshingAction:@selector(requestData)];
    
    [self requestData:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIEdgeInsets)separatorInsetForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return UIEdgeInsetsMake(0,0,0,0);
    }
    return UIEdgeInsetsMake(0,10,0,0);
}

#pragma mark - webData Request

- (void)requestData {
    [self requestData:YES];
}

- (void)requestData:(BOOL)refresh {
    if (self.model == nil) {
        [self.view showLoadingBee];
    }
    
    CacheType cacheType = refresh ? CacheTypeDisable : CacheTypeDisable;
    
    NSDictionary * dic;
    if ([[LocationService defaultService] hasLocation]) {
        CLLocation *location = [LocationService defaultService].location;
        dic = @{@"id":self.ids, @"pos":[NSString stringWithFormat:@"%f,%f", location.coordinate.longitude, location.coordinate.latitude]};
        
    } else {
        dic = @{@"id":self.ids};
    }
    
    [[HttpService defaultService] GET:URL_APPEND_PATH(@"/v2/course") parameters:dic cacheType:cacheType JSONModelClass:[CourseDetailModel class] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (self.model == nil) {
            [self.view removeLoadingBee];
        }
        
        self.model = responseObject;
        if ([self.model.data.buyable intValue] == 1 && self.buyAble) {
            [self setBuyView];
            
        } else {
            self.model.data.buyable = [NSNumber numberWithInt:0];
        }
        
        [self.tableView reloadData];
        [self.tableView.header endRefreshing];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.view removeLoadingBee];
        [self showDialogWithTitle:nil message:error.message];
        [self.tableView.header endRefreshing];
    }];
}

- (void)setBuyView {
    NSArray *arr = [[NSBundle mainBundle] loadNibNamed:@"CourseBuyCell" owner:self options:nil];
    CourseBuyCell *buyCell = [arr objectAtIndex:0];
    buyCell.data = self.model.data;
    UIButton *buyBtn = [buyCell viewWithTag:1001];
    UITapGestureRecognizer *singleTap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onBuyClicked:)];
    [buyBtn addGestureRecognizer:singleTap];
    buyCell.frame = CGRectMake(0, SCREEN_HEIGHT - 128, SCREEN_WIDTH, 64);
    [self.view addSubview:buyCell];
}

- (void)onBuyClicked:(UITapGestureRecognizer *)tap {
    [self openURL:[NSString stringWithFormat:@"duola://fillorder?id=%@&coid=%@&coname=%@", self.model.data.subjectId, self.model.data.ids, [self.model.data.subject URLEncodedString]]];
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    CellType type = [self cellTypeForRowAtIndexPath:indexPath];
    if (type == CellTitlePoi) {
        [self openURL:[NSString stringWithFormat:@"duola://book?id=%@&onlyshow=1", self.ids]];
        
    } else if (type == CellTitleTeacher) {
        [self openURL:[NSString stringWithFormat:@"duola://courseteacherlist?id=%@", self.ids]];
        
    } else if (type == CellTitleBook) {
        [self openURL:[NSString stringWithFormat:@"duola://coursebookbrowser?id=%@", self.ids]];
        
    } else if (type == CellTitleDetail) {
//        NSString *url = [NSString stringWithFormat:@"http://%@/course/detail/app?id=%@", MO_DEBUG ? @"m.momia.cn" : @"m.sogokids.com", self.ids];
//        [self openURL:[NSString stringWithFormat:@"duola://web?url=%@", [url URLEncodedString]]];
        
    } else if (type == CellTitleComment) {
        [self openURL:[NSString stringWithFormat:@"duola://reviewlist?courseId=%@", self.ids]];
        
    } else if (type == CellTitleOrg) {
        NSString *url = [NSString stringWithFormat:@"http://%@/institution/detail/app?id=%@", MO_DEBUG ? @"m.momia.cn" : @"m.sogokids.com", self.ids];
        [self openURL:[NSString stringWithFormat:@"duola://web?url=%@", [url URLEncodedString]]];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CellType)cellTypeForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    if (section == 0) {
        if (row == 0) {
            return CellPhotoHeader;
        } else if (row == 1) {
            return CellTitle;
        } else {
            return CellPrice;
        }
    }
    
    int num = 0;
    if (self.model.data.comments) {
        num++;
        if (section == num) {
            return row == 0 ? CellTitleComment : CellComment;
        }
    }
    
    num++;
    if (section == num) {
        return row == 0 ? CellTitleDetail : CellDetail;
    }
    
    if (self.model.data.place) {
        num++;
        if (section == num) {
            return row == 0 ? CellTitlePoi : CellPoi;
        }
    }
    
    if (self.model.data.teachers) {
        num++;
        if (section == num) {
            return row == 0 ? CellTitleTeacher : CellTeacher;
        }
    }
    
    if (self.model.data.tips.length > 0) {
        num++;
        if (section == num) {
            return row == 0 ? CellTitleTips : CellTips;
        }
    }
    
    if (self.model.data.notice.length > 0) {
        num++;
        if (section == num) {
            return row == 0 ? CellTitleNotice : CellNotice;
        }
    }
    
    if (self.model.data.institution) {
        num++;
        if (section == num) {
            return row == 0 ? CellTitleOrg : CellOrg;
        }
    }
    return CellDefault;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.model) {
        int num = 2;
//        if (self.model.data.book) {
//            num++;
//        }
        if (self.model.data.place) {
            num++;
        }
        if (self.model.data.comments) {
            num++;
        }
        if (self.model.data.teachers) {
            num++;
        }
        if (self.model.data.tips.length > 0) {
            num++;
        }
        if (self.model.data.notice.length > 0) {
            num++;
        }
        if (self.model.data.institution) {
            num++;
        }
        return num;
    }
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 3;
    }
    if (section == 1 && self.model.data.comments) {
        return 1 + self.model.data.comments.list.count;
    }
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CellType type = [self cellTypeForRowAtIndexPath:indexPath];
    UITableViewCell *cell;
    
    if (type == CellPhotoHeader) {
        PhotoTitleHeaderCell *headerCell = [PhotoTitleHeaderCell cellWithTableView:tableView forIndexPath:indexPath withIdentifier:identifierPhotoTitleHeaderCell];
        headerCell.data = self.model.data;
        cell = headerCell;
        
    } else if (type == CellPrice) {
        CoursePriceCell *priceCell = [CoursePriceCell cellWithTableView:tableView forIndexPath:indexPath withIdentifier:identifierCoursePriceCell];
        priceCell.data = self.model.data;
        cell = priceCell;
        cell.selectionStyle = UITableViewCellSeparatorStyleNone;
        
    } else if (type == CellTitle) {
        CourseTitleCell *titleCell = [CourseTitleCell cellWithTableView:tableView forIndexPath:indexPath withIdentifier:identifierCourseTitleCell];
        titleCell.data = self.model.data;
        cell = titleCell;
        cell.selectionStyle = UITableViewCellSeparatorStyleNone;
        
    } else if (type == CellTitleGoal) {
        CourseSectionTitleCell *titleCell = [CourseSectionTitleCell cellWithTableView:tableView forIndexPath:indexPath withIdentifier:identifierCourseSectionTitleCell];
        titleCell.accessoryType = UITableViewCellAccessoryNone;
        titleCell.titleLabel.text = @"课程目标";
        titleCell.subTitleLabel.text = @"";
        cell = titleCell;
        cell.selectionStyle = UITableViewCellSeparatorStyleNone;
        
    } else if (type == CellGoal) {
        CourseDiscCell *discCell = [CourseDiscCell cellWithTableView:tableView forIndexPath:indexPath withIdentifier:identifierCourseDiscCell];
        discCell.data = self.model.data.goal;
        cell = discCell;
        cell.selectionStyle = UITableViewCellSeparatorStyleNone;
        
    } else if (type == CellTitlePoi) {
        CourseSectionTitleCell *titleCell = [CourseSectionTitleCell cellWithTableView:tableView forIndexPath:indexPath withIdentifier:identifierCourseSectionTitleCell];
        titleCell.titleLabel.text = @"课程表";
        titleCell.subTitleLabel.text = @"";
        titleCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell = titleCell;
        cell.selectionStyle = UITableViewCellSeparatorStyleSingleLine;
        
    } else if (type == CellPoi) {
        CoursePoiCell *poiCell = [CoursePoiCell cellWithTableView:tableView forIndexPath:indexPath withIdentifier:identifierCoursePoiCell];
        poiCell.data = self.model.data.place;
        cell = poiCell;
        cell.selectionStyle = UITableViewCellSeparatorStyleNone;
        
    } else if (type == CellTitleBook) {
        CourseSectionTitleCell *titleCell = [CourseSectionTitleCell cellWithTableView:tableView forIndexPath:indexPath withIdentifier:identifierCourseSectionTitleCell];
        titleCell.titleLabel.text = @"课前绘本";
        titleCell.subTitleLabel.text = @"";
        titleCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell = titleCell;
        cell.selectionStyle = UITableViewCellSeparatorStyleSingleLine;
        
    } else if (type == CellBook) {
        CourseBookCell *bookCell = [CourseBookCell cellWithTableView:tableView forIndexPath:indexPath withIdentifier:identifierCourseBookCell];
        bookCell.data = self.model.data.book;
        cell = bookCell;
        cell.selectionStyle = UITableViewCellSeparatorStyleNone;
        
    } else if (type == CellTitleDetail) {
        CourseSectionTitleCell *titleCell = [CourseSectionTitleCell cellWithTableView:tableView forIndexPath:indexPath withIdentifier:identifierCourseSectionTitleCell];
        titleCell.titleLabel.text = @"课程内容";
        titleCell.subTitleLabel.text = @"";
        titleCell.accessoryType = UITableViewCellAccessoryNone;
        cell = titleCell;
        cell.selectionStyle = UITableViewCellSeparatorStyleNone;
        
    } else if (type == CellDetail) {
        CourseDetailCell *discCell = [CourseDetailCell cellWithTableView:tableView forIndexPath:indexPath withIdentifier:identifierCourseDetailCell];
        discCell.data = self.model.data;
        cell = discCell;
        cell.selectionStyle = UITableViewCellSeparatorStyleNone;
        
    } else if (type == CellTitleComment) {
        CourseSectionTitleCell *titleCell = [CourseSectionTitleCell cellWithTableView:tableView forIndexPath:indexPath withIdentifier:identifierCourseSectionTitleCell];
        titleCell.titleLabel.text = [NSString stringWithFormat:@"用户点评（%@）", self.model.data.comments.totalCount];
        cell = titleCell;
        titleCell.subTitleLabel.text = @"更多";
        titleCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSeparatorStyleSingleLine;
        
    } else if (type == CellComment) {
        ReviewListItemCell *reviewCell = [ReviewListItemCell cellWithTableView:self.tableView forIndexPath:indexPath withIdentifier:identifierReviewListItemCell];
        [reviewCell setData:self.model.data.comments.list[indexPath.row - 1]];
        cell = reviewCell;
        cell.selectionStyle = UITableViewCellSeparatorStyleNone;
        
    } else if (type == CellTitleTeacher) {
        CourseSectionTitleCell *titleCell = [CourseSectionTitleCell cellWithTableView:tableView forIndexPath:indexPath withIdentifier:identifierCourseSectionTitleCell];
        titleCell.titleLabel.text = @"讲师团";
        titleCell.subTitleLabel.text = @"";
        titleCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell = titleCell;
        cell.selectionStyle = UITableViewCellSeparatorStyleSingleLine;
        
    } else if (type == CellTeacher) {
        CourseTeacherCell *bookCell = [CourseTeacherCell cellWithTableView:tableView forIndexPath:indexPath withIdentifier:identifierCourseTeacherCell];
        bookCell.data = self.model.data.teachers;
        cell = bookCell;
        cell.selectionStyle = UITableViewCellSeparatorStyleNone;
        
    } else if (type == CellTitleTips) {
        CourseSectionTitleCell *titleCell = [CourseSectionTitleCell cellWithTableView:tableView forIndexPath:indexPath withIdentifier:identifierCourseSectionTitleCell];
        titleCell.titleLabel.text = @"特别提示";
        titleCell.subTitleLabel.text = @"";
        titleCell.accessoryType = UITableViewCellAccessoryNone;
        cell = titleCell;
        cell.selectionStyle = UITableViewCellSeparatorStyleNone;
        
    } else if (type == CellTips) {
        CourseDiscCell *discCell = [CourseDiscCell cellWithTableView:tableView forIndexPath:indexPath withIdentifier:identifierCourseDiscCell];
        discCell.data = self.model.data.tips;
        cell = discCell;
        cell.selectionStyle = UITableViewCellSeparatorStyleNone;
        
    } else if (type == CellTitleNotice) {
        CourseSectionTitleCell *titleCell = [CourseSectionTitleCell cellWithTableView:tableView forIndexPath:indexPath withIdentifier:identifierCourseSectionTitleCell];
        titleCell.titleLabel.text = @"购买须知";
        titleCell.subTitleLabel.text = @"";
        titleCell.accessoryType = UITableViewCellAccessoryNone;
        cell = titleCell;
        cell.selectionStyle = UITableViewCellSeparatorStyleNone;
        
    } else if (type == CellNotice) {
        CourseDiscCell *discCell = [CourseDiscCell cellWithTableView:tableView forIndexPath:indexPath withIdentifier:identifierCourseDiscCell];
        discCell.data = self.model.data.notice;
        cell = discCell;
        cell.selectionStyle = UITableViewCellSeparatorStyleNone;
        
    } else if (type == CellTitleOrg) {
        CourseSectionTitleCell *titleCell = [CourseSectionTitleCell cellWithTableView:tableView forIndexPath:indexPath withIdentifier:identifierCourseSectionTitleCell];
        titleCell.titleLabel.text = @"合作机构介绍";
        titleCell.subTitleLabel.text = @"";
        titleCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell = titleCell;
        cell.selectionStyle = UITableViewCellSeparatorStyleSingleLine;
        
    } else if (type == CellOrg) {
        CourseDiscCell *discCell = [CourseDiscCell cellWithTableView:tableView forIndexPath:indexPath withIdentifier:identifierCourseDiscCell];
        discCell.data = self.model.data.institution;
        cell = discCell;
        cell.selectionStyle = UITableViewCellSeparatorStyleNone;
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CellType type = [self cellTypeForRowAtIndexPath:indexPath];
    
    if (type == CellPhotoHeader) {
        return [PhotoTitleHeaderCell heightWithTableView:tableView withIdentifier:identifierPhotoTitleHeaderCell forIndexPath:indexPath data:self.model.data];
        
    } else if (type == CellPrice) {
        return [CoursePriceCell heightWithTableView:tableView withIdentifier:identifierCoursePriceCell forIndexPath:indexPath data:self.model.data];
        
    } else if (type == CellTitle) {
        return [CourseTitleCell heightWithTableView:tableView withIdentifier:identifierCourseTitleCell forIndexPath:indexPath data:self.model.data];
        
    } else if (type == CellTitleGoal) {
        return [CourseSectionTitleCell heightWithTableView:tableView withIdentifier:identifierCourseSectionTitleCell forIndexPath:indexPath data:nil];
        
    } else if (type == CellGoal) {
        return [CourseDiscCell heightWithTableView:tableView withIdentifier:identifierCourseDiscCell forIndexPath:indexPath data:self.model.data.goal];
        
    } else if (type == CellTitlePoi) {
        return [CourseSectionTitleCell heightWithTableView:tableView withIdentifier:identifierCourseSectionTitleCell forIndexPath:indexPath data:nil];
        
    } else if (type == CellPoi) {
        return [CoursePoiCell heightWithTableView:tableView withIdentifier:identifierCoursePoiCell forIndexPath:indexPath data:nil];
        
    } else if (type == CellTitleBook) {
        return [CourseSectionTitleCell heightWithTableView:tableView withIdentifier:identifierCourseSectionTitleCell forIndexPath:indexPath data:nil];
        
    } else if (type == CellBook) {
        return [CourseBookCell heightWithTableView:tableView withIdentifier:identifierCourseBookCell forIndexPath:indexPath data:nil];
        
    } else if (type == CellTitleDetail) {
        return [CourseSectionTitleCell heightWithTableView:tableView withIdentifier:identifierCourseSectionTitleCell forIndexPath:indexPath data:nil];
        
    } else if (type == CellDetail) {
        return [CourseDetailCell heightWithTableView:tableView withIdentifier:identifierCourseDetailCell forIndexPath:indexPath data:self.model.data];
        
    } else if (type == CellTitleComment) {
        return [CourseSectionTitleCell heightWithTableView:tableView withIdentifier:identifierCourseSectionTitleCell forIndexPath:indexPath data:nil];
        
    } else if (type == CellComment) {
        return [ReviewListItemCell heightWithTableView:tableView withIdentifier:identifierReviewListItemCell forIndexPath:indexPath data:self.model.data.comments.list[indexPath.row - 1]];
        
    } else if (type == CellTitleTeacher) {
        return [CourseSectionTitleCell heightWithTableView:tableView withIdentifier:identifierCourseSectionTitleCell forIndexPath:indexPath data:nil];
        
    } else if (type == CellTeacher) {
        return [CourseTeacherCell heightWithTableView:tableView withIdentifier:identifierCourseDiscCell forIndexPath:indexPath data:nil];
        
    } else if (type == CellTitleTips) {
        return [CourseSectionTitleCell heightWithTableView:tableView withIdentifier:identifierCourseSectionTitleCell forIndexPath:indexPath data:nil];
        
    } else if (type == CellTips) {
        return [CourseDiscCell heightWithTableView:tableView withIdentifier:identifierCourseDiscCell forIndexPath:indexPath data:self.model.data.tips];
        
    } else if (type == CellTitleNotice) {
        return [CourseSectionTitleCell heightWithTableView:tableView withIdentifier:identifierCourseSectionTitleCell forIndexPath:indexPath data:nil];
        
    } else if (type == CellNotice) {
        return [CourseDiscCell heightWithTableView:tableView withIdentifier:identifierCourseDiscCell forIndexPath:indexPath data:self.model.data.notice];
        
    } else if (type == CellTitleOrg) {
        return [CourseSectionTitleCell heightWithTableView:tableView withIdentifier:identifierCourseSectionTitleCell forIndexPath:indexPath data:nil];
        
    } else if (type == CellOrg) {
        return [CourseDiscCell heightWithTableView:tableView withIdentifier:identifierCourseDiscCell forIndexPath:indexPath data:self.model.data.institution];
    }
    
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if ([self.model.data.buyable intValue] == 1 && section == ([self numberOfSectionsInTableView:tableView] - 1)) {
        return 74;
    }
    return 10;
}
@end
