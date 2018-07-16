//
//  MJXPatientsWithSetViewController.m
//  XinSuiFang
//
//  Created by majinxing on 16/9/24.
//  Copyright © 2016年 majinxing. All rights reserved.
//

#import "MJXPatientsWithSetViewController.h"
#import "MJXRootViewController.h"
#import "MJXPatientsWithSetTableViewCell.h"
#import <RongIMLib/RongIMLib.h>
#import "FMDBTool.h"
#import "MJXSelectGroupViewController.h"

@interface MJXPatientsWithSetViewController ()<UITableViewDelegate,UITableViewDataSource,MJXPatientsWithSetTableViewCellDelegate>
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)NSString *findMessage;//判断是否接受信息
@property (nonatomic,strong)FMDatabase *db;//数据库

@end

@implementation MJXPatientsWithSetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHexString:@"#f7f7f7"];
    _findMessage = [[NSString alloc] init];
    [MJXUIUtils addNavigationWithView:self.view withTitle:@"患者设置"];
    [self addBackButton];
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, APPLICATION_WIDTH, APPLICATION_HEIGHT-64) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor colorWithHexString:@"#f7f7f7"];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    [self getData];
    // Do any additional setup after loading the view.
}
-(void)getData{
   AFHTTPRequestOperationManager *manger = [MJXClient setAFHTTPRequestOperationManagerSomeQuality];
    NSString * url = [NSString stringWithFormat:@"%@/followup/findMessage",MJXBaseURL];
    [manger POST:url parameters:@{
                                 @"username": [[MJXAppsettings sharedInstance] getUserPhone],
                                 @"patientId" :_patients.patientId
                                 } success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                     _findMessage =[NSString stringWithFormat:@"%@", [responseObject objectForKey:@"result"]];
                                     [_tableView reloadData];
                                 } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                     
                                 }];

}
-(void)addBackButton{
    UIImageView *backImage = [[UIImageView alloc] initWithFrame:CGRectMake(20, 20+15, 7, 15)];
    backImage.image = [UIImage imageNamed:@"return"];
    [self.view addSubview:backImage];
    UIButton *back = [UIButton buttonWithType:UIButtonTypeCustom];
    back.frame = CGRectMake(0,20,60, 44);
    [back addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:back];
    
}

-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)deletePatientsFromChatList:(MJXPatients *)patients{
    if (!_db) {
        _db = [FMDBTool createDBWithName:SQLITE_NAME];
    }
    if ([_db open]) {
       BOOL r = [FMDBTool deleteWithDB:_db tableName:TABLE_NAME_RECENT_CONSULTING withPatientTagetId:patients.targetId];
        if (r) {
            
        }
    }

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark UITableViewdelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MJXPatientsWithSetTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!cell) {
        cell=[[MJXPatientsWithSetTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    }
    cell.delegae = self;
    if (indexPath.section==0) {
        [cell receivingPatientCounseling:_findMessage withTitleStr:@"接收患者咨询"];
    }else if (indexPath.section==1){
        [cell receivingPatientCounseling:@"" withTitleStr:@"邀请患者加入心随访"];
    }else if (indexPath.section==2){
        [cell receivingPatientCounseling:@"" withTitleStr:@"分组设置"];
    
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section==2) {
        MJXSelectGroupViewController * vc = [[MJXSelectGroupViewController alloc] init];
        vc.patients = _patients;
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section==0) {
        return 10;
    }else if (section==1){
        return 7+15+13;
    }else if (section==2){
        return 7+15+13;
    }
    return 0;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, APPLICATION_WIDTH, 7+15+10)];
    view.backgroundColor = [UIColor colorWithHexString:@"#f7f7f7"];
    if (section!=0) {
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(19, 10, APPLICATION_WIDTH-38, 11)];
        titleLabel.font = [UIFont systemFontOfSize:11];
        titleLabel.textColor = [UIColor colorWithHexString:@"#999999"];
        [view addSubview:titleLabel];
        if (section==1) {
            titleLabel.text = @"关闭将无法与患者一对一沟通，不便于您的随访管理";
        }else if (section==2){
            titleLabel.text = @"系统代发短信邀请患者加入方便交流与管理";
        }
        
        
    }
    return view;

}
#pragma mark MJXPatientsWithSetTableViewCellDelegate
-(void)switchBtnPressed:(UIButton *)btn{
    AFHTTPRequestOperationManager *manger = [MJXClient setAFHTTPRequestOperationManagerSomeQuality];
    NSString * url = [NSString stringWithFormat:@"%@/followup/updateMessage",MJXBaseURL];
    NSString * n = [[NSString alloc]init];
    if ([_findMessage isEqualToString:@"1"]) {
        n = @"0";
    }else{
        n = @"1";
    }
    if ([n isEqualToString:@"0"]&&![_patients.targetId isEqualToString:@""]&&![_patients.targetId isKindOfClass:[NSNull class]]) {
        [self deletePatientsFromChatList:_patients];
        [[RCIMClient sharedRCIMClient] addToBlacklist:_patients.targetId success:^{
            NSLog(@"1");
        } error:^(RCErrorCode status) {
            NSLog(@"0");
        }];
    }else if([n isEqualToString:@"1"]&&![_patients.targetId isEqualToString:@""]&&![_patients.targetId isKindOfClass:[NSNull class]]){
       [[RCIMClient sharedRCIMClient] removeFromBlacklist:_patients.targetId success:^{
           NSLog(@"1");
       } error:^(RCErrorCode status) {
           NSLog(@"0");
       }];
    }
    
    [manger POST:url parameters:@{
                                  @"username": [[MJXAppsettings sharedInstance] getUserPhone],
                                  @"patientId" :_patients.patientId,
                                  @"messageSetting": n
                                  } success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                      [self getData];
                                     
                                  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                      [MJXUIUtils show404WithDelegate:self];
                                  }];
    
}
-(void)immediatelySendBtnPressed{
    AFHTTPRequestOperationManager *manger = [MJXClient setAFHTTPRequestOperationManagerSomeQuality];
    NSString *url = [NSString stringWithFormat:@"%@/followup/sendInvitation",MJXBaseURL];
    [manger POST:url parameters:@{
                                  @"username" :[[MJXAppsettings sharedInstance] getUserPhone],
                                  @"patientId" :_patients.patientId
                                 } success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                     
                                 } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                     
                                 }];

}



@end
