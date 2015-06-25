//
//  OrderPersonViewController.m
//  MomiaIOS
//
//  Created by Owen on 15/6/10.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import "OrderPersonViewController.h"
#import "OrderPersonCell.h"
#import "CommonHeaderView.h"
static NSString * orderPersonIdentifier = @"CellOrderPerson";

@interface OrderPersonViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation OrderPersonViewController



#pragma tableView dataSource&delegate

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 41.0f;
}


-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    CommonHeaderView * header = [CommonHeaderView cellWithTableView:self.tableView];
    header.data = @"请选择成人1名，儿童1名";
    
    return header;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    OrderPersonCell * cell = [OrderPersonCell cellWithTableView:tableView forIndexPath:indexPath withIdentifier:orderPersonIdentifier];
    return cell;
}

#pragma mark - btn event responser
- (IBAction)onSubmitClick:(id)sender {
    
    
}

-(void)onNewAddClick
{
    NSURL * url = [NSURL URLWithString:@"tq://orderaddperson"];
    [[UIApplication sharedApplication] openURL:url];
}

#pragma mark - view life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"选择出行人";
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"新增" style:UIBarButtonItemStylePlain target:self action:@selector(onNewAddClick)];
    
    [CommonHeaderView registerCellWithTableView:self.tableView];
    
    [OrderPersonCell registerCellWithTableView:self.tableView withIdentifier:orderPersonIdentifier];
    
    self.tableView.backgroundView = [[UIView alloc] init];
    self.tableView.backgroundView.backgroundColor = UIColorFromRGB(0xf1f1f1);
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
