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
#import "CourseTagsCell.h"
#import "CourseDiscCell.h"
#import "CourseSectionTitleCell.h"
#import "CourseListItemCell.h"
#import "CourseNoticeCell.h"
#import "ReviewListItemCell.h"
#import "SubjectTabCell.h"

static NSString *identifierPhotoTitleHeaderCell = @"PhotoTitleHeaderCell";
static NSString *identifierSubjctBuyCell = @"SubjctBuyCell";
static NSString *identifierCourseTagsCell = @"CourseTagsCell";
static NSString *identifierCourseDiscCell = @"CourseDiscCell";
static NSString *identifierCourseSectionTitleCell = @"CourseSectionTitleCell";
static NSString *identifierCourseListItemCell = @"CourseListItemCell";
static NSString *identifierCourseNoticeCell = @"CourseNoticeCell";
static NSString *identifierReviewListItemCell = @"ReviewListItemCell";
static NSString *identifierSubjectTabCell = @"SubjectTabCell";

@interface SubjectDetailViewController ()<SubjectTabCellDelegate>

@property (nonatomic, strong) NSString *ids;

@property (nonatomic, strong) SubjectTabCell *topTabView;
@property (nonatomic, assign) CGRect rectInTableView;
@property (nonatomic, strong) SubjectDetailModel *model;
@property (nonatomic, assign) BOOL hasFeed;
@property (nonatomic, assign) BOOL hasCourse;

@property (nonatomic, assign) NSInteger tabIndex;

//课程列表
@property (nonatomic, strong) NSMutableArray *courseList;
@property (nonatomic, assign) BOOL clLoading;
@property (nonatomic, assign) NSInteger clNextIndex;

//评论列表
@property (nonatomic, strong) NSMutableArray *reviewList;
@property (nonatomic, assign) BOOL flLoading;
@property (nonatomic, assign) NSInteger flNextIndex;

@property (nonatomic, strong) AFHTTPRequestOperation * curOperation;

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
    [CourseTagsCell registerCellFromClassWithTableView:self.tableView withIdentifier:identifierCourseTagsCell];
    [CourseSectionTitleCell registerCellFromNibWithTableView:self.tableView withIdentifier:identifierCourseSectionTitleCell];
    [CourseListItemCell registerCellFromNibWithTableView:self.tableView withIdentifier:identifierCourseListItemCell];
    [CourseNoticeCell registerCellFromClassWithTableView:self.tableView withIdentifier:identifierCourseNoticeCell];
    [CourseDiscCell registerCellFromClassWithTableView:self.tableView withIdentifier:identifierCourseDiscCell];
    [ReviewListItemCell registerCellFromNibWithTableView:self.tableView withIdentifier:identifierReviewListItemCell];
    [SubjectTabCell registerCellFromNibWithTableView:self.tableView withIdentifier:identifierSubjectTabCell];
    
    [self setTopTabView];
    
    self.tabIndex = 0;
    self.tableView.header = [MJRefreshHelper createGifHeaderWithRefreshingTarget:self refreshingAction:@selector(requestData)];
    
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

- (void)setBuyView {
    NSArray *arr = [[NSBundle mainBundle] loadNibNamed:@"SubjectBuyCell" owner:self options:nil];
    SubjectBuyCell *buyCell = [arr objectAtIndex:0];
    buyCell.data = self.model.data.subject;
    UIButton *buyBtn = [buyCell viewWithTag:1001];
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
        return UIEdgeInsetsMake(0,0,0,0);
    }
    if (indexPath.section == 1 && indexPath.row == 0) {
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
    
    if (self.courseList == nil) {
        self.courseList = [[NSMutableArray alloc]init];
        self.reviewList = [[NSMutableArray alloc]init];
    }
    
    if (refresh) {
        self.clNextIndex = 0;
        self.clLoading = NO;
        [self.courseList removeAllObjects];
        
        self.flNextIndex = 0;
        self.flLoading = NO;
        [self.reviewList removeAllObjects];
    }
    
    CacheType cacheType = refresh ? CacheTypeDisable : CacheTypeDisable;
    
    NSDictionary * dic = @{@"id":self.ids};
    [[HttpService defaultService] GET:URL_APPEND_PATH(@"/v2/subject") parameters:dic cacheType:cacheType JSONModelClass:[SubjectDetailModel class] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (self.model == nil) {
            [self.view removeLoadingBee];
        }
        
        self.model = responseObject;
        self.hasFeed = self.model.data.comments && self.model.data.comments.list.count > 0;
        self.hasCourse = self.model.data.courses &&  self.model.data.courses.list.count > 0;
        self.navigationItem.title = self.model.data.subject.title;
        
        if (self.model.data.courses) {
            [self.courseList addObjectsFromArray:self.model.data.courses.list];
            self.clNextIndex = [self.model.data.courses.nextIndex integerValue];
        }
        if (self.model.data.comments) {
            [self.reviewList addObjectsFromArray:self.model.data.comments.list];
            self.flNextIndex = [self.model.data.comments.nextIndex integerValue];
        }
        
        [self setBuyView];
        [self.tableView reloadData];
        [self.tableView.header endRefreshing];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.view removeLoadingBee];
        [self showDialogWithTitle:nil message:error.message];
        [self.tableView.header endRefreshing];
    }];
}

