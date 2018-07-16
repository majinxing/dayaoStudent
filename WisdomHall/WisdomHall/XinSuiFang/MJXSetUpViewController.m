//
//  MJXSetUpViewController.m
//  XinSuiFang
//
//  Created by majinxing on 16/10/9.
//  Copyright © 2016年 majinxing. All rights reserved.
//

#import "MJXSetUpViewController.h"
#import "MJXFeedbackViewController.h"
#import "MJXUserLoginViewController.h"
#import "MJXModifyInformationViewController.h"
#import "MJXUseTheHelpViewController.h"
@interface MJXSetUpViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)NSArray *ary;
@end

@implementation MJXSetUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHexString:@"#f7f7f7"];
    [MJXUIUtils addNavigationWithView:self.view withTitle:@"设置"];
    [self addBackButton];
    _ary = [[NSArray alloc] initWithObjects:@"使用帮助",@"意见反馈",@"关于我们", nil];
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, APPLICATION_WIDTH, 180) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    UIButton * getOut = [UIButton buttonWithType:UIButtonTypeCustom];
    getOut.frame = CGRectMake(21, CGRectGetMaxY(_tableView.frame)+110, APPLICATION_WIDTH-42, 44);
    [getOut setTitle:@"退出登录" forState:UIControlStateNormal];
    [getOut setTitleColor:[UIColor colorWithHexString:@"#01aeff"] forState:UIControlStateNormal];
    getOut.layer.cornerRadius = 5;
    getOut.layer.masksToBounds = YES;
    getOut.layer.borderWidth = 1;
    getOut.layer.borderColor = [[UIColor colorWithHexString:@"#01aeff"] CGColor];
    getOut.backgroundColor = [UIColor colorWithHexString:@"#f7f7f7"];
    [getOut addTarget:self action:@selector(letOut) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:getOut];
    // Do any additional setup after loading the view.
}
-(void)letOut{
    [[MJXAppsettings sharedInstance] logOut];
    MJXUserLoginViewController *userLogin=[[MJXUserLoginViewController alloc] init];
    [UIApplication sharedApplication].keyWindow.rootViewController=[[UINavigationController alloc]initWithRootViewController:userLogin];
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
    return 3;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!cell) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    }
    cell.textLabel.text = _ary[indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    cell.textLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    UIView * line  = [[UIView alloc] initWithFrame:CGRectMake(0, 49, APPLICATION_WIDTH, 1)];
    line.backgroundColor = [UIColor colorWithHexString:@"#e5e5e5"];
    [cell.contentView addSubview:line];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        MJXUseTheHelpViewController * tU = [[MJXUseTheHelpViewController alloc] init];
        tU.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:tU animated:YES];
    }else if (indexPath.row == 1) {
        MJXFeedbackViewController *fbVC = [[MJXFeedbackViewController alloc] init];
        fbVC.hidesBottomBarWhenPushed = YES;
        fbVC.titleString = @"意见反馈";
        [self.navigationController pushViewController:fbVC animated:YES];
    }else if (indexPath.row == 2){
        MJXFeedbackViewController *fbVC = [[MJXFeedbackViewController alloc] init];
        fbVC.hidesBottomBarWhenPushed = YES;
        fbVC.titleString = @"关于我们";
        [self.navigationController pushViewController:fbVC animated:YES];
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
