//
//  PackageDetailViewController.m
//  MomiaIOS
//
//  Created by Deng Jun on 15/10/8.
//  Copyright © 2015年 Deng Jun. All rights reserved.
//

#import "SubjectDetailViewController.h"
#import "MJRefreshHelper.h"
#import "SubjectDetailModel.h"
#import "CourseListModel.h"
#import "ReviewListModel.h"

#import "PhotoTitleHeaderCell.h"
#import "SubjectBuyCell.h"
#import "SubjectDiscCell.h"
#import "CourseSectionTitleCell.h"
#import "CourseNoticeCell.h"
#import "ReviewListItemCell.h"
#import "SubjectCourseCell.h"

static NSString *identifierPhotoTitleHeaderCell = @"PhotoTitleHeaderCell";
static NSString *identifierSubjctBuyCell = @"SubjctBuyCell";
static NSString *identifierSubjectDiscCell = @"SubjectDiscCell";
static NSString *identifierCourseSectionTitleCell = @"CourseSectionTitleCell";
static NSString *identifierCourseNoticeCell = @"CourseNoticeCell";
static NSString *identifierReviewListItemCell = @"ReviewListItemCell";
static NSString *identifierSubjectCourseCell = @"SubjectCourseCell";

@interface SubjectDetailViewController ()

@property (nonatomic, strong) NSString *ids;

@property (nonatomic, strong) SubjectDetailModel *model;
@property (nonatomic, assign) BOOL hasFeed;
@end

@implementation SubjectDetailViewController

- (UIEdgeInsets)tableViewOriginalContentInset {
    return UIEdgeInsetsMake(-1, 0, 64, 0);
}

- (instancetype)initWithParams:(NSDictionary *)params {
    if (self = [super initWithParams:params]) {
        self.ids = [params objectForKey:@"id"];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [PhotoTitleHeaderCell registerCellFromNibWithTableView:self.tableView withIdentifier:identifierPhotoTitleHeaderCell];
    [SubjectBuyCell registerCellFromNibWithTableView:self.tableView withIdentifier:identifierSubjctBuyCell];
    [CourseSectionTitleCell registerCellFromNibWithTableView:self.tableView withIdentifier:identifierCourseSectionTitleCell];
    [CourseNoticeCell registerCellFromClassWithTableView:self.tableView withIdentifier:identifierCourseNoticeCell];
    [SubjectDiscCell registerCellFromClassWithTableView:self.tableView withIdentifier:identifierSubjectDiscCell];
    [ReviewListItemCell registerCellFromNibWithTableView:self.tableView withIdentifier:identifierReviewListItemCell];
    [SubjectCourseCell registerCellFromNibWithTableView:self.tableView withIdentifier:identifierSubjectCourseCell];

    self.tableView.mj_header = [MJRefreshHelper createGifHeaderWithRefreshingTarget:self refreshingAction:@selector(requestData)];
    
    [self requestData:YES];
}

- (void)setBuyView {
//    NSArray *arr = [[NSBundle mainBundle] loadNibNamed:@"SubjectBuyCell" owner:self options:nil];
//    SubjectBuyCell *buyCell = [arr objectAtIndex:0];
//    
//    buyCell.data = self.model.data.subject;
//    UIButton *buyBtn = [buyCell viewWithTag:1001];
//    UITapGestureRecognizer *singleTap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onBuyClicked:)];
//    [buyBtn addGestureRecognizer:singleTap];
//    buyCell.frame = CGRectMake(0, SCREEN_HEIGHT - 128, SCREEN_WIDTH, 64);
//    [self.view addSubview:buyCell];
    
    NSArray *arr = [[NSBundle mainBundle] loadNibNamed:@"SubjectBuyCell" owner:self options:nil];
    SubjectBuyCell *buyCell = [arr objectAtIndex:0];
    buyCell.data = self.model.data.subject;
    UIButton *buyBtn = buyCell.buyButton;
    UITapGestureRecognizer *singleTap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onBuyClicked:)];
    [buyBtn addGestureRecognizer:singleTap];
    buyCell.frame = CGRectMake(0, SCREEN_HEIGHT - 128, SCREEN_WIDTH, 64);
    [self.view addSubview:buyCell];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIEdgeInsets)separatorInsetForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return UIEdgeInsetsMake(0,SCREEN_WIDTH,0,0);
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
    
    NSDictionary * dic = @{@"id":self.ids};
    [[HttpService defaultService] GET:URL_APPEND_PATH(@"/v2/subject") parameters:dic cacheType:cacheType JSONModelClass:[SubjectDetailModel class] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (self.model == nil) {
            [self.view removeLoadingBee];
        }
        
        self.model = responseObject;
        self.hasFeed = self.model.data.comments && self.model.data.comments.list.count > 0;

        self.navigationItem.title = self.model.data.subject.title;
        
        [self setBuyView];
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.view removeLoadingBee];
        [self showDialogWithTitle:nil message:error.message];
        [self.tableView.mj_header endRefreshing];
    }];
}


