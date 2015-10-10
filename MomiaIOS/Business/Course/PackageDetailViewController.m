//
//  PackageDetailViewController.m
//  MomiaIOS
//
//  Created by Deng Jun on 15/10/8.
//  Copyright © 2015年 Deng Jun. All rights reserved.
//

#import "PackageDetailViewController.h"

#import "PhotoTitleHeaderCell.h"
#import "CourseBuyCell.h"
#import "CourseTagsCell.h"
#import "CourseDiscCell.h"
#import "CourseSectionTitleCell.h"
#import "CourseListItemCell.h"

static NSString *identifierPhotoTitleHeaderCell = @"PhotoTitleHeaderCell";
static NSString *identifierCourseBuyCell = @"CourseBuyCell";
static NSString *identifierCourseTagsCell = @"CourseTagsCell";
static NSString *identifierCourseDiscCell = @"CourseDiscCell";
static NSString *identifierCourseSectionTitleCell = @"CourseSectionTitleCell";
static NSString *identifierCourseListItemCell = @"CourseListItemCell";

@interface PackageDetailViewController ()

@property(nonatomic, strong) UIView *buyView;
@property(nonatomic, assign) CGRect rectInTableView;

@end

@implementation PackageDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationItem.title = @"课程包详情";
    
    [PhotoTitleHeaderCell registerCellFromNibWithTableView:self.tableView withIdentifier:identifierPhotoTitleHeaderCell];
    [CourseBuyCell registerCellFromNibWithTableView:self.tableView withIdentifier:identifierCourseBuyCell];
    [CourseTagsCell registerCellFromClassWithTableView:self.tableView withIdentifier:identifierCourseTagsCell];
    [CourseSectionTitleCell registerCellFromNibWithTableView:self.tableView withIdentifier:identifierCourseSectionTitleCell];
    [CourseListItemCell registerCellFromNibWithTableView:self.tableView withIdentifier:identifierCourseListItemCell];
    
    self.buyView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64)];
    self.buyView.hidden = YES;
    self.buyView.backgroundColor = [UIColor greenColor];
    [self.view addSubview:self.buyView];
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

#pragma mark - tableview delegate & datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 3;
    } else if (section == 1) {
        return 2;
    } else if (section == 2) {
        return 3;
    } else if (section == 3) {
        return 6;
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
            headerCell.data = @"";
            cell = headerCell;
            
        } else if (row == 1) {
            CourseBuyCell *buyCell = [CourseBuyCell cellWithTableView:tableView forIndexPath:indexPath withIdentifier:identifierCourseBuyCell];
            buyCell.data = @"";
            cell = buyCell;
        } else {
            CourseTagsCell *tagsCell = [CourseTagsCell cellWithTableView:tableView forIndexPath:indexPath withIdentifier:identifierCourseTagsCell];
            tagsCell.data = @"";
            cell = tagsCell;
        }
    } else if (section == 1) {
        if (row == 0) {
            CourseSectionTitleCell *titleCell = [CourseSectionTitleCell cellWithTableView:tableView forIndexPath:indexPath withIdentifier:identifierCourseSectionTitleCell];
            titleCell.titleLabel.text = @"课程介绍";
            cell = titleCell;
            
        } else {
            CourseDiscCell *discCell = [tableView dequeueReusableCellWithIdentifier:identifierCourseDiscCell];
            if (discCell == nil) {
                discCell = [[CourseDiscCell alloc]initWithTableView:tableView forModel:@"" reuseIdentifier:identifierCourseDiscCell];
            }
            cell = discCell;
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
            cell = itemCell;
        }
    } else if (section == 3) {
        if (row == 0) {
            CourseSectionTitleCell *titleCell = [CourseSectionTitleCell cellWithTableView:tableView forIndexPath:indexPath withIdentifier:identifierCourseSectionTitleCell];
            titleCell.titleLabel.text = @"购买须知";
            cell = titleCell;
            
        } else {
            CourseListItemCell *itemCell = [CourseListItemCell cellWithTableView:tableView forIndexPath:indexPath withIdentifier:identifierCourseListItemCell];
            cell = itemCell;
        }
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    if (section == 0) {
        if (row == 0) {
            return [PhotoTitleHeaderCell heightWithTableView:tableView withIdentifier:identifierPhotoTitleHeaderCell forIndexPath:indexPath data:@""];
            
        } else if (row == 1) {
            return [CourseBuyCell heightWithTableView:tableView withIdentifier:identifierCourseBuyCell forIndexPath:indexPath data:@""];
        } else {
            return [CourseTagsCell heightWithTableView:tableView withIdentifier:identifierCourseTagsCell forIndexPath:indexPath data:@""];
        }
    } else if (section == 1) {
        if (row == 0) {
            return 44;
            
        } else {
            return [CourseDiscCell heightWithTableView:tableView forModel:@""];
        }
    } else if (section == 2) {
        if (row == 0) {
            return 44;
            
        } else {
            return 87;
        }
    } else if (section == 3) {
        if (row == 0) {
            return 44;
            
        } else {
            return 87;
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
