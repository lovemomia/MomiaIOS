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
#import "ReviewListModel.h"

#import "PhotoTitleHeaderCell.h"
#import "CourseTitleCell.h"
#import "CourseTagsCell.h"
#import "CourseDiscCell.h"
#import "CourseSectionTitleCell.h"
#import "CourseListItemCell.h"
#import "CoursePoiCell.h"
#import "CourseBookCell.h"
#import "CourseTeacherCell.h"
#import "ReviewListItemCell.h"
#import "CourseDetailCell.h"
#import "SubjectBuyCell.h"
#import "SubjectTabCell.h"
#import "CourseNoticeCell.h"

static NSString *identifierPhotoTitleHeaderCell = @"PhotoTitleHeaderCell";
static NSString *identifierCourseTagsCell = @"CourseTagsCell";
static NSString *identifierCourseTitleCell = @"CourseTitleCell";
static NSString *identifierCourseDiscCell = @"CourseDiscCell";
static NSString *identifierCourseSectionTitleCell = @"CourseSectionTitleCell";
static NSString *identifierCourseListItemCell = @"CourseListItemCell";
static NSString *identifierCoursePoiCell = @"CoursePoiCell";
static NSString *identifierCourseBookCell = @"CourseBookCell";
static NSString *identifierCourseTeacherCell = @"CourseTeacherCell";
static NSString *identifierReviewListItemCell = @"ReviewListItemCell";
static NSString *identifierCourseDetailCell = @"CourseDetailCell";
static NSString *identifierSubjectTabCell = @"SubjectTabCell";
static NSString *identifierCourseNoticeCell = @"CourseNoticeCell";

@interface CourseDetailViewController ()<SubjectTabCellDelegate>

@property (nonatomic, strong) NSString *ids;
@property (nonatomic, assign) int recommend;
@property (nonatomic, strong) CourseDetailModel *model;
@property (nonatomic, assign) NSInteger tabIndex;

@property (nonatomic, strong) SubjectTabCell *topTabView;
@property (nonatomic, assign) CGRect rectInTableView;

//评论列表
@property (nonatomic, strong) NSMutableArray *reviewList;
@property (nonatomic, assign) BOOL flLoading;
@property (nonatomic, assign) NSInteger flNextIndex;

@property (nonatomic, strong) AFHTTPRequestOperation * curOperation;

@end

@implementation CourseDetailViewController

- (instancetype)initWithParams:(NSDictionary *)params {
    if (self = [super initWithParams:params]) {
        self.ids = [params objectForKey:@"id"];
        if ([params objectForKey:@"recommend"]) {
            self.recommend = [[params objectForKey:@"recommend"] intValue];
        } else {
            self.recommend = 0;
        }
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationItem.title = @"课程详情";
    
    [PhotoTitleHeaderCell registerCellFromNibWithTableView:self.tableView withIdentifier:identifierPhotoTitleHeaderCell];
    [CourseTagsCell registerCellFromClassWithTableView:self.tableView withIdentifier:identifierCourseTagsCell];
    [CourseTitleCell registerCellFromNibWithTableView:self.tableView withIdentifier:identifierCourseTitleCell];
    [CourseSectionTitleCell registerCellFromNibWithTableView:self.tableView withIdentifier:identifierCourseSectionTitleCell];
    [CourseListItemCell registerCellFromNibWithTableView:self.tableView withIdentifier:identifierCourseListItemCell];
    [CoursePoiCell registerCellFromNibWithTableView:self.tableView withIdentifier:identifierCoursePoiCell];
    [CourseBookCell registerCellFromClassWithTableView:self.tableView withIdentifier:identifierCourseBookCell];
    [CourseTeacherCell registerCellFromClassWithTableView:self.tableView withIdentifier:identifierCourseTeacherCell];
    [CourseDiscCell registerCellFromClassWithTableView:self.tableView withIdentifier:identifierCourseDiscCell];
    [ReviewListItemCell registerCellFromNibWithTableView:self.tableView withIdentifier:identifierReviewListItemCell];
    [CourseDetailCell registerCellFromClassWithTableView:self.tableView withIdentifier:identifierCourseDetailCell];
    [SubjectTabCell registerCellFromNibWithTableView:self.tableView withIdentifier:identifierSubjectTabCell];
    [CourseNoticeCell registerCellFromClassWithTableView:self.tableView withIdentifier:identifierCourseNoticeCell];
    
    [self setTopTabView];
    
    self.tableView.mj_header = [MJRefreshHelper createGifHeaderWithRefreshingTarget:self refreshingAction:@selector(requestData)];
    
    [self requestData:YES];
}

- (void)setTopTabView {
    NSArray *arr = [[NSBundle mainBundle] loadNibNamed:@"SubjectTabCell" owner:self options:nil];
    self.topTabView = [arr objectAtIndex:0];
    self.topTabView.delegate = self;
    self.topTabView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 50);
    [self.view addSubview:self.topTabView];
    self.topTabView.hidden = YES;
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
    
    if (self.reviewList == nil) {
        self.reviewList = [[NSMutableArray alloc]init];
    }
    
    if (refresh) {
        self.flNextIndex = 0;
        self.flLoading = NO;
        [self.reviewList removeAllObjects];
    }
    
    CacheType cacheType = refresh ? CacheTypeDisable : CacheTypeDisable;
    
    NSDictionary * dic;
    if ([[LocationService defaultService] hasLocation]) {
        CLLocation *location = [LocationService defaultService].location;
        dic = @{@"id":self.ids, @"pos":[NSString stringWithFormat:@"%f,%f", location.coordinate.longitude, location.coordinate.latitude], @"recommend":[NSString stringWithFormat:@"%d", self.recommend]};
        
    } else {
        dic = @{@"id":self.ids, @"recommend":[NSString stringWithFormat:@"%d", self.recommend]};
    }
    
    [[HttpService defaultService] GET:URL_APPEND_PATH(@"/v3/course") parameters:dic cacheType:cacheType JSONModelClass:[CourseDetailModel class] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (self.model == nil) {
            [self.view removeLoadingBee];
        }
        
        self.model = responseObject;
        [self setBuyView];
        
        if (self.model.data.comments) {
            [self.reviewList addObjectsFromArray:self.model.data.comments.list];
            self.flNextIndex = [self.model.data.comments.nextIndex integerValue];
        }
        
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.view removeLoadingBee];
        [self showDialogWithTitle:nil message:error.message];
        [self.tableView.mj_header endRefreshing];
    }];
}

