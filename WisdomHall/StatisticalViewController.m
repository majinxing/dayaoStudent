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
    
    _titleAry = @[@"选择学期",@"选择开始时间",@"选择结束时间"];
    
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
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
    self.title = @"统计";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark UIPickViewDelegate

-(void)addPickView{
    [self.view endEditing: YES];
    if (!self.pickerView) {
        self.bView = [UIButton buttonWithType:UIButtonTypeCustom];
        self.bView.frame = CGRectMake(0, 0, APPLICATION_WIDTH, APPLICATION_HEIGHT);
        self.bView.backgroundColor = [UIColor blackColor];
        [self.bView addTarget:self action:@selector(outView) forControlEvents:UIControlEventTouchUpInside];
        self.bView.alpha = 0.5;
        self.pickerView = [[UIView alloc] initWithFrame:CGRectMake(0, APPLICATION_HEIGHT - 200 - 30, APPLICATION_WIDTH, 200 + 30)];
        
        UIPickerView * pickerViewD = [[UIPickerView alloc] initWithFrame:CGRectMake(0.0,30,APPLICATION_WIDTH,200)];
        pickerViewD.backgroundColor=[UIColor whiteColor];
        pickerViewD.delegate = self;
        pickerViewD.dataSource =  self;
        pickerViewD.showsSelectionIndicator = YES;
        self.pickerView.backgroundColor=[UIColor whiteColor];
        
        
        UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
        leftButton.frame = CGRectMake(0, 0, 50, 30);
        [leftButton setTitle:@"取消" forState:UIControlStateNormal];
        [leftButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [leftButton addTarget:self action:@selector(leftButton) forControlEvents:UIControlEventTouchUpInside];
        [self.pickerView addSubview:leftButton];
        
        UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        rightButton.frame = CGRectMake(APPLICATION_WIDTH - 50, 0, 50, 30);
        [rightButton setTitle:@"确认" forState:UIControlStateNormal];
        [rightButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [rightButton addTarget:self action:@selector(rightButton) forControlEvents:UIControlEventTouchUpInside];
        [self.pickerView addSubview:rightButton];
        [self.pickerView addSubview:pickerViewD];
    }
    [self.view addSubview:_bView];
    [self.view addSubview:self.pickerView];
}
-(void)outView{
    
    [self.bView removeFromSuperview];
    [self.pickerView removeFromSuperview];
    self.pickerView = nil;
    
}
-(void)leftButton{
    
    [self.bView removeFromSuperview];
    [self.pickerView removeFromSuperview];
    
    _temp = 0;
    
}
-(void)rightButton{
    
    [self.bView removeFromSuperview];
    
    [self.pickerView removeFromSuperview];
    
    _textAry[0] = _ary[_temp];
    
    [self.tableView reloadData];
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
    
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    
    return _ary.count;
    
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    
    return _ary[row];
    
    
    return @"";
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    _temp = (int)row;
}
#pragma mark StatisticalTableViewCellDelegate
-(void)selectBtnPressedDelegate:(UIButton *)btn{
    
    
    UserModel * user = [[Appsetting sharedInstance] getUsetInfo];
    
    
    [self showHudInView:self.view hint:NSLocalizedString(@"正在加载数据", @"Load data...")];
    
    NSDictionary * dict = [[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%@",user.peopleId],@"userId",[NSString stringWithFormat:@"%d",_temp+1],@"termId",_textAry[1],@"startTime",_textAry[2],@"endTime", nil];
    
    [_dataAry removeAllObjects];
    
    [[NetworkRequest sharedInstance] GET: StatisticsSelf dict:dict succeed:^(id data) {
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
                
                [self.navigationController pushViewController:vc animated:YES];
                
                self.hidesBottomBarWhenPushed = YES;
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
    
    return 4;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    StatisticalTableViewCell * cell;
    if (indexPath.row ==3) {
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
    if (indexPath.row ==3) {
        return 100;
    }
    return 60;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}
-(void)selectTime:(int)index{
    if (index == 0) {
        [self addPickView];
    }else{
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
