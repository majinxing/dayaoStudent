//
//  MJXTemplatemanagementViewController.m
//  XinSuiFang
//
//  Created by majinxing on 16/10/9.
//  Copyright © 2016年 majinxing. All rights reserved.
//

#import "MJXTemplatemanagementViewController.h"
#import "MJXTemplate.h"
@interface MJXTemplatemanagementViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)NSMutableArray *templateArray;
@property (nonatomic,strong)UITableView *tableView;
@end

@implementation MJXTemplatemanagementViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    _templateArray = [NSMutableArray arrayWithCapacity:10];
    [MJXUIUtils addNavigationWithView:self.view withTitle:@"模板管理"];
    [self addBackButton];
    [self getData];
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, APPLICATION_WIDTH, APPLICATION_HEIGHT-64) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    // Do any additional setup after loading the view.
}
-(void)getData{
    [_templateArray removeAllObjects];
    AFHTTPRequestOperationManager *manger = [MJXClient setAFHTTPRequestOperationManagerSomeQuality];
    NSString *url = [NSString stringWithFormat:@"%@/followup/findMyTemplate",MJXBaseURL];
    [manger POST:url parameters:@{
                                   @"username" :[[MJXAppsettings sharedInstance] getUserPhone]
                                 } success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                     id data = [responseObject objectForKey:@"result"];
                                     if (![data isEqual:@""]) {
                                         NSArray *ary = [responseObject objectForKey:@"result"];
                                         for (int i =0; i<ary.count; i++) {
                                             MJXTemplate * one = [[MJXTemplate alloc] init];
                                             one.templateId = [NSString stringWithFormat:@"%@",[ary[i] objectForKey:@"followupId"]];
                                             one.templateName = [ary[i] objectForKey:@"name"];
                                             [_templateArray addObject:one];
                                         }
                                     }
                                     [_tableView reloadData];
                                     NSLog(@"0");
                                 } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                 }];

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
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _templateArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!cell) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    }
    MJXTemplate * one = _templateArray[indexPath.row];
    cell.textLabel.text = one.templateName;
    //cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    cell.textLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    UIView * line  = [[UIView alloc] initWithFrame:CGRectMake(0, 49, APPLICATION_WIDTH, 1)];
    line.backgroundColor = [UIColor colorWithHexString:@"#e5e5e5"];
    [cell.contentView addSubview:line];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    AFHTTPRequestOperationManager *manger = [MJXClient setAFHTTPRequestOperationManagerSomeQuality];
    NSString *url = [NSString stringWithFormat:@"%@/followup/deleteMyTemplate",MJXBaseURL];
    MJXTemplate * one = _templateArray[indexPath.row];
    NSString * template = one.templateId;
    [manger POST:url parameters:@{
                                  @"username" : [[MJXAppsettings sharedInstance] getUserPhone],
                                  @"templateId" : template
                                 } success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                     [self getData];
                                  [_tableView reloadData];
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
