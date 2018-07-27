//
//  StatisticalViewController.m
//  WisdomHall
//
//  Created by XTU-TI on 2018/1/29.
//  Copyright © 2018年 majinxing. All rights reserved.
//

#import "StatisticalViewController.h"
#import "DYHeader.h"
#import "StatisticalTableViewCell.h"
#import "SelectSchoolViewController.h"
//#import "StatisticalResultModel.h"
#import "CalendarViewController.h"

#import "StatisticalResultModel.h"

#import "StatisticalSelfUIViewController.h"

@interface StatisticalViewController ()<UITableViewDelegate,UITableViewDataSource,StatisticalTableViewCellDelegate,UIPickerViewDelegate,UIPickerViewDataSource>
@property (nonatomic,strong)UITableView * tableView;
@property (nonatomic,strong)NSArray * titleAry;
@property (nonatomic,strong)NSMutableArray * textAry;

@property (nonatomic,strong)StatisticalResultModel * statistl;

@property (nonatomic,strong)UIButton * bView;//滚轮的背景

@property (nonatomic,strong) UIView * pickerView;


@property (nonatomic,assign) int temp;

@property (nonatomic,strong)NSMutableArray * statisticalAry;

@property (nonatomic,strong)NSArray *ary;

@property (nonatomic,strong)NSMutableArray * dataAry;

@end

@implementation StatisticalViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.view.backgroundColor = RGBA_COLOR(231, 231, 231, 1);
    
    [self setNavigationTitle];
    
    [self setTableView];
    
    _temp = 0;
    
    _dataAry = [NSMutableArray arrayWithCapacity:1];
    
    _ary = @[@"2017-8至2018-3学期",@"2018-3至2018-8学期",@"2018-8至2019-3学期",@"2019-3至2019-8学期",@"2019-8至2020-3学期"];
    
    _titleAry = @[@"选择开始时间",@"选择结束时间"];
    
    _textAry = [NSMutableArray arrayWithCapacity:1];
    
    for (int j = 0; j<3; j++) {
        [_textAry addObject:@""];
    }
}
-(void)viewWillAppear:(BOOL)animated{
    
    self.navigationController.navigationBarHidden = NO; //设置隐藏
    
}
-(void)setTableView{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, APPLICATION_WIDTH, APPLICATION_HEIGHT-64) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_tableView];
}
/**
 *  显示navigation的标题
 **/
-(void)setNavigationTitle{
    //    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
    self.title = @"统计";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark StatisticalTableViewCellDelegate
-(void)selectBtnPressedDelegate:(UIButton *)btn{
    
    
    [self showHudInView:self.view hint:NSLocalizedString(@"正在加载数据", @"Load data...")];
    
    NSDictionary * dict = [[NSDictionary alloc] initWithObjectsAndKeys:_textAry[0],@"startTime",_textAry[1],@"endTime", nil];
    
    [_dataAry removeAllObjects];
    
    [[NetworkRequest sharedInstance] POST: StatisticsSelf dict:dict succeed:^(id data) {
        NSString * str = [[data objectForKey:@"header"] objectForKey:@"code"];
        if (![UIUtils isBlankString:str]) {
            if ([str isEqualToString:@"0000"]) {
                
                NSArray * ary = [data objectForKey:@"body"];
                
                for (int i = 0; i<ary.count; i++) {
                    
                    StatisticalResultModel * s = [[StatisticalResultModel alloc] init];
                    
                    [s setValueWithDict:ary[i]];
                    
                    
                    [_dataAry addObject:s];
                }
                StatisticalSelfUIViewController * vc = [[StatisticalSelfUIViewController alloc] init];
                vc.dataAry = [NSMutableArray arrayWithArray:_dataAry];
                self.hidesBottomBarWhenPushed = YES;
                vc.startTime = _textAry[0];
                vc.endTime = _textAry[1];
                [self.navigationController pushViewController:vc animated:YES];
                
            }else{
                NSString * message = [[data objectForKey:@"header"] objectForKey:@"message"];
                [UIUtils showInfoMessage:message withVC:self];
            }
        }else{
            [UIUtils showInfoMessage:@"获取数据失败" withVC:self];
        }
        [self hideHud];
    } failure:^(NSError *error) {
        [UIUtils showInfoMessage:@"获取数据失败，请检查网络" withVC:self];
        [self hideHud];
    }];
    
}

#pragma mark UITableViewdelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 3;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    StatisticalTableViewCell * cell;
    if (indexPath.row ==2) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"StatisticalTableViewCellSecond"];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"StatisticalTableViewCell" owner:self options:nil] objectAtIndex:1];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }else{
        cell = [tableView dequeueReusableCellWithIdentifier:@"StatisticalTableViewCellFirst"];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"StatisticalTableViewCell" owner:self options:nil] objectAtIndex:0];
        }
        [cell addContentView:_titleAry[indexPath.row] withText:_textAry[indexPath.row]];
    }
    
    cell.delegate = self;
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self selectTime:(int)indexPath.row];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row ==2) {
        return 100;
    }
    return 60;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}
-(void)selectTime:(int)index{
    if (index==2) {
        return;
    }
    CalendarViewController * vc = [[CalendarViewController alloc] init];
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
    [vc returnText:^(NSString *str) {
        if (![UIUtils isBlankString:str]) {
            
            _textAry[index] = str;
            
            [_tableView reloadData];
        }
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
