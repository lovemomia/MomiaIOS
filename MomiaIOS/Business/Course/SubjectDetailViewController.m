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
#import "CourseListItemCell.h"

#define SubjectDetailURL URL_APPEND_PATH(@"/v3/subject")

static NSString *identifierPhotoTitleHeaderCell = @"PhotoTitleHeaderCell";
static NSString *identifierSubjctBuyCell = @"SubjctBuyCell";
static NSString *identifierSubjectDiscCell = @"SubjectDiscCell";
static NSString *identifierCourseSectionTitleCell = @"CourseSectionTitleCell";
static NSString *identifierCourseNoticeCell = @"CourseNoticeCell";
static NSString *identifierReviewListItemCell = @"ReviewListItemCell";
static NSString *identifierSubjectCourseCell = @"SubjectCourseCell";
static NSString *identifierNewCoursesCell = @"CourseListItemCell";

static NSString *SubjectDetailSectionTypeNewCoursesDictKey = @"SubjectDetailSectionTypeNewCoursesDictKey";
static NSString *SubjectDetailSectionTypeAllCoursesDictKey = @"SubjectDetailSectionTypeAllCoursesDictKey";

typedef NS_ENUM(NSInteger,SubjectDetailSectionType){
    SubjectDetailSectionTypeCover,
    SubjectDetailSectionTypeNewCourses,
    SubjectDetailSectionTypeAllCourses,
    SubjectDetailSectionTypeComments,
    SubjectDetailSectionTypeNotices,
};

typedef NS_ENUM(NSInteger,SubjectDetailRowType){
    SubjectDetailRowTypeHeader,
    SubjectDetailRowTypeData,
    SubjectDetailRowTypeFooter,
};

@interface SubjectDetailSectionItem : NSObject

@property (nonatomic, assign) SubjectDetailSectionType itemType;
@property (nonatomic, strong) id data;

-(instancetype)init:(SubjectDetailSectionType)type data:(id)data;

@end

@implementation SubjectDetailSectionItem

-(instancetype)init:(SubjectDetailSectionType)type data:(id)data{
    if (self == [super init]) {
        self.itemType = type;
        self.data = data;
    }
    return self;
}
@end

@interface SubjectDetailRowItem : NSObject

@property (nonatomic,assign) NSInteger subjectDetailRowType;
@property (nonatomic,strong) id data;

@end

@implementation SubjectDetailRowItem
@end

@interface SubjectDetailViewController ()

@property (nonatomic, strong) NSString *ids;
@property (nonatomic, strong) SubjectDetailModel *model;
@property (nonatomic, strong) NSMutableArray* dataArray;
@property (nonatomic, assign) BOOL isOpenNewCourses;
@property (nonatomic, assign) BOOL isOPenAllCourses;
@property (nonatomic, strong) NSMutableDictionary *keySection;

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

-(NSMutableArray*)dataArray{
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc]initWithCapacity:20];
    }
    return _dataArray;
}

-(NSMutableDictionary*)keySection{
    if (!_keySection) {
        _keySection = [[NSMutableDictionary alloc]init];
    }
    return _keySection;
}

