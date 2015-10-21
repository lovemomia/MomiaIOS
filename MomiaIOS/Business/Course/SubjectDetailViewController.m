//
//  PackageDetailViewController.m
//  MomiaIOS
//
//  Created by Deng Jun on 15/10/8.
//  Copyright © 2015年 Deng Jun. All rights reserved.
//

#import "SubjectDetailViewController.h"

#import "SubjectDetailModel.h"
#import "CourseList.h"

#import "PhotoTitleHeaderCell.h"
#import "CourseBuyCell.h"
#import "CourseTagsCell.h"
#import "CourseDiscCell.h"
#import "CourseSectionTitleCell.h"
#import "CourseListItemCell.h"
#import "CourseNoticeCell.h"

static NSString *identifierPhotoTitleHeaderCell = @"PhotoTitleHeaderCell";
static NSString *identifierCourseBuyCell = @"CourseBuyCell";
static NSString *identifierCourseTagsCell = @"CourseTagsCell";
static NSString *identifierCourseDiscCell = @"CourseDiscCell";
static NSString *identifierCourseSectionTitleCell = @"CourseSectionTitleCell";
static NSString *identifierCourseListItemCell = @"CourseListItemCell";
static NSString *identifierCourseNoticeCell = @"CourseNoticeCell";

@interface SubjectDetailViewController ()

@property (nonatomic, strong) NSString *ids;

@property (nonatomic, strong) UIView *buyView;
@property (nonatomic, assign) CGRect rectInTableView;
@property (nonatomic, strong) SubjectDetailModel *model;

@end

@implementation SubjectDetailViewController

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
    [CourseBuyCell registerCellFromNibWithTableView:self.tableView withIdentifier:identifierCourseBuyCell];
    [CourseTagsCell registerCellFromClassWithTableView:self.tableView withIdentifier:identifierCourseTagsCell];
    [CourseSectionTitleCell registerCellFromNibWithTableView:self.tableView withIdentifier:identifierCourseSectionTitleCell];
    [CourseListItemCell registerCellFromNibWithTableView:self.tableView withIdentifier:identifierCourseListItemCell];
    [CourseNoticeCell registerCellFromClassWithTableView:self.tableView withIdentifier:identifierCourseNoticeCell];
    [CourseDiscCell registerCellFromClassWithTableView:self.tableView withIdentifier:identifierCourseDiscCell];
    
    self.buyView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64)];
    self.buyView.hidden = YES;
    [self.view addSubview:self.buyView];
    
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

- (void)requestData:(BOOL)refresh {
    if (self.model == nil) {
        [self.view showLoadingBee];
    }
    
    CacheType cacheType = refresh ? CacheTypeDisable : CacheTypeDisable;
    
    NSDictionary * dic = @{@"id":self.ids};
    [[HttpService defaultService] GET:URL_APPEND_PATH(@"/subject") parameters:dic cacheType:cacheType JSONModelClass:[SubjectDetailModel class] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (self.model == nil) {
            [self.view removeLoadingBee];
        }
        
        self.model = responseObject;
        self.navigationItem.title = self.model.data.subject.title;
        
        [self.tableView reloadData];
        [self.tableView.header endRefreshing];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.view removeLoadingBee];
        [self showDialogWithTitle:nil message:error.message];
        [self.tableView.header endRefreshing];
    }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark -- UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    //获取悬停cell在TableView中的高度
    CGRect rectInTableView = [self.tableView rectForRowAtIndexPath:[NSIndexPath indexPathForItem:1 inSection:0]];
    if ((scrollView.contentOffset.y - rectInTableView.origin.y) > 0 && self.buyView.hidden == NO) {
        return;
    }
    if ((scrollView.contentOffset.y - rectInTableView.origin.y) < 0 && self.buyView.hidden == YES) {
        return;
    }
    
    if (self.buyView.subviews.count == 0) {
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForItem:1 inSection:0]];
        //复制一份用于显示在悬停View
        NSData * tempArchive = [NSKeyedArchiver archivedDataWithRootObject:cell];
        UITableViewCell *cellCopy = [NSKeyedUnarchiver unarchiveObjectWithData:tempArchive];
        UIView *buyBtn = [cellCopy viewWithTag:1001];
        UITapGestureRecognizer *singleTap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onBuyClicked:)];
        [buyBtn addGestureRecognizer:singleTap];
        cellCopy.frame = CGRectMake(0, 0, SCREEN_WIDTH, 64);
        [self.buyView addSubview:cellCopy];
    }
    
    //悬停的控制
    if ((scrollView.contentOffset.y - rectInTableView.origin.y) > 0){
        if (self.buyView.hidden == YES) {
            self.buyView.hidden = NO;
        }
    }
    if ((scrollView.contentOffset.y - rectInTableView.origin.y) < 0){
        if (self.buyView.hidden == NO) {
            self.buyView.hidden = YES;
        }
    }
}

