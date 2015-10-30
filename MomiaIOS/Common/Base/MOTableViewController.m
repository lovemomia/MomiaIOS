//
//  MOTableViewController.m
//  MomiaIOS
//
//  Created by Deng Jun on 15/5/7.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import "MOTableViewController.h"

@interface MOTableViewController ()

@end

@implementation MOTableViewController

-(instancetype)init {
    if (self = [super init]) {
        self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:[self tableViewStyle]];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        
        self.tableView.separatorStyle = [self tableViewCellSeparatorStyle];
        self.tableView.backgroundView = [[UIView alloc] init];
        self.tableView.backgroundView.backgroundColor = MO_APP_VCBackgroundColor;
    }
    return self;
}

- (instancetype)initWithParams:(NSDictionary *)params {
    if (self = [super initWithParams:params]) {
        self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:[self tableViewStyle]];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        
        self.tableView.separatorStyle = [self tableViewCellSeparatorStyle];
        self.tableView.separatorColor = MO_APP_SeparatorColor;
        self.tableView.backgroundColor = MO_APP_VCBackgroundColor;
        self.tableView.backgroundView = nil;
    }
    return self;
}

- (UITableViewStyle)tableViewStyle {
    return UITableViewStylePlain;
}

- (UITableViewCellSeparatorStyle)tableViewCellSeparatorStyle {
    return UITableViewCellSeparatorStyleNone;
}

- (BOOL)enablePullDownToRefresh {
    return NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if ([self.tableView superview] == nil) {
//        [self.tableView setFrame:self.view.bounds];
        [self.tableView setContentInset:[self tableViewOriginalContentInset]];
        [self.view addSubview:self.tableView];
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)didMoveToParentViewController:(UIViewController *)parent {
    [super didMoveToParentViewController:parent];
    
//    [self.tableView setContentInset:[self tableViewOriginalContentInset]];
//    [self.tableView setFrame:self.view.bounds];
}

- (void)dealloc {
    self.tableView.dataSource = nil;
    self.tableView.delegate = nil;
}

#pragma mark tableView delegate, dataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.frame.size.height;
}


#pragma mark -
#pragma mark Override

- (UIEdgeInsets)tableViewOriginalContentInset {
    return UIEdgeInsetsMake(-1, 0, 0, 0);
}

- (UIEdgeInsets)separatorInset {
    return UIEdgeInsetsMake(0,0,0,0);
}

- (UIEdgeInsets)separatorInsetForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UIEdgeInsetsMake(0,0,0,0);
}

-(void)viewDidLayoutSubviews
{
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:[self separatorInset]];
    }
    
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:[self separatorInset]];
    }
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:[self separatorInsetForRowAtIndexPath:indexPath]];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:[self separatorInsetForRowAtIndexPath:indexPath]];
    }
}



@end
