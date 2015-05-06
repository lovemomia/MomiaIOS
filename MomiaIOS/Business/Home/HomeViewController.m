//
//  HomeViewController.m
//  MomiaIOS
//
//  Created by Deng Jun on 15/4/16.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import "HomeViewController.h"
#import "MineViewController.h"
#import "HomeTopicCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface HomeViewController ()

- (void)onMineClicked;
- (void)onDiscoverClicked;
- (void)onPullDownToRefresh:(UIRefreshControl *)refreshs;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) UIRefreshControl *refreshControl;

@end

@implementation HomeViewController

- (instancetype)initViewController {
    if (self = [super initWithNibName:@"HomeViewController" bundle:nil]) {
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
            [self.tableView setSeparatorInset:UIEdgeInsetsZero];
        }
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self.navigationItem setTitle:@"麻麻蜜丫"];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"发现" style:UIBarButtonItemStylePlain target:self action:@selector(onDiscoverClicked)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"我的" style:UIBarButtonItemStylePlain target:self action:@selector(onMineClicked)];
    
    if ([self.tableView superview] == nil) {
        [self.tableView setFrame:self.view.bounds];
        [self.view addSubview:self.tableView];
    }
    
    self.refreshControl = [[UIRefreshControl alloc]init];
    self.refreshControl.tintColor = [UIColor lightGrayColor];
    [self.refreshControl addTarget:self action:@selector(onPullDownToRefresh:) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:self.refreshControl];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - title button listener

- (void)onMineClicked {
//    [self.navigationController pushViewController:[[MineViewController alloc]initViewController] animated:true];
    NSURL *url = [NSURL URLWithString:@"momia://mine"];
    [[UIApplication sharedApplication ] openURL:url];
}

- (void)onDiscoverClicked {
    NSLog(@"onDiscoverClicked");
}

- (void)onPullDownToRefresh:(UIRefreshControl *)refreshs {
//    if (refreshs.refreshing) {
//        refreshs.attributedTitle = [[NSAttributedString alloc]initWithString:@"正在刷新"];
//    }
}

#pragma mark - tableview delegate & datasource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return SCREEN_WIDTH / 1.23;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSURL *url = [NSURL URLWithString:@"momia://articlelist"];
    [[UIApplication sharedApplication] openURL:url];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellArticle = @"CellArticle";
    static NSString *CellGoods = @"CellGoods";
    static NSString *CellPromotion = @"CellPromotion";
    
    HomeTopicCell *cell = [tableView dequeueReusableCellWithIdentifier:CellArticle];
    if (cell == nil) {
        NSArray *arr = [[NSBundle mainBundle] loadNibNamed:@"HomeTopicCell" owner:self options:nil];
        cell = [arr objectAtIndex:0];
    }
    [cell.backImage sd_setImageWithURL:[NSURL URLWithString:@"http://b1.hucdn.com/upload/oversea/1503/17/98292375114078_640x300.jpg"]];
    return cell;
}

@end
