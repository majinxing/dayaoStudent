//
//  MJXNewAddPatientsViewController.m
//  XinSuiFang
//
//  Created by majinxing on 16/9/2.
//  Copyright © 2016年 majinxing. All rights reserved.
//

#import "MJXNewAddPatientsViewController.h"
#import "MJXPatients.h"
#import "MJXPatientsCell.h"
#import "MJXAddPatientsViewController.h"
#import "MJXRootViewController.h"
@interface MJXNewAddPatientsViewController ()<UITableViewDelegate,UITableViewDataSource,MJXPatientsCellDelegate>
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *data;
@property (nonatomic,strong) NSString *titlel;
@property (nonatomic,strong)NSMutableArray *ary;
@end

@implementation MJXNewAddPatientsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [MJXUIUtils addNavigationWithView:self.view withTitle:@"新的患者"];
    [self addBackButton];
    _data=[NSMutableArray arrayWithCapacity:20];
    
    self.tableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 64, APPLICATION_WIDTH, APPLICATION_HEIGHT-64) style:UITableViewStylePlain];
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    //self.tableView.contentInset=UIEdgeInsetsMake(45, 0, 0, 0);
    [self.view addSubview:self.tableView];
    //获取数据
    [self getData];
    //[self addSearchButton];
    // Do any additional setup after loading the view from its nib.
}
-(void)addSearchButton{
    UIButton *search=[UIButton buttonWithType:UIButtonTypeCustom];
    search.frame=CGRectMake(0,64,APPLICATION_WIDTH, 45);
    search.backgroundColor=[UIColor greenColor];
    [search addTarget:self action:@selector(search) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:search];
}
-(void)search{
  
}
-(void)addBackButton{
    UIImageView *backImage=[[UIImageView alloc] initWithFrame:CGRectMake(20, 20+15, 7, 15)];
    backImage.image=[UIImage imageNamed:@"return"];
    [self.view addSubview:backImage];
    UIButton *back=[UIButton buttonWithType:UIButtonTypeCustom];
    back.frame=CGRectMake(0,20,60, 44);
    [back addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:back];
    
    UIImageView *btn=[[UIImageView alloc] initWithFrame:CGRectMake(APPLICATION_WIDTH-40, 35, 20, 20)];
    btn.image=[UIImage imageNamed:@"addP"];
    [self.view addSubview:btn];
    UIButton *save=[UIButton buttonWithType:UIButtonTypeCustom];
    save.frame=CGRectMake(APPLICATION_WIDTH-70,20,60, 44);
//    [save setTitle:@"保 存" forState:UIControlStateNormal];
    [save setTitleColor:[UIColor colorWithHexString:@"#01aeff"] forState:UIControlStateNormal];
    save.titleLabel.font=[UIFont systemFontOfSize:15];
    [save addTarget:self action:@selector(save) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:save];
}
-(void)save{
    MJXAddPatientsViewController *addPatientVC=[[MJXAddPatientsViewController alloc] init];
    addPatientVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:addPatientVC animated:YES];
}
-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)getData{
     NSString *url=[NSString stringWithFormat:@"%@%@",MJXBaseURL,@"/patient/showNewPatient"];
    AFHTTPRequestOperationManager *manger = [MJXClient setAFHTTPRequestOperationManagerSomeQuality];
    [manger POST:url parameters:@{
                                  @"username" :[[MJXAppsettings sharedInstance] getUserPhone],
                                  @"pageNum" : @"1",
                                  @"pageSize" : @"20"
                                  } success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                      id data = [responseObject objectForKey:@"result"];
                                      if (![data isEqual:@""]) {
                                          NSMutableArray *allPatientInfoArray=[NSMutableArray arrayWithCapacity:10];
                                          allPatientInfoArray=[responseObject objectForKey:@"result"];
                                          [self savePatientWithArray:allPatientInfoArray];
                                      }
                                      NSLog(@"成功");
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         NSLog(@"失败");

     }];

}
-(void)savePatientWithArray:(NSMutableArray *)array{
    
    for (int i=0; i<[array count]; i++) {
        MJXPatients *patient=[[MJXPatients alloc] init];
        [patient savePatientInfo:array[i]];
        [_data setObject:patient atIndexedSubscript:i];
    }
    [self.tableView reloadData];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark UITableViewdelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _data.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 65;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MJXPatientsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!cell) {
        cell=[[MJXPatientsCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    }
    if (!([_data count]<=0)) {
         [cell setInitializeDataWithPatient:_data[indexPath.row]];
        cell.delegate = self;
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
#pragma mark MJXPatientsCellDelegate
-(void)attentionButtonPressed:(UIButton *)btn{
    AFHTTPRequestOperationManager *manger = [MJXClient setAFHTTPRequestOperationManagerSomeQuality];
    NSString *url=[NSString stringWithFormat:@"%@%@",MJXBaseURL,@"/patient/updateDoctorIsGuanzhu"];
    [manger POST:url parameters:@{
                                  @"username":[[MJXAppsettings sharedInstance] getUserPhone],
                                  @"patientId":[NSString stringWithFormat:@"%d",(int)btn.tag-1],
                                  @"attention" : @"1"
                                 } success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                     [self getData];
                                 } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                     
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
