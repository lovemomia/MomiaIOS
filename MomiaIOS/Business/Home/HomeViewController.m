//
//  HomeViewController.m
//  MomiaIOS
//
//  Created by Owen on 15/6/11.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import "HomeViewController.h"
#import "HomeModel.h"
#import "HomeCarouselCell.h"
#import "HomeCell.h"

@interface HomeViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong,nonatomic) HomeModel * model;
@property (strong,nonatomic) HomeCarouselModel * carouselModel;

@end

@implementation HomeViewController

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    return 0.1;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1 + self.model.data.list.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    if(section == 0) return [HomeCarouselCell heightWithTableView:tableView];
    return [HomeCell heightWithTableView:tableView forIndexPath:indexPath data:self.model.data.list[section - 1]];

}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    UITableViewCell * cell;

    if(section == 0) {
        HomeCarouselCell * carousel = [HomeCarouselCell cellWithTableView:tableView forIndexPath:indexPath];
        carousel.data = self.carouselModel.data;
        cell = carousel;
    } else {
        HomeCell * home = [HomeCell cellWithTableView:tableView forIndexPath:indexPath];
        home.data = self.model.data.list[section - 1];
        cell = home;
    }
   
    return cell;
}

-(void)onCityClick
{
    NSURL * url = [NSURL URLWithString:@"momia://fillorder"];
    [[UIApplication sharedApplication] openURL:url];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationItem.title = @"我的";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"上海" style:UIBarButtonItemStylePlain target:self action:@selector(onCityClick)];
    
    NSDictionary * dic1 = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"HomeData" ofType:@"plist"]];
    NSDictionary * dic2 = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"HomeCarouselData" ofType:@"plist"]];
    
    self.model = [[HomeModel alloc] initWithDictionary:dic1 error:nil];
    self.carouselModel = [[HomeCarouselModel alloc] initWithDictionary:dic2 error:nil];
    
    [HomeCarouselCell registerCellWithTableView:self.tableView];
    [HomeCell registerCellWithTableView:self.tableView];
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

@end
