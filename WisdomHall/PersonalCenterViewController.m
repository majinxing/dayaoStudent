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

#import "HelpViewController.h"
#import "AFNetworking.h"

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
    
//    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;

//    [self getWANIPAddress];
    // Do any additional setup after loading the view from its nib.
}
/**
 *  显示navigation的标题
 **/
-(void)setNavigationTitle{
//    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
   
    self.title = @"个人中心";
}
-(void)viewWillAppear:(BOOL)animated{
    [_tableview reloadData];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

    
-(NSString *)getWANIPAddress  {
    
    NSError *error;
    
    NSURL *ipURL = [NSURL URLWithString:@"http://pv.sohu.com/cityjson?ie=utf-8"];
    
    NSMutableString *ip = [NSMutableString stringWithContentsOfURL:ipURL encoding:NSUTF8StringEncoding error:&error];
    
    //判断返回字符串是否为所需数据
    
    if ([ip hasPrefix:@"var returnCitySN = "]) {
        
        //对字符串进行处理，然后进行json解析
        
        //删除字符串多余字符串
        
        NSRange range = NSMakeRange(0, 19);
        
        [ip deleteCharactersInRange:range];
        
        NSString * nowIp =[ip substringToIndex:ip.length-1];
        
        //将字符串转换成二进制进行Json解析
        
        NSData * data = [nowIp dataUsingEncoding:NSUTF8StringEncoding];
        
        NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        
        NSLog(@"%@",dict);
        
        return dict[@"cip"] ? dict[@"cip"] : @"";
        
    }
    
    return @"";
    
}


#pragma mark UITableViewdelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }else if (section == 1){
        return 5;
    }else if (section == 2){
        return 1;
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
            
            StatisticalViewController * vc = [[StatisticalViewController alloc] init];
            self.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
            self.hidesBottomBarWhenPushed = NO;
            
        }
        else if (indexPath.row == 2){
            AboutUSViewController *cVC = [[AboutUSViewController alloc] init];
            self.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:cVC animated:YES];
            self.hidesBottomBarWhenPushed = NO;
        }else if (indexPath.row == 3){
            FeedbackViewController * f = [[FeedbackViewController alloc] init];
            self.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:f animated:YES];
            self.hidesBottomBarWhenPushed = NO;
        }else if (indexPath.row == 4){
            HelpViewController * f = [[HelpViewController alloc] init];
            self.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:f animated:YES];
            self.hidesBottomBarWhenPushed = NO;
        }
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 148;
    }else if (indexPath.section ==2){
        return 80;
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
