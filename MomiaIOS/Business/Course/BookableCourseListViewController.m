//
//  BookableCourseListViewController.m
//  MomiaIOS
//
//  Created by Deng Jun on 15/10/19.
//  Copyright © 2015年 Deng Jun. All rights reserved.
//

#import "BookableCourseListViewController.h"
#import "BookCourseListItemCell.h"
#import "CourseListItemCell.h"
#import "CourseListModel.h"
#import "JSDropDownMenu.h"

static NSString * identifierBookCourseListItemCell = @"BookCourseListItemCell";
static NSString * identifierCourseListItemCell = @"CourseListItemCell";

@interface BookableCourseListViewController()<JSDropDownMenuDataSource,JSDropDownMenuDelegate>

@property (nonatomic, strong) NSString *ids;
@property (nonatomic, strong) NSString *pid;
@property (nonatomic, assign) BOOL onlyShow;

@property (nonatomic, strong) NSMutableArray *list;
@property (nonatomic, strong) NSArray *ages;
@property (nonatomic, strong) NSArray *sorts;
@property (nonatomic, strong) Filter *currentAge;
@property (nonatomic, strong) Filter *currentSort;
@property (nonatomic, assign) NSInteger currentAgeIndex;
@property (nonatomic, assign) NSInteger currentSortIndex;

@property (nonatomic, assign) BOOL hasAddedMenu;
@property (nonatomic, assign) BOOL isLoading;
@property (nonatomic, assign) NSInteger nextIndex;
@property (nonatomic, strong) AFHTTPRequestOperation * curOperation;

@end

@implementation BookableCourseListViewController

- (instancetype)initWithParams:(NSDictionary *)params {
    if (self = [super initWithParams:params]) {
        self.ids = [params objectForKey:@"id"];
        self.pid = [params objectForKey:@"pid"];
        self.onlyShow = [[params objectForKey:@"onlyshow"]boolValue];
    }
    return self;
}

- (UIEdgeInsets)tableViewOriginalContentInset {
    return UIEdgeInsetsMake(46, 0, 0, 0);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"可选课程";
    
    [BookCourseListItemCell registerCellFromNibWithTableView:self.tableView withIdentifier:identifierBookCourseListItemCell];
    [CourseListItemCell registerCellFromNibWithTableView:self.tableView withIdentifier:identifierCourseListItemCell];
    
    self.list = [NSMutableArray new];
    [self requestData:YES];
}

- (void)requestData:(BOOL)refresh {
    if(self.curOperation) {
        [self.curOperation pause];
    }
    
    if ([self.list count] == 0) {
        [self.view showLoadingBee];
    }
    
    if (refresh) {
        self.nextIndex = 0;
        self.isLoading = NO;
    }
    
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc]init];
    [paramDic setValue:self.ids forKey:@"id"];
    [paramDic setValue:[NSString stringWithFormat:@"%ld", (long)self.nextIndex] forKey:@"start"];
    

    if (self.ages) {
        Filter *filter = self.ages[self.currentAgeIndex];
        [paramDic setValue:filter.ids forKey:@"age"];
    }

    if (self.sorts) {
        Filter *filter = self.sorts[self.currentSortIndex];
        [paramDic setValue:filter.ids forKey:@"sort"];
    }

    self.curOperation = [[HttpService defaultService]GET:URL_APPEND_PATH(@"/subject/course")
                                              parameters:paramDic cacheType:CacheTypeDisable JSONModelClass:[CourseListModel class]
                                                 success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                                     if ([self.list count] == 0) {
                                                         [self.view removeLoadingBee];
                                                     }
                                                     
                                                     CourseListModel *model = (CourseListModel *)responseObject;
                                                     if (self.nextIndex == 0) {
                                                         self.ages = model.data.ages;
                                                         self.sorts = model.data.sorts;
                                                         // age
                                                         for (int i = 0; i < self.ages.count; i++) {
                                                             Filter *age = self.ages[i];
                                                             if ([model.data.currentAge isEqualToNumber:age.ids]) {
                                                                 self.currentAge = age;
                                                                 self.currentSortIndex = i;
                                                                 break;
                                                             }
                                                         }
                                                         // sort
                                                         for (int i = 0; i < self.sorts.count; i++) {
                                                             Filter *sort = self.sorts[i];
                                                             if ([model.data.currentSort isEqualToNumber:sort.ids]) {
                                                                 self.currentSort = sort;
                                                                 self.currentSortIndex = i;
                                                                 break;
                                                             }
                                                         }
                                                         [self setFilterMenu];
                                                     }
                                                     
                                                     if (model.data.courses.nextIndex) {
                                                         self.nextIndex = [model.data.courses.nextIndex integerValue];
                                                     } else {
                                                         self.nextIndex = -1;
                                                     }
                                                     
                                                     if (refresh) {
                                                         [self.list removeAllObjects];
                                                     }
                                                     if ([model.data.courses.totalCount intValue] == 0) {
                                                         [self.view showEmptyView:@"没有符合条件的课程，尽请期待~"];
                                                         return;
                                                     }
                                                     
                                                     for (Course *course in model.data.courses.list) {
                                                         [self.list addObject:course];
                                                     }
                                                     [self.tableView reloadData];
                                                     self.isLoading = NO;
                                                     
                                                 }
                         
                                                 failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                                     if ([self.list count] == 0) {
                                                         [self.view removeLoadingBee];
                                                     }
                                                     [self showDialogWithTitle:nil message:error.message];
                                                     self.isLoading = NO;
                                                 }];
}

