//
//  SelectingSubjectListViewController.m
//  MomiaIOS
//
//  Created by Deng Jun on 15/10/19.
//  Copyright © 2015年 Deng Jun. All rights reserved.
//

#import "BookingSubjectListViewController.h"
#import "BookingSubjectItemCell.h"
#import "BookingSubjectListModel.h"

static NSString * identifierBookingSubjectItemCell = @"BookingSubjectItemCell";

@interface BookingSubjectListViewController()

@property (nonatomic, strong) NSString *oid;

@property (nonatomic, strong) NSMutableArray *list;
@property (nonatomic, assign) BOOL isLoading;
@property (nonatomic, assign) NSInteger nextIndex;
@property (nonatomic, strong) AFHTTPRequestOperation * curOperation;

@end

@implementation BookingSubjectListViewController

-(instancetype)initWithParams:(NSDictionary *)params {
    if (self = [super initWithParams:params]) {
        self.oid = [params objectForKey:@"oid"];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"待约课程包";
    
    [BookingSubjectItemCell registerCellFromNibWithTableView:self.tableView withIdentifier:identifierBookingSubjectItemCell];
    
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
    
    NSDictionary * paramDic = @{@"oid":self.oid ? self.oid : @"",@"start":[NSString stringWithFormat:@"%ld", (long)self.nextIndex]};
    self.curOperation = [[HttpService defaultService]GET:URL_APPEND_PATH(@"/user/bookable")
                                              parameters:paramDic cacheType:CacheTypeDisable JSONModelClass:[BookingSubjectListModel class]
                                                 success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                                     if ([self.list count] == 0) {
                                                         [self.view removeLoadingBee];
                                                     }
                                                     
                                                     BookingSubjectListModel *model = (BookingSubjectListModel *)responseObject;
                                                     if (model.data.nextIndex) {
                                                         self.nextIndex = [model.data.nextIndex integerValue];
                                                     } else {
                                                         self.nextIndex = -1;
                                                     }
                                                     
                                                     if (refresh) {
                                                         [self.list removeAllObjects];
                                                     }
                                                     if ([model.data.totalCount intValue] == 0) {
                                                         [self.view showEmptyView:@"您还没有待约课程包哦，赶快去浏览一下吧~"];
                                                         return;
                                                     }
                                                     
                                                     for (BookingSubject *bs in model.data.list) {
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.row < self.list.count) {
        BookingSubject *bs = self.list[indexPath.row];
        if ([bs.courseId intValue] > 0) {
            [self openURL:[NSString stringWithFormat:@"duola://book?id=%@&pid=%@", bs.courseId, bs.packageId]];
        } else {
            [self openURL:[NSString stringWithFormat:@"duola://bookablecourselist?id=%@&pid=%@", bs.subjectId, bs.packageId]];
        }
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
        BookingSubjectItemCell * itemCell = [BookingSubjectItemCell cellWithTableView:tableView forIndexPath:indexPath withIdentifier:identifierBookingSubjectItemCell];
        itemCell.data = self.list[indexPath.row];
        cell = itemCell;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 97;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == [self numberOfSectionsInTableView:tableView]) {
        return SCREEN_HEIGHT;
    }
    return 0.1;
}

@end