- (void)onBuyClicked:(UITapGestureRecognizer *)tap {
    [self openURL:[NSString stringWithFormat:@"fillorder?id=%@", self.model.data.subject.ids]];
    
    [MobClick event:@"Subject_Buy"];
}

#pragma mark - tableview delegate & datasource

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 && indexPath.row > 1) {
        Course *course = self.model.data.courses.list[indexPath.row - 2];
        [self openURL:[NSString stringWithFormat:@"coursedetail?id=%@", course.ids]];
        
        NSDictionary *attributes = @{@"name":course.title, @"index":[NSString stringWithFormat:@"%d", (int)(indexPath.row - 2)]};
        [MobClick event:@"Subject_List" attributes:attributes];
        
    } else if (indexPath.section == 1 && indexPath.row == 0 && self.hasFeed) {
        [self openURL:[NSString stringWithFormat:@"reviewlist?subjectId=%@", self.ids]];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.model) {
        if (self.model.data.comments && self.model.data.comments.list.count > 0) {
            return 3;
        }
        return 2;
    }
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 2 + self.model.data.courses.list.count;
        
    } else if (section == 1 && self.model.data.comments && self.model.data.comments.list.count > 0) {
        return 2;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    UITableViewCell *cell;
    if (section == 0) {
        if (row == 0) {
            PhotoTitleHeaderCell *headerCell = [PhotoTitleHeaderCell cellWithTableView:tableView forIndexPath:indexPath withIdentifier:identifierPhotoTitleHeaderCell];
            headerCell.data = self.model.data.subject;
            cell = headerCell;
            
        } else if (row == 1) {
            SubjectDiscCell *discCell = [SubjectDiscCell cellWithTableView:tableView forIndexPath:indexPath withIdentifier:identifierSubjectDiscCell];
            discCell.data = self.model.data.subject.intro;
            cell = discCell;
            cell.selectionStyle = UITableViewCellSeparatorStyleNone;
            
        } else {
            SubjectCourseCell *courseCell = [SubjectCourseCell cellWithTableView:tableView forIndexPath:indexPath withIdentifier:identifierSubjectCourseCell];
            courseCell.data = self.model.data.courses.list[row - 2];
            cell = courseCell;
            cell.selectionStyle = UITableViewCellSeparatorStyleNone;
        }
        
    } else if (section == 1 && self.hasFeed) {
        if (row == 0) {
            CourseSectionTitleCell *titleCell = [CourseSectionTitleCell cellWithTableView:tableView forIndexPath:indexPath withIdentifier:identifierCourseSectionTitleCell];
            titleCell.titleLabel.text = @"用户评价";
            titleCell.subTitleLabel.text = @"";
            titleCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell = titleCell;
            cell.selectionStyle = UITableViewCellSeparatorStyleSingleLine;
            
        } else {
            ReviewListItemCell *reviewCell = [ReviewListItemCell cellWithTableView:self.tableView forIndexPath:indexPath withIdentifier:identifierReviewListItemCell];
            Review *review = self.model.data.comments.list[0];
            review.isShowOnly3Photos = [NSNumber numberWithBool:YES];
            [reviewCell setData:review];
            cell = reviewCell;
            cell.selectionStyle = UITableViewCellSeparatorStyleNone;
        }
        
    } else {
        CourseNoticeCell *noticeCell = [CourseNoticeCell cellWithTableView:tableView forIndexPath:indexPath withIdentifier:identifierCourseNoticeCell];
        noticeCell.data = self.model.data.subject.notice;
        cell = noticeCell;
        cell.selectionStyle = UITableViewCellSeparatorStyleNone;
        
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    if (section == 0) {
        if (row == 0) {
            return [PhotoTitleHeaderCell heightWithTableView:tableView withIdentifier:identifierPhotoTitleHeaderCell forIndexPath:indexPath data:self.model.data.subject];
            
        } else if (row == 1) {
            return [SubjectDiscCell heightWithTableView:tableView withIdentifier:identifierSubjectDiscCell forIndexPath:indexPath data:self.model.data.subject.intro];
            
        } else {
            return (SCREEN_WIDTH - 20) * 180 / 300 + 10;
        }
        
    } else if (section == 1 && self.hasFeed) {
        if (row == 0) {
            return 44;
            
        } else {
            Review *review = self.model.data.comments.list[0];
            review.isShowOnly3Photos = [NSNumber numberWithBool:YES];
            return [ReviewListItemCell heightWithTableView:tableView withIdentifier:identifierReviewListItemCell forIndexPath:indexPath data:review];
        }
        
    } else {
        return [CourseNoticeCell heightWithTableView:tableView withIdentifier:identifierCourseNoticeCell forIndexPath:indexPath data:self.model.data.subject.notice];
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10.0;
}

@end
