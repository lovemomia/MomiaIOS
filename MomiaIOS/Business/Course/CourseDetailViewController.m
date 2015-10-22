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

#import "PhotoTitleHeaderCell.h"
#import "CoursePriceCell.h"
#import "CourseTagsCell.h"
#import "CourseDiscCell.h"
#import "CourseSectionTitleCell.h"
#import "CourseListItemCell.h"
#import "CoursePoiCell.h"
#import "CourseBookCell.h"
#import "CourseTeacherCell.h"

#import "FeedUserHeadCell.h"
#import "FeedContentCell.h"

static NSString *identifierPhotoTitleHeaderCell = @"PhotoTitleHeaderCell";
static NSString *identifierCoursePriceCell = @"CoursePriceCell";
static NSString *identifierCourseTagsCell = @"CourseTagsCell";
static NSString *identifierCourseDiscCell = @"CourseDiscCell";
static NSString *identifierCourseSectionTitleCell = @"CourseSectionTitleCell";
static NSString *identifierCourseListItemCell = @"CourseListItemCell";
static NSString *identifierCoursePoiCell = @"CoursePoiCell";
static NSString *identifierCourseBookCell = @"CourseBookCell";
static NSString *identifierCourseTeacherCell = @"CourseTeacherCell";

typedef enum {
    CellPhotoHeader,
    CellPrice,
    CellTag,
    
    CellTitleGoal,
    CellGoal,
    
    CellTitlePoi,
    CellPoi,
    
    CellTitleBook,
    CellBook,
    
    CellTitleFlow,
    CellFlow,
    
    CellTitleHomework,
    CellHomework,
    
    CellTitleComment,
    CellComment,
    
    CellTitleTeacher,
    CellTeacher,
    
    CellTitleTips,
    CellTips,
    
    CellTitleOrg,
    CellOrg,
    
    CellDefault
    
} CellType;

@interface CourseDetailViewController ()

@property (nonatomic, strong) NSString *ids;
@property (nonatomic, strong) CourseDetailModel *model;

@end

@implementation CourseDetailViewController