- (UITableViewCellSeparatorStyle)tableViewCellSeparatorStyle {
    return UITableViewCellSeparatorStyleSingleLine;
}

- (void)setFilterMenu {
    if (!self.hasAddedMenu) {
        JSDropDownMenu *menu = [[JSDropDownMenu alloc] initWithOrigin:CGPointMake(0, 1) andHeight:45];
        menu.indicatorColor = [UIColor colorWithRed:175.0f/255.0f green:175.0f/255.0f blue:175.0f/255.0f alpha:1.0];
        menu.separatorColor = [UIColor colorWithRed:210.0f/255.0f green:210.0f/255.0f blue:210.0f/255.0f alpha:1.0];
        menu.textColor = [UIColor colorWithRed:83.f/255.0f green:83.f/255.0f blue:83.f/255.0f alpha:1.0f];
        menu.dataSource = self;
        menu.delegate = self;
        
        [self.view addSubview:menu];
    }
    
}

#pragma mark - JSDropDownMenu delegate & datasourse

- (void)menu:(JSDropDownMenu *)menu didSelectRowAtIndexPath:(JSIndexPath *)indexPath {
    if (indexPath.column == 0) {
        if (self.currentAgeIndex == indexPath.row) {
            return;
        }
        self.currentAgeIndex = indexPath.row;
        
    } else {
        if (self.currentSortIndex == indexPath.row) {
            return;
        }
        self.currentSortIndex = indexPath.row;
    }
    if (self.list) {
        [self.list removeAllObjects];
        [self.tableView reloadData];
        [self requestData:YES];
    }
}

- (NSInteger)numberOfColumnsInMenu:(JSDropDownMenu *)menu {
    return 2;
}

- (NSInteger)menu:(JSDropDownMenu *)menu numberOfRowsInColumn:(NSInteger)column leftOrRight:(NSInteger)leftOrRight leftRow:(NSInteger)leftRow {
    if (column == 0) {
        return self.ages.count;
    } else {
        return self.sorts.count;
    }
}

- (NSString *)menu:(JSDropDownMenu *)menu titleForRowAtIndexPath:(JSIndexPath *)indexPath {
    if (indexPath.column == 0) {
        return ((Filter *)self.ages[indexPath.row]).text;
    } else {
        return ((Filter *)self.sorts[indexPath.row]).text;
    }
}

- (NSString *)menu:(JSDropDownMenu *)menu titleForColumn:(NSInteger)column {
    if (column == 0) {
        return self.currentAge.text;
    } else {
        return self.currentSort.text;
    }
}

- (CGFloat)widthRatioOfLeftColumn:(NSInteger)column {
    return 1;
}

- (BOOL)haveRightTableViewInColumn:(NSInteger)column {
    return NO;
}


- (NSInteger)currentLeftSelectedRow:(NSInteger)column {
    if (column == 0) {
        return self.currentAgeIndex;
    } else {
        return self.currentSortIndex;
    }
}

#pragma mark - tableview delegate & datasource

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if(indexPath.row < self.list.count) {
        Course *course = self.list[indexPath.row];
        if (self.onlyShow) {
            [self openURL:[NSString stringWithFormat:@"duola://coursedetail?id=%@", course.ids]];
            
        } else {
            [self openURL:[NSString stringWithFormat:@"duola://bookcoursedetail?id=%@&pid=%@&book=1", course.ids, self.pid]];
        }
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.nextIndex > 0) {
        return self.list.count + 1;
    }
    return self.list.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger row = indexPath.row;
    UITableViewCell * cell;
    if(row == self.list.count) {
        static NSString * loadIdentifier = @"CellLoading";
        UITableViewCell * load = [tableView dequeueReusableCellWithIdentifier:loadIdentifier];
        if(load == nil) {
            load = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:loadIdentifier];
        }
        [load showLoadingBee];
        cell = load;
        if(!self.isLoading) {
            [self requestData:NO];
            self.isLoading = YES;
        }
        
    } else {
        if (self.onlyShow) {
            CourseListItemCell * itemCell = [CourseListItemCell cellWithTableView:tableView forIndexPath:indexPath withIdentifier:identifierCourseListItemCell];
            itemCell.data = self.list[indexPath.row];
            cell = itemCell;
        } else {
            BookCourseListItemCell * itemCell = [BookCourseListItemCell cellWithTableView:tableView forIndexPath:indexPath withIdentifier:identifierBookCourseListItemCell];
            itemCell.data = self.list[indexPath.row];
            itemCell.pid = self.pid;
            cell = itemCell;
        }
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 87;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == [self numberOfSectionsInTableView:tableView]) {
        return SCREEN_HEIGHT;
    }
    return 0.1;
}

@end
