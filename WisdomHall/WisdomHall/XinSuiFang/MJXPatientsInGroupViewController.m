//
//  MJXPatientsInGroupViewController.m
//  XinSuiFang
//
//  Created by majinxing on 16/9/11.
//  Copyright © 2016年 majinxing. All rights reserved.
//

#import "MJXPatientsInGroupViewController.h"
#import "MJXRootViewController.h"
#import "MJXPatientsCell.h"
#import "MJXPatients.h"
#import "FMDatabase.h"
#import "FMDBTool.h"

@interface MJXPatientsInGroupViewController ()<UITableViewDelegate,UITableViewDataSource,MJXPatientsCellDelegate>
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)NSMutableArray *dataArray;
@property (nonatomic,strong)NSMutableArray *addPatientsId;
@property (nonatomic,strong)NSMutableArray *allPatientsArray;
@property (nonatomic,strong)FMDatabase *db;//数据库

@end

@implementation MJXPatientsInGroupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _dataArray = [NSMutableArray arrayWithCapacity:10];
    _addPatientsId = [NSMutableArray arrayWithCapacity:10];
    _db = [FMDBTool createDBWithName:SQLITE_NAME];
    _allPatientsArray = [NSMutableArray arrayWithCapacity:10];
    [MJXUIUtils addNavigationWithView:self.view withTitle:@"选择患者"];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self addBackButton];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, APPLICATION_WIDTH, APPLICATION_HEIGHT-64) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    [self.view addSubview:_tableView];
    [self getData];
    
    
    
}
-(void)getData{
    AFHTTPRequestOperationManager *manger = [MJXClient setAFHTTPRequestOperationManagerSomeQuality];
    NSString *url = [NSString stringWithFormat:@"%@/patient/isBelongToGroup",MJXBaseURL];
    
    [manger POST:url parameters:@{
                                  @"username" :[[MJXAppsettings sharedInstance] getUserPhone],
                                  @"groupId" : _groupId
                                  } success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                      NSLog(@"0");
                                      
                                      NSMutableArray *ary = [NSMutableArray arrayWithCapacity:10];
                                      id data = [responseObject objectForKey:@"result"];
                                      if (![data isEqual:@""]) {
                                          ary = [responseObject objectForKey:@"result"];
                                      }
                                      
                                      
                                      [self getArray:ary];
                                      [_tableView reloadData];
                                  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                      NSLog(@"1");
                                      
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
    
    AFHTTPRequestOperationManager *manger = [MJXClient setAFHTTPRequestOperationManagerSomeQuality];
    NSString *url = [NSString stringWithFormat:@"%@/group/addPatientToGroup",MJXBaseURL];
    if ([_db open]) {
        [self insertedIntoTheDatabaseDataGroupPatients:_allPatientsArray withTableName:_groupName];
    }
    [_db close];
    for (int i=0; i<_addPatientsId.count; i++) {
        [manger POST:url parameters:@{
                                      @"username" :[[MJXAppsettings sharedInstance] getUserPhone],
                                      @"groupName" : _groupName,
                                      @"patientId":_addPatientsId[i]
                                      } success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                          if ([[responseObject objectForKey:@"statusCode"] isEqualToString:@"200"]) {
                                              if (i==_addPatientsId.count-1) {
                                                  [self back];
                                                  
                                              }
                                          }
                                      } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                          
                                      }];
    }
}
-(void)getArray:(NSMutableArray *)ary{
    for (int i=0; i<ary.count; i++) {
        MJXPatients *p =[[MJXPatients alloc] init];
        [p savePatientInfoWithStatus:ary[i]];
        [_dataArray setObject:p atIndexedSubscript:i];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark FMDB
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
            NSString * sql = [NSString stringWithFormat:@"insert into %@ (age, heading,sex,name,patientsId,userId) values ('%@', '%@','%@','%@','%@','%@')" tableName,p.patientAge,p.patientHeadImageUrl,p.patientSex,p.patientsName,p.patientId,[[MJXAppsettings sharedInstance] getUserPhone]];
            BOOL rs = [FMDBTool insertWithDB:_db tableName:tableName withSqlStr:sql];
            if (rs) {
                
            }
        }
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
#pragma mark UITableViewdelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (_dataArray.count>0) {
        return _dataArray.count;
    }
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MJXPatientsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!cell) {
        cell=[[MJXPatientsCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    }
    MJXPatients *p =_dataArray[indexPath.row];
    p.tag = [NSString stringWithFormat:@"%ld",indexPath.row];
    [cell setInitializeDataWithPatient:p];
    cell.delegate = self;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}
#pragma mark MJXPatientsCellDelegate
-(void)patientsInGroupButtonPressed:(UIButton *)btn{
    MJXPatients *p =_dataArray[btn.tag-1];
    if ([p.status isEqualToString:@"1"]) {
        p.status = @"0";
        [_addPatientsId addObject:p.patientId];
        [_allPatientsArray addObject:p];
        [_tableView reloadData];
    }else{
        for (int i=0; i<_addPatientsId.count; i++) {
            NSString *str =_addPatientsId[i];
            if ([p.patientId isEqual:str]) {
                p.status = @"1";
                [_addPatientsId removeObjectAtIndex:i];
                [_allPatientsArray removeObjectAtIndex:i];
                [_tableView reloadData];
            }
        }
    }
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