- (void)requestCourse {
    if(self.curOperation) {
        [self.curOperation pause];
    }
    
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc]init];
    [paramDic setValue:self.ids forKey:@"id"];
    [paramDic setValue:[NSString stringWithFormat:@"%ld", (long)self.clNextIndex] forKey:@"start"];
    
    self.curOperation = [[HttpService defaultService]GET:URL_APPEND_PATH(@"/subject/course")
                                              parameters:paramDic cacheType:CacheTypeDisable JSONModelClass:[CourseListModel class]
                                                 success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                                     if ([self.courseList count] == 0) {
                                                         [self.view removeLoadingBee];
                                                     }
                                                     
                                                     CourseListModel *model = (CourseListModel *)responseObject;
                                                     
                                                     if (model.data.courses.nextIndex) {
                                                         self.clNextIndex = [model.data.courses.nextIndex integerValue];
                                                     } else {
                                                         self.clNextIndex = -1;
                                                     }
                                                     
                                                     for (Course *course in model.data.courses.list) {
                                                         [self.courseList addObject:course];
                                                     }
                                                     [self.tableView reloadData];
                                                     self.clLoading = NO;
                                                     
                                                 }
                         
                                                 failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                                     [self showDialogWithTitle:nil message:error.message];
                                                     self.clLoading = NO;
                                                 }];
}

