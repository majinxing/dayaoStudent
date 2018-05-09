//
//  StatisticalSelfUIViewController.m
//  WisdomHall
//
//  Created by XTU-TI on 2018/3/23.
//  Copyright © 2018年 majinxing. All rights reserved.
//

#import "StatisticalSelfUIViewController.h"
#import "DYHeader.h"
#import "StatisticalResultTableViewCell.h"


@interface StatisticalSelfUIViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UIButton * bView;//滚轮的背景

@property (nonatomic,strong) UITableView * tableView;

@property (nonatomic,strong) NSArray * ary;

@property (nonatomic,assign) int temp;



@property (nonatomic,assign) int  pickTemp;

@property (nonatomic,copy)NSString * startTime;

@property (nonatomic,copy)NSString * endTime;

@end

@implementation StatisticalSelfUIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self addTableView];
    // Do any additional setup after loading the view from its nib.
}
-(void)viewWillAppear:(BOOL)animated{
}

-(void)addTableView{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, APPLICATION_WIDTH, APPLICATION_HEIGHT-64) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
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
    StatisticalResultTableViewCell * cell;
    cell = [tableView dequeueReusableCellWithIdentifier:@"StatisticalResultTableViewCellFirst"];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"StatisticalResultTableViewCell" owner:self options:nil] objectAtIndex:0];
    }
    StatisticalResultModel * s = _dataAry[indexPath.row];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [cell addContentView:s];
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 180;
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