- (void)requestReview {
    if(self.curOperation) {
        [self.curOperation pause];
    }
    
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc]init];
    [paramDic setValue:self.ids forKey:@"id"];
    [paramDic setValue:[NSString stringWithFormat:@"%ld", (long)self.flNextIndex] forKey:@"start"];
    
    self.curOperation = [[HttpService defaultService]GET:URL_APPEND_PATH(@"/course/comment/list")
                                              parameters:paramDic cacheType:CacheTypeDisable JSONModelClass:[ReviewListModel class]
                                                 success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                                     ReviewListModel *model = (ReviewListModel *)responseObject;
                                                     
                                                     if (model.data.nextIndex) {
                                                         self.flNextIndex = [model.data.nextIndex integerValue];
                                                     } else {
                                                         self.flNextIndex = -1;
                                                     }
                                                     
                                                     for (Review *review in model.data.list) {
                                                         [self.reviewList addObject:review];
                                                     }
                                                     [self.tableView reloadData];
                                                     self.flLoading = NO;
                                                 }
                         
                                                 failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                                     [self showDialogWithTitle:nil message:error.message];
                                                     self.flLoading = NO;
                                                 }];
}

- (void)setBuyView {
    NSArray *arr = [[NSBundle mainBundle] loadNibNamed:@"SubjectBuyCell" owner:self options:nil];
    SubjectBuyCell *buyCell = [arr objectAtIndex:0];
    buyCell.data = self.model.data;
    UIButton *buyBtn = buyCell.buyButton;
    UITapGestureRecognizer *singleTap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onBuyClicked:)];
    [buyBtn addGestureRecognizer:singleTap];
    buyCell.frame = CGRectMake(0, SCREEN_HEIGHT - 128, SCREEN_WIDTH, 64);
    [self.view addSubview:buyCell];
}

- (void)onBuyClicked:(UITapGestureRecognizer *)tap {
    if ([self.model.data.buyable boolValue]) {
        [self openURL:[NSString stringWithFormat:@"fillorder?id=%@&coid=%@&coname=%@", self.model.data.subjectId, self.model.data.ids, [self.model.data.subject URLEncodedString]]];
    } else {
        [self openURL:[NSString stringWithFormat:@"fillorder?id=%@", self.model.data.subjectId]];
    }
    
    NSDictionary *attributes = @{@"name":self.model.data.title};
    [MobClick event:@"Course_Buy" attributes:attributes];
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
    if (self.rectInTableView.origin.y == 0) {
        return;
    }
    
    if ((scrollView.contentOffset.y - self.rectInTableView.origin.y) > 0 && self.topTabView.hidden == NO) {
        return;
    }
    if ((scrollView.contentOffset.y - self.rectInTableView.origin.y) < 0 && self.topTabView.hidden == YES) {
        return;
    }
    
    //悬停的控制
    if ((scrollView.contentOffset.y - self.rectInTableView.origin.y) > 0){
        if (self.topTabView.hidden == YES) {
            self.topTabView.hidden = NO;
        }
    }
    if ((scrollView.contentOffset.y - self.rectInTableView.origin.y) < 0){
        if (self.topTabView.hidden == NO) {
            self.topTabView.hidden = YES;
        }
    }
}

