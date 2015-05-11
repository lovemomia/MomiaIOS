//
//  ArticleDetailViewController.m
//  MomiaIOS
//
//  Created by Deng Jun on 15/5/7.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import "ArticleDetailViewController.h"
#import "ArticleDetailContentCell.h"

@interface ArticleDetailViewController ()

@property (nonatomic, strong) UIImageView *coverImageView;

@end

@implementation ArticleDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self addNavBackView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)isNavTransparent {
    return YES;
}

- (UITableViewCellSeparatorStyle)tableViewCellSeparatorStyle {
    return UITableViewCellSeparatorStyleSingleLine;
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
//    NSInteger row = indexPath.row;
//    if (row == 0) {
//        return 250; //header
//    } else if (row == 1) {
//        if (self.contentHeight == 0) {
//            return 600;
//        }
//        return self.contentHeight; //content
//    } else if (row == 2) {
//        return 218; //author
//    } else if (row > 5) {
//        return 54; //more
//    }
//    return 116; //comment
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 7;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *array = [[NSArray alloc]initWithObjects:@"CellHeader", @"CellContent", @"CellAuthor", @"CellComment", @"CellMore", nil];
    
    UITableViewCell *cell;
    NSInteger row = indexPath.row;
    if (row < 3) {
        cell = [tableView dequeueReusableCellWithIdentifier:[array objectAtIndex:row]];
        if (cell == nil) {
            NSArray *arr = [[NSBundle mainBundle] loadNibNamed:@"ArticleDetailCells" owner:self options:nil];
            cell = [arr objectAtIndex:row];
        }
        
    } else if (row > 5) {
        cell = [tableView dequeueReusableCellWithIdentifier:[array objectAtIndex:4]];
        if (cell == nil) {
            NSArray *arr = [[NSBundle mainBundle] loadNibNamed:@"ArticleDetailCells" owner:self options:nil];
            cell = [arr objectAtIndex:4];
        }
    } else {
        cell = [tableView dequeueReusableCellWithIdentifier:[array objectAtIndex:3]];
        if (cell == nil) {
            NSArray *arr = [[NSBundle mainBundle] loadNibNamed:@"ArticleDetailCells" owner:self options:nil];
            cell = [arr objectAtIndex:3];
        }
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offsetY = scrollView.contentOffset.y;
    if (offsetY < 0) {
        if (self.coverImageView != nil) {
            self.coverImageView.top = offsetY;
//            self.coverImageView.height = [ArticleTopicHeaderCell coverHeight] - offsetY;
        }
        self.navBackView.alpha = 0;
        
    } else if (offsetY > 200) {
        self.navBackView.alpha = 1;
        
    } else {
        self.navBackView.alpha = offsetY / 200;
    }
}

@end
