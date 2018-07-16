//
//  MJXPatientGroupsViewController.m
//  XinSuiFang
//
//  Created by majinxing on 16/8/25.
//  Copyright © 2016年 majinxing. All rights reserved.
//

#import "MJXPatientGroupsViewController.h"
#import "MJXPatientsGroupView.h"
#import "MJXPatients.h"
#import "MJXPatientsCell.h"
#import "MJXVGroupManagementiewController.h"
#import "MJXRootViewController.h"
#import "MJXPatientsInfoViewController.h"

#import "FMDatabase.h"
#import "FMDBTool.h"
@interface MJXPatientGroupsViewController ()<UITableViewDataSource,UITableViewDelegate,MJXPatientsCellDelegate>
@property (nonatomic,strong) NSMutableArray *groupName;
@property (nonatomic,strong) NSMutableArray *dataGroup;
@property (nonatomic,strong) MJXPatientsGroupView *patientGroup;
@property (nonatomic,strong)FMDatabase *db;//数据库

@end

@implementation MJXPatientGroupsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    _groupName = [NSMutableArray arrayWithCapacity:10];
    _dataGroup = [NSMutableArray arrayWithCapacity:10];
    
    _patientGroup = [[MJXPatientsGroupView alloc] initWithFrame:CGRectMake(0,0, APPLICATION_WIDTH, APPLICATION_HEIGHT-64-44)];
    
    _patientGroup.tableView.delegate = self;
    _patientGroup.tableView.dataSource = self;
    _patientGroup.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _patientGroup.tableView.backgroundColor = [UIColor colorWithHexString:@"#f7f7f7"];
    [self.view addSubview:_patientGroup];
    
    //[self getData];
    
}
-(void)viewWillAppear:(BOOL)animated{
    if (_patientGroup.tableView!=nil
        ) {
        [self getData];
        [self queryTheDatabase];
    }
}
-(void)getData{
    AFHTTPRequestOperationManager *manger = [MJXClient setAFHTTPRequestOperationManagerSomeQuality];
    NSString *url = [NSString stringWithFormat:@"%@/group/showAllGroup",MJXBaseURL];
    [manger POST:url parameters:@{
                                  @"username":  [[MJXAppsettings sharedInstance] getUserPhone]                                             } success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                      if ([[responseObject objectForKey:@"statusCode"] isEqualToString:@"200"]) {
                                          
                                          // [_groupName removeAllObjects];
                                          //[_dataGroup removeAllObjects];
                                          NSMutableArray * data = [NSMutableArray arrayWithCapacity:10];
                                          NSArray *ary = [[NSArray alloc] init];
                                          ary = [responseObject objectForKey:@"result"];
                                          for (int i=0; i<ary.count; i++) {
                                              MJXPatients *p=[[MJXPatients alloc] init];
                                              p.groupName = [ary[i] objectForKey:@"gname"];
                                              p.groupId = [NSString stringWithFormat:@"%@",[ary[i] objectForKey:@"gid"]];
                                              p.gruopOpen = NO;
                                              [self getGroupPatients:p];
                                              [data setObject: p atIndexedSubscript:i];
                                              //[_groupName setObject:p atIndexedSubscript:i];
                                          }
                                          [self insertedIntoTheDatabaseDataGroupName:data];
                                          // [_patientGroup.tableView reloadData];
                                      }
                                  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                      // [_patientGroup.tableView reloadData];
                                      NSLog(@"失败");
                                  }];
}
-(void)getGroupPatients:(MJXPatients *)p{
    dispatch_async(dispatch_get_main_queue(), ^{
        AFHTTPRequestOperationManager *manger = [MJXClient setAFHTTPRequestOperationManagerSomeQuality];
        NSString *str = [NSString stringWithFormat:@"%@/patient/showPatientGroup",MJXBaseURL];
        [manger POST:str parameters:@{                                                                      @"username" :[[MJXAppsettings sharedInstance] getUserPhone],
                                                                                                            @"pageNum" :@"1",
                                                                                                            @"pageSize":@"200",
                                                                                                            @"group"  :p.groupName                                                                                                                                          } success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                                                                                                if ([[responseObject objectForKey:@"statusCode"] isEqualToString:@"200"]) {
                                                                                                                    NSMutableArray *ary = [[NSMutableArray alloc] init];
                                                                                                                    NSArray *array;
                                                                                                                    array=[responseObject objectForKey:@ "result"];
                                                                                                                    if(![array isEqual:@""]) {
                                                                                                                        for (int i=0; i<[[responseObject objectForKey:@"result"] count]; i++) {
                                                                                                                            MJXPatients *p = [[MJXPatients alloc] init];
                                                                                                                            [p savePatientInfo:[responseObject objectForKey:@"result"][i]];
                                                                                                                            [ary setObject:p atIndexedSubscript:i];
                                                                                                                        }
                                                                                                                        [self insertedIntoTheDatabaseDataGroupPatients:ary withTableName:p.groupName];
                                                                                                                    }
                                                                                                                }
                                                                                                                NSLog(@"成功");
                                                                                                            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                                                                                                NSLog(@"失败");
                                                                                                            }];
    });
    
}
-(void)dataReloadData{
    if (_dataGroup != nil) {
        [_dataGroup removeAllObjects];
    }
    _dataGroup = [NSMutableArray arrayWithCapacity:10];
    for (MJXPatients *p in _groupName) {
        [_dataGroup addObject:p];
        if (p.gruopOpen) {
            [_dataGroup addObjectsFromArray:p.patientsArray];
        }
    }
    [_patientGroup.tableView reloadData];
}
//判断字符串是否为空
-(BOOL)isBlankString:(NSString *)string
{
    if (string == nil)
    {
        return YES;
    }
    if (string == NULL)
    {
        return YES;
    }
    if ([string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length == 0)
    {
        return YES;
    }
    return NO;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark FMDB
//TABLE_NAME_GROUP_NAME
//创建数据库
- (void)createDB
{
    if (!_db)
    {
        _db = [FMDBTool createDBWithName:SQLITE_NAME];
    }
}
//往患者分组添加数据
-(void)insertedIntoTheDatabaseDataGroupName:(NSMutableArray *)ary{
    if ([_db open]) {
        [FMDBTool deleteTable:TABLE_NAME_GROUP_NAME with :_db];
    }
    [_db close];
    
    [self createTable];
    
    if ([_db open]) {
        for (int i = 0; i<ary.count; i++) {
            MJXPatients *p=[[MJXPatients alloc] init];
            p = ary[i];
            NSString * sql = [NSString stringWithFormat:@"insert into %@ (gid, gname, userId) values ('%@', '%@', '%@')",TABLE_NAME_GROUP_NAME,p.groupId,p.groupName,[[MJXAppsettings sharedInstance] getUserPhone]];
            BOOL rs = [FMDBTool insertWithDB:_db tableName:TABLE_NAME_GROUP_NAME withSqlStr:sql];
            if (rs) {
                
            }
        }
    }
    [_db close];
    
    [self queryTheDatabase];
}
-(void)insertedIntoTheDatabaseDataGroupPatients:(NSMutableArray *)ary withTableName:(NSString *)tableName{
    if ([_db open]) {
        [FMDBTool deleteTable:tableName withDB:_db];
    }
    [_db close];
    
    [self creatPatientGroupTable:tableName];
    
    if ([_db open]) {
        for (int i = 0; i<ary.count; i++) {
            MJXPatients *p=[[MJXPatients alloc] init];
            p = ary[i];
            NSString * sql = [NSString stringWithFormat:@"insert into %@ (age, heading,phone,sex,zhenduan,name,patientsId,userId) values ('%@', '%@', '%@','%@','%@','%@','%@','%@')",tableName,p.patientAge,p.patientHeadImageUrl,p.patientNumberPhone,p.patientSex,p.patientDiagnosis,p.patientsName,p.patientId,[[MJXAppsettings sharedInstance] getUserPhone]];
            BOOL rs = [FMDBTool insertWithDB:_db tableName:tableName withSqlStr:sql];
            if (rs) {
                
            }
        }
    }
    [_db close];
}
//查询本地组名数据库
-(void)queryTheDatabase{
    [_dataGroup removeAllObjects];
    [_groupName removeAllObjects];
    [self createDB];
    [self createTable];
    if ([_db open]) {
        FMResultSet * rs1 = [FMDBTool queryWithDB:_db tableName:TABLE_NAME_GROUP_NAME];
        
        while (rs1.next) {
            MJXPatients *p=[[MJXPatients alloc] init];
            p.groupName = [rs1 stringForColumn:@"gname"];
            p.groupId = [rs1 stringForColumn:@"gid"];
            p.gruopOpen = NO;
            [_dataGroup addObject:p];
            [_groupName addObject:p];
        }
        for (int i = 0; i<_dataGroup.count; i++) {
            MJXPatients * p =_dataGroup[i];
            //[self getGroupPatients:p];
            [self querGruopPatientsFromTable:p];
        }
        [_patientGroup.tableView reloadData];
    }
    [_db close];
}
//查询每个分组的成员
-(void)querGruopPatientsFromTable:(MJXPatients *)p{
    [self createDB];
    [self creatPatientGroupTable:p.groupName];
    if ([_db open]) {
        FMResultSet * rs = [FMDBTool queryWithDB:_db tableName:p.groupName];
        NSMutableArray *ary = [[NSMutableArray alloc] init];
        while (rs.next) {
            MJXPatients * p1 =[[MJXPatients alloc] init];
            p1.patientsName = [rs stringForColumn:@"name"];
            p1.patientHeadImageUrl = [rs stringForColumn:@"heading"];
            p1.patientSex = [rs stringForColumn:@"sex"];
            p1.patientDiagnosis = [rs stringForColumn:@"zhenduan"];
            p1.patientAge = [rs stringForColumn:@"age"];
            p1.patientId = [rs stringForColumn:@"patientsId"];
            p1.patientNumberPhone = [rs stringForColumn:@"phone"];
            //p1.attention = [NSString stringWithFormat:@"%@",[rs stringForColumn:@"attention"]];
            p1.gruopOpen = NO;
            [ary addObject:p1];
        }
        p.patientsArray = ary;
    }
    [_db close];
}
-(void)creatPatientGroupTable:(NSString *)tableName{
    if ([_db open]) {
        BOOL result = [FMDBTool createTableWithDB:_db tableName:tableName
                                       parameters:@{
                                                    @"address" : @"text",
                                                    @"age" : @"text",
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
                                                    @"userId" : @"text",
                                                    @"targetId" : @"text",
                                                    @"zhenduan" : @"text"
                                                    }];
        if (result)
        {
            NSLog(@"建表成功");
        }
        else
        {
            NSLog(@"建表失败");
        }
    }
    [_db close];
}
//创建表
- (void)createTable
{
    if ([_db open])
    {
        BOOL result = [FMDBTool createTableWithDB:_db tableName:TABLE_NAME_GROUP_NAME
                                       parameters:@{
                                                    @"docid" : @"text",
                                                    @"gid" : @"text",
                                                    @"gname" : @"text",
                                                    @"userId" : @"text"
                                                    }];
        if (result)
        {
            NSLog(@"建表成功");
        }
        else
        {
            NSLog(@"建表失败");
        }
    }
    [_db close];
    
}
#pragma mark UITableViewdelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ([_dataGroup count]>0) {
        return _dataGroup.count+1;
    }
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MJXPatientsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!cell) {
        cell=[[MJXPatientsCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    }
    if (indexPath.row==0) {
        [cell setGroupManagement];
        cell.delegate = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }else{
        if (_groupName.count>0&&(indexPath.row<=_dataGroup.count)&&indexPath.row>=1) {
            [cell setInitializeDataWithPatient:_dataGroup[indexPath.row-1]];
        }
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row==0) {
        [self groupManagementPressed];
    }else{
        
        MJXPatients *p = _dataGroup[indexPath.row-1];
        
        if ([self isBlankString:p.groupName]) {
            MJXPatientsInfoViewController *patientsInfo=[[MJXPatientsInfoViewController alloc] init];
            patientsInfo.patients=p;
            patientsInfo.hidesBottomBarWhenPushed = YES;
            
            [self.navigationController pushViewController:patientsInfo animated:YES];
        }else{
            if (!p.gruopOpen) {
                p.gruopOpen = !p.gruopOpen;
                [self dataReloadData];
            }
            else{
                p.gruopOpen = !p.gruopOpen;
                [self dataReloadData];
            }
        }
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return 70;
    }
    return 60;
}
#pragma mark MJXPatientsCellDelegate
-(void)groupManagementPressed{
    MJXVGroupManagementiewController *groupM = [[MJXVGroupManagementiewController alloc] init];
    groupM.array =  [NSMutableArray arrayWithArray:_groupName];
    groupM.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:groupM animated:YES];
    
}

@end
