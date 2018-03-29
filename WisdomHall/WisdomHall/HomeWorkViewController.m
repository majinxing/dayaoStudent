//
//  HomeWorkViewController.m
//  WisdomHall
//
//  Created by XTU-TI on 2018/3/23.
//  Copyright © 2018年 majinxing. All rights reserved.
//

#import "HomeWorkViewController.h"
#import "DYHeader.h"
#import "HomeworkListTableViewCell.h"
#import "CreateHomeworkViewController.h"
#import "Homework.h"

@interface HomeWorkViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong) UITableView * tableView;
@property (nonatomic,strong) UserModel * user;
@property (nonatomic,strong) NSMutableArray * dataAry;
@end

@implementation HomeWorkViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    _dataAry = [NSMutableArray arrayWithCapacity:1];
    
    _user = [[Appsetting sharedInstance] getUsetInfo];
    
    [self addTableView];
    
    [self setNavigationTitle];
    
    [self getData];
    // Do any additional setup after loading the view from its nib.
}
-(void)getData{
    NSDictionary * dict = [[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%@",_c.sclassId],@"courseId", nil];
    [[NetworkRequest sharedInstance] GET:CourseWorkList dict:dict succeed:^(id data) {
        
        NSArray * ary = [[data objectForKey:@"body"] objectForKey:@"list"];
        for (int i = 0; i<ary.count; i++) {
            Homework * h = [[Homework alloc] init];
            [h setValueWithDict:ary[i]];
            [_dataAry addObject:h];
        }
        [_tableView reloadData];
    } failure:^(NSError *error) {
        [UIUtils showInfoMessage:@"请求失败请"];
    }];
}
/**
 *  显示navigation的标题
 **/
-(void)setNavigationTitle{
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
    self.title = @"作业";
    
    UIBarButtonItem *myButton = [[UIBarButtonItem alloc] initWithTitle:@"创建作业" style:UIBarButtonItemStylePlain target:self action:@selector(createHomework)];
    [myButton setTintColor:[UIColor whiteColor]];
    
    if ([[NSString stringWithFormat:@"%@",_c.teacherWorkNo] isEqualToString:[NSString stringWithFormat:@"%@",_user.studentId]]) {
        self.navigationItem.rightBarButtonItem = myButton;
    }
}
-(void)createHomework{
    CreateHomeworkViewController * vc = [[CreateHomeworkViewController alloc] init];
    self.hidesBottomBarWhenPushed = YES;
    vc.c = _c;
    vc.edit = YES;
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)addTableView{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, NaviHeight, APPLICATION_WIDTH,APPLICATION_HEIGHT-64) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
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
    return _dataAry.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HomeworkListTableViewCell * cell ;
    cell = [tableView dequeueReusableCellWithIdentifier:@"HomeworkListTableViewCellFirst"];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"HomeworkListTableViewCell" owner:self options:nil] objectAtIndex:0];
    }
    Homework * h = _dataAry[indexPath.row];
    [cell addContentViewWith:h];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    CreateHomeworkViewController * vc = [[CreateHomeworkViewController alloc] init];
    self.hidesBottomBarWhenPushed = YES;
    vc.c = _c;
    vc.edit = NO;
    vc.homeworkModel = _dataAry[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 120;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath { 
    if ([[NSString stringWithFormat:@"%@",_c.teacherWorkNo] isEqualToString:[NSString stringWithFormat:@"%@",_user.studentId]]) {
        Homework * h = _dataAry[indexPath.row];
        NSDictionary * dict = [[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%@",h.homeworkId],@"id", nil];
        [[NetworkRequest sharedInstance] POST:DeleteHomework dict:dict succeed:^(id data) {
            NSString * code = [[data objectForKey:@"header"] objectForKey:@"code"];
            if ([code isEqualToString:@"0000"]) {
                [_dataAry removeObjectAtIndex:indexPath.row];
                [_tableView reloadData];
            }else{
                [UIUtils showInfoMessage:@"删除失败"];
            }
        } failure:^(NSError *error) {
            [UIUtils showInfoMessage:@"删除失败"];
        }];
    }
}
    
    /** * 修改Delete按钮文字为“删除” */
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath { return @"删除";
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