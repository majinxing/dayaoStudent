//
//  MJXAllPatientsViewController.m
//  XinSuiFang
//
//  Created by majinxing on 16/8/25.
//  Copyright © 2016年 majinxing. All rights reserved.
//

#import "MJXAllPatientsViewController.h"
#import "MJXAllPatient.h"
#import "MJXPatientsCell.h"
#import "MJXPatients.h"
#import "MJXNewAddPatientsViewController.h"
#import "MJXRootViewController.h"
#import "MJXPatientsInfoViewController.h"
#import "MJXClient.h"
#import "MJRefresh.h"
#import "PinYinFirstLetter.h"

#import "FMDatabase.h"
#import "FMDBTool.h"

@interface MJXAllPatientsViewController ()<UITableViewDelegate,UITableViewDataSource,MJXPatientsCellDelegate,MJXAllPatientViewDelegate>

@property (nonatomic,strong) MJXAllPatient *allPatient;
@property (nonatomic,strong)NSMutableArray *allPatientInfoArray;
@property (nonatomic,strong)NSMutableArray *patientModelArray;
@property (nonatomic,strong)FMDatabase *db;//数据库

@property (nonatomic,strong)NSMutableDictionary * dictP;
@property (nonatomic,strong)NSMutableArray * keys;//存首字母
@property (nonatomic,assign) int temp;
@end