-(void)setModel:(SubjectDetailModel *)model{
    self.isOpenNewCourses = NO;
    self.isOPenAllCourses = NO;
    [self.keySection removeAllObjects];
    [self.dataArray removeAllObjects];
    _model = model;
    if (model) {
        if (model.data.subject) { //设置subject
            [self.dataArray addObject:[[SubjectDetailSectionItem alloc]init:SubjectDetailSectionTypeCover data:model.data.subject]];
        }
        if (model.data.freshCourses.count > 0) { //最新开班
            //如果count > 3 显示点击展开
            NSMutableArray *dataArray = [[NSMutableArray alloc]init];
            SubjectDetailRowItem *item = [[SubjectDetailRowItem alloc]init];
            item.subjectDetailRowType = SubjectDetailRowTypeHeader;
            [dataArray addObject:item];
            NSInteger Count = 3;
            if (model.data.courses.count < Count) {
                Count = model.data.courses.count;
            }
            for (int i = 0; i < Count; i++ ) {
                SubjectDetailRowItem *item = [[SubjectDetailRowItem alloc]init];
                item.subjectDetailRowType = SubjectDetailRowTypeData;
                item.data = model.data.freshCourses[i];
                [dataArray addObject:item];
            }
            if (model.data.freshCourses.count > 3) {
                SubjectDetailRowItem *item = [[SubjectDetailRowItem alloc]init];
                item.subjectDetailRowType = SubjectDetailRowTypeFooter;
                [dataArray addObject:item];
            }
            [self.dataArray addObject:[[SubjectDetailSectionItem alloc]init:SubjectDetailSectionTypeNewCourses data:dataArray]];
            [self.keySection setObject:dataArray forKey:SubjectDetailSectionTypeNewCoursesDictKey];
        }
        if (model.data.courses.count > 0) {//全部课程
            //同上
            NSMutableArray *dataArray = [[NSMutableArray alloc]init];
            SubjectDetailRowItem *item = [[SubjectDetailRowItem alloc]init];
            item.subjectDetailRowType = SubjectDetailRowTypeHeader;
            [dataArray addObject:item];
            NSInteger Count = 3;
            if (model.data.courses.count < Count) {
                Count = model.data.courses.count;
            }
            for (int i = 0; i < Count; i++ ) {
                SubjectDetailRowItem *item = [[SubjectDetailRowItem alloc]init];
                item.subjectDetailRowType = SubjectDetailRowTypeData;
                item.data = model.data.courses[i];
                [dataArray addObject:item];
            }
            if (model.data.courses.count > 3) {
                SubjectDetailRowItem *item = [[SubjectDetailRowItem alloc]init];
                item.subjectDetailRowType = SubjectDetailRowTypeFooter;
                [dataArray addObject:item];
            }
            [self.dataArray addObject:[[SubjectDetailSectionItem alloc]init:SubjectDetailSectionTypeAllCourses data:dataArray]];
            [self.keySection setObject:dataArray forKey:SubjectDetailSectionTypeAllCoursesDictKey];
        }
        if (model.data.comments.list.count > 0) {//评论
            [self.dataArray addObject:[[SubjectDetailSectionItem alloc]init:SubjectDetailSectionTypeComments data:model.data.comments]];
        }
        if (self.model.data.subject.notice) { //注意事项
            [self.dataArray addObject:[[SubjectDetailSectionItem alloc]init:SubjectDetailSectionTypeNotices data:self.model.data.subject.notice]];
        }
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.mj_header = [MJRefreshHelper createGifHeaderWithRefreshingTarget:self refreshingAction:@selector(requestData)];
    //注册cell
    [PhotoTitleHeaderCell registerCellFromNibWithTableView:self.tableView withIdentifier:identifierPhotoTitleHeaderCell];
    [SubjectBuyCell registerCellFromNibWithTableView:self.tableView withIdentifier:identifierSubjctBuyCell];
    [CourseSectionTitleCell registerCellFromNibWithTableView:self.tableView withIdentifier:identifierCourseSectionTitleCell];
    [CourseNoticeCell registerCellFromClassWithTableView:self.tableView withIdentifier:identifierCourseNoticeCell];
    [SubjectDiscCell registerCellFromClassWithTableView:self.tableView withIdentifier:identifierSubjectDiscCell];
    [ReviewListItemCell registerCellFromNibWithTableView:self.tableView withIdentifier:identifierReviewListItemCell];
    [SubjectCourseCell registerCellFromNibWithTableView:self.tableView withIdentifier:identifierSubjectCourseCell];
    [CourseListItemCell registerCellFromNibWithTableView:self.tableView withIdentifier:identifierNewCoursesCell];
    [self requestData:YES];
}

- (void)setBuyView {
    
    SubjectBuyCell *buyCell = [self.tableView dequeueReusableCellWithIdentifier:identifierSubjctBuyCell];
    buyCell.data = self.model.data.subject;
    UIButton *buyBtn = buyCell.buyButton;
    UITapGestureRecognizer *singleTap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onBuyClicked:)];
    [buyBtn addGestureRecognizer:singleTap];
    buyCell.frame = CGRectMake(0, SCREEN_HEIGHT - 128, SCREEN_WIDTH, 64);
    [self.view addSubview:buyCell];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (UIEdgeInsets)separatorInsetForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return UIEdgeInsetsMake(0,SCREEN_WIDTH,0,0);
    }
    SubjectDetailSectionItem *sectionItem = self.dataArray[indexPath.section];
    if (sectionItem.itemType == SubjectDetailSectionTypeAllCourses) {
        return UIEdgeInsetsMake(0,SCREEN_WIDTH,0,0);
    }else if (sectionItem.itemType == SubjectDetailSectionTypeNewCourses) {
        NSArray *rowsItem = sectionItem.data;
        SubjectDetailRowItem *rowItem = rowsItem[indexPath.row];
        if (rowItem.subjectDetailRowType == SubjectDetailRowTypeHeader || rowItem.subjectDetailRowType == SubjectDetailRowTypeFooter) {
            return UIEdgeInsetsMake(0,SCREEN_WIDTH,0,0);
        }else if (rowItem.subjectDetailRowType == SubjectDetailRowTypeData){
            SubjectDetailRowItem *nextRowItem = rowsItem[indexPath.row + 1];
            if (nextRowItem.subjectDetailRowType == SubjectDetailRowTypeFooter) {
                return UIEdgeInsetsMake(0,SCREEN_WIDTH,0,0);
            }
            return UIEdgeInsetsMake(0,10,0,0);
        }
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
    [[HttpService defaultService] GET:SubjectDetailURL parameters:dic cacheType:cacheType JSONModelClass:[SubjectDetailModel class] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        self.model = responseObject;
        if (self.model != nil) {
            [self.view removeLoadingBee];
        }
        self.navigationItem.title = self.model.data.subject.title;
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
        [self setBuyView];
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
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    SubjectDetailSectionItem *item = [self.dataArray objectAtIndex:section];
    if (item.itemType == SubjectDetailSectionTypeAllCourses) {
        NSArray *rowsArray = item.data;
        SubjectDetailRowItem *rowItem = rowsArray[row];
        if(rowItem.subjectDetailRowType == SubjectDetailRowTypeData){
            Course *course = rowItem.data;
            [self openURL:[NSString stringWithFormat:@"coursedetail?id=%@", course.ids]];
            NSDictionary *attributes = @{@"name":course.title, @"index":[NSString stringWithFormat:@"%d", (int)(indexPath.row - 2)]};
            [MobClick event:@"Subject_List" attributes:attributes];
        }
    }else if(item.itemType == SubjectDetailSectionTypeComments){
        [self openURL:[NSString stringWithFormat:@"reviewlist?subjectId=%@", self.ids]];
    }else if(item.itemType == SubjectDetailSectionTypeNewCourses){
        NSArray *rowsArray = item.data;
        SubjectDetailRowItem *rowItem = rowsArray[row];
        if(rowItem.subjectDetailRowType == SubjectDetailRowTypeData){
            Course *course = rowItem.data;
            [self openURL:[NSString stringWithFormat:@"coursedetail?id=%@", course.ids]];
            NSDictionary *attributes = @{@"name":course.title, @"index":[NSString stringWithFormat:@"%d", (int)(indexPath.row - 2)]};
            [MobClick event:@"Subject_List" attributes:attributes];
        }
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
//点击全部课程的展开按钮
-(void)tapAllCoursesFold{
    if (!self.isOPenAllCourses && self.model.data.courses.count > 3) {
        NSMutableArray *dataArray = [self.keySection objectForKey:SubjectDetailSectionTypeAllCoursesDictKey];
        if (!dataArray) {
            return;
        }
        NSInteger offset = dataArray.count - 2;
        for (NSInteger i = offset; i < self.model.data.courses.count; i++) {
            SubjectDetailRowItem *rowItem = [[SubjectDetailRowItem alloc]init];
            rowItem.data = self.model.data.courses[i];
            rowItem.subjectDetailRowType = SubjectDetailRowTypeData;
            [dataArray insertObject:rowItem atIndex:dataArray.count -1];
        }
        [self.tableView reloadData];
        self.isOPenAllCourses = YES;
    }else if (self.isOPenAllCourses && self.model.data.courses.count > 3) {
        NSMutableArray *dataArray = [self.keySection objectForKey:SubjectDetailSectionTypeAllCoursesDictKey];
        if (!dataArray) {
            return;
        }
        for (NSInteger i = dataArray.count - 2 ; i > 3; i--) {
            [dataArray removeObjectAtIndex:i];
        }
        [self.tableView reloadData];
        self.isOPenAllCourses = NO;
    }
}

//点击最新课程的展开按钮
-(void)tapNewCoursesFold{
    if (!self.isOpenNewCourses && self.model.data.freshCourses.count > 3) {
        NSMutableArray *dataArray = [self.keySection objectForKey:SubjectDetailSectionTypeNewCoursesDictKey];
        if (!dataArray) {
            return;
        }
        NSInteger offset = dataArray.count - 2;
        for (NSInteger i = offset; i < self.model.data.freshCourses.count; i++) {
            SubjectDetailRowItem *rowItem = [[SubjectDetailRowItem alloc]init];
            rowItem.data = self.model.data.freshCourses[i];
            rowItem.subjectDetailRowType = SubjectDetailRowTypeData;
            [dataArray insertObject:rowItem atIndex:dataArray.count -1];
        }
        [self.tableView reloadData];
        self.isOpenNewCourses = YES;
    }else if (self.isOpenNewCourses && self.model.data.freshCourses.count > 3) {
        NSMutableArray *dataArray = [self.keySection objectForKey:SubjectDetailSectionTypeNewCoursesDictKey];
        if (!dataArray) {
            return;
        }
        for (NSInteger i = dataArray.count - 2 ; i > 3; i--) {
            [dataArray removeObjectAtIndex:i];
        }
        [self.tableView reloadData];
        self.isOpenNewCourses = NO;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    SubjectDetailSectionItem *item = [self.dataArray objectAtIndex:section];
    if (item.itemType == SubjectDetailSectionTypeCover) {
        return 2;
    }else if (item.itemType == SubjectDetailSectionTypeNewCourses){
        NSArray *rowsArray = item.data;
        return rowsArray.count;
    }else if (item.itemType == SubjectDetailSectionTypeAllCourses){
        NSArray *rowsArray = item.data;
        return rowsArray.count;
    }else if (item.itemType == SubjectDetailSectionTypeComments){
        return 2;
    }else if(item.itemType == SubjectDetailSectionTypeNotices){
        return 1;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    SubjectDetailSectionItem *item = [self.dataArray objectAtIndex:section];
    UITableViewCell *cell;
    if (item.itemType == SubjectDetailSectionTypeCover) {
        if (row == 0){
            PhotoTitleHeaderCell *headerCell = [PhotoTitleHeaderCell cellWithTableView:tableView forIndexPath:indexPath withIdentifier:identifierPhotoTitleHeaderCell];
            headerCell.data = self.model.data.subject;
            return headerCell;
        }else{
            SubjectDiscCell *discCell = [SubjectDiscCell cellWithTableView:tableView forIndexPath:indexPath withIdentifier:identifierSubjectDiscCell];
            discCell.data = self.model.data.subject.intro;
            cell = discCell;
            cell.selectionStyle = UITableViewCellSeparatorStyleNone;
            return cell;
        }
    }else if (item.itemType == SubjectDetailSectionTypeNewCourses ){
        NSArray *rowsArray = item.data;
        SubjectDetailRowItem *rowItem = rowsArray[row];
        if (rowItem.subjectDetailRowType == SubjectDetailRowTypeHeader) {
            NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"SubjectDetailHeaders" owner:self options:nil];
            UITableViewCell *newCoursesHeader = array[1];
            newCoursesHeader.selectionStyle = UITableViewCellSeparatorStyleNone;
            return newCoursesHeader;
        }else if(rowItem.subjectDetailRowType == SubjectDetailRowTypeData) {
            Course *course = rowItem.data;
            CourseListItemCell * itemCell = [CourseListItemCell cellWithTableView:tableView forIndexPath:indexPath withIdentifier:identifierNewCoursesCell];
            itemCell.data = course;
            return itemCell;
        }else if(rowItem.subjectDetailRowType == SubjectDetailRowTypeFooter) {
            NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"SubjectDetailHeaders" owner:self options:nil];
            UITableViewCell *newCoursesHeader = array[0];
            newCoursesHeader.selectionStyle = UITableViewCellSeparatorStyleNone;
            UIButton *btn = [newCoursesHeader viewWithTag:11];
            UILabel *label = [newCoursesHeader viewWithTag:12];
            UIImageView *arrowImage = [newCoursesHeader viewWithTag:13];
            newCoursesHeader.selectionStyle = UITableViewCellSeparatorStyleNone;
            if (self.isOpenNewCourses) {
                label.text = @"点击收起";
                arrowImage.image = [UIImage imageNamed:@"Fold"];
            } else {
                label.text = @"点击展开";
                arrowImage.image = [UIImage imageNamed:@"Unfold"];
            }
            [btn addTarget:self action:@selector(tapNewCoursesFold) forControlEvents:UIControlEventTouchDown];
            btn.layer.borderWidth = 1;
            btn.layer.borderColor = [UIColor blackColor].CGColor;
            btn.layer.cornerRadius = 5;
            return newCoursesHeader;
        }

    }else if(item.itemType == SubjectDetailSectionTypeAllCourses){
        NSArray *rowsArray = item.data;
        SubjectDetailRowItem *rowItem = rowsArray[row];
        if (rowItem.subjectDetailRowType == SubjectDetailRowTypeHeader) {
            NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"SubjectDetailHeaders" owner:self options:nil];
            UITableViewCell *allCourseCell = array[2];
            allCourseCell.selectionStyle = UITableViewCellSeparatorStyleNone;
            return allCourseCell;
        }else if(rowItem.subjectDetailRowType == SubjectDetailRowTypeData){
            Course *course = rowItem.data;
            SubjectCourseCell *courseCell = [SubjectCourseCell cellWithTableView:tableView forIndexPath:indexPath withIdentifier:identifierSubjectCourseCell];
            courseCell.lessonCountLabel.text = [NSString stringWithFormat: @"LESSON %d",row];
            courseCell.data = course;
            cell = courseCell;
            cell.selectionStyle = UITableViewCellSeparatorStyleNone;
            return cell;
        }else if(rowItem.subjectDetailRowType == SubjectDetailRowTypeFooter){
            NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"SubjectDetailHeaders" owner:self options:nil];
            UITableViewCell *allCourseCellFooter = array[0];
            UIButton *btn = [allCourseCellFooter viewWithTag:11];
            UILabel *label = [allCourseCellFooter viewWithTag:12];
            UIImageView *arrowImage = [allCourseCellFooter viewWithTag:13];
            allCourseCellFooter.selectionStyle = UITableViewCellSeparatorStyleNone;
            if (self.isOPenAllCourses) {
                label.text = @"点击收起";
                arrowImage.image = [UIImage imageNamed:@"Fold"];
            }else{
                label.text = @"点击展开";
                arrowImage.image = [UIImage imageNamed:@"Unfold"];
            }
            [btn addTarget:self action:@selector(tapAllCoursesFold) forControlEvents:UIControlEventTouchDown];
            btn.layer.borderWidth = 1;
            btn.layer.borderColor = [UIColor blackColor].CGColor;
            btn.layer.cornerRadius = 5;
            return allCourseCellFooter;
        }
    }
    else if(item.itemType == SubjectDetailSectionTypeComments){
        if (row == 0) {
            CourseSectionTitleCell *titleCell = [CourseSectionTitleCell cellWithTableView:tableView forIndexPath:indexPath withIdentifier:identifierCourseSectionTitleCell];
            titleCell.titleLabel.text = @"用户评价";
            titleCell.subTitleLabel.text = @"";
            titleCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell = titleCell;
            cell.selectionStyle = UITableViewCellSeparatorStyleSingleLine;
            return cell;
        } else {
            ReviewListItemCell *reviewCell = [ReviewListItemCell cellWithTableView:self.tableView forIndexPath:indexPath withIdentifier:identifierReviewListItemCell];
            Review *review = self.model.data.comments.list[0];
            review.isShowOnly3Photos = [NSNumber numberWithBool:YES];
            [reviewCell setData:review];
            cell = reviewCell;
            cell.selectionStyle = UITableViewCellSeparatorStyleNone;
        }
        return cell;
    }else if(item.itemType == SubjectDetailSectionTypeNotices) {
            CourseNoticeCell *noticeCell = [CourseNoticeCell cellWithTableView:tableView forIndexPath:indexPath withIdentifier:identifierCourseNoticeCell];
            noticeCell.data = self.model.data.subject.notice;
            cell = noticeCell;
            cell.selectionStyle = UITableViewCellSeparatorStyleNone;
            return cell;
    }
    cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"maybewrong"];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    SubjectDetailSectionItem *itemSection = [self.dataArray objectAtIndex:section];
    if (itemSection.itemType == SubjectDetailSectionTypeCover) {
        if (row == 0) {
            return SCREEN_WIDTH * 225 / 320;
            } else if(row == 1) {
                return [SubjectDiscCell heightWithTableView:tableView withIdentifier:identifierSubjectDiscCell forIndexPath:indexPath data:self.model.data.subject.intro];
            }
        }else if (itemSection.itemType == SubjectDetailSectionTypeNewCourses) {
            NSArray *rowsArray = itemSection.data;
            SubjectDetailRowItem *rowItem = rowsArray[row];
            if (rowItem.subjectDetailRowType == SubjectDetailRowTypeHeader) {
                return 61;
            }else if(rowItem.subjectDetailRowType == SubjectDetailRowTypeFooter){
                return 61;
            }else {
                Course *course = rowItem.data;
                return [CourseListItemCell heightWithTableView:tableView withIdentifier:identifierNewCoursesCell forIndexPath:indexPath data:course];
            }
            
        }else if (itemSection.itemType == SubjectDetailSectionTypeComments) {
            if (row == 0){
                return 44;
            }
            Review *review = self.model.data.comments.list[0];
            review.isShowOnly3Photos = [NSNumber numberWithBool:YES];
            return [ReviewListItemCell heightWithTableView:tableView withIdentifier:identifierReviewListItemCell forIndexPath:indexPath data:review];
        }else if (itemSection.itemType == SubjectDetailSectionTypeNotices) {
            return [CourseNoticeCell heightWithTableView:tableView withIdentifier:identifierCourseNoticeCell forIndexPath:indexPath data:self.model.data.subject.notice];
        }else if (itemSection.itemType == SubjectDetailSectionTypeAllCourses) {
            NSArray *rowsArray = itemSection.data;
            SubjectDetailRowItem *rowItem = rowsArray[row];
            if (rowItem.subjectDetailRowType == SubjectDetailRowTypeHeader) {
                return 61;
            } else if(rowItem.subjectDetailRowType == SubjectDetailRowTypeFooter) {
                return 61;
            } else if(rowItem.subjectDetailRowType == SubjectDetailRowTypeData) {
                return (SCREEN_WIDTH - 20) * 180 / 300 + 10;
            }
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