- (void)onBuyClicked:(UITapGestureRecognizer *)tap {
    [self openURL:[NSString stringWithFormat:@"duola://fillorder?id=%@", self.model.data.subject.ids]];
}

#pragma mark - tableview delegate & datasource

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 2) {
        if (indexPath.row == 0) {
            [self openURL:[NSString stringWithFormat:@"duola://bookablecourselist?id=%@", self.model.data.subject.ids]];
        } else {
            Course *course = self.model.data.courses.list[indexPath.row - 1];
            [self openURL:[NSString stringWithFormat:@"duola://coursedetail?id=%@", course.ids]];
        }
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.model) {
        return 4;
    }
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 3;
    } else if (section == 1) {
        return 2;
    } else if (section == 2) {
        return 1 + self.model.data.courses.list.count;
    } else if (section == 3) {
        return 2;
    }
    return 0;
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
            CourseBuyCell *buyCell = [CourseBuyCell cellWithTableView:tableView forIndexPath:indexPath withIdentifier:identifierCourseBuyCell];
            buyCell.data = self.model.data.subject;
            UIView *buyBtn = [buyCell viewWithTag:1001];
            UITapGestureRecognizer *singleTap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onBuyClicked:)];
            [buyBtn addGestureRecognizer:singleTap];
            cell = buyCell;
            cell.selectionStyle = UITableViewCellSeparatorStyleNone;
            
        } else {
            CourseTagsCell *tagsCell = [CourseTagsCell cellWithTableView:tableView forIndexPath:indexPath withIdentifier:identifierCourseTagsCell];
            tagsCell.data = self.model.data.subject;
            cell = tagsCell;
            cell.selectionStyle = UITableViewCellSeparatorStyleNone;
        }
    } else if (section == 1) {
        if (row == 0) {
            CourseSectionTitleCell *titleCell = [CourseSectionTitleCell cellWithTableView:tableView forIndexPath:indexPath withIdentifier:identifierCourseSectionTitleCell];
            titleCell.titleLabel.text = @"课程目标";
            cell = titleCell;
            cell.selectionStyle = UITableViewCellSeparatorStyleNone;
            
        } else {
            CourseDiscCell *discCell = [CourseDiscCell cellWithTableView:tableView forIndexPath:indexPath withIdentifier:identifierCourseDiscCell];
            discCell.data = self.model.data.subject.intro;
            cell = discCell;
            cell.selectionStyle = UITableViewCellSeparatorStyleNone;
        }
    } else if (section == 2) {
        if (row == 0) {
            CourseSectionTitleCell *titleCell = [CourseSectionTitleCell cellWithTableView:tableView forIndexPath:indexPath withIdentifier:identifierCourseSectionTitleCell];
            titleCell.titleLabel.text = @"可选课程";
            titleCell.subTitleLabel.text = @"查看更多";
            titleCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell = titleCell;
            
        } else {
            CourseListItemCell *itemCell = [CourseListItemCell cellWithTableView:tableView forIndexPath:indexPath withIdentifier:identifierCourseListItemCell];
            itemCell.data = self.model.data.courses.list[row - 1];
            cell = itemCell;
        }
    } else if (section == 3) {
        if (row == 0) {
            CourseSectionTitleCell *titleCell = [CourseSectionTitleCell cellWithTableView:tableView forIndexPath:indexPath withIdentifier:identifierCourseSectionTitleCell];
            titleCell.titleLabel.text = @"购买须知";
            cell = titleCell;
            cell.selectionStyle = UITableViewCellSeparatorStyleNone;
            
        } else {
            CourseNoticeCell *noticeCell = [CourseNoticeCell cellWithTableView:tableView forIndexPath:indexPath withIdentifier:identifierCourseNoticeCell];
            noticeCell.data = self.model.data.subject;
            cell = noticeCell;
            cell.selectionStyle = UITableViewCellSeparatorStyleNone;
        }
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
            return [CourseBuyCell heightWithTableView:tableView withIdentifier:identifierCourseBuyCell forIndexPath:indexPath data:self.model.data.subject];
        } else {
            return [CourseTagsCell heightWithTableView:tableView withIdentifier:identifierCourseTagsCell forIndexPath:indexPath data:self.model.data.subject];
        }
    } else if (section == 1) {
        if (row == 0) {
            return 44;
            
        } else {
            return [CourseDiscCell heightWithTableView:tableView withIdentifier:identifierCourseDiscCell forIndexPath:indexPath data:self.model.data.subject.intro];
        }
    } else if (section == 2) {
        if (row == 0) {
            return 44;
            
        } else {
            return [CourseListItemCell heightWithTableView:tableView withIdentifier:identifierCourseListItemCell forIndexPath:indexPath data:self.model.data.courses.list[row - 1]];
        }
    } else if (section == 3) {
        if (row == 0) {
            return 44;
            
        } else {
            return [CourseNoticeCell heightWithTableView:tableView withIdentifier:identifierCourseNoticeCell forIndexPath:indexPath data:self.model.data.subject];
        }
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0.1;
    }
    return 10.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}

@end
