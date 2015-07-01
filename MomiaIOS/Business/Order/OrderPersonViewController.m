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
#import "OrderPersonModel.h"

static NSString * orderPersonIdentifier = @"CellOrderPerson";

@interface OrderPersonViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) OrderPersonModel * model;

@end

@implementation OrderPersonViewController




#pragma tableView dataSource&delegate

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}


-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    CommonHeaderView * header = [CommonHeaderView cellWithTableView:self.tableView];
    NSString * content = @"请选择";
    if(self.personStyle.adult > 0) {
        content = [content stringByAppendingFormat:@"成人%ld名",self.personStyle.adult];

    }
    if(self.personStyle.child > 0) {
        if(self.personStyle.adult > 0) {
            content = [content stringByAppendingString:@"，"];
        }
        content = [content stringByAppendingFormat:@"儿童%ld名",self.personStyle.child];
    }
    header.data = content;
    return header;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
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
    OrderPersonDataModel * dataModel = self.model.data[indexPath.row];
    [cell setData:dataModel withSelectedDic:self.selectedDictionary];
    cell.onCheckBlock = ^(UIButton * checkBtn) {
        if(checkBtn.selected) {
            [self.selectedDictionary setObject:dataModel.type forKey:@(dataModel.opId)];
        } else {
            [self.selectedDictionary removeObjectForKey:@(dataModel.opId)];
        }
    };
    return cell;
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
    NSURL * url = [NSURL URLWithString:[NSString stringWithFormat:@"tq://orderaddperson?utoken=%@",self.utoken]];
    [[UIApplication sharedApplication] openURL:url];
}



#pragma mark - webData Request

- (void)requestData {
    if (self.model == nil) {
        [self.view showLoadingBee];
    }
    
    NSDictionary * dic = @{@"utoken":self.utoken};
    [[HttpService defaultService] GET:URL_APPEND_PATH(@"/participant/list") parameters:dic cacheType:CacheTypeDisable JSONModelClass:[OrderPersonModel class] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (self.model == nil) {
            [self.view removeLoadingBee];
        }
        
        self.model = responseObject;
        
        [self.tableView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}


#pragma mark - view life cycle

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"addPersonSuccess" object:nil];
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
    
    [CommonHeaderView registerCellWithTableView:self.tableView];
    
    [OrderPersonCell registerCellWithTableView:self.tableView withIdentifier:orderPersonIdentifier];
    
    self.tableView.backgroundView = [[UIView alloc] init];
    self.tableView.backgroundView.backgroundColor = UIColorFromRGB(0xf1f1f1);
    
    [self requestData];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(addPersonSuccess)
                                                 name:@"addPersonSuccess"
                                               object:nil];
}

-(void)addPersonSuccess
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