- (instancetype)initWithParams:(NSDictionary *)params {
    if (self = [super initWithParams:params]) {
        self.ids = [params objectForKey:@"id"];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationItem.title = @"课程详情";
    
    [PhotoTitleHeaderCell registerCellFromNibWithTableView:self.tableView withIdentifier:identifierPhotoTitleHeaderCell];
    [CoursePriceCell registerCellFromNibWithTableView:self.tableView withIdentifier:identifierCoursePriceCell];
    [CourseTagsCell registerCellFromClassWithTableView:self.tableView withIdentifier:identifierCourseTagsCell];
    [CourseSectionTitleCell registerCellFromNibWithTableView:self.tableView withIdentifier:identifierCourseSectionTitleCell];
    [CourseListItemCell registerCellFromNibWithTableView:self.tableView withIdentifier:identifierCourseListItemCell];
    [CoursePoiCell registerCellFromNibWithTableView:self.tableView withIdentifier:identifierCoursePoiCell];
    [CourseBookCell registerCellFromClassWithTableView:self.tableView withIdentifier:identifierCourseBookCell];
    [CourseTeacherCell registerCellFromClassWithTableView:self.tableView withIdentifier:identifierCourseTeacherCell];
    [CourseDiscCell registerCellFromClassWithTableView:self.tableView withIdentifier:identifierCourseDiscCell];
    
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
    [[HttpService defaultService] GET:URL_APPEND_PATH(@"/course") parameters:dic cacheType:cacheType JSONModelClass:[CourseDetailModel class] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (self.model == nil) {
            [self.view removeLoadingBee];
        }
        
        self.model = responseObject;
        
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

#pragma mark - tableview delegate & datasource

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    CellType type = [self cellTypeForRowAtIndexPath:indexPath];
    if (type == CellTitlePoi) {
        [self openURL:[NSString stringWithFormat:@"duola://book?id=%@&onlyshow=1", self.ids]];
        
    } else if (type == CellTitleTeacher) {
        [self openURL:[NSString stringWithFormat:@"duola://courseteacherlist?id=%@", self.ids]];
        
    } else if (type == CellTitleBook) {
        [self openURL:[NSString stringWithFormat:@"duola://coursebookbrowser?id=%@", self.ids]];
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
            return CellPrice;
        } else {
            return CellTag;
        }
    }
    if (section == 1) {
        return row == 0 ? CellTitleGoal : CellGoal;
    }
    if (section == 2) {
        return row == 0 ? CellTitlePoi : CellPoi;
    }
    int num = 2;
    if (self.model.data.book) {
        num++;
        if (section == num) {
            return row == 0 ? CellTitleBook : CellBook;
        }
    }
    num++;
    if (section == num) {
        return row == 0 ? CellTitleFlow : CellFlow;
    }
    if (self.model.data.homework) {
        num++;
        if (section == num) {
            return row == 0 ? CellTitleHomework : CellHomework;
        }
    }
    if (self.model.data.comments) {
        num++;
        if (section == num) {
            return row == 0 ? CellTitleComment : CellComment;
        }
    }
    if (self.model.data.teachers) {
        num++;
        if (section == num) {
            return row == 0 ? CellTitleTeacher : CellTeacher;
        }
    }
    if (self.model.data.tips) {
        num++;
        if (section == num) {
            return row == 0 ? CellTitleTips : CellTips;
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
        int num = 4;
        if (self.model.data.book) {
            num++;
        }
        if (self.model.data.homework) {
            num++;
        }
        if (self.model.data.comments) {
            num++;
        }
        if (self.model.data.teachers) {
            num++;
        }
        if (self.model.data.tips) {
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
    int num = 0;
    if (self.model.data.book) {
        num++;
    }
    if (self.model.data.homework) {
        num++;
        if (section == 4 + num) {
            return 3;
        }
    }
    if (self.model.data.comments) {
        num++;
        if (section == 4 + num) {
            return 3;
        }
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
        
    } else if (type == CellTag) {
        CourseTagsCell *tagsCell = [CourseTagsCell cellWithTableView:tableView forIndexPath:indexPath withIdentifier:identifierCourseTagsCell];
        tagsCell.data = self.model.data;
        cell = tagsCell;
        cell.selectionStyle = UITableViewCellSeparatorStyleNone;
        
    } else if (type == CellTitleGoal) {
        CourseSectionTitleCell *titleCell = [CourseSectionTitleCell cellWithTableView:tableView forIndexPath:indexPath withIdentifier:identifierCourseSectionTitleCell];
        titleCell.accessoryType = UITableViewCellAccessoryNone;
        titleCell.titleLabel.text = @"课程目标";
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
        titleCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell = titleCell;
        cell.selectionStyle = UITableViewCellSeparatorStyleSingleLine;
        
    } else if (type == CellBook) {
        CourseBookCell *bookCell = [CourseBookCell cellWithTableView:tableView forIndexPath:indexPath withIdentifier:identifierCourseBookCell];
        bookCell.data = self.model.data.book;
        cell = bookCell;
        cell.selectionStyle = UITableViewCellSeparatorStyleNone;
        
    } else if (type == CellTitleFlow) {
        CourseSectionTitleCell *titleCell = [CourseSectionTitleCell cellWithTableView:tableView forIndexPath:indexPath withIdentifier:identifierCourseSectionTitleCell];
        titleCell.titleLabel.text = @"课程内容";
        titleCell.subTitleLabel.text = @"更多图文详情";
        titleCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell = titleCell;
        cell.selectionStyle = UITableViewCellSeparatorStyleSingleLine;
        
    } else if (type == CellFlow) {
        CourseDiscCell *discCell = [CourseDiscCell cellWithTableView:tableView forIndexPath:indexPath withIdentifier:identifierCourseDiscCell];
        discCell.data = self.model.data.flow;
        cell = discCell;
        cell.selectionStyle = UITableViewCellSeparatorStyleNone;
        
    } else if (type == CellTitleTeacher) {
        CourseSectionTitleCell *titleCell = [CourseSectionTitleCell cellWithTableView:tableView forIndexPath:indexPath withIdentifier:identifierCourseSectionTitleCell];
        titleCell.titleLabel.text = @"讲师团";
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
        titleCell.accessoryType = UITableViewCellAccessoryNone;
        cell = titleCell;
        cell.selectionStyle = UITableViewCellSeparatorStyleNone;
        
    } else if (type == CellTips) {
        CourseDiscCell *discCell = [CourseDiscCell cellWithTableView:tableView forIndexPath:indexPath withIdentifier:identifierCourseDiscCell];
        discCell.data = self.model.data.tips;
        cell = discCell;
        cell.selectionStyle = UITableViewCellSeparatorStyleNone;
        
    } else if (type == CellTitleOrg) {
        CourseSectionTitleCell *titleCell = [CourseSectionTitleCell cellWithTableView:tableView forIndexPath:indexPath withIdentifier:identifierCourseSectionTitleCell];
        titleCell.titleLabel.text = @"合作机构介绍";
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
        
    } else if (type == CellTag) {
        return [CourseTagsCell heightWithTableView:tableView withIdentifier:identifierCourseTagsCell forIndexPath:indexPath data:self.model.data];
        
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
        
    } else if (type == CellTitleFlow) {
        return [CourseSectionTitleCell heightWithTableView:tableView withIdentifier:identifierCourseSectionTitleCell forIndexPath:indexPath data:nil];
        
    } else if (type == CellFlow) {
        return [CourseDiscCell heightWithTableView:tableView withIdentifier:identifierCourseDiscCell forIndexPath:indexPath data:self.model.data.flow];
        
    } else if (type == CellTitleTeacher) {
        return [CourseSectionTitleCell heightWithTableView:tableView withIdentifier:identifierCourseSectionTitleCell forIndexPath:indexPath data:nil];
        
    } else if (type == CellTeacher) {
        return [CourseTeacherCell heightWithTableView:tableView withIdentifier:identifierCourseDiscCell forIndexPath:indexPath data:nil];
        
    } else if (type == CellTitleTips) {
        return [CourseSectionTitleCell heightWithTableView:tableView withIdentifier:identifierCourseSectionTitleCell forIndexPath:indexPath data:nil];
        
    } else if (type == CellTips) {
        return [CourseDiscCell heightWithTableView:tableView withIdentifier:identifierCourseDiscCell forIndexPath:indexPath data:self.model.data.tips];
        
    } else if (type == CellTitleOrg) {
        return [CourseSectionTitleCell heightWithTableView:tableView withIdentifier:identifierCourseSectionTitleCell forIndexPath:indexPath data:nil];
        
    } else if (type == CellOrg) {
        return [CourseDiscCell heightWithTableView:tableView withIdentifier:identifierCourseDiscCell forIndexPath:indexPath data:self.model.data.institution];
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
