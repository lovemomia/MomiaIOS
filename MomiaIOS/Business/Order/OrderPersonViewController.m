//
//  OrderPersonViewController.m
//  MomiaIOS
//
//  Created by Owen on 15/6/10.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import "OrderPersonViewController.h"
#import "OrderPersonCell.h"
static NSString * identifier = @"OrderPersonHeaderViewIdentifier";

@interface OrderPersonViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property(nonatomic,strong) NSArray * dataArray;

@end

@implementation OrderPersonViewController



#pragma tableView dataSource&delegate

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 35.0f;
}


-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UITableViewHeaderFooterView * view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:identifier];
    view.textLabel.text = @"请选择1名成人和1名儿童";
    return view;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [OrderPersonCell heightWithTableView:tableView forIndexPath:indexPath data:self.dataArray[indexPath.row]];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    OrderPersonCell * cell = [OrderPersonCell cellWithTableView:tableView forIndexPath:indexPath];
    cell.data = self.dataArray[indexPath.row];

    __weak OrderPersonCell * weakCell = cell;
    cell.editBlock = ^(UIButton * sender) {
        NSLog(@"edit:%@",weakCell.nameLabel.text);
    };
    
    cell.selectBlock = ^(UIButton * sender) {
        NSLog(@"select:%@",weakCell.nameLabel.text);
    };
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
    
    NSDictionary * dic1 = @{@"name":@"陈子文",@"sex":@"成人 男",@"birth":@"1995-10-23"};
    NSDictionary * dic2 = @{@"name":@"欧阳微微",@"sex":@"成人 女",@"birth":@"1992-8-23"};
    NSDictionary * dic3 = @{@"name":@"离歌",@"sex":@"儿童 女",@"birth":@"2009-12-3"};

    self.dataArray = @[dic1,dic2,dic3];
    
    [self.tableView registerClass:[UITableViewHeaderFooterView class] forHeaderFooterViewReuseIdentifier:identifier];
    
    [OrderPersonCell registerCellWithTableView:self.tableView];
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
