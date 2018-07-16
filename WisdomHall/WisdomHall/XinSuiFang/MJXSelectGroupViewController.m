//
//  MJXSelectGroupViewController.m
//  XinSuiFang
//
//  Created by majinxing on 16/11/22.
//  Copyright © 2016年 majinxing. All rights reserved.
//

#import "MJXSelectGroupViewController.h"
#import "MJXGroup.h"
#import "MJXSelectGroupTableViewCell.h"

@interface MJXSelectGroupViewController ()<UITableViewDelegate,UITableViewDataSource,MJXSelectGroupTableViewCellDelegate>
@property (nonatomic,strong) UITableView * tableView;
@property (nonatomic,strong) NSMutableArray * groupNameArray;
@property (nonatomic,strong) NSMutableArray * selectGroupName;
@end

@implementation MJXSelectGroupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    _groupNameArray = [NSMutableArray arrayWithCapacity:10];
    _selectGroupName = [NSMutableArray arrayWithCapacity:10];
    [MJXUIUtils addNavigationWithView:self.view withTitle:@"选择分组"];
    [self addBackButton];
    [self addTableView];
    [self getData];
    // Do any additional setup after loading the view.
}
-(void)getData{
    AFHTTPRequestOperationManager *manger = [MJXClient setAFHTTPRequestOperationManagerSomeQuality];
    NSString * url = [NSString stringWithFormat:@"%@/group/showAllGroup",MJXBaseURL];
    [manger POST:url parameters:@{
                                  @"username" : [[MJXAppsettings sharedInstance] getUserPhone]
                                  } success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                      if ([[responseObject objectForKey:@"statusCode"] isEqualToString:@"200"]) {
                                          NSArray * ary = [[NSArray alloc] init];
                                          ary = [responseObject objectForKey:@"result"];
                                          for (int i = 0; i<ary.count; i++) {
                                              MJXGroup * g = [[MJXGroup alloc] init];
                                              [g saveGroup:ary[i]];
                                              [_groupNameArray addObject:g];
                                          }
                                          [_tableView reloadData];
                                      }
                                  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                      [MJXUIUtils show404WithDelegate:self];
                                  }];
}
-(void)addTableView{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, APPLICATION_WIDTH, APPLICATION_HEIGHT-64) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = [UIColor colorWithHexString:@"#f7f7f7"];
    [self.view addSubview:_tableView];
}
-(void)addBackButton{
    UIImageView *backImage=[[UIImageView alloc] initWithFrame:CGRectMake(20, 20+15, 7, 15)];
    backImage.image=[UIImage imageNamed:@"return"];
    [self.view addSubview:backImage];
    UIButton *back=[UIButton buttonWithType:UIButtonTypeCustom];
    back.frame=CGRectMake(0,20,60, 44);
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
    NSString * url = [NSString stringWithFormat:@"%@/group/addPatientToGroup",MJXBaseURL];
    for (int i = 0; i<_selectGroupName.count; i++) {
        NSString * str = [[NSString alloc] init];
        str = _selectGroupName[i];
        [manger POST:url parameters:@{
                                      @"username" : [[MJXAppsettings sharedInstance] getUserPhone],
                                      @"groupName" : str,
                                      @"patientId" :_patients.patientId
                                          } success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                              
                                          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                              
                                          }];
    }
    [self back];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark MJXSelectGroupTableViewCellDelegate
-(void)selectBtnPressed:(UIButton *)btn{
    MJXGroup * g = _groupNameArray[btn.tag - 1];
    int n =0;
    for (int i = 0; i<_selectGroupName.count; i++) {
        NSString * str = _selectGroupName[i];
        if ([str isEqualToString:g.gName]) {
            [_selectGroupName removeObjectAtIndex:i];
            n=1;
            break;
        }
    }
    if (n==0) {
        [_selectGroupName addObject:g.gName];
    }
}
#pragma mark UITableViewdelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (_groupNameArray!=nil&&_groupNameArray.count>0) {
        return _groupNameArray.count;
    }
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MJXSelectGroupTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!cell) {
        cell=[[MJXSelectGroupTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    }
    MJXGroup * g = _groupNameArray[indexPath.row];
    [cell selectGroup:g withTag:(int)indexPath.row+1];
    cell.delegate = self;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
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
