//
//  MJXPersonalCenterViewController.m
//  XinSuiFang
//
//  Created by majinxing on 16/8/11.
//  Copyright © 2016年 majinxing. All rights reserved.
//

#import "MJXPersonalCenterViewController.h"
#import "MJXPersonalCenterCell.h"
#import "MJXVGroupManagementiewController.h"
#import "MJXTemplatemanagementViewController.h"
#import "MJXSetUpViewController.h"
#import "MJXModifyInformationViewController.h"
@interface MJXPersonalCenterViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)NSArray *imageName;
@property (nonatomic,strong)NSArray *titleText;
@property (nonatomic,strong)NSMutableArray * textArray;
@end

@implementation MJXPersonalCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    _textArray = [NSMutableArray arrayWithCapacity:10];
    [_textArray setObject:@"" atIndexedSubscript:0];
    [_textArray setObject:@"" atIndexedSubscript:1];
    [_textArray setObject:@"" atIndexedSubscript:2];
    [_textArray setObject:@"" atIndexedSubscript:3];
   
   [MJXUIUtils addNavigationWithView:self.view withTitle:@"个人中心"];
    [self getArray];
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, APPLICATION_WIDTH, APPLICATION_HEIGHT-64-40) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = [UIColor colorWithHexString:@"#f7f7f7"];
    [self.view addSubview:_tableView];
    [self getTextWithUserModel];
    [self getData];
}

-(void)getData{
    AFHTTPRequestOperationManager *manger = [MJXClient setAFHTTPRequestOperationManagerSomeQuality];
    NSString * url = [NSString stringWithFormat:@"%@/user/findDoctorInformation",MJXBaseURL];
    [manger POST:url parameters:@{
                                  @"username" :[[MJXAppsettings sharedInstance] getUserPhone]
                                  } success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                      if ([[responseObject objectForKey:@"statusCode"] isEqualToString:@"200"]) {
                                        [self getText:[responseObject objectForKey:@"result"]];
                                      }
                                      
                                      
                                      
                                  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                      
                                  }];
    
    
}
-(void)getText:(NSDictionary *)dict{
    [[MJXAppsettings sharedInstance] sevaUserInfoWithDict:dict];
    _textArray[0] = [NSString stringWithFormat:@"%@",[dict objectForKey:@"name"]];
    _textArray[1] = [NSString stringWithFormat:@"%@",[dict objectForKey:@"hospital"]];
    _textArray[2] = [NSString stringWithFormat:@"%@",[dict objectForKey:@"titleid"]];
    _textArray[3] = [NSString stringWithFormat:@"%@",[dict objectForKey:@"headimg"]];
    [_tableView reloadData];
}
-(void)getTextWithUserModel{
   MJXUserModel *userInfo = [[MJXUserModel alloc] init];
    userInfo = [[MJXAppsettings sharedInstance] getUserInfo];
    _textArray[0] = [NSString stringWithFormat:@"%@",userInfo.userName];
    _textArray[1] = [NSString stringWithFormat:@"%@",userInfo.hospital];
    _textArray[2] = [NSString stringWithFormat:@"%@",userInfo.position];
    _textArray[3] = [NSString stringWithFormat:@"%@",userInfo.headimg];
    [_tableView reloadData];
}
-(void)getArray{
    _imageName = [[NSArray alloc] initWithObjects:@"grxx",@"fzgl",@"mbgl",@"sz", nil];
    _titleText = [[NSArray alloc] initWithObjects:@"个人信息",@"分组管理",@"模板管理",@"设置", nil];
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
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }else
    return 4;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MJXPersonalCenterCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!cell) {
        cell=[[MJXPersonalCenterCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    }
    if (indexPath.section == 0) {
        [cell addHeadImage:_textArray[3] withName:_textArray[0] withTheTitle:_textArray[2] withHospital:_textArray[1]];
        cell.userInteractionEnabled = NO;
    }else if (indexPath.section == 1){
        [cell setImageName:_imageName[indexPath.row] withText:_titleText[indexPath.row]];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 1&&indexPath.row == 1) {
        MJXVGroupManagementiewController *gMVC = [[MJXVGroupManagementiewController alloc] init];
        gMVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:gMVC animated:YES];
    }else if (indexPath.section ==1&&indexPath.row ==2){
        MJXTemplatemanagementViewController *tMVC = [[MJXTemplatemanagementViewController alloc] init];
        tMVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:tMVC animated:YES];
    }else if (indexPath.section == 1&&indexPath.row ==3){
        MJXSetUpViewController *setUp = [[MJXSetUpViewController alloc] init];
        setUp.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:setUp animated:YES];
    }else if (indexPath.section == 1 && indexPath.row == 0){
        MJXModifyInformationViewController * mif = [[MJXModifyInformationViewController alloc] init];
        mif.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:mif animated:YES];
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 175;
    }else
        return 60;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section ==0) {
        return 0;
    }else
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
