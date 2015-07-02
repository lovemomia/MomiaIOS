//
//  OrderContactViewController.m
//  MomiaIOS
//
//  Created by Owen on 15/7/1.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import "OrderContactViewController.h"
#import "OrderContactCell.h"
#import "NSString+Predicate.h"

static NSString * identifier = @"CellOrderContact";

@interface OrderContactViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) FillOrderContactsModel * showModel;

@end

@implementation OrderContactViewController

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
    NSInteger row = indexPath.row;
    OrderContactCell * cell = [OrderContactCell cellWithTableView:tableView forIndexPath:indexPath withIdentifier:identifier];
    [cell setData:self.showModel withIndex:row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.editingChanged = ^(UITextField * field) {
        if(row == 0) {
            self.showModel.name = field.text;
        } else {
            self.showModel.mobile = field.text;
        }
    };

    return cell;
}

-(void)onFinishedClick
{
    if(self.showModel.name.length == 0) {
        [AlertNotice showNotice:@"联系人姓名不能为空"];
        return;
    }
    if(self.showModel.mobile.length == 0) {
        [AlertNotice showNotice:@"联系人电话号码不能为空"];
        return;
    }
    if(![self.showModel.mobile isMobileNumber]) {
        [AlertNotice showNotice:@"电话号码格式有误"];
        return;
    }
    self.model.name = self.showModel.name;
    self.model.mobile = self.showModel.mobile;
    self.onContactFinishClick();
    [self.navigationController popViewControllerAnimated:YES];
}

-(FillOrderContactsModel *)showModel
{
    if(!_showModel) {
        _showModel = [[FillOrderContactsModel alloc] init];
        _showModel.name = self.model.name;
        _showModel.mobile = self.model.mobile;
    }
    return _showModel;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"联系人信息";

     self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(onFinishedClick)];
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.backgroundView.backgroundColor = UIColorFromRGB(0xf1f1f1);
    
    [OrderContactCell registerCellWithTableView:self.tableView withIdentifier:identifier];
    
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
