//
//  OfficeViewController.m
//  WisdomHall
//
//  Created by XTU-TI on 2017/9/22.
//  Copyright © 2017年 majinxing. All rights reserved.
//

#import "OfficeViewController.h"
#import "DYHeader.h"
#import "OfficeTableViewCell.h"
#import "AllTheMeetingViewController.h"
#import "NoticeViewController.h"
#import "GroupListViewController.h"
//#import "StatisticalViewController.h"
#import "WisdomHall-Swift.h"
#import "JPUSHService.h"
#import "CollectionHeadView.h"
#import "NoticeDetailsViewController.h"
#import "StatisticalSelfUIViewController.h"
#import "SignInViewController.h"

@interface OfficeViewController ()<UITableViewDelegate,UITableViewDataSource,OfficeTableViewCellDelegate>
@property (nonatomic,strong)UITableView * tableView;
@property (nonatomic,strong)UIImageView * bImage;

@end

@implementation OfficeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    _bImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"timg"]];
    
    _bImage.frame = CGRectMake(0, 0, APPLICATION_WIDTH, APPLICATION_HEIGHT-44);

    
    [self.view addSubview:_bImage];

    [self addTableView];

    [self setAlias];
    
    
    // Do any additional setup after loading the view from its nib.
}

-(void)setAlias{
#pragma mark - 推送别名设置
    UserModel * user = [[Appsetting sharedInstance] getUsetInfo];

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [JPUSHService setAlias:[NSString stringWithFormat:@"%@%@",user.school,user.studentId] completion:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {
            
        } seq:1];
        
    });
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}
-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = YES; //设置隐藏
    [_tableView reloadData];
}
-(void)viewWillDisappear:(BOOL)animated{
//    self.navigationController.navigationBarHidden = YES; //设置隐藏
}
/**
 *  显示navigation的标题
 **/
-(void)setNavigationTitle{
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
 
    self.title = @"办公";
}
-(void)addTableView{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,SafeAreaTopHeight, APPLICATION_WIDTH, APPLICATION_HEIGHT-64-44) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = [UIColor clearColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.view addSubview:_tableView];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark OfficeTableViewCellDelegate
-(void)shareButtonClickedDelegate:(NSString *)str{
    if ([str isEqualToString:Meeting]) {
        self.hidesBottomBarWhenPushed = YES;
        AllTheMeetingViewController * s = [[AllTheMeetingViewController alloc] init];
        [self.navigationController pushViewController:s animated:YES];
        self.hidesBottomBarWhenPushed = NO;
    }else if ([str isEqualToString:Announcement]){
        NoticeViewController * noticeVC = [[NoticeViewController alloc] init];
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:noticeVC animated:YES];
        self.hidesBottomBarWhenPushed = NO;
    }else if ([str isEqualToString:Group]){
        GroupListViewController * g = [[GroupListViewController alloc] init];
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:g animated:YES];
        self.hidesBottomBarWhenPushed = NO;
    }else if ([str isEqualToString:Statistical]){
        StatisticalSelfUIViewController * vc = [[StatisticalSelfUIViewController alloc] init];
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
        self.hidesBottomBarWhenPushed = NO;
    }else{
        [UIUtils showInfoMessage:@"正在加紧步伐开发中，敬请期待" withVC:self];
    }
}

-(void)signBtnPressedDelegate:(UIButton *)btn{
    [UIUtils dailyCheck];
    [_tableView reloadData];
}
-(void)noticeBtnPressedDelegateOfficeCellDelegate:(NoticeModel *)notice{
    NoticeDetailsViewController * notice1 = [[NoticeDetailsViewController alloc] initWithActionBlock:^(NSString *str) {
        
    }];
    notice1.notice = notice;
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:notice1 animated:YES];
    self.hidesBottomBarWhenPushed = NO;
    
}
#pragma mark UITableViewdelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    OfficeTableViewCell * cell;
    
    cell = [tableView dequeueReusableCellWithIdentifier:@"OfficeTableViewCellSecond"];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"OfficeTableViewCell" owner:self options:nil] objectAtIndex:1];
    }
    [cell addSecondContentView];

    //    }
    cell.delegate = self;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    //    if (indexPath.section == 0) {
    //        return 160;
    //    }
    return APPLICATION_HEIGHT-64-44;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0;
}

@end


