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
#import "OrderPerson.h"
#import "PostPersonModel.h"
#import "MJRefresh.h"
#import "OrderPersonModel.h"


static NSString * orderPersonIdentifier = @"CellOrderPerson";

@interface OrderPersonViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) OrderPersonModel * model;

@end

@implementation OrderPersonViewController

#pragma tableView dataSource&delegate

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //执行删除联系人操作
        [self deletePerson:indexPath];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    CommonHeaderView * header = [CommonHeaderView cellWithTableView:self.tableView];
    NSString * content = @"请选择";
    if(self.personStyle.adult > 0) {
        content = [content stringByAppendingFormat:@"成人%ld名",(unsigned long)self.personStyle.adult];

    }
    if(self.personStyle.child > 0) {
        if(self.personStyle.adult > 0) {
            content = [content stringByAppendingString:@"，"];
        }
        content = [content stringByAppendingFormat:@"儿童%ld名",(unsigned long)self.personStyle.child];
    }
    header.data = content;
    return header;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if(self.model) return 1;
    return 0;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.model.data.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    OrderPersonCell * cell = [OrderPersonCell cellWithTableView:tableView forIndexPath:indexPath withIdentifier:orderPersonIdentifier];
    OrderPerson *dataModel = self.model.data[indexPath.row];
    [cell setData:dataModel withSelectedDic:self.selectedDictionary];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.onEditBlock = ^(UIButton * editBtn) {
        //开始编辑出行人
        OrderPerson * model = self.model.data[indexPath.row];
        NSURL * url = [NSURL URLWithString:[NSString stringWithFormat:@"duola://orderupdateperson?personId=%ld",(long)model.opId]];
        [[UIApplication sharedApplication] openURL:url];

    };
    return cell;
}

-(void)tableView:(UITableView *) tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    OrderPerson *dataModel = self.model.data[indexPath.row];
    if([self.selectedDictionary objectForKey:@(dataModel.opId)]) {
        [self.selectedDictionary removeObjectForKey:@(dataModel.opId)];
    } else {
        [self.selectedDictionary setObject:dataModel.type forKey:@(dataModel.opId)];
    }
    
    UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    if([cell isKindOfClass:[OrderPersonCell class]]) {
        OrderPersonCell * personCell = (OrderPersonCell *)cell;
        OrderPerson *dataModel = self.model.data[indexPath.row];
        [personCell setData:dataModel withSelectedDic:self.selectedDictionary];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

   
//    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];// thie method to change cell data is not so good,delete it. that's it.
}

#pragma mark - btn event responser
- (IBAction)onFinishClick:(id)sender {
    if(self.selectedPersonStyle.child == self.personStyle.child && self.selectedPersonStyle.adult == self.personStyle.adult) {
        self.onFinishClick();
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [AlertNotice showNotice:@"选择的出行人不合要求，请重新选择"];
    }
}

-(PersonStyle)selectedPersonStyle
{
    PersonStyle personStyle = {0,0};
    NSArray * allKeys = self.selectedDictionary.allKeys;
    for(id number in allKeys) {
        if([self.selectedDictionary[number] isEqualToString:@"儿童"])
            personStyle.child ++;
        else personStyle.adult++;
    }
    return personStyle;

}

-(void)onNewAddClick
{
    NSURL * url = [NSURL URLWithString:[NSString stringWithFormat:@"duola://orderupdateperson"]];
    [[UIApplication sharedApplication] openURL:url];
}



#pragma mark - webData Request

-(void)deletePerson:(NSIndexPath *) indexPath
{
    OrderPerson * dataModel = self.model.data[indexPath.row];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSDictionary *params = @{@"id":@(dataModel.opId)};
    
    [[HttpService defaultService]POST:URL_APPEND_PATH(@"/participant/delete")
                           parameters:params
                       JSONModelClass:[PostPersonModel class]
                              success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                  [MBProgressHUD hideHUDForView:self.view animated:NO];
                                  [self requestData];
                                  
                              }
                              failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                  [MBProgressHUD hideHUDForView:self.view animated:YES];
                                  [self showDialogWithTitle:nil message:error.message];
                              }];

    
}




- (void)requestData {
    self.model = nil;
    [self.tableView reloadData];
    
    [self.view showLoadingBee];
    
    [[HttpService defaultService] GET:URL_APPEND_PATH(@"/participant/list") parameters:nil cacheType:CacheTypeDisable JSONModelClass:[OrderPersonModel class] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self.view removeLoadingBee];
        
        self.model = responseObject;
        
        [self.tableView reloadData];
        
        [self.tableView.header endRefreshing];

        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.view removeLoadingBee];
        [self showDialogWithTitle:nil message:error.message];
        NSLog(@"Error: %@", error);
    }];
}


#pragma mark - view life cycle

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"updatePersonSuccess" object:nil];
}

//-(instancetype)initWithParams:(NSDictionary *)params
//{
//    self = [super initWithParams:params];
//    if(self) {
//        self.utoken = [params objectForKey:@"utoken"];
//        PersonStyle personStyle;
//        personStyle.adult = [(NSString *)[params objectForKey:@"adult"] integerValue];
//        personStyle.child = [(NSString *)[params objectForKey:@"child"] integerValue];
//        self.personStyle = personStyle;
//    }
//    return self;
//}



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"选择出行人";
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"新增" style:UIBarButtonItemStylePlain target:self action:@selector(onNewAddClick)];
    
    [CommonHeaderView registerCellFromNibWithTableView:self.tableView];
    
    [OrderPersonCell registerCellFromNibWithTableView:self.tableView withIdentifier:orderPersonIdentifier];
    
    self.tableView.backgroundView = [[UIView alloc] init];
    self.tableView.backgroundView.backgroundColor = UIColorFromRGB(0xf1f1f1);
    
    // 设置下拉刷新
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(requestData)];

    
    [self requestData];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updatePersonSuccess)
                                                 name:@"updatePersonSuccess"
                                               object:nil];
}

-(void)updatePersonSuccess
{
    [self requestData];
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
