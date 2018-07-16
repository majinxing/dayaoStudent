//
//  MJXFollowUpPlanViewController.m
//  XinSuiFang
//
//  Created by majinxing on 16/9/23.
//  Copyright © 2016年 majinxing. All rights reserved.
//随访计划页面

#import "MJXFollowUpPlanViewController.h"
#import "MJXRootViewController.h"
#import "MJXFollowUpPlanTableViewCell.h"
#import "MJXTemplate.h"
#import "MJXAddFollowUpViewController.h"
@interface MJXFollowUpPlanViewController ()<UITableViewDelegate,UITableViewDataSource,MJXFollowUpPlanTableViewCellDelegate>
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)NSString *planName;
@property (nonatomic,strong)NSMutableArray *templateArray;
@end

@implementation MJXFollowUpPlanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    _templateArray = [NSMutableArray arrayWithCapacity:10];
    _planName = [[NSString alloc] init];
    [MJXUIUtils addNavigationWithView:self.view withTitle:@"随访计划"];
    [self addBackButton];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, APPLICATION_WIDTH, APPLICATION_HEIGHT-64) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    [self getData];
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated{
    if (!_tableView) {
        [self getData];
    }
}
-(void)getData{
    [_templateArray removeAllObjects];
   AFHTTPRequestOperationManager *manger = [MJXClient setAFHTTPRequestOperationManagerSomeQuality];
    NSString *url = [NSString stringWithFormat:@"%@/followup/findPatientPlan",MJXBaseURL];
    [manger POST:url parameters:@{
                                  @"username":[[MJXAppsettings sharedInstance] getUserPhone],
                                  @"patientId":_patients.patientId
                                 } success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                     if ([[responseObject objectForKey:@"statusCode"] isEqualToString:@"200"]) {
                                         
                                        NSArray *data = [responseObject objectForKey:@"result"];
                                        
                                         if (data.count>0) {
                                             NSDictionary *dict = [responseObject objectForKey:@"result"][0];
                                             _planName = [dict objectForKey:@"name"];
                                             NSMutableArray *ary = [NSMutableArray arrayWithCapacity:10];
                                             ary = [dict objectForKey:@"node"];
                                             for (int i=0; i<ary.count; i++) {
                                                 MJXTemplate *one = [[MJXTemplate alloc] init];
                                                 one.futureTime = [ary[i] objectForKey:@"sendDate"];
                                                 one.advice = [ary[i] objectForKey:@"content"];
                                                 one.state =  [NSString stringWithFormat:@"%@",[ary[i] objectForKey:@"status"]];
                                                 one.nodeId = [ary[i] objectForKey:@"nodeId"];
                                                 [_templateArray addObject:one];
                                                 
                                             }
                                             
                                         }
                                         [_tableView reloadData];

                                         }else{
                                           return ;
                                         }
                                                                              NSLog(@"1");
                                 } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                     NSLog(@"0");
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
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark MJXFollowUpPlanTableViewCellDelegate
-(void)followUpPlanTableViewCelladjustThePlanPressed{
    MJXAddFollowUpViewController * aFUVC = [[MJXAddFollowUpViewController alloc] init];
    aFUVC.patients = _patients;
    aFUVC.titleStr = @"修改随访";
    aFUVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:aFUVC animated:YES];
}
//立即发送
-(void)immediatelySendPressed:(UIButton *)btn{
    NSString * url = [NSString stringWithFormat:@"%@/followup/sendNow",MJXBaseURL];
    MJXTemplate *one = _templateArray[btn.tag-2000-2];
    NSMutableDictionary * dict = [[NSMutableDictionary alloc] init];
    [dict setValue:[[MJXAppsettings sharedInstance] getUserPhone] forKey:@"username"];
    [dict setValue:_patients.patientId forKey:@"patientId"];
    [dict setValue:one.nodeId forKey:@"nodeId"];
    [self changeStatusWithUrl:url withDict:dict];
}
//取消发送
-(void)cancelSendPressed:(UIButton *)btn{
    NSString * url = [NSString stringWithFormat:@"%@/followup/cancelSending",MJXBaseURL];
    MJXTemplate *one = _templateArray[btn.tag-1000-2];
    NSMutableDictionary * dict = [[NSMutableDictionary alloc] init];
    [dict setValue:[[MJXAppsettings sharedInstance] getUserPhone] forKey:@"username"];
    [dict setValue:_patients.patientId forKey:@"patientId"];
    [dict setValue:one.nodeId forKey:@"nodeId"];
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
    }
    MJXTemplate *one = _templateArray[btn.tag-2];
    NSMutableDictionary * dict = [[NSMutableDictionary alloc] init];
    [dict setValue:[[MJXAppsettings sharedInstance] getUserPhone] forKey:@"username"];
    [dict setValue:_patients.patientId forKey:@"patientId"];
    [dict setValue:one.nodeId forKey:@"nodeId"];
    [self changeStatusWithUrl:url withDict:dict];
}
-(void)changeStatusWithUrl:(NSString *)url withDict:(NSDictionary *)dict{
    AFHTTPRequestOperationManager *manger = [MJXClient setAFHTTPRequestOperationManagerSomeQuality];
    [manger POST:url parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"1");
        [self getData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"0");
        [_tableView reloadData];
    }];
}
#pragma mark UITableViewdelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (_templateArray.count>0) {
        return _templateArray.count+2;
    }
    return 2;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MJXFollowUpPlanTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!cell) {
        cell=[[MJXFollowUpPlanTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    if (indexPath.row==0) {
        [cell showPatientName:_patients.patientsName withPhoneNumber:_patients.patientNumberPhone withSex:_patients.patientSex withAge:_patients.patientAge withPatientHead:_patients.patientHeadImageUrl];
    }else if (indexPath.row==1) {
        [cell showNameOfFollowUp:_planName];
        cell.delegate = self;
    }else{
        cell.backgroundColor = [UIColor colorWithHexString:@"#f7f7f7"];
        MJXTemplate *one = _templateArray[indexPath.row-2];
        [cell addContenViewWithFollowUpTime:one.futureTime withContent:one.advice withRemindstate:one.state withButtonTag:(int)indexPath.row];
        cell.delegate = self;
    }
   
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==0) {
        return 65;
    }else if (indexPath.row==1){
        return 60;
    }
    MJXFollowUpPlanTableViewCell *cell = (MJXFollowUpPlanTableViewCell *)[self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.height;
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
