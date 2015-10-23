//
//  CourseTeacherListViewController.m
//  MomiaIOS
//
//  Created by Deng Jun on 15/10/22.
//  Copyright © 2015年 Deng Jun. All rights reserved.
//

#import "CourseTeacherListViewController.h"
#import "CourseTeacherListModel.h"
#import "CourseTeacherListItemCell.h"

static NSString * identifierCourseTeacherListItemCell = @"CourseTeacherListItemCell";

@interface CourseTeacherListViewController()

@property (nonatomic, strong) NSString *ids;

@property (nonatomic, strong) NSMutableArray *list;
@property (nonatomic, assign) BOOL isLoading;
@property (nonatomic, assign) NSInteger nextIndex;
@property (nonatomic, strong) AFHTTPRequestOperation * curOperation;

@end

@implementation CourseTeacherListViewController

-(instancetype)initWithParams:(NSDictionary *)params {
    if (self = [super initWithParams:params]) {
        self.ids = [params objectForKey:@"id"];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"讲师团";
    
    [CourseTeacherListItemCell registerCellFromNibWithTableView:self.tableView withIdentifier:identifierCourseTeacherListItemCell];
    
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
    
    NSDictionary * paramDic = @{@"id":self.ids, @"start":[NSString stringWithFormat:@"%ld", (long)self.nextIndex]};
    self.curOperation = [[HttpService defaultService]GET:URL_APPEND_PATH(@"/m/course/teacher")
                                              parameters:paramDic cacheType:CacheTypeDisable JSONModelClass:[CourseTeacherListModel class]
                                                 success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                                     if ([self.list count] == 0) {
                                                         [self.view removeLoadingBee];
                                                     }
                                                     
                                                     CourseTeacherListModel *model = (CourseTeacherListModel *)responseObject;
                                                     if (model.data.nextIndex) {
                                                         self.nextIndex = [model.data.nextIndex integerValue];
                                                     } else {
                                                         self.nextIndex = -1;
                                                     }
                                                     
                                                     if (refresh) {
                                                         [self.list removeAllObjects];
                                                     }
                                                     if (model.data.totalCount == 0) {
                                                         [self.view showEmptyView:@"该课程目前还没有讲师团"];
                                                         return;
                                                     }
                                                     
                                                     for (CourseTeacher *bs in model.data.list) {
                                                         [self.list addObject:bs];
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

#pragma mark - tableview delegate & datasource

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
        CourseTeacherListItemCell * itemCell = [CourseTeacherListItemCell cellWithTableView:tableView forIndexPath:indexPath withIdentifier:identifierCourseTeacherListItemCell];
        itemCell.data = self.list[indexPath.row];
        cell = itemCell;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < self.list.count) {
        return [CourseTeacherListItemCell heightWithTableView:tableView withIdentifier:identifierCourseTeacherListItemCell forIndexPath:indexPath data:self.list[indexPath.row]];
    }
    return 87;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == [self numberOfSectionsInTableView:tableView]) {
        return SCREEN_HEIGHT;
    }
    return 0.1;
}

@end