@implementation MJXAllPatientsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _allPatientInfoArray = [NSMutableArray arrayWithCapacity:10];
    _patientModelArray = [NSMutableArray arrayWithCapacity:10];
    _temp = 0;
    
    _dictP = [[NSMutableDictionary alloc] init];
    _keys = [NSMutableArray arrayWithCapacity:10];
    //获取数据
    [self adddata];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    _allPatient = [[MJXAllPatient alloc] initWithFrame:CGRectMake(0,0, APPLICATION_WIDTH, APPLICATION_HEIGHT-64-44)];
    _allPatient.tableView.delegate = self;
    _allPatient.tableView.dataSource = self;
    _allPatient.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _allPatient.tableView.backgroundColor = [UIColor colorWithHexString:@"#f7f7f7"];
    
    _allPatient.delegate =self;
    
    [self.view addSubview:_allPatient];
}
-(void)viewWillAppear:(BOOL)animated{
    [self getAllPatientInfo];
    [self adddata];
}
-(void)adddata{
    NSString *url=[NSString stringWithFormat:@"%@%@",MJXBaseURL,@"/patient/showAllPatient"];
    //    http://120.27.29.242:8080/xsfServer/app
    //    192.168.31.153
    AFHTTPRequestOperationManager *manger = [MJXClient setAFHTTPRequestOperationManagerSomeQuality];
    [manger POST:url parameters:@{
                                  @"username" : [[MJXAppsettings sharedInstance] getUserPhone] ,
                                  @"pageNum" : @"1",
                                  @"pageSize":@"200",
                                  } success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                      if ([[responseObject objectForKey:@"statusCode"] isEqualToString:@"200"]) {
                                          id data = [responseObject objectForKey:@"result"];
                                          if (![data isEqual:@""]) {                                          _allPatientInfoArray=[responseObject objectForKey:@"result"];
                                                [self savePatientWithArray:_allPatientInfoArray];                                        [self saveALLPatientsInfoWithArray:_allPatientInfoArray];
                                              [self saveToDBWithAlllPatients:_allPatientInfoArray];
                                          }
                                      }
                                      [_allPatient.tableView headerEndRefreshing];
                                      
                                  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                      NSLog(@"失败 %@",operation);
                                      [_allPatient.tableView headerEndRefreshing];
                                  }];
}
-(void)savePatientWithArray:(NSMutableArray *)array{
    [self sortWithArray:array];
}
//数组排序
-(void)sortWithArray:(NSMutableArray *)array{
    //创建26个数组
    for (char character = 'a'; character <= 'z'; character++)
    {
        NSMutableArray *sectionArray = [[NSMutableArray alloc] init];
        [self.dictP setValue:sectionArray forKey:[NSString stringWithFormat:@"%c",character]];
        [self.keys addObject:[NSString stringWithFormat:@"%c",character]];
    }
    NSMutableArray *sectionArray = [[NSMutableArray alloc] init];
    [self.dictP setValue:sectionArray forKey:[NSString stringWithFormat:@"zz"]];
    [self.keys addObject:[NSString stringWithFormat:@"zz"]];
    
    //将数据按拼音首字母分别放入字典中的26个数组中
    for (NSDictionary *schoolDic in array)
    {
        id schoolName = [schoolDic objectForKey:@"name"];
        if (schoolName!=nil&&![schoolName isEqual:@"<null>"]&&![schoolName isKindOfClass:[NSNull class]]) {
            
            NSString *schoolKey = [PinYinFirstLetter pinyinFirstLetter:[schoolName characterAtIndex:0]];
            if ([schoolKey isEqualToString:@"#"]) {
                NSRange range = NSMakeRange(0,1);
                schoolKey = [schoolName substringWithRange:range];
            }
            if ([schoolKey compare:@"A"]>=0&&[schoolKey compare:@"Z"]<=0) {
                schoolKey = [schoolKey lowercaseString];
            }
            
            if ([schoolKey compare:@"z"]<=0&&[schoolKey compare:@"a"]>=0) {
                
                NSMutableArray *array = [self.dictP objectForKey:schoolKey];
                MJXPatients *patient=[[MJXPatients alloc] init];
                [patient savePatientInfo:schoolDic];
                [array addObject:patient];
            }else{
                NSMutableArray *array = [self.dictP objectForKey:@"zz"];
                MJXPatients *patient=[[MJXPatients alloc] init];
                [patient savePatientInfo:schoolDic];
                [array addObject:patient];
            }
            
        }
    }
    //删除空白数组
    for (char character = 'a'; character <= 'z'; character++)
    {
        NSString *key = [NSString stringWithFormat:@"%c",character];
        NSArray *array = [self.dictP objectForKey:key];
        if (array.count == 0)
        {
            [self.dictP removeObjectForKey:key];
        }
    }
    
    self.keys = [NSMutableArray arrayWithArray:[self.dictP.allKeys sortedArrayUsingSelector:@selector(compare:)]];
    [_allPatient.tableView reloadData];
    //    NSLog(@"%s",__func__);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark FMDB
//写入数据库
-(void)saveToDBWithAlllPatients:(NSMutableArray *)ary{
    [self createDB];
    if ([_db open]) {
        [FMDBTool deleteTable:TABLE_NAME_PATIENTS withDB:_db];
    }
    [_db close];
    [self createTable];
    if ([_db open]) {
        for (int i = 0; i<ary.count; i++) {
            NSDictionary * dict = ary[i];
            MJXPatients *patient=[[MJXPatients alloc] init];
            [patient savePatientInfo:dict];
            NSString * sql = [NSString stringWithFormat:@"insert into %@ (patientsId,heading,phone,sex,name,age,zhenduan,targetId,userId) values ('%@','%@','%@','%@','%@','%@','%@','%@','%@')",TABLE_NAME_PATIENTS,patient.patientId,patient.patientHeadImageUrl,patient.patientNumberPhone,patient.patientSex,patient.patientsName,patient.patientAge,patient.patientDiagnosis,patient.targetId,[[MJXAppsettings sharedInstance] getUserPhone]];
            [FMDBTool insertWithDB:_db tableName:TABLE_NAME_PATIENTS withSqlStr:sql];
        }
    }
    [_db close];
   
    
}
//创建数据库
- (void)createDB
{
    if (!_db)
    {
        _db = [FMDBTool createDBWithName:SQLITE_NAME];
    }
}
//创建表
- (void)createTable
{
    if ([_db open])
    {
        BOOL result = [FMDBTool createTableWithDB:_db tableName:TABLE_NAME_PATIENTS
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
                                                    @"targetId" : @"text",
                                                    @"userId" : @"text",
                                                    @"zhenduan" : @"text",
                                                    @"age" : @"text"
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
-(void)saveALLPatientsInfoWithArray:(NSMutableArray *)ary{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSMutableDictionary * patientsDict = [[NSMutableDictionary alloc] init];
        
        [patientsDict setObject:ary forKey:@"patientAllInfo"];
        
        NSData *resultData = [NSJSONSerialization dataWithJSONObject:patientsDict options:NSJSONWritingPrettyPrinted error:nil];
        
        NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
        //缓存的路径
        NSString *draftPath = [docPath stringByAppendingPathComponent:[NSString stringWithFormat:@"Draft/userId%@",[[MJXAppsettings sharedInstance] getUserPhone] ]];
        
        //判断文件夹是否存在，若不存在创建路径中的文件夹
        if (![[NSFileManager defaultManager] fileExistsAtPath:draftPath])
        {
            [[NSFileManager defaultManager] createDirectoryAtPath:draftPath withIntermediateDirectories:YES attributes:nil error:nil];
        }else{
            
            [[NSFileManager defaultManager] removeItemAtPath:draftPath error:nil];
            [[NSFileManager defaultManager] createDirectoryAtPath:draftPath withIntermediateDirectories:YES attributes:nil error:nil];
        }
        NSString *imagePath = [draftPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",[[MJXAppsettings sharedInstance] getUserPhone]]];
        BOOL result = [resultData writeToFile:imagePath atomically:YES];
    });
}
-(void)getAllPatientInfo{
    NSArray *docPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *docPath = [docPaths lastObject];
    //路径
    NSString *draftPath = [docPath stringByAppendingPathComponent:[NSString stringWithFormat:@"Draft/userId%@",[[MJXAppsettings sharedInstance] getUserPhone]]];
    NSString *imagePath = [draftPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",[[MJXAppsettings sharedInstance] getUserPhone]]];
    
    NSData *data = [NSData dataWithContentsOfFile:imagePath];
    if (data==nil) {
        return;
    }
    NSDictionary * resultDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    NSMutableArray * ary = [NSMutableArray arrayWithCapacity:10];
    ary = [resultDic objectForKey:@"patientAllInfo"];
    _allPatientInfoArray = ary;
    [self savePatientWithArray:_allPatientInfoArray];
}
#pragma mark MJXAllPatientViewDelegate
-(void)allPatientHeaderRereshing{
    [self adddata];
    [_allPatient.tableView reloadData];
}
#pragma mark UITableViewdelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (_keys.count>0) {
        return _keys.count+1;
    }
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==0) {
        return 1;
    }else if(_keys.count>0){
        NSString * key = [_keys objectAtIndex:section-1];
        NSArray *ary = [_dictP objectForKey:key];
        return ary.count;
    }
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        return 20;
    }else
        return 20;
    return 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0;
}
-(void)tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section{
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MJXPatientsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    if (!cell) {
        cell=[[MJXPatientsCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    }
    if (indexPath.section==0) {
        [cell setAddPatientButton];
    }else{
        NSString * key = [_keys objectAtIndex:indexPath.section-1];
        NSArray *ary = [_dictP objectForKey:key];
        
        [cell setInitializeDataWithPatient:ary[indexPath.row]];
    }
    cell.delegate=self;
    return cell;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 65;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section==0) {
        [self seeAddNewPatientsButtonPressed];
        return;
    }else{
        MJXPatientsInfoViewController *patientsInfo=[[MJXPatientsInfoViewController alloc] init];
        NSString * key = [_keys objectAtIndex:indexPath.section-1];
        NSArray *ary = [_dictP objectForKey:key];
        
        patientsInfo.patients=ary[indexPath.row];
        patientsInfo.hidesBottomBarWhenPushed = YES;
        
        [self.navigationController pushViewController:patientsInfo animated:YES];
    }
    
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, APPLICATION_WIDTH,20)];
        view.backgroundColor = [UIColor colorWithHexString:@"#f7f7f7"];
        return view;
    }
    if (section != 0) {
        UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, APPLICATION_WIDTH,20)];
        view.backgroundColor = [UIColor colorWithHexString:@"#f7f7f7"];
        UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 30, 15)];
        if (_keys.count>0) {
            
        }else{
            return nil;
        }
        label.text = _keys[section-1];
        if (label.text.length>1) {
            label.text = @"#";
        }
        label.textColor = [UIColor colorWithHexString:@"#777777"];
        label.font = [UIFont systemFontOfSize:15];
        [view addSubview:label];
        return view;
    }
    return nil;
}
//快捷索引 返回的是一个数组
-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView{
    
    NSMutableArray *array=[[NSMutableArray alloc]initWithCapacity:10];
    if (_keys.count>0) {
        
    }else{
        return nil;
    }
    for (int i=0; i<_keys.count; i++) {
        if (_keys.count == i+1) {
            [array addObject:[NSString stringWithFormat:@"%@",[@"#" uppercaseString]]];
        }else
            [array addObject:[NSString stringWithFormat:@"%@",[_keys[i] uppercaseString]]];
    }
    
    return array;
    
}
////每一个分区的名字
//-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
//
////    if (section>=0) {
////
////    }else return nil;
////
////    if (_keys.count>0) {
////
////    }else{
////        return nil;
////    }
//    if (section == 0||_keys.count<section) {
//        return [@"" uppercaseString];
//    }
//
//    NSString * key1=[_keys objectAtIndex:section-1];
//    if (_keys.count == (section)) {
//        key1 = @"#";
//    }
//    return  [key1 uppercaseString];
//
//}
-(NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index{
    return index+1;
}
#pragma mark MJXPatiensCellDelegate
-(void)seeAddNewPatientsButtonPressed{
    MJXNewAddPatientsViewController *newAddPatient=[[MJXNewAddPatientsViewController alloc] init];
    newAddPatient.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:newAddPatient animated:YES];
    
}


@end
