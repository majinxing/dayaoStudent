//
//  ResultsOfVoteViewController.m
//  WisdomHall
//
//  Created by XTU-TI on 2017/6/7.
//  Copyright © 2017年 majinxing. All rights reserved.
//

#import "ResultsOfVoteViewController.h"
#import "DYHeader.h"
#import "VoteDrawView.h"
#import "VoteOption.h"
#import "VoteResultTableViewCell.h"

@interface ResultsOfVoteViewController ()<UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)VoteDrawView * drawView;
@property (nonatomic,strong)UIScrollView * scrollView;
@property(nonatomic, strong)NSMutableArray *x_arr;//x轴数据数组
@property(nonatomic, strong)NSMutableArray *y_arr;//y轴数据数组
@property (nonatomic,strong)NSMutableArray * dataAry;
@property (nonatomic,assign)int n;
@property (nonatomic,strong)UITableView * tableView;
@end

@implementation ResultsOfVoteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self.view addSubview:self.drawView];
    _n = 0;
    
    _dataAry = [NSMutableArray arrayWithCapacity:1];
    
    _x_arr = [NSMutableArray arrayWithCapacity:1];
    
    _y_arr = [NSMutableArray arrayWithCapacity:1];

    
    [self getData];
    
    [self addTableView];

}
-(void)addTableView{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64,APPLICATION_WIDTH, APPLICATION_HEIGHT-64) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    //    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.estimatedRowHeight = 50;
//    _tableView.rowHeight = UITableViewAutomaticDimension;
    _tableView.separatorStyle = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.view addSubview:_tableView];
}
-(void)getData{
    NSDictionary * dict = [[NSDictionary alloc] initWithObjectsAndKeys:_voteModel.voteId,@"themeId",@"1",@"start",@"1000",@"length",nil];
    [[NetworkRequest sharedInstance] GET:QueryVoteResult dict:dict succeed:^(id data) {
//        NSLog(@"%@",data);
        NSArray * ary = [[data objectForKey:@"body"] objectForKey:@"list"];
        for (int i = 0; i<ary.count; i++) {
            VoteOption * v = [[VoteOption alloc] init];
            [v setInfo:ary[i]];
            [_dataAry addObject:v];
            [_x_arr addObject:v.content];
            [_y_arr addObject:v.count];
            _n = _n + [v.count intValue];
        }
        if (_n==0) {
            [UIUtils showInfoMessage:@"暂无投票数据"];
        }else{
            [_tableView reloadData];
        }
    } failure:^(NSError *error) {
        [UIUtils showInfoMessage:@"获取数据失败，请检查网络"];
    }];
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
    if (_dataAry.count>0) {
        return _dataAry.count+1;
    }
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    VoteResultTableViewCell * cell;
    if (indexPath.row==0) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"VoteResultTableViewCellSecond"];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"VoteResultTableViewCell" owner:nil options:nil] objectAtIndex:1];;
        }
        [cell addSecondContentView:[NSString stringWithFormat:@"%d",_n]];
    }else{
        cell = [tableView dequeueReusableCellWithIdentifier:@"VoteResultTableViewCellFirst"];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"VoteResultTableViewCell" owner:nil options:nil] objectAtIndex:0];;
        }
        VoteOption * v = _dataAry[indexPath.row-1];
        
        [cell addContentViewWith:v withAllVotes:[NSString stringWithFormat:@"%d",_n] withIndex:(int)indexPath.row];
        
    }
   
    
  
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
