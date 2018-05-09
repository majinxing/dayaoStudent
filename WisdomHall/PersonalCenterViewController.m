//
//  PersonalCenterViewController.m
//  WisdomHall
//
//  Created by XTU-TI on 2017/4/24.
//  Copyright © 2017年 majinxing. All rights reserved.
//

#import "PersonalCenterViewController.h"
#import "SystemSettingsViewController.h"
#import "SystemSetingTableViewCell.h"
#import "PersonalInfoViewController.h"
#import "NoticeViewController.h"
#import "CompanyProfileViewController.h"
#import "FeedbackViewController.h"
#import "GroupListViewController.h"
#import "DYHeader.h"
#import "ChangeThemeInfoViewController.h"
#import "StatisticalSelfUIViewController.h"
#import "AboutUSViewController.h"

#import "StatisticalViewController.h"

@interface PersonalCenterViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView * tableview;
@end

@implementation PersonalCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavigationTitle];
    
    _tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, APPLICATION_WIDTH, APPLICATION_HEIGHT-64-44) style:UITableViewStylePlain];
    _tableview.delegate = self;
    _tableview.dataSource = self;
    _tableview.separatorStyle = NO;
    [self.view addSubview:_tableview];
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;

    // Do any additional setup after loading the view from its nib.
}
/**
 *  显示navigation的标题
 **/
-(void)setNavigationTitle{
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
   
    self.title = @"我的";
}
-(void)viewWillAppear:(BOOL)animated{
    [_tableview reloadData];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark UITableViewdelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }else if (section == 1){
        return 7;
    }
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SystemSetingTableViewCell * cell =[SystemSetingTableViewCell tempTableViewCellWith:tableView indexPath:indexPath];
    if (indexPath.section != 1) {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            PersonalInfoViewController * pVC = [[PersonalInfoViewController alloc] init];
            self.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:pVC animated:YES];
            self.hidesBottomBarWhenPushed = NO;
        }
        else if (indexPath.row == 1){
            GroupListViewController * g = [[GroupListViewController alloc] init];
            self.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:g animated:YES];
            self.hidesBottomBarWhenPushed = NO;
        }else if (indexPath.row == 2){
            
            StatisticalViewController * vc = [[StatisticalViewController alloc] init];
            self.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
            self.hidesBottomBarWhenPushed = NO;
            
        }else if (indexPath.row == 3){
            ChangeThemeInfoViewController * vc = [[ChangeThemeInfoViewController alloc] init];
            self.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
            self.hidesBottomBarWhenPushed = NO;
        }else if (indexPath.row == 4) {
            SystemSettingsViewController * systemVC = [[SystemSettingsViewController alloc] init];
            self.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:systemVC animated:YES];
            self.hidesBottomBarWhenPushed = NO;
        }else if (indexPath.row == 5){
            AboutUSViewController *cVC = [[AboutUSViewController alloc] init];
            self.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:cVC animated:YES];
            self.hidesBottomBarWhenPushed = NO;
        }else if (indexPath.row == 6){
            FeedbackViewController * f = [[FeedbackViewController alloc] init];
            self.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:f animated:YES];
            self.hidesBottomBarWhenPushed = NO;
        }
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 146;
    }
    return 50;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0;
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
