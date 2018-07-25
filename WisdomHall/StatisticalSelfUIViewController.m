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

#import "StatisticalCourseViewController.h"
#import "CourseStatisticalModel.h"

@interface StatisticalSelfUIViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UIButton * bView;//滚轮的背景

@property (nonatomic,strong) UITableView * tableView;

@property (nonatomic,strong) NSArray * ary;

@property (nonatomic,assign) int temp;



@property (nonatomic,assign) int  pickTemp;



@end

@implementation StatisticalSelfUIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self addTableView];
    self.title = @"学习统计";
    // Do any additional setup after loading the view from its nib.
}

-(void)viewWillAppear:(BOOL)animated{
}

-(void)addTableView{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, APPLICATION_WIDTH, APPLICATION_HEIGHT-64) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
//    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
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
    
    cell.contentView.backgroundColor = [UIColor colorWithHexString:@"#fafafa"];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    StatisticalResultModel * s = _dataAry[indexPath.row];
    
    NSDictionary * dict = [[NSDictionary alloc] initWithObjectsAndKeys:s.courseId,@"courseId",_startTime,@"startTime",_endTime,@"endTime", nil];
    
    [[NetworkRequest sharedInstance] POST:CourseStatistic dict:dict succeed:^(id data) {
        NSString * str = [NSString stringWithFormat:@"%@",[[data objectForKey:@"header"] objectForKey:@"message"]];
        
        if ([str isEqualToString:@"成功"]) {
            NSArray * ary = [data objectForKey:@"body"];
            StatisticalCourseViewController * vc = [[StatisticalCourseViewController alloc] init];
            vc.dataAry = [NSMutableArray arrayWithCapacity:1];
            for (int i = 0; i<ary.count; i++) {
                CourseStatisticalModel * c = [[CourseStatisticalModel alloc] init];
                [c setValueWithDict:ary[i]];
                c.courseName = s.courseName;
                [vc.dataAry addObject:c];
            }
            [self.navigationController pushViewController:vc animated:YES];
        }else{
            [UIUtils showInfoMessage:str withVC:self];
        }
        
    } failure:^(NSError *error) {
        
    }];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 310;
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
