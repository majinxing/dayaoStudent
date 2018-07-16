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
#import "StatisticalModel.h"
#import "CalendarViewController.h"
#import "StatisticalResultModel.h"
#import "StatisticalResultViewController.h"

@interface StatisticalViewController ()<UITableViewDelegate,UITableViewDataSource,StatisticalTableViewCellDelegate,UIPickerViewDelegate,UIPickerViewDataSource>
@property (nonatomic,strong)UITableView * tableView;
@property (nonatomic,strong)NSArray * titleAry;
@property (nonatomic,strong)NSMutableArray * textAry;
@property (nonatomic,strong)StatisticalModel * statistl;
@property (nonatomic,strong)UIButton * bView;//滚轮的背景

@property (nonatomic,assign) int temp;
@property (nonatomic,strong)NSMutableArray * statisticalAry;
@end

@implementation StatisticalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = RGBA_COLOR(231, 231, 231, 1);
    
    [self setNavigationTitle];
    
    [self setTableView];
    
    _statistl = [[StatisticalModel alloc] init];
    
    _temp = 0;
    
    _titleAry = @[@[@"选择院系",@"选择专业(选填)",@"选择班级(选填)"],
                  @[@"开始时间",@"结束时间"],
                  @[@"结果形式"]];
    
    _textAry = [[NSMutableArray alloc] init];
    
    _statisticalAry = [NSMutableArray arrayWithCapacity:1];
    
    for (int j = 0; j<3; j++) {
        NSMutableArray * ary = [[NSMutableArray alloc] initWithObjects:@"",@"",@"", nil];
        [_textAry addObject:ary];
    }
    _textAry[1][0] = [UIUtils getTime];
    
    _textAry[1][1] = [UIUtils getTime];
    
    _statistl.endTime = [UIUtils getTime];
    
    _statistl.startTime = [UIUtils getTime];
    
    UserModel * user = [[Appsetting sharedInstance] getUsetInfo];
    
    _textAry[0][0] = user.departmentsName;
    
    [_statistl.departmentsAry addObject:[NSString stringWithFormat:@"%@",user.departments]];
    
    
    
    _textAry[2][0] = @"按部门";
    // Do any additional setup after loading the view from its nib.
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
#pragma mark StatisticalTableViewCellDelegate
-(void)selectBtnPressedDelegate:(UIButton *)btn{
    if ([_statistl statisticalModelIsNil]) {
        NSMutableDictionary * dict = [_statistl returnDict];
        if (_temp==0) {
            [self showHudInView:self.view hint:NSLocalizedString(@"正在加载数据", @"Load data...")];
            
            [[NetworkRequest sharedInstance] POST:QuertyStatistics dict:dict succeed:^(id data) {
                //                NSLog(@"%@",data);
                
                NSArray * ary = [[data objectForKey:@"body"] objectForKey:@"list"];
                [_statisticalAry removeAllObjects];
                for (int i = 0; i<ary.count; i++) {
                    StatisticalResultModel * s = [[StatisticalResultModel alloc] init];
                    [s setValueWithDict:ary[i]];
                    [_statisticalAry addObject:s];
                }
                StatisticalResultViewController * vc = [[StatisticalResultViewController alloc] init];
                self.hidesBottomBarWhenPushed = YES;
                vc.statisticalResultAry = _statisticalAry;
                [self.navigationController pushViewController:vc animated:YES];
                [self hideHud];
            } failure:^(NSError *error) {
                [self hideHud];
                
                [UIUtils showInfoMessage:@"请检查网络状态"];
            }];
        }else if(_temp == 1){
            [self showHudInView:self.view hint:NSLocalizedString(@"正在加载数据", @"Load data...")];
            
            [[NetworkRequest sharedInstance] POST:QuertyClass dict:dict succeed:^(id data) {
                [self hideHud];
                
                NSArray * ary = [data objectForKey:@"body"];
                [_statisticalAry removeAllObjects];
                for (int i = 0; i<ary.count; i++) {
                    StatisticalResultModel * s = [[StatisticalResultModel alloc] init];
                    [s setValueWithDict:ary[i]];
                    [_statisticalAry addObject:s];
                }
                StatisticalResultViewController * vc = [[StatisticalResultViewController alloc] init];
                self.hidesBottomBarWhenPushed = YES;
                vc.statisticalResultAry = _statisticalAry;
                [self.navigationController pushViewController:vc animated:YES];
            } failure:^(NSError *error) {
                [self hideHud];
                [UIUtils showInfoMessage:@"请检查网络状态"];
            }];
        }else{
            [UIUtils showInfoMessage:@"请选择查询结果形式"];
        }
    }else{
        [UIUtils showInfoMessage:@"请把信息填写完整"];
    }
}
-(void)departmentPressedDelegate:(UIButton *)btn{
    _temp = 0;
    [_tableView reloadData];
}
-(void)classPressedDelegate:(UIButton *)btn{
    _temp =1;
    [_tableView reloadData];
}