- (void)requestFeed {
    if(self.curOperation) {
        [self.curOperation pause];
    }
    
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc]init];
    [paramDic setValue:self.ids forKey:@"id"];
    [paramDic setValue:[NSString stringWithFormat:@"%ld", (long)self.flNextIndex] forKey:@"start"];
    
    self.curOperation = [[HttpService defaultService]GET:URL_APPEND_PATH(@"/subject/comment/list")
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

- (void)onTabClicked:(UITapGestureRecognizer *)tap {
    NSInteger index = tap.view.tag;
    self.tabIndex = index;
    [self.tableView reloadData];
    
    if (index == 0) {
        [MobClick event:@"Subject_Tab_Courses"];
    } else if (index == 1) {
        [MobClick event:@"Subject_Tab_Notice"];
    } else {
        [MobClick event:@"Subject_Tab_Feed"];
    }
}

- (void)onBuyClicked:(UITapGestureRecognizer *)tap {
    NSString *url;
    [self openURL:[NSString stringWithFormat:@"fillorder?id=%@", self.model.data.subject.ids]];
    
    [MobClick event:@"Subject_Buy"];
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
    NSIndexPath* indexPath = [NSIndexPath indexPathForRow:0 inSection:1];
    [self.tableView scrollToRowAtIndexPath:indexPath
                          atScrollPosition:UITableViewScrollPositionTop animated:YES];
}

#pragma mark - tableview delegate & datasource

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1 && indexPath.row > 0) {
        if (self.tabIndex == 0) {
            Course *course = self.model.data.courses.list[indexPath.row - 1];
            [self openURL:[NSString stringWithFormat:@"coursedetail?id=%@", course.ids]];
            
            NSDictionary *attributes = @{@"name":course.title, @"index":[NSString stringWithFormat:@"%d", (indexPath.row - 1)]};
            [MobClick event:@"Subject_List" attributes:attributes];
        }
    } else if (indexPath.section == 3 && self.hasFeed) {
        [self openURL:[NSString stringWithFormat:@"reviewlist?subjectId=%@", self.ids]];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.model) {
        return 2;
    }
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 3;
    } else if (section == 1) {
        if (self.tabIndex == 0) {
            if (self.clNextIndex > 0) {
                return self.courseList.count + 2;
            }
            return 1 + self.courseList.count;
            
        } else if (self.tabIndex == 2) {
            if (self.flNextIndex > 0) {
                return self.reviewList.count + 2;
            }
            return 1 + self.reviewList.count;
            
        } else {
            return 2;
        }
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
            CourseTagsCell *tagsCell = [CourseTagsCell cellWithTableView:tableView forIndexPath:indexPath withIdentifier:identifierCourseTagsCell];
            tagsCell.data = self.model.data.subject;
            cell = tagsCell;
            cell.selectionStyle = UITableViewCellSeparatorStyleNone;
            
        } else {
            CourseDiscCell *discCell = [CourseDiscCell cellWithTableView:tableView forIndexPath:indexPath withIdentifier:identifierCourseDiscCell];
            discCell.data = self.model.data.subject.intro;
            cell = discCell;
            cell.selectionStyle = UITableViewCellSeparatorStyleNone;
        }
        
    } else if (section == 1) {
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
                if((row - 1) == self.courseList.count) {
                    static NSString * loadIdentifier = @"CellLoading";
                    UITableViewCell * load = [tableView dequeueReusableCellWithIdentifier:loadIdentifier];
                    if(load == nil) {
                        load = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:loadIdentifier];
                    }
                    [load showLoadingBee];
                    cell = load;
                    if(!self.clLoading) {
                        [self requestCourse];
                        self.clLoading = YES;
                    }
                    
                } else {
                    CourseListItemCell *itemCell = [CourseListItemCell cellWithTableView:tableView forIndexPath:indexPath withIdentifier:identifierCourseListItemCell];
                    itemCell.data = self.courseList[row - 1];
                    cell = itemCell;
                }
                
            } else if (self.tabIndex == 1) {
                CourseNoticeCell *noticeCell = [CourseNoticeCell cellWithTableView:tableView forIndexPath:indexPath withIdentifier:identifierCourseNoticeCell];
                noticeCell.data = self.model.data.subject.notice;
                cell = noticeCell;
                cell.selectionStyle = UITableViewCellSeparatorStyleNone;
                
            } else {
                if((row - 1) == self.reviewList.count) {
                    static NSString * loadIdentifier = @"CellLoading";
                    UITableViewCell * load = [tableView dequeueReusableCellWithIdentifier:loadIdentifier];
                    if(load == nil) {
                        load = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:loadIdentifier];
                    }
                    [load showLoadingBee];
                    cell = load;
                    if(!self.flLoading) {
                        [self requestFeed];
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
            return [PhotoTitleHeaderCell heightWithTableView:tableView withIdentifier:identifierPhotoTitleHeaderCell forIndexPath:indexPath data:self.model.data.subject];
            
        } else if (row == 1) {
            return [CourseTagsCell heightWithTableView:tableView withIdentifier:identifierCourseTagsCell forIndexPath:indexPath data:self.model.data.subject];
        } else {
            
            return [CourseDiscCell heightWithTableView:tableView withIdentifier:identifierCourseDiscCell forIndexPath:indexPath data:self.model.data.subject.intro];
        }
    } else if (section == 1) {
        if (row == 0) {
            return 50;
            
        } else {
            if (self.tabIndex == 0) {
                if((row - 1) == self.courseList.count) {
                    return 44;
                }
                return [CourseListItemCell heightWithTableView:tableView withIdentifier:identifierCourseListItemCell forIndexPath:indexPath data:self.courseList[row - 1]];
                
            } else if (self.tabIndex == 1) {
                return [CourseNoticeCell heightWithTableView:tableView withIdentifier:identifierCourseNoticeCell forIndexPath:indexPath data:self.model.data.subject.notice];
                
            } else {
                if((row - 1) == self.reviewList.count) {
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
    return 10.0;
}

@end
