//
//  MJXHasBeenCompletedViewController.m
//  XinSuiFang
//
//  Created by majinxing on 16/10/11.
//  Copyright © 2016年 majinxing. All rights reserved.
//

#import "MJXHasBeenCompletedViewController.h"
#import "MJXPatientsNodeInfoTableViewCell.h"
#import "MJXPatients.h"
#import "MJRefresh.h"
#import "MJXReviewTheResultsViewController.h"
#import "MJXReviewTheResultsViewController.h"

@interface MJXHasBeenCompletedViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView * tableView;
@property (nonatomic,strong)NSMutableArray * patientsArray;//患者数组
@end

@implementation MJXHasBeenCompletedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    _patientsArray = [NSMutableArray arrayWithCapacity:10];
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, APPLICATION_WIDTH, APPLICATION_HEIGHT-64-40-40) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = [UIColor colorWithHexString:@"#f7f7f7"];
    [self.view addSubview:_tableView];
    //加载更多数据
    __weak  typeof(self)vc = self;
    [_tableView addHeaderWithCallback:^{
        [vc headerRereshing];
    }];
    //    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    //    btn.frame = CGRectMake(100, 200, 100, 100);
    //    [btn addTarget:self action:@selector(btn) forControlEvents:UIControlEventTouchUpInside];
    //    btn.backgroundColor = [UIColor greenColor];
    //    [self.view addSubview:btn];
    //[self getData];
    // Do any additional setup after loading the view.
}
-(void)btn{
    MJXReviewTheResultsViewController * vc = [[MJXReviewTheResultsViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)headerRereshing{
    [self getData];
}
-(void)getData{
    [_patientsArray removeAllObjects];
    AFHTTPRequestOperationManager *manger = [MJXClient setAFHTTPRequestOperationManagerSomeQuality];
    NSString * url = [NSString stringWithFormat:@"%@/followup/findNodesByStatus",MJXBaseURL];
    [manger POST:url parameters:@{
                                  @"username":[[MJXAppsettings sharedInstance] getUserPhone],
                                  @"nodeStatus" : @"110"
                                  } success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                      id data = [responseObject objectForKey:@"result"];
                                      if (![data isEqual:@""]) {
                                          NSArray * ary = [responseObject objectForKey:@"result"];
                                          for (int  i = 0; i<ary.count; i++) {
                                              MJXPatients * one = [[MJXPatients alloc] init];
                                              [one saveNodeInfo:ary[i]];
                                              [_patientsArray addObject:one];
                                          }
                                      }
                                      [_tableView headerEndRefreshing];   [_tableView reloadData];
                                  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                      [_tableView headerEndRefreshing];
                                      [_tableView reloadData];
                                      NSLog(@"0");
                                  }];
    
}
-(void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    if (_tableView) {
        [self getData];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark UITableViewdelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (_patientsArray.count>0&&_patientsArray!=nil) {
        return _patientsArray.count;
    }
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MJXPatientsNodeInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!cell) {
        cell=[[MJXPatientsNodeInfoTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    }
    if (_patientsArray.count>0&&_patientsArray!=nil) {
        MJXPatients * one = _patientsArray[indexPath.row];
        [cell addPatientsInfoWithPatiens:one];
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    MJXReviewTheResultsViewController * vc = [[MJXReviewTheResultsViewController alloc] init];
    MJXPatients * one = _patientsArray[indexPath.row];
    vc.hidesBottomBarWhenPushed = YES;
    vc.patients = one;
    [self.navigationController pushViewController:vc animated:YES];
    
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