#pragma mark UITableViewdelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 3;
    }else if (section == 1){
        return 2;
    }else if (section == 2){
        return 2;
    }
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    StatisticalTableViewCell * cell;
    
    if (indexPath.section == 2&&indexPath.row==1) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"StatisticalTableViewCellSecond"];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"StatisticalTableViewCell" owner:self options:nil] objectAtIndex:1];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }else if (indexPath.section==2&&indexPath.row == 0){
        cell = [tableView dequeueReusableCellWithIdentifier:@"StatisticalTableViewCellThird"];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"StatisticalTableViewCell" owner:self options:nil] objectAtIndex:2];
        }
        [cell addContentThirdView:_temp];
    }else{
        cell = [tableView dequeueReusableCellWithIdentifier:@"StatisticalTableViewCellFirst"];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"StatisticalTableViewCell" owner:self options:nil] objectAtIndex:0];
        }
        [cell addContentView:_titleAry[indexPath.section][indexPath.row] withText:_textAry[indexPath.section][indexPath.row]];
    }
    cell.delegate = self;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self selectTableViewCell:indexPath];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section ==2&&indexPath.row==1) {
        return 120;
    }
    return 60;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, APPLICATION_WIDTH, 20)];
    view.backgroundColor = RGBA_COLOR(236, 236, 236, 1);
    UILabel * l = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 100, 20)];
    l.font = [UIFont systemFontOfSize:14];
    [view addSubview:l];
    
    if (section == 0) {
        
        l.text = @"部门";
        return view;
    }else if(section == 1){
        
        l.text = @"时间段";
        return view;
    }
    return nil;
}
-(void)selectTableViewCell:(NSIndexPath *)indexPath{
    if (indexPath.section==0&&indexPath.row==0) {
        SelectSchoolViewController * s = [[SelectSchoolViewController alloc] init];
        s.selectType = SelectDepartment;
        s.s = [[SchoolModel alloc] init];
        s.s.schoolId = @"500";
        s.typeSelect = @"statistical";
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:s animated:YES];
        [s returnText:^(SchoolModel *returnText) {
            if (returnText) {
                [self.view endEditing:YES];
                if (![UIUtils isBlankString:[NSString stringWithFormat:@"%@",returnText.departmentId]]) {
                    [_statistl.departmentsAry removeAllObjects];
                    [_statistl.departmentsAry addObject:[NSString stringWithFormat:@"%@",returnText.departmentId]];
                    _textAry[0][0] = returnText.department;
                    [_statistl.professional removeAllObjects];
                    [_statistl.theClass removeAllObjects];
                    _textAry[0][1] = @"";
                    _textAry[0][2] = @"";
                    [_tableView reloadData];
                }
            }
        }];
    }else if (indexPath.section == 0&&indexPath.row ==1){
        if (_statistl.departmentsAry.count>0) {
            SelectSchoolViewController * s = [[SelectSchoolViewController alloc] init];
            s.selectType = SelectMajor;
            s.s = [[SchoolModel alloc] init];
            s.s.departmentId = _statistl.departmentsAry[0];
            s.typeSelect = @"statistical";
            self.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:s animated:YES];
            [s returnText:^(SchoolModel *returnText) {
                if (returnText) {
                    [self.view endEditing:YES];
                    if ((![UIUtils isBlankString:returnText.major])&&[returnText.major isEqualToString:@"所有专业"]) {
                        
                        [_statistl.professional removeAllObjects];
                        [_statistl.professional addObjectsFromArray:s.allIdAry];
                        _textAry[0][1] = returnText.major;
                        [_tableView reloadData];
                        
                    }else if (![UIUtils isBlankString:returnText.major]) {
                        [_statistl.professional removeAllObjects];
                        [_statistl.professional addObject:[NSString stringWithFormat:@"%@",returnText.majorId]];
                        _textAry[0][1] = returnText.major;
                        [_tableView reloadData];
                    }
                }
            }];
        }else{
            [UIUtils showInfoMessage:@"请先选择院系"];
        }
    }else if (indexPath.section == 0&&indexPath.row == 2){
        if(_statistl.professional.count>0){
            SelectSchoolViewController * s = [[SelectSchoolViewController alloc] init];
            s.selectType = SelectClass;
            s.s = [[SchoolModel alloc] init];
            s.s.majorId = _statistl.professional[0];
            s.typeSelect = @"statistical";
            if (_statistl.professional.count>1) {
                [UIUtils showInfoMessage:@"查询单一专业才可以选择班级"];
                return;
            }
            self.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:s animated:YES];
            [s returnText:^(SchoolModel *returnText) {
                if (returnText) {
                    [self.view endEditing:YES];
                    if (![UIUtils isBlankString:returnText.sclass]&&[returnText.sclass isEqualToString:@"所有班级"]) {
                            [_statistl.theClass removeAllObjects];
                            [_statistl.theClass addObjectsFromArray:s.allIdAry];
                            _textAry[0][2] = returnText.sclass;
                            [_tableView reloadData];
                        
                    }else if (![UIUtils isBlankString:[NSString stringWithFormat:@"%@",returnText.sclassId]]) {
                        [_statistl.theClass removeAllObjects];
                        [_statistl.theClass addObject:[NSString stringWithFormat:@"%@",returnText.sclassId]];
                        _textAry[0][2] = returnText.sclass;
                        [_tableView reloadData];
                    }
                }
            }];
        }else{
            [UIUtils showInfoMessage:@"请先选择专业"];
        }
    }else if (indexPath.section==1&&indexPath.row==0){
        CalendarViewController * vc = [[CalendarViewController alloc] init];
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
        [vc returnText:^(NSString *str) {
            if (![UIUtils isBlankString:str]) {
                _textAry[1][0] = str;
                _statistl.startTime = str;
                [_tableView reloadData];
            }
        }];
    }else if (indexPath.section==1&&indexPath.row==1){
        CalendarViewController * vc = [[CalendarViewController alloc] init];
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
        [vc returnText:^(NSString *str) {
            if (![UIUtils isBlankString:str]) {
                _textAry[1][1] = str;
                _statistl.endTime = str;
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
