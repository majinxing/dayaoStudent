//
//  SignListViewController.m
//  WisdomHall
//
//  Created by XTU-TI on 2017/5/6.
//  Copyright © 2017年 majinxing. All rights reserved.
//

#import "SignListViewController.h"
#import "PersonalInfoTableViewCell.h"
#import "DYHeader.h"
@interface SignListViewController ()<UITableViewDelegate,UITableViewDataSource,PersonalInfoTableViewCellDelegate>
@property (nonatomic,strong)UITableView * tableView;
@end

@implementation SignListViewController

-(void)dealloc{
    NSLog(@"%s",__func__);
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavigationTitle];
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,64, APPLICATION_WIDTH,APPLICATION_HEIGHT-64) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    // Do any additional setup after loading the view from its nib.
}
/**
 *  显示navigation的标题
 **/
-(void)setNavigationTitle{
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    //[self.navigationController.navigationBar setBarTintColor:[UIColor blackColor]];
    [self.navigationController.navigationBar setTitleTextAttributes:@{
                                                                      NSFontAttributeName:[UIFont systemFontOfSize:17],
                                                                      NSForegroundColorAttributeName:[UIColor blackColor]}];
    self.title = @"签到";
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark  PersonalInfoTableViewCellDelegate
-(void)signBtnPressedPInfoDelegate{
    UserModel * userModel = [[Appsetting sharedInstance] getUsetInfo];
    if (_signType == SignMeeting) {
        NSString *idfv = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
        NSDictionary * dict = [[NSDictionary alloc] initWithObjectsAndKeys:_meetingModel.meetingId,@"meetingId",userModel.peopleId,@"userId" ,idfv,@"mck",@"2",@"status",nil];
        [[NetworkRequest sharedInstance] POST:MeetingSign dict:dict succeed:^(id data) {
            
            NSLog(@"succedd:%@",data);
            
            [self alter:[[data objectForKey:@"header"] objectForKey:@"code"]];
            
        } failure:^(NSError *error) {
            NSLog(@"失败：%@",error);
        }];
        
    }else if(_signType == SignClassRoom){
        NSDictionary * dict = [[NSDictionary alloc] initWithObjectsAndKeys:_classModel.sclassId,@"courseId",userModel.peopleId,@"userId" ,nil];
        [[NetworkRequest sharedInstance] POST:ClassSign dict:dict succeed:^(id data) {
            NSLog(@"succedd:%@",data);
        } failure:^(NSError *error) {
            NSLog(@"失败：%@",error);
        }];
    }
}
-(void)alter:(NSString *) str{
    if ([str isEqualToString:@"1002"]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"现在还不能签到" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
    }else if ([str isEqualToString:@"1003"]){
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"已经签到" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
    }else if ([str isEqualToString:@"1004"]){
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"没有参加课程" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
    }else if ([str isEqualToString:@"0000"]){
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"签到成功" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
        _meetingModel.n = _meetingModel.n + 1;
        // 2.创建通知
        NSNotification *notification =[NSNotification notificationWithName:@"SignSucceed" object:nil userInfo:nil];
        // 3.通过 通知中心 发送 通知
        
        [[NSNotificationCenter defaultCenter] postNotification:notification];
        
        
    }else if ([str isEqualToString:@"5000"]){
//        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
//        [alertView show];
    }else if ([str isEqualToString:@"1008"]){
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"不可以用同一台手机签到多个用户" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
    }
}
#pragma mark  UITableViewdelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (_signType == SignMeeting) {
        if (section==0) {
            return 1;
        }if (_meetingModel.m>0&&section==1){
            return _meetingModel.m;
        }
    }else if (_signType == SignClassRoom){
        if (section == 0) {
            return 1;
        }else if(_ary.count>0&&section == 1){
            return _ary.count;
        }
    }
    
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PersonalInfoTableViewCell * cell ;
    if (_signType == SignMeeting) {
        cell = [PersonalInfoTableViewCell tempTableViewCellWith:tableView indexPath:indexPath array:_meetingModel.signNo];
        [cell setSignNumebr:[NSString stringWithFormat:@"%ld",(long)_meetingModel.m]];
    }else if(_signType == SignClassRoom){
        cell = [PersonalInfoTableViewCell tempTableViewCellWith:tableView indexPath:indexPath array:_ary];
        [cell setSignNumebr:[NSString stringWithFormat:@"%ld",(long)_ary.count]];
    }
    
    cell.delegate = self;
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1) {
        return 60;
    }
    return 50;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 0;
    }
    return 10;
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
