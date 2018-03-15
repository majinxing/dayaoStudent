//
//  GroupListViewController.m
//  WisdomHall
//
//  Created by XTU-TI on 2017/10/9.
//  Copyright © 2017年 majinxing. All rights reserved.
//

#import "GroupListViewController.h"
#import "DYHeader.h"
#import "GroupModel.h"
#import "JoinCours.h"
#import "GroupPeopleViewController.h"
#import "SignPeople.h"
#import "ClassManagementViewController.h"
#import "GroupListTableViewCell.h"

@interface GroupListViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)NSMutableArray * dataAry;
@property (nonatomic,strong)UITableView * tableView;
@property (nonatomic,strong)JoinCours * join;

@end

@implementation GroupListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    _dataAry = [NSMutableArray arrayWithCapacity:1];
    
    [self getData];
    
    [self addTable];
    
    [self setNavigationTitle];
    
    // Do any additional setup after loading the view from its nib.
}
/**
 *  显示navigation的标题
 **/
-(void)setNavigationTitle{
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;

    self.title = @"群组成员";
    UIBarButtonItem *myButton = [[UIBarButtonItem alloc] initWithTitle:@"加入群组" style:UIBarButtonItemStylePlain target:self action:@selector(joinGroup)];
    
    self.navigationItem.rightBarButtonItem = myButton;
}
-(void)joinGroup{
    if (_join==nil) {
        _join = [[JoinCours alloc] init];
        _join.delegate = self;
        _join.frame = CGRectMake(0, 0, APPLICATION_WIDTH, APPLICATION_HEIGHT);
        [self.view addSubview:_join];
    }
}
-(void)addTable{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, APPLICATION_WIDTH, APPLICATION_HEIGHT-64) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.view addSubview:_tableView];
}
-(void)getData{
    UserModel * user = [[Appsetting sharedInstance] getUsetInfo];
    
    NSDictionary * d = [[NSDictionary alloc] initWithObjectsAndKeys:user.peopleId,@"userId", nil];
    [[NetworkRequest sharedInstance] POST:QueryGroupList dict:d succeed:^(id data) {
        NSString * str = [[data objectForKey:@"header"] objectForKey:@"code"];
        if ([str isEqualToString:@"0000"]) {
            NSArray * ary = [data objectForKey:@"body"];
            [_dataAry removeAllObjects];
            for (int i = 0; i<ary.count; i++) {
                GroupModel * g = [[GroupModel alloc] init];
                [g setSelfWithDict:ary[i]];
                [_dataAry addObject:g];
            }
            [_tableView reloadData];
        }
    } failure:^(NSError *error) {
        
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark JoinCoursDelegate
-(void)joinCourseDelegete:(UIButton *)btn{
    [self.view endEditing:YES];
    if (btn.tag == 1) {
        [_join removeFromSuperview];
        _join = nil;
    }else if (btn.tag == 2){
        NSDictionary * dict = [[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%@",_join.courseNumber.text],@"groupId", nil];
        [[NetworkRequest sharedInstance] POST:JoinGroup dict:dict succeed:^(id data) {
            [self getData];
        } failure:^(NSError *error) {
            
        }];
        [_join removeFromSuperview];
        _join = nil;
    }
}
#pragma mark UITableViewdelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (_dataAry.count>0) {
        return _dataAry.count;
    }
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    GroupListTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"GroupListTableViewCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"GroupListTableViewCell" owner:self options:nil] objectAtIndex:0];
    }
//    [[[NSBundle mainBundle] loadNibNamed:@"PersonalInfoTableViewCell" owner:self options:nil] objectAtIndex:index];
    GroupModel * g = _dataAry[indexPath.row];
    [cell addContentView:g];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    GroupModel * group = _dataAry[indexPath.row];
    
    [self getDataWithGruop:group];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}
-(void)getDataWithGruop:(GroupModel *)group{
    NSDictionary * dict = [[NSDictionary alloc] initWithObjectsAndKeys:group.groupId,@"groupId", nil];
    [[NetworkRequest sharedInstance] GET:GroupPeople dict:dict succeed:^(id data) {
        NSString * str = [[data objectForKey:@"header"] objectForKey:@"code"];
        if ([str isEqualToString:@"0000"]) {
            NSArray * ary = [data objectForKey:@"body"];
            NSMutableArray * signAry = [NSMutableArray arrayWithCapacity:1];
            for (int i = 0; i<ary.count; i++) {
                SignPeople * s = [[SignPeople alloc] init];
                [s setInfoWithDict:ary[i]];
                [signAry addObject:s];
            }
            ClassManagementViewController * classManegeVC = [[ClassManagementViewController alloc] init];
            self.hidesBottomBarWhenPushed = YES;
            classManegeVC.manage = ClassManageType;
            classManegeVC.signAry = [NSMutableArray arrayWithCapacity:1];
            classManegeVC.signAry = signAry;
            [self.navigationController pushViewController:classManegeVC animated:YES];
        }
    } failure:^(NSError *error) {
        
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
