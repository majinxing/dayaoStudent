//
//  MJXEditingGroupViewController.m
//  XinSuiFang
//
//  Created by majinxing on 16/9/8.
//  Copyright © 2016年 majinxing. All rights reserved.
//

#import "MJXEditingGroupViewController.h"
#import "MJXRootViewController.h"
#import "MJXPatientsCell.h"
#import "MJXPatientsInGroupViewController.h"

#import "FMDatabase.h"
#import "FMDBTool.h"

@interface MJXEditingGroupViewController ()<UITableViewDelegate,UITableViewDataSource,MJXPatientsCellDelegate,UIAlertViewDelegate>
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)NSMutableArray *dataArray;
@property (nonatomic,strong)FMDatabase *db;//数据库

@end

@implementation MJXEditingGroupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    _dataArray = [NSMutableArray arrayWithCapacity:10];
    _db = [FMDBTool createDBWithName:SQLITE_NAME];
    
    [MJXUIUtils addNavigationWithView:self.view withTitle:@"编辑分组"];
    [self addBackButton];
    [self getData];
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, APPLICATION_WIDTH, APPLICATION_HEIGHT-64) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated{
    if (_tableView) {
        [self getData];
    }
}
-(void)getData{
    AFHTTPRequestOperationManager *manger = [MJXClient setAFHTTPRequestOperationManagerSomeQuality];
    NSString *url = [NSString stringWithFormat:@"%@/patient/showPatientGroup",MJXBaseURL];
    
    [manger POST:url parameters:@{                                                                      @"username" :[[MJXAppsettings sharedInstance] getUserPhone],
                                                                                                        @"pageNum" :@"1",
                                                                                                        @"pageSize":@"20",
                                                                                                        @"group"  :_patients.groupName                                                                                                                                          }
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             id data = [responseObject objectForKey:@"result"];
             if (![data isEqual:@""]) {
                 _dataArray = [responseObject objectForKey:@"result"];
             }else{
                 _dataArray = [NSMutableArray arrayWithCapacity:10];
             }
             [_tableView reloadData];
             
         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             NSLog(@"1");
             [MJXUIUtils show404WithDelegate:self];
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
    UIButton *save=[UIButton buttonWithType:UIButtonTypeCustom];
    save.frame=CGRectMake(APPLICATION_WIDTH-70,20,60, 44);
    [save setTitle:@"保 存" forState:UIControlStateNormal];
    [save setTitleColor:[UIColor colorWithHexString:@"#01aeff"] forState:UIControlStateNormal];
    save.titleLabel.font=[UIFont systemFontOfSize:15];
    [save addTarget:self action:@selector(save) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:save];
}

-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)save{
    if ([_patients.groupName isEqualToString:@""]) {
        UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@""
                                                      message:@"组名不能为空"
                                                     delegate:self
                                            cancelButtonTitle:@"确认"
                                            otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    AFHTTPRequestOperationManager *manger = [MJXClient setAFHTTPRequestOperationManagerSomeQuality];
    NSString *url = [NSString stringWithFormat:@"%@/group/updateGroup",MJXBaseURL];
    [manger POST:url parameters:@{
                                  @"username" :[[MJXAppsettings sharedInstance] getUserPhone],
                                  @"groupName":_patients.groupName,
                                  @"groupId":_patients.groupId
                                  } success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                      [self back];
                                  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                      
                                  }];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//回收键盘的
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    [self.view endEditing:YES];
    
}
#pragma mark UITableViewdelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==0) {
        return 1;
    }else if (section==1){
        return 1;
    }else if (section==2){
        return _dataArray.count;
    }
    return 0;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MJXPatientsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!cell) {
        cell=[[MJXPatientsCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    }
    if (indexPath.section==0&&indexPath.row==0) {
        [cell setGroupNameWithString:_patients.groupName];
        cell.delegate = self;
        
    }else if (indexPath.section==1&&indexPath.row==0){
        [cell addNewPatientsButton];
        cell.delegate = self;
    }else{
        MJXPatients *pa = [[MJXPatients alloc] init];
        [pa savePatientInfo:_dataArray[indexPath.row]];
        [cell setInitializeDataWithPatient:pa];
    }
    return cell;
}
//指定行是否可编辑
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==2) {
        return YES;
    }
    return NO;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 50;
    }else if (indexPath.section == 1){
        return 60;
    }
    return 65;
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section!=2) {
        return 31;
    }
    return 10;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0,APPLICATION_WIDTH,31)];
    view.backgroundColor = [UIColor colorWithHexString:@"#f7f7f7"];
    if (section==2) {
        view.frame = CGRectMake(0, 0, APPLICATION_WIDTH, 10);
    }
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 80, 15)];
    if (section==0) {
        label.text = @"分组名称";
    }else if (section==1){
        label.text = @"组内成员";
    }
    label.font = [UIFont systemFontOfSize:13];
    label.textColor = [UIColor colorWithHexString:@"#999999"];
    [view addSubview:label];
    return view;
}
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    MJXPatients *pa = [[MJXPatients alloc] init];
    [pa savePatientInfo:_dataArray[indexPath.row]];
    AFHTTPRequestOperationManager *manger = [MJXClient setAFHTTPRequestOperationManagerSomeQuality];
    NSString *url = [NSString stringWithFormat:@"%@/group/deletePatientToGroup",MJXBaseURL];
    [manger POST:url parameters:@{
                                  @"username":[[MJXAppsettings sharedInstance] getUserPhone],
                                  @"groupName" : _patients.groupName,
                                  @"patientId":pa.patientId
                                  } success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                      if ([[responseObject objectForKey:@"statusCode"] isEqualToString:@"200"]) {
                                          
                                          [self getData];
                                          if ([_db open]) {
                                              NSString *sqlString = [NSString stringWithFormat:@"delete from %@ where patientsId = '%@';",_patients.groupName,pa.patientId];
                                              [FMDBTool deleteWithDB:_db withSqlStr:sqlString];
                                          }
                                          [_db close];
                                          //
                                      }
                                      // [_tableView reloadData];
                                      
                                  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                      [MJXUIUtils show404WithDelegate:self];
                                  }];
}

#pragma mark MJXPatientsCellDelegate
-(void)addPatientsButtonPressed{
    MJXPatientsInGroupViewController *pVC = [[MJXPatientsInGroupViewController alloc] init];
    pVC.groupName = _patients.groupName;
    pVC.groupId = _patients.groupId;
    pVC.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:pVC animated:YES];
}
-(void)textFieldDidChangeDid:(UITextField *)textf{
    _patients.groupName = textf.text;
    
}
-(void)btnDelecatePressed{
    _patients.groupName = @"";
    [_tableView reloadData];
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
