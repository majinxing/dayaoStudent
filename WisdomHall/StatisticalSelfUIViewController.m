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


@interface StatisticalSelfUIViewController ()<UIPickerViewDelegate,UIPickerViewDataSource,UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UIButton * bView;//滚轮的背景
@property (strong, nonatomic) IBOutlet UIButton *selectT;
@property (nonatomic,strong) UIView * pickerView;
@property (nonatomic,strong) UITableView * tableView;
@property (nonatomic,strong) NSArray * ary;
@property (nonatomic,assign) int temp;
@property (nonatomic,strong) NSMutableArray * dataAry;

@property (nonatomic,assign)int yesr;
@property (nonatomic,assign)int moth;
@property (nonatomic,assign)int day;

@property (nonatomic,assign) int  pickTemp;

@property (nonatomic,copy)NSString * startTime;

@property (nonatomic,copy)NSString * endTime;

@end

@implementation StatisticalSelfUIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    _ary = @[@"2017-8至2018-3学期",@"2018-3至2018-8学期",@"2018-8至2019-3学期",@"2019-3至2019-8学期",@"2019-8至2020-3学期"];
    
    _temp = 0;
    
    _pickTemp = 1;
    
    _yesr = 0;
    
    _moth = 0;
    
    _day = 0;
    
    _dataAry = [NSMutableArray arrayWithCapacity:1];
    
    [self addTableView];
    // Do any additional setup after loading the view from its nib.
}
-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = NO; //设置隐藏
}
-(void)getDataWith:(NSString *)t{
    
    UserModel * user = [[Appsetting sharedInstance] getUsetInfo];
    
    NSDictionary * dict = [[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%@",user.peopleId],@"userId",t,@"termId",_startTime,@"startTime",_endTime,@"endTime", nil];
    
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
            }
        }else{
            [UIUtils showInfoMessage:@"获取数据失败" withVC:self];
        }
        
        [_tableView reloadData];
    } failure:^(NSError *error) {
        [UIUtils showInfoMessage:@"获取数据失败，请检查网络" withVC:self];
    }];
}
- (IBAction)querySelf:(UIButton *)sender {
    
    [self addPickView];
}
-(void)addTableView{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_selectT.frame), APPLICATION_WIDTH, APPLICATION_HEIGHT-64-_selectT.frame.size.height) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
}
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
    _yesr = 0;
    _moth = 0;
    _day = 0;
}
-(void)rightButton{
    
    [self.bView removeFromSuperview];
    
    [self.pickerView removeFromSuperview];
    
    _bView = nil;
    
    _pickerView = nil;
    
    if (_pickTemp == 1) {
        
        [_selectT setTitle:_ary[_temp] forState:UIControlStateNormal];
        
        _pickTemp = 2;
        
        [self addPickView];
        
    }else if (_pickTemp == 2){
        if (_moth<9) {
            _startTime = [NSString stringWithFormat:@"%d-0%d",2017+_yesr,_moth];
            if (_day<9) {
                _startTime = [_startTime stringByAppendingString:[NSString stringWithFormat:@"-0%d",_day]];
            }else{
                _startTime = [_startTime stringByAppendingString:[NSString stringWithFormat:@"-%d",_day]];
            }
        }else{
            _startTime = [NSString stringWithFormat:@"%d-%d",2017+_yesr,_moth+1];
            if (_day<9) {
                _startTime = [_startTime stringByAppendingString:[NSString stringWithFormat:@"-0%d",_day+1]];
            }else{
                _startTime = [_startTime stringByAppendingString:[NSString stringWithFormat:@"-%d",_day+1]];
            }
        }
        _yesr = 0;
        _moth = 0;
        _day = 0;
        
        _pickTemp = 3;
        [self addPickView];
    }else if(_pickTemp == 3){
        if (_moth<9) {
            _endTime = [NSString stringWithFormat:@"%d-0%d",2017+_yesr,_moth+1];
            if (_day<9) {
                _endTime = [_endTime stringByAppendingString:[NSString stringWithFormat:@"-0%d",_day+1]];
            }else{
                _endTime = [_endTime stringByAppendingString:[NSString stringWithFormat:@"-%d",_day+1]];
            }
        }else{
            _endTime = [NSString stringWithFormat:@"%d-%d",2017+_yesr,_moth+1];
            if (_day<9) {
                _endTime = [_endTime stringByAppendingString:[NSString stringWithFormat:@"-0%d",_day+1]];
            }else{
                _endTime = [_endTime stringByAppendingString:[NSString stringWithFormat:@"-%d",_day+1]];
            }
        }
        _yesr = 0;
        
        _moth = 0;
        
        _day = 0;
        
        _pickTemp = 1;
        
        [self getDataWith:[NSString stringWithFormat:@"%d",_temp+1]];
        
        _temp = 0;

        
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark UIPickViewDelegate

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    if (_pickTemp == 1) {
        return 1;
    }else{
        return 3;
    }
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (_pickTemp == 1) {
        return _ary.count;
    }else{
        if (component == 0) {
            return 3;
        }else if(component == 1){
            return 12;
        }else if (component ==2){
            return 31;
        }
    }
    return 0;
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (_pickTemp == 1) {
        if (row<_ary.count) {
            return _ary[row];
        }
    }else{
        if (component == 0) {
            return [NSString stringWithFormat:@"%ld",2017+row];
        }else if(component == 1){
            return [NSString stringWithFormat:@"%ld",1+row];
        }else if (component ==2){
            return [NSString stringWithFormat:@"%ld",1+row];
        }
    }
    
    return @"";
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (_pickTemp == 1) {
        _temp = (int)row;
    }else{
        if (component == 0) {
            _yesr = (int)row;
        }else if(component == 1){
            _moth = (int)row;
        }else if (component ==2){
            _day = (int)row;
        }
    }
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
    
    [cell addContentView:s];
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 120;
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