- (void)onTabChanged:(NSInteger)index {
    if (self.tabIndex == index) {
        return;
    }
    if(self.curOperation) {
        [self.curOperation pause];
    }
    self.tabIndex = index;
    [self.tableView reloadData];
    self.topTabView.data = [NSNumber numberWithInteger:index];
    NSIndexPath* indexPath = [NSIndexPath indexPathForRow:0 inSection:2];
    [self.tableView scrollToRowAtIndexPath:indexPath
                          atScrollPosition:UITableViewScrollPositionTop animated:YES];
}

#pragma mark - tableview delegate & datasource

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    
    if (section == 1 && row == 0) {
        [self openURL:[NSString stringWithFormat:@"book?id=%@&onlyshow=1", self.ids]];
        
        [MobClick event:@"Course_SkuList"];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.model) {
        return 3;
    }
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 3;
        
    } else if (section == 1) {
        if (self.model.data.place) {
            return 2;
        }
        return 1;
        
    } else if (section == 2) {
        if (self.tabIndex == 0) {
            if (self.model.data.teachers) {
                return 3 + self.model.data.teachers.count;
            }
            return 3;
            
        } else if (self.tabIndex == 1) {
            return 2;
            
        } else {
            if (self.flNextIndex > 0) {
                return self.reviewList.count + 2;
            }
            if (self.reviewList.count == 0) {
                return 2;
            }
            return 1 + self.reviewList.count;
        }
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    
    if (section == 0) {
        if (row == 0) {
            PhotoTitleHeaderCell *headerCell = [PhotoTitleHeaderCell cellWithTableView:tableView forIndexPath:indexPath withIdentifier:identifierPhotoTitleHeaderCell];
            headerCell.data = self.model.data;
            cell = headerCell;
            
        } else if (row == 1) {
            CourseTitleCell *titleCell = [CourseTitleCell cellWithTableView:tableView forIndexPath:indexPath withIdentifier:identifierCourseTitleCell];
            titleCell.data = self.model.data;
            cell = titleCell;
            cell.selectionStyle = UITableViewCellSeparatorStyleNone;
            
        } else {
            CourseTagsCell *priceCell = [CourseTagsCell cellWithTableView:tableView forIndexPath:indexPath withIdentifier:identifierCourseTagsCell];
            priceCell.data = self.model.data;
            cell = priceCell;
            cell.selectionStyle = UITableViewCellSeparatorStyleNone;
        }
        
    } else if (section == 1) {
        if (row == 0) {
            CourseSectionTitleCell *titleCell = [CourseSectionTitleCell cellWithTableView:tableView forIndexPath:indexPath withIdentifier:identifierCourseSectionTitleCell];
            titleCell.titleLabel.text = @"课程表";
            titleCell.subTitleLabel.text = @"";
            titleCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell = titleCell;
            cell.selectionStyle = UITableViewCellSeparatorStyleSingleLine;
            
        } else {
            CoursePoiCell *poiCell = [CoursePoiCell cellWithTableView:tableView forIndexPath:indexPath withIdentifier:identifierCoursePoiCell];
            poiCell.data = self.model.data.place;
            cell = poiCell;
            cell.selectionStyle = UITableViewCellSeparatorStyleNone;
        }
    } else if (section == 2) {
        if (row == 0) {
            SubjectTabCell *tabCell = [SubjectTabCell cellWithTableView:tableView forIndexPath:indexPath withIdentifier:identifierSubjectTabCell];
            tabCell.delegate = self;
            [tabCell setData:[NSNumber numberWithInteger:self.tabIndex]];
            cell = tabCell;
            cell.selectionStyle = UITableViewCellSeparatorStyleNone;
            
            if (self.rectInTableView.origin.y == 0) {
                self.rectInTableView = [self.tableView rectForRowAtIndexPath:indexPath];
            }
            
        } else {
            if (self.tabIndex == 0) {
                if (row == 1) {
                    CourseDetailCell *discCell = [CourseDetailCell cellWithTableView:tableView forIndexPath:indexPath withIdentifier:identifierCourseDetailCell];
                    discCell.data = self.model.data;
                    cell = discCell;
                    cell.selectionStyle = UITableViewCellSeparatorStyleNone;
                    
                } else if (row == 2) {
                    CourseDiscCell *discCell = [CourseDiscCell cellWithTableView:tableView forIndexPath:indexPath withIdentifier:identifierCourseDiscCell];
                    discCell.data = self.model.data.tips;
                    cell = discCell;
                    cell.selectionStyle = UITableViewCellSeparatorStyleNone;
                    
                } else {
                    // teacher
                    CourseTeacherCell *bookCell = [CourseTeacherCell cellWithTableView:tableView forIndexPath:indexPath withIdentifier:identifierCourseTeacherCell];
                    CourseTeacher *teacher = self.model.data.teachers[row - 3];
                    teacher.isFirst = [NSNumber numberWithInt:(row == 3 ? 1 : 0)];
                    bookCell.data = teacher;
                    cell = bookCell;
                    cell.selectionStyle = UITableViewCellSeparatorStyleNone;
                }
                
            } else if (self.tabIndex == 1) {
                CourseNoticeCell *noticeCell = [CourseNoticeCell cellWithTableView:tableView forIndexPath:indexPath withIdentifier:identifierCourseNoticeCell];
                noticeCell.data = self.model.data.subjectNotice;
                cell = noticeCell;
                cell.selectionStyle = UITableViewCellSeparatorStyleNone;
                
            } else {
                if (self.reviewList.count == 0) {
                    UITableViewCell *emptyCell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@""];
                    UIView *emptyView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 300)];
                    [emptyView showEmptyView:@"还没有人评价哦～"];
                    [emptyCell.contentView addSubview:emptyView];
                    cell = emptyCell;
                    
                } else if (self.reviewList.count == (row - 1)) {
                    static NSString * loadIdentifier = @"CellLoading";
                    UITableViewCell * load = [tableView dequeueReusableCellWithIdentifier:loadIdentifier];
                    if(load == nil) {
                        load = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:loadIdentifier];
                    }
                    [load showLoadingBee];
                    cell = load;
                    if(!self.flLoading) {
                        [self requestReview];
                        self.flLoading = YES;
                    }
                    
                } else {
                    ReviewListItemCell *reviewCell = [ReviewListItemCell cellWithTableView:self.tableView forIndexPath:indexPath withIdentifier:identifierReviewListItemCell];
                    [reviewCell setData:self.reviewList[row - 1]];
                    cell = reviewCell;
                    cell.selectionStyle = UITableViewCellSeparatorStyleNone;
                }
            }
        }
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    
    if (section == 0) {
        if (row == 0) {
            return [PhotoTitleHeaderCell heightWithTableView:tableView withIdentifier:identifierPhotoTitleHeaderCell forIndexPath:indexPath data:self.model.data];
            
        } else if (row == 1) {
            return [CourseTitleCell heightWithTableView:tableView withIdentifier:identifierCourseTitleCell forIndexPath:indexPath data:self.model.data];
            
        } else {
            return [CourseTagsCell heightWithTableView:tableView withIdentifier:identifierCourseTagsCell forIndexPath:indexPath data:self.model.data];
        }
        
    } else if (section == 1) {
        if (row == 0) {
            return [CourseSectionTitleCell heightWithTableView:tableView withIdentifier:identifierCourseSectionTitleCell forIndexPath:indexPath data:nil];
            
        } else {
            return [CoursePoiCell heightWithTableView:tableView withIdentifier:identifierCoursePoiCell forIndexPath:indexPath data:nil];
        }
        
    } else if (section == 2) {
        if (row == 0) {
            return 50;
            
        } else {
            if (self.tabIndex == 0) {
                if (row == 1) {
                    return [CourseDetailCell heightWithTableView:tableView withIdentifier:identifierCourseDetailCell forIndexPath:indexPath data:self.model.data];
                    
                } else if (row == 2) {
                    return [CourseDiscCell heightWithTableView:tableView withIdentifier:identifierCourseDiscCell forIndexPath:indexPath data:self.model.data.tips];
                    
                } else {
                    CourseTeacher *teacher = self.model.data.teachers[row - 3];
                    teacher.isFirst = [NSNumber numberWithInt:(row == 3 ? 1 : 0)];
                    return [CourseTeacherCell heightWithTableView:tableView withIdentifier:identifierCourseTeacherCell forIndexPath:indexPath data:teacher];
                    
                }
            } else if (self.tabIndex == 1) {
                return [CourseNoticeCell heightWithTableView:tableView withIdentifier:identifierCourseNoticeCell forIndexPath:indexPath data:self.model.data.subjectNotice];
            } else {
                if (self.reviewList.count == 0) {
                    return 300;
                } else if((row - 1) == self.reviewList.count) {
                    return 44;
                }
                return [ReviewListItemCell heightWithTableView:self.tableView withIdentifier:identifierReviewListItemCell forIndexPath:indexPath data:self.reviewList[row - 1]];
            }
        }
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == ([self numberOfSectionsInTableView:tableView] - 1)) {
        return 74;
    }
    return 10;
}
@end
