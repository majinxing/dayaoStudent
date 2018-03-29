//
//  MJXConsultingViewController.m
//  XinSuiFang
//
//  Created by majinxing on 16/8/11.
//  Copyright © 2016年 majinxing. All rights reserved.
//

#import "MJXConsultingViewController.h"
#import "MJXChatViewController.h"
#import "MJXPatients.h"
#import "FMDatabase.h"
#import "FMDBTool.h"
#import "MJXChatTableViewCell.h"
#import <RongIMLib/RongIMLib.h>
#import "MJXTabBarController.h"
@interface MJXConsultingViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView * tableView;
@property (nonatomic,strong)FMDatabase *db;//数据库
@property (nonatomic,strong)NSMutableArray * patientsArrary;
@property (nonatomic,strong)MJXTabBarController * vc;
@property (nonatomic,strong)NSMutableArray * chatState;
@end

@implementation MJXConsultingViewController

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _patientsArrary = [NSMutableArray arrayWithCapacity:10];
    _chatState = [NSMutableArray arrayWithCapacity:10];
    self.view.backgroundColor=[UIColor whiteColor];
    [MJXUIUtils addNavigationWithView:self.view withTitle:@"最近咨询"];
    
   // [self getData];

    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, APPLICATION_WIDTH,APPLICATION_HEIGHT-64-44) style:UITableViewStylePlain];
    _tableView.backgroundColor = [UIColor colorWithHexString:@"#f7f7f7"];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    [self.view addSubview:_tableView];
    [self addListeningToTheMessage];
    //注册通知
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tongzhi:) name:@"tongzhi" object:nil];
}
-(void)viewWillAppear:(BOOL)animated{
    [self getData];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}
#pragma mark 监听
-(void)addListeningToTheMessage{
    _vc = [MJXTabBarController sharedInstance];
    [_vc addObserver:self forKeyPath: @"message" options: NSKeyValueObservingOptionNew context: nil];
}
-(void)tongzhi:(NSNotification *)dict{
    RCMessage * message = dict.userInfo[@"message"];
    if ([message.content isMemberOfClass:[RCTextMessage class]]){
       // NSLog(@"%@",message.targetId);
        [self theQueryRecentConsultingDraftWithTagetId:message.targetId];
    }
    //NSLog(@"%@",dict);
}
#pragma mark FMDB
-(void)theQueryRecentConsultingDraftWithTagetId:(NSString *)tagetId{
    if (!_db) {
        _db = [FMDBTool createDBWithName:SQLITE_NAME];
    }
    [self createTable];
    if ([_db open]) {
        NSString * sqlStr = [NSString stringWithFormat:@"select * from %@ where targetId = '%@';",TABLE_NAME_RECENT_CONSULTING,tagetId];
        FMResultSet * rs = [FMDBTool queryWithDB:_db withTableName:TABLE_NAME_RECENT_CONSULTING withSqlStr:sqlStr];
        if (!rs.next) {
            NSString * sqlStr1 = [NSString stringWithFormat:@"select * from %@ where targetId = '%@';",TABLE_NAME_PATIENTS,tagetId];
            FMResultSet * rs1 = [FMDBTool queryWithDB:_db withTableName:TABLE_NAME_PATIENTS withSqlStr:sqlStr1];
            MJXPatients *p=[[MJXPatients alloc] init];
            if(rs1.next) {
                p.patientsName = [rs1 stringForColumn:@"name"];
                p.patientNumberPhone = [rs1 stringForColumn:@"phone"];
                p.patientSex = [rs1 stringForColumn:@"sex"];
                p.patientId = [rs1 stringForColumn:@"patientsId"];
                p.targetId = [rs1 stringForColumn:@"targetId"];
                p.patientHeadImageUrl = [rs1 stringForColumn:@"heading"];
                p.patientAge = [rs1 stringForColumn:@"age"];
                p.patientDiagnosis = [rs1 stringForColumn:@"zhenduan"];
                BOOL result = [FMDBTool insertToRecentConsultingWithDB:_db tableName:TABLE_NAME_RECENT_CONSULTING withPatient:p];
                if (result) {
                    [self getData];
                }
            }
        }
        
    }
    [_db close];
}
-(void)getData{
    if (!_db) {
        _db = [FMDBTool createDBWithName:SQLITE_NAME];
    }
    if ([_db open]) {
        FMResultSet * rs = [FMDBTool queryWithDB:_db tableName:TABLE_NAME_RECENT_CONSULTING];
        [_patientsArrary removeAllObjects];
        while(rs.next) {
            MJXPatients * patients = [[MJXPatients alloc] init];
            patients.patientHeadImageUrl = [rs stringForColumn:@"heading"];
            patients.patientsName = [rs stringForColumn:@"name"];
            patients.patientSex = [rs stringForColumn:@"sex"];
            patients.patientAge = [rs stringForColumn:@"birthday"];
            patients.sendTime = [rs stringForColumn:@"consultingTime"];
            patients.targetId = [rs stringForColumn:@"targetId"];
            patients.theLastChat = [self getTheLastChat:patients];
            [_patientsArrary addObject:patients];
        }
        [_tableView reloadData];
    }
    [_db close];

}
//创建表
- (void)createTable
{
    if ([_db open])
    {
        BOOL result = [FMDBTool createTableWithDB:_db tableName:TABLE_NAME_RECENT_CONSULTING
                                       parameters:@{
                                                    @"address" : @"text",
                                                    @"birthday" : @"text",
                                                    @"heading" : @"text",
                                                    @"groupName" : @"text",
                                                    @"patientsId" : @"text",
                                                    @"idCode" : @"text",
                                                    @"marriageInfo" :@"text",
                                                    @"medicalRecordNum" :@"text",
                                                    @"name" : @"text",
                                                    @"nation" : @"text",
                                                    @"occupation": @"text",
                                                    @"phone" : @"text",
                                                    @"sex" : @"text",
                                                    @"zyzz" : @"text",
                                                    @"consultingTime" : @"text",
                                                    @"userId":@"text",
                                                    @"targetId" : @"text"
                                                    }];
        if (result)
        {
            NSLog(@"建表成功");
        }
        else
        {
            NSLog(@"建表失败");
        }
        [_db close];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark 融云
-(NSString *)getTheLastChat:(MJXPatients *)patients{
    NSArray * a = [[NSArray alloc] init];
    a = [[RCIMClient sharedRCIMClient] getLatestMessages:ConversationType_PRIVATE targetId:patients.targetId count:1];
    if (a.count>0&&a!=nil) {
        RCMessage * mensage = a[0];
        RCTextMessage *testMessage = (RCTextMessage *)mensage.content;
        return  testMessage.content;
    }
    return @"";
}
#pragma mark UITableViewdelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (_patientsArrary.count>0&&_patientsArrary!=nil) {
        return _patientsArrary.count;
    }
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MJXChatTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!cell) {
        cell=[[MJXChatTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    }
    if (_patientsArrary.count>0) {
       [cell addPatientsChatInfoWith:_patientsArrary[indexPath.row]];
    }
    cell.backgroundColor = [UIColor whiteColor];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    MJXChatViewController * vc = [[MJXChatViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    vc.patients = _patientsArrary[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    MJXPatients * patients = [[MJXPatients alloc] init];
    patients = _patientsArrary[indexPath.row];
    if ([_db open]) {
        NSString *sqlString = [NSString stringWithFormat:@"delete from %@ where targetId = '%@';",TABLE_NAME_RECENT_CONSULTING,patients.targetId];
        BOOL rs = [FMDBTool deleteWithDB:_db withSqlStr:sqlString];
        [self getData];
    }
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
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
