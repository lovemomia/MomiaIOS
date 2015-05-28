//
//  PersonInfoViewController.m
//  MomiaIOS
//
//  Created by Owen on 15/5/12.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import "PersonInfoViewController.h"

@interface PersonInfoViewController ()

@end

@implementation PersonInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"个人信息";
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

#pragma mark - tableview delegate & datasource

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if (indexPath.section == 0) {
//        return 59;
//    }
//    return 44;
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0 || section == 3) {
        return 1;
    } else if (section == 1) {
        return 3;
    } else return 2;
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    static NSString *CellDefault = @"DefaultCell";
    static NSString *CellLogo = @"LogoCell";
    UITableViewCell *cell;
    if (section == 0) {
        cell = [tableView dequeueReusableCellWithIdentifier:CellLogo];
        if (cell == nil) {
            NSArray *arr = [[NSBundle mainBundle] loadNibNamed:@"PersonLogoCell" owner:self options:nil];
            cell = [arr objectAtIndex:0];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
    } else {
        cell = [tableView dequeueReusableCellWithIdentifier:CellDefault];
        if (cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellDefault];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        
        switch (section) {
            case 1:
                if (row == 0) {
                    cell.textLabel.text = @"昵称";
                } else if(row == 1){
                    cell.textLabel.text = @"宝宝年龄";
                } else {
                    cell.textLabel.text = @"常住地";
                }
                break;
            case 2:
                if (row == 0) {
                    cell.textLabel.text = @"手机号";
                    cell.detailTextLabel.text = @"15929403020";
                } else {
                    cell.textLabel.text = @"第三方账号绑定";
                }
                break;
            case 3:
                cell.textLabel.text = @"修改密码";
            default:
                break;
        }
    }
    return cell;
}






@end
