//
//  SystemSettingsViewController.m
//  WisdomHall
//
//  Created by XTU-TI on 2017/4/28.
//  Copyright © 2017年 majinxing. All rights reserved.
//

#import "SystemSettingsViewController.h"
#import "TheLoginViewController.h"
#import "DYTabBarViewController.h"
#import "DYHeader.h"
#import "ChatHelper.h"
#import "WorkingLoginViewController.h"
#import "SystemSetingTableViewCell.h"
#import "ChangeThemeInfoViewController.h"

@interface SystemSettingsViewController ()<UITableViewDelegate,UITableViewDataSource,SystemSetingTableViewCellDelegate>
@property (nonatomic,strong)UITableView * tableView;
@end

@implementation SystemSettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"系统设置";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self addTableView];
    // Do any additional setup after loading the view from its nib.
}
-(void)addTableView{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, NaviHeight, APPLICATION_WIDTH, (APPLICATION_HEIGHT)-(NaviHeight)) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
//    _tableView.separatorStyle = NO;
    [self.view addSubview:_tableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark SystemSetingTableViewCellDelegate
-(void)outAPPBtnPressedDelegate{
    [[Appsetting sharedInstance] getOut];
    
    DYTabBarViewController *rootVC = [DYTabBarViewController sharedInstance];
    rootVC = nil;
    ChatHelper * c =[ChatHelper shareHelper];
    [c getOut];
    
    WorkingLoginViewController * userLogin = [[WorkingLoginViewController alloc] init];
    //    TheLoginViewController * userLogin = [[TheLoginViewController alloc] init];
    
    [UIApplication sharedApplication].keyWindow.rootViewController =[[UINavigationController alloc] initWithRootViewController:userLogin];
}
#pragma mark UITableViewdelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SystemSetingTableViewCell * cell ;
    if (indexPath.row == 1) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"SystemSetingTableViewCellFourth"];
        cell = [[[NSBundle mainBundle] loadNibNamed:@"SystemSetingTableViewCell" owner:self options:nil] objectAtIndex:3];
    }else if (indexPath.row == 0){
        cell = [tableView dequeueReusableCellWithIdentifier:@"SystemSetingTableViewCellFifth"];
        cell = [[[NSBundle mainBundle] loadNibNamed:@"SystemSetingTableViewCell" owner:self options:nil] objectAtIndex:4];
        cell.selected = NO;
    }
    cell.delegate = self;

    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
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
