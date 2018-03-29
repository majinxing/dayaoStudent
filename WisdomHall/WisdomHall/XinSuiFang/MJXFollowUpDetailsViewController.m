//
//  MJXFollowUpDetailsViewController.m
//  XinSuiFang
//
//  Created by majinxing on 16/10/12.
//  Copyright © 2016年 majinxing. All rights reserved.
//

#import "MJXFollowUpDetailsViewController.h"
#import "MJXPatientsNodeInfoTableViewCell.h"
@interface MJXFollowUpDetailsViewController ()<UITableViewDelegate,UITableViewDataSource,MJXPatientsNodeInfoTableViewCellDelegate>
@property (nonatomic,strong)UITableView * tableView;
@end

@implementation MJXFollowUpDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [MJXUIUtils addNavigationWithView:self.view withTitle:@"随访详情"];
    [self addBackButton];
    UIView * line = [[UIView alloc] initWithFrame:CGRectMake(0, 63, APPLICATION_WIDTH, 1)];
    line.backgroundColor = [UIColor colorWithHexString:@"#f7f7f7"];
    [self.view addSubview:line];
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, APPLICATION_WIDTH, APPLICATION_HEIGHT-64) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor colorWithHexString:@"#f7f7f7"];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    // Do any additional setup after loading the view.
}
-(void)addBackButton{
    UIImageView *backImage=[[UIImageView alloc] initWithFrame:CGRectMake(20, 20+15, 7, 15)];
    backImage.image=[UIImage imageNamed:@"return"];
    [self.view addSubview:backImage];
    UIButton *back=[UIButton buttonWithType:UIButtonTypeCustom];
    back.frame=CGRectMake(0,20,60, 44);
    [back addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:back];
    
}
-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
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
        return 2;
    }
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MJXPatientsNodeInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!cell) {
        cell=[[MJXPatientsNodeInfoTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    }
    cell.backgroundColor = [UIColor whiteColor];
    if (indexPath.section == 0) {
        [cell setInitializeDataWithPatient:_patients];
    }else if (indexPath.section == 1 && indexPath.row == 0){
        [cell setTemplate:_patients.tempLateName status:_patients.status];
    }else if (indexPath.section == 1 && indexPath.row){
        [cell addContenViewWithFollowUpTime:_patients.nodeTime withContent:_patients.nodeDescription withRemindstate:_patients.status withButtonTag: (int)indexPath.row];
        cell.delegate = self;
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 60;
    }else if (indexPath.section == 1&&indexPath.row == 0){
        return 50;
    }else if (indexPath.section == 1 &&indexPath.row == 1){
        MJXPatientsNodeInfoTableViewCell *cell = (MJXPatientsNodeInfoTableViewCell *)[self tableView:tableView cellForRowAtIndexPath:indexPath];
        return cell.height;
    }
    return 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        return 10;
    }
    return 0;
}
#pragma mark MJXPatientsNodeInfoTableViewCellDelegate
//立即发送
-(void)immediatelySendPressed:(UIButton *)btn{
    NSString * url = [NSString stringWithFormat:@"%@/followup/sendNow",MJXBaseURL];
    NSMutableDictionary * dict = [[NSMutableDictionary alloc] init];
    [dict setValue:[[MJXAppsettings sharedInstance] getUserPhone] forKey:@"username"];
    [dict setValue:_patients.patientId forKey:@"patientId"];
    [dict setValue:_patients.nodeId forKey:@"nodeId"];
    [self changeStatusWithUrl:url withDict:dict];
}
//取消发送
-(void)cancelSendPressed:(UIButton *)btn{
    NSString * url = [NSString stringWithFormat:@"%@/followup/cancelSending",MJXBaseURL];
    NSMutableDictionary * dict = [[NSMutableDictionary alloc] init];
    [dict setValue:[[MJXAppsettings sharedInstance] getUserPhone] forKey:@"username"];
    [dict setValue:_patients.patientId forKey:@"patientId"];
    [dict setValue:_patients.nodeId forKey:@"nodeId"];
    [self changeStatusWithUrl:url withDict:dict];
    
}
//恢复发送 重新发送 查看复查结果
-(void)sendMessagePressed:(UIButton *)btn{
    NSString * url = [[NSString alloc] init];
    if ([btn.titleLabel.text isEqualToString:@"恢复发送"]) {
        url = [NSString stringWithFormat:@"%@/followup/backToSend",MJXBaseURL];
    }else if ([btn.titleLabel.text isEqualToString:@"重新发送"]){
        url = [NSString stringWithFormat:@"%@/followup/sendAgain",MJXBaseURL];
    }else if ([btn.titleLabel.text isEqualToString:@"查看复查结果"]){
        url = [NSString stringWithFormat:@"%@/followup/findReviewResults",MJXBaseURL];
        return;
    }
    NSMutableDictionary * dict = [[NSMutableDictionary alloc] init];
    [dict setValue:[[MJXAppsettings sharedInstance] getUserPhone] forKey:@"username"];
    [dict setValue:_patients.patientId forKey:@"patientId"];
    [dict setValue:_patients.nodeId forKey:@"nodeId"];
    [self changeStatusWithUrl:url withDict:dict];
}

-(void)changeStatusWithUrl:(NSString *)url withDict:(NSDictionary *)dict{
    AFHTTPRequestOperationManager *manger = [MJXClient setAFHTTPRequestOperationManagerSomeQuality];
    [manger POST:url parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"1");
        if ([url isEqualToString:@"http://120.27.29.242/xsfServer/app/followup/cancelSending"]) {
            _patients.status = @"001";//恢复发送
            [_tableView reloadData];
        }else if ([url isEqualToString:@"http://120.27.29.242/xsfServer/app/followup/sendNow"]){
           _patients.status = @"101";//重新发送
            [_tableView reloadData];
        }else if ([url isEqualToString:@"http://120.27.29.242/xsfServer/app/followup/backToSend"]){
            _patients.status = @"010";
            [_tableView reloadData];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"0");
        [_tableView reloadData];
    }];
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
