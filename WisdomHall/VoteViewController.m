//
//  VoteViewController.m
//  WisdomHall
//
//  Created by XTU-TI on 2017/6/1.
//  Copyright © 2017年 majinxing. All rights reserved.
//

#import "VoteViewController.h"
#import "DYHeader.h"
#import "VoteTableViewCell.h"
#import "CreateVoteViewController.h"
#import "JoinVoteViewController.h"
#import "VoteModel.h"
#import "ShareView.h"
#import "MJRefresh.h"


@interface VoteViewController ()<UITableViewDelegate,UITableViewDataSource,VoteTableViewCellDelegate,ShareViewDelegate>
@property (nonatomic,strong)UITableView * tableview;
@property (nonatomic,strong)UserModel * user;
@property (nonatomic,strong)NSMutableArray * dataAry;
@property (nonatomic,strong)ShareView * vote;
@property (nonatomic,strong)VoteModel * voteModel;

@end

@implementation VoteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _user = [[Appsetting sharedInstance] getUsetInfo];
    _dataAry = [NSMutableArray arrayWithCapacity:1];
//    [self getData];
    [self addTableView];
    
    [self setNavigationTitle];
    
    // Do any additional setup after loading the view from its nib.
}
-(void)viewWillAppear:(BOOL)animated{
    [self getData];
}
-(void)getData{

    dispatch_async(dispatch_get_main_queue(), ^{
        //获取主线程
        [self hideHud];
        [self showHudInView:self.view hint:NSLocalizedString(@"正在加载数据", @"Load data...")];
    });
    if ([_type isEqualToString:@"meeting"]) {
        
        NSDictionary * dict = [[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%@",_meetModel.meetingId],@"relId",@"1",@"start",@"100",@"length",@"2",@"relType",nil];
        
        [[NetworkRequest sharedInstance] GET:QueryVote dict:dict succeed:^(id data) {
            //        NSLog(@"%@",data);
            [_dataAry removeAllObjects];
            NSArray * ary = [[data objectForKey:@"body"] objectForKey:@"list"];
            for (int i = 0; i<ary.count; i++) {
                VoteModel * v = [[VoteModel alloc] init];
                [v setInfo:ary[i]];
                [_dataAry addObject:v];
            }
            if (_dataAry.count>0) {
                
            }else{
                [UIUtils showInfoMessage:@"暂无数据" withVC:self];
            }
            [self hideHud];
            [_tableview reloadData];
        } failure:^(NSError *error) {
            [UIUtils showInfoMessage:@"获取数据失败，请检查网络" withVC:self];

            [self hideHud];
        }];
        
    }else{
        NSDictionary * dict = [[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%@",_classModel.sclassId],@"relId",@"1",@"start",@"10000",@"length",@"1",@"relType",nil];
        [[NetworkRequest sharedInstance] GET:QueryVote dict:dict succeed:^(id data) {
            //        NSLog(@"%@",data);
            [_dataAry removeAllObjects];
            NSArray * ary = [[data objectForKey:@"body"] objectForKey:@"list"];
            for (int i = 0; i<ary.count; i++) {
                VoteModel * v = [[VoteModel alloc] init];
                [v setInfo:ary[i]];
                [_dataAry addObject:v];
            }
            if (_dataAry.count>0) {
                
            }else{
                [UIUtils showInfoMessage:@"暂无数据" withVC:self];
            }
            [self hideHud];
            [_tableview reloadData];
        } failure:^(NSError *error) {
            [UIUtils showInfoMessage:@"获取数据失败，请检查网络" withVC:self];

            [self hideHud];
        }];
    }
        [_tableview headerEndRefreshing];
        [_tableview footerEndRefreshing];
}
-(void)addTableView{
    _tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, APPLICATION_WIDTH, APPLICATION_HEIGHT-64) style:UITableViewStylePlain];
    _tableview.delegate = self;
    _tableview.dataSource = self;
    _tableview.estimatedRowHeight = 70;
    _tableview.rowHeight = UITableViewAutomaticDimension;
    _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableview];
    
    __weak VoteViewController * weakSelf = self;
    [self.tableview addHeaderWithCallback:^{
        [weakSelf getData];
    }];
    
    [self.tableview addFooterWithCallback:^{
        [weakSelf getData];
    }];
}
/**
 *  显示navigation的标题
 **/
-(void)setNavigationTitle{
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
    self.title = @"投票";
    if ([[NSString stringWithFormat:@"%@",_meetModel.meetingHostId] isEqualToString:[NSString stringWithFormat:@"%@",_user.peopleId]]) {
        UIBarButtonItem *myButton = [[UIBarButtonItem alloc] initWithTitle:@"新建投票" style:UIBarButtonItemStylePlain target:self action:@selector(createVote)];
        
        self.navigationItem.rightBarButtonItem = myButton;
    }else if ([[NSString stringWithFormat:@"%@",_classModel.teacherWorkNo] isEqualToString:[NSString stringWithFormat:@"%@",_user.studentId]]) {
        UIBarButtonItem *myButton = [[UIBarButtonItem alloc] initWithTitle:@"新建投票" style:UIBarButtonItemStylePlain target:self action:@selector(createVote)];
        
        self.navigationItem.rightBarButtonItem = myButton;
    }
    

}

-(void)createVote{
    
    CreateVoteViewController * c = [[CreateVoteViewController alloc] init];
    self.hidesBottomBarWhenPushed = YES;
    if ([_type isEqualToString:@"meeting"]) {
        c.meetModel = _meetModel;
        c.type = @"meeting";
    }else{
        c.classModel = _classModel;
        c.type = @"classModel";
    }
    [self.navigationController pushViewController:c animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark VoteTableViewCellDelegate
-(void)moreVoteTableViewCellDelegate:(UIButton *)btn{
    _voteModel = _dataAry[btn.tag-1];
    
    if (!_vote)
    {
        _vote = [[ShareView alloc] initWithFrame:self.navigationController.view.bounds withType:@"vote"];
        _vote.delegate = self;
    }
    
    [_vote showInView:self.navigationController.view];

}
#pragma mark ShareViewDelegate

- (void)shareViewButtonClick:(NSString *)platform
{
    if ([platform isEqualToString:Vote_delecate]){
        
        NSDictionary * dict = [[NSDictionary alloc] initWithObjectsAndKeys:_voteModel.voteId,@"id", nil];
        [[NetworkRequest sharedInstance] POST:VoteDelect dict:dict succeed:^(id data) {
            [self getData];
            [_vote hide];
        } failure:^(NSError *error) {
            [UIUtils showInfoMessage:@"删除数据失败，请检查网络" withVC:self];
        }];
        
    }else if ([platform isEqualToString:Vote_Stop]){
        NSDictionary * dict = [[NSDictionary alloc] initWithObjectsAndKeys:_voteModel.voteId,@"id",@"1",@"status",nil];
        [[NetworkRequest sharedInstance] POST:VoteEditor dict:dict succeed:^(id data) {
            NSLog(@"%@",data);
            [self getData];
            [_vote hide];
        } failure:^(NSError *error) {
            [UIUtils showInfoMessage:@"发送数据失败，请检查网络" withVC:self];

        }];
    
    }else if ([platform isEqualToString:Vote_Stare]){
        NSDictionary * dict = [[NSDictionary alloc] initWithObjectsAndKeys:_voteModel.voteId,@"id",@"2",@"status",nil];
        [[NetworkRequest sharedInstance] POST:VoteEditor dict:dict succeed:^(id data) {
            NSLog(@"%@",data);
            [self getData];
            [_vote hide];
        } failure:^(NSError *error) {
            [UIUtils showInfoMessage:@"开始失败，请检查网络" withVC:self];
        }];
        
    }else if ([platform isEqualToString:Vote_Modify]){
        [UIUtils showInfoMessage:@"未完待续" withVC:self];
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
    VoteTableViewCell * cell = [_tableview dequeueReusableCellWithIdentifier:@"VoteTableViewCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"VoteTableViewCell" owner:nil options:nil] objectAtIndex:0];
    }
    VoteModel * v = _dataAry[indexPath.row];
    
    [cell voteTitle:v.title withCreateTime:v.time withState:v.selfVoteStatus withIndex:(int)indexPath.row+1 withVoteStatus:v.voteState];
    
    cell.delegate = self;
    
    if ([[NSString stringWithFormat:@"%@",_meetModel.meetingHostId] isEqualToString:[NSString stringWithFormat:@"%@",_user.peopleId]]) {
        
    }else if ([[NSString stringWithFormat:@"%@",_classModel.teacherWorkNo] isEqualToString:[NSString stringWithFormat:@"%@",_user.studentId]]) {
       
    }else{
        cell.moreImage.image = [UIImage imageNamed:@""];
        [cell.moreBtn setEnabled:NO];
    }
    
    return cell;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    JoinVoteViewController * j = [[JoinVoteViewController alloc] init];
    self.hidesBottomBarWhenPushed = YES;
    
    j.vote = _dataAry[indexPath.row];
    
    [self.navigationController pushViewController:j animated:YES];
}
//-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    return 70;
//}
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
