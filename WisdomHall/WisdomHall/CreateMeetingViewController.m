//
//  CreateMeetingViewController.m
//  WisdomHall
//
//  Created by XTU-TI on 2017/8/11.
//  Copyright © 2017年 majinxing. All rights reserved.
//

#import "CreateMeetingViewController.h"
#import "DYHeader.h"
#import "DefinitionPersonalTableViewCell.h"
#import "QueryMeetingRoomViewController.h"
#import "SelectPeopleToClassViewController.h"
#import "SignPeople.h"
#import "MeetingChooseSeatViewController.h"
#import "CalendarViewController.h"

@interface CreateMeetingViewController ()<UITableViewDelegate,UITableViewDataSource,UIPickerViewDelegate,UIPickerViewDataSource,DefinitionPersonalTableViewCellDelegate>
@property (nonatomic,strong)UITableView * tableView;
@property (nonatomic,strong)NSMutableArray * labelAry;
@property (nonatomic,strong)NSArray * labelSecAry;
@property (nonatomic,strong)NSMutableArray * textFileAry;
@property (nonatomic,strong)UIButton * bView;//滚轮的背景
@property (nonatomic,strong)UIView * pickerView;
@property (nonatomic,strong) NSMutableArray * selectPeopleAry;
@property (nonatomic,strong)SeatIngModel * seat;
@property (nonatomic,assign)int temp;//标志位判断选择的是哪一个滚轮
@property (nonatomic,assign)int year;
@property (nonatomic,assign)int month;
@property (nonatomic,assign)int day;
@property (nonatomic,assign)int hours;
@property (nonatomic,assign)int minutes;
@property (nonatomic,assign)int n;
@property (nonatomic,assign)int monthOrWeekCycle;
@property (nonatomic,strong)NSMutableArray * searAry;
@property (nonatomic,copy)NSString * seatTable;
@property (nonatomic,assign)BOOL cycle;
@end

@implementation CreateMeetingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    _year = 0;
    
    _month = 0;
    
    _day = 0;
    
    _n = 0;
    
    _hours = 0;
    
    _minutes = 0;
    
    _monthOrWeekCycle = 0;
    
    _selectPeopleAry = [NSMutableArray arrayWithCapacity:1];
    
    _searAry = [NSMutableArray arrayWithCapacity:1];
    
    [self setNavigationTitle];
    
    [self addTableView];
    
    [self keyboardNotification];
    
    
    // Do any additional setup after loading the view from its nib.
}
/**
 *  显示navigation的标题
 **/
-(void)setNavigationTitle{
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;

    self.title = @"创建会议";
    
    UIBarButtonItem *myButton = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(saveMeeting)];
    [myButton setTintColor:[UIColor whiteColor]];

    self.navigationItem.rightBarButtonItem = myButton;
    
    //    UIBarButtonItem * selection = [[UIBarButtonItem alloc] initWithTitle:@"搜索" style:UIBarButtonItemStylePlain target:self action:@selector(selectionBtnPressed)];
    //    self.navigationItem.leftBarButtonItem = selection;
}
-(void)saveMeeting{
    
    for (int i = 0; i<_textFileAry.count; i++) {
        if ([UIUtils isBlankString:_textFileAry[i]]) {
            UIAlertView * alter = [[UIAlertView alloc] initWithTitle:nil message:@"请填写完整会议信息" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alter show];
            return;
        }
    }
    NSMutableDictionary * dict = [[NSMutableDictionary alloc] init];
    
    UserModel  * user = [[Appsetting sharedInstance] getUsetInfo];
    
    [dict setObject:_textFileAry[0] forKey:@"name"];
    
    [dict setObject:@"0" forKey:@"pictureId"];
    if ([_textFileAry[2] isEqualToString:@"no"]) {
        NSMutableArray * ar = [UIUtils returnAry:_textFileAry[1] withEndTime:_textFileAry[1] room:_seat.seatTableId meetingsFacilitatorList:user.userName monthOrWeek:@""];
        [dict setObject:ar forKey:@"detailList"];
    }else{
        NSArray *aa = [_textFileAry[3] componentsSeparatedByString:@" "];
        if ([aa[1] isEqualToString:@"按周"]) {
            NSMutableArray * ar = [UIUtils returnAry:_textFileAry[1] withEndTime:aa[0] room:_seat.seatTableId meetingsFacilitatorList:user.userName monthOrWeek:@"week"];
            [dict setObject:ar forKey:@"detailList"];
        }else{
            NSMutableArray * ar = [UIUtils returnAry:_textFileAry[1] withEndTime:aa[0] room:_seat.seatTableId meetingsFacilitatorList:user.userName monthOrWeek:@"month"];
            [dict setObject:ar forKey:@"detailList"];
        }
    }
    
    
    NSDictionary * d = [UIUtils seatWithPeople:_selectPeopleAry withSeat:_searAry roomId:_seat.seatTableId];
    
    NSMutableArray * ary = [d objectForKey:@"peopleWithSeat"];
    
    [dict setObject:ary forKey:@"userList"];
    
    
    [self showHudInView:self.view hint:NSLocalizedString(@"正在提交数据", @"Load data...")];
    
    [[NetworkRequest sharedInstance] POST:CreateMeeting dict:dict succeed:^(id data) {
        NSString * str = [[data objectForKey:@"header"] objectForKey:@"message"];
        if ([str isEqualToString:@"成功"]) {
            // 2.创建通知
            NSNotification *notification =[NSNotification notificationWithName:@"UpdateTheMeetingPage" object:nil userInfo:nil];
            // 3.通过 通知中心 发送 通知
            
            [[NSNotificationCenter defaultCenter] postNotification:notification];
            
            UIAlertView * alter = [[UIAlertView alloc] initWithTitle:nil message:@"会议创建成功" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            
            [alter show];
            
//            [UIUtils sendMeetingInfo:sendDict]; 发送环信消息，提示会议创建成功
            
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [UIUtils showInfoMessage:@"系统错误"];
        }
        [self hideHud];

    } failure:^(NSError *error) {
        [self hideHud];
        [UIUtils showInfoMessage:@"创建失败，请检查网络"];
    }];
    
}
-(void)addTableView{
    _cycle = NO;
    _labelAry = [[NSMutableArray alloc] initWithObjects:@"会议主题",@"会议时间",@"会议周期",@"会议室",@"参加人员",nil];//2
    _textFileAry = [NSMutableArray arrayWithCapacity:1];

    for (int i = 0; i<5; i++) {
        [_textFileAry addObject:@""];
    }
    [_textFileAry setObject:@"no" atIndexedSubscript:2];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, APPLICATION_WIDTH, APPLICATION_HEIGHT-64) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    self.automaticallyAdjustsScrollViewInsets = NO;
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
        
        if (_temp == 1) {
            NSString * str = [UIUtils getTime];
            NSArray * ary = [str componentsSeparatedByString:@"-"];
            [pickerViewD selectRow:[ary[0] intValue]-2018 inComponent:0 animated:YES];
            [pickerViewD selectRow:[ary[1] intValue]-1 inComponent:1 animated:YES];
            [pickerViewD selectRow:[ary[2] intValue]-1 inComponent:2 animated:YES];
            _year = [ary[0] intValue]-2018;
            _month = [ary[1] intValue]-1;
            _day = [ary[2] intValue]-1;
        }
        
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
    self.pickerView = nil;
    if (_temp == 2) {
        [UIUtils showInfoMessage:@"请将信息选择完整"];
        _textFileAry[3] = @"";
        [_tableView reloadData];
    }
}
-(void)rightButton{
    [self.bView removeFromSuperview];
    [self.pickerView removeFromSuperview];
    self.pickerView = nil;
    if (_temp == 1) {
        NSString * m;
        if (_month<9) {
            m = [NSString stringWithFormat:@"0%d",_month+1];
        }else{
            m = [NSString stringWithFormat:@"%d",_month+1];
        }
        NSString * d;
        if (_day<9) {
            d = [NSString stringWithFormat:@"0%d",_day+1];
        }else{
            d = [NSString stringWithFormat:@"%d",_day+1];
        }
        NSString * h;
        if (_hours<9) {
            h = [NSString stringWithFormat:@"0%d",_hours+1];
        }else{
            h = [NSString stringWithFormat:@"%d",_hours+1];
        }
        NSString * ms;
        if (_minutes<9) {
            ms = [NSString stringWithFormat:@"0%d",_minutes+1];
        }else{
            ms = [NSString stringWithFormat:@"%d",_minutes+1];
        }
        [_textFileAry setObject:[NSString stringWithFormat:@"%d-%@-%@ %@:%@",_year+2018,m,d,h,ms] atIndexedSubscript:1];
        
        _year = 0;
        _month = 0;
        _day = 0;
        _hours = 0;
        _minutes = 0;
        [_tableView reloadData];
    }else if (_temp == 2){
        if (_monthOrWeekCycle == 0) {
            _textFileAry[3] = [NSString stringWithFormat:@"%@ 按周",_textFileAry[3]];
        }else{
            _textFileAry[3] = [NSString stringWithFormat:@"%@ 按月",_textFileAry[3]];
        }
        _monthOrWeekCycle = 0;
        [_tableView reloadData];
    }
}
/**
 * 键盘监听
 **/
-(void)keyboardNotification{
    //监听键盘出现和消失
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark 键盘出现
-(void)keyboardWillShow:(NSNotification *)note
{
    CGRect keyBoardRect=[note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, keyBoardRect.size.height, 0);
}
#pragma mark 键盘消失
-(void)keyboardWillHide:(NSNotification *)note
{
    self.tableView.contentInset = UIEdgeInsetsZero;
}
#pragma mark UIPickView
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    if (_temp == 1) {
        return 5;
    }else if (_temp == 2){
        return 1;
    }
    return 0;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (_temp == 1) {
        if (component == 0) {
            return 3;
        }else if (component == 1){
            return 12;
        }else if (component == 2){
            return 31;
        }else if (component == 3){
            return 24;
        }else if (component == 4){
            return 59;
        }
    }else if (_temp == 2){
        return 2;
    }
    return 0;
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (_temp == 1) {
        if (component == 0) {
            return [NSString stringWithFormat:@"%d",2018+row];
        }else if (component == 1){
            return [NSString stringWithFormat:@"%d月",1+row];
        }else if (component == 2){
            return [NSString stringWithFormat:@"%d日",1+row];
        }else if (component == 3){
            return [NSString stringWithFormat:@"%d点",1+row];
        }else if (component == 4){
            return [NSString stringWithFormat:@"%d分",1+row];
        }
    }else if (_temp ==2){
        if (row==0) {
            return @"按周";
        }else if (row ==1){
            return @"按月";
        }
    }
    return @"2016";
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (_temp == 1) {
        if (component == 0) {
            _year = (int)row;
        }else if (component == 1){
            _month = (int)row;
        }else if (component == 2){
            _day = (int)row;
        }else if (component == 3){
            _hours = (int)row;
        }else if (component == 4){
            _minutes = (int)row;
        }
    }else if(_temp == 2){
        if (row == 0) {
            _monthOrWeekCycle = 0;
        }else{
            _monthOrWeekCycle = 1;
        }
    }
}
#pragma mark DefinitionPersonalTableViewCellDelegate
-(void)textFileDidChangeForDPTableViewCellDelegate:(UITextField *)textFile{
    if (textFile.tag == 0) {
        [_textFileAry setObject:textFile.text atIndexedSubscript:textFile.tag];
    }
};
-(void)gggDelegate:(UIButton *)btn{
    [self.view endEditing:YES];
    NSString * str = _labelAry[btn.tag];
    if ([str isEqualToString:@"会议时间"]) {
        _temp = 1;
        [self addPickView];
    }else if ([str isEqualToString:@"会议室"]){
        QueryMeetingRoomViewController * q = [[QueryMeetingRoomViewController alloc] init];
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:q animated:YES];
        
        [q returnText:^(SeatIngModel *returnText) {
            
            if (returnText) {
                if (![UIUtils isBlankString:returnText.seatTableNamel]) {
//                    if (_textFileAry.count==5) {
//                       [_textFileAry setObject:returnText.seatTableNamel atIndexedSubscript:4];
//                    }else{
//                       [_textFileAry setObject:returnText.seatTableNamel atIndexedSubscript:3];
//                    }
                    [_textFileAry setObject:returnText.seatTableNamel atIndexedSubscript:btn.tag];
                    
                    _seat = returnText;
                    
                    if (![UIUtils isBlankString:_textFileAry[4]]) {
                        
                        NSMutableDictionary * dict = [UIUtils seatingArrangements:_seat.seatTable  withNumberPeople:[NSString stringWithFormat:@"%ld",(unsigned long)_selectPeopleAry.count]];
                        _seatTable = [dict objectForKey:@"newSeat"];
                        _searAry = [dict objectForKey:@"seatAry"];
                        
                        int allpeople = 0;
                        
                        for (int i = 0; i<_seat.seatColumn.count; i++) {
                            allpeople = [_seat.seatColumn[i] intValue]+allpeople;
                        }
                        
                        if (_selectPeopleAry.count>allpeople) {
                            UIAlertView * alter = [[UIAlertView alloc] initWithTitle:@"会议室座次不够" message:@"您选择的会议室的座位数少于参加会议的人数" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                            [alter show];
                        }
                        
                    }
                    
                    [_tableView reloadData];
                }
            }
        }];
    }else if ([str isEqualToString:@"参加人员"]){
        SelectPeopleToClassViewController * s = [[SelectPeopleToClassViewController alloc] init];
        
        self.hidesBottomBarWhenPushed = YES;
        
        s.selectPeople = [[NSMutableArray alloc] initWithArray:_selectPeopleAry];
        
        [self.navigationController pushViewController:s animated:YES];
        
        [s returnText:^(NSMutableArray *returnText) {
            
            [_selectPeopleAry removeAllObjects];

            for (int i = 0; i<returnText.count; i++) {
                
                SignPeople * s = returnText[i];
                
                int n = 0;
                
                for (int j = 0; j<_selectPeopleAry.count; j++) {
                    SignPeople * sp = _selectPeopleAry[j];
                    if ([[NSString stringWithFormat:@"%@",s.userId] isEqualToString:[NSString stringWithFormat:@"%@",sp.userId]]) {
                        n = 1;
                        break;
                    }
                }
                if (n == 0) {
                    [_selectPeopleAry addObject:s];
                }
            }
            if (_selectPeopleAry.count>0) {
                
                [_textFileAry setObject:[NSString stringWithFormat:@"已选择%ld人",(unsigned long)_selectPeopleAry.count] atIndexedSubscript:btn.tag];
                
                if (![UIUtils isBlankString:_textFileAry[3]]) {
                    
                    NSMutableDictionary * dict = [UIUtils seatingArrangements:_seat.seatTable  withNumberPeople:[NSString stringWithFormat:@"%ld",(unsigned long)_selectPeopleAry.count]];
                    _seatTable = [dict objectForKey:@"newSeat"];
                    _searAry = [dict objectForKey:@"seatAry"];
                    
                    int allpeople = 0;
                    
                    for (int i = 0; i<_seat.seatColumn.count; i++) {
                        allpeople = [_seat.seatColumn[i] intValue]+allpeople;
                    }
                    if (_selectPeopleAry.count>allpeople) {
                        [UIUtils showInfoMessage:@"您选择的会议室的座位数少于参加会议的人数"];
                    }
                }
                
                [_tableView reloadData];
            }else{
                [_textFileAry setObject:[NSString stringWithFormat:@"已选择0人"] atIndexedSubscript:btn.tag];
                
                [_tableView reloadData];
    
            }
            
        }];
    }else if([str isEqualToString:@"会议结束时间"]){
        CalendarViewController * vc = [[CalendarViewController alloc] init];
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
        [vc returnText:^(NSString *str) {
            if (![UIUtils isBlankString:str]) {
                
                [_textFileAry setObject:[NSString stringWithFormat:@""] atIndexedSubscript:btn.tag];
                
                [_textFileAry setObject:[NSString stringWithFormat:@"%@",str] atIndexedSubscript:btn.tag];
                
                [_tableView reloadData];
                
                _temp = 2;
                
                [self addPickView];
            }
        }];
    }
}
-(void)switchCycleDelegate:(UISwitch *)sender{
    if (sender.on) {
        [_labelAry insertObject:@"会议结束时间" atIndex:3];
        [_textFileAry insertObject:@"" atIndex:3];
        [_textFileAry setObject:@"yes" atIndexedSubscript:2];
    }else{
        [_labelAry removeObjectAtIndex:3];
        [_textFileAry removeObjectAtIndex:3];
        [_textFileAry setObject:@"no" atIndexedSubscript:2];
    }
    [_tableView reloadData];
}
-(void)seeSaetPressedDelegate{
    if ([UIUtils isBlankString:_seat.seatTable]) {
        UIAlertView * alter = [[UIAlertView alloc] initWithTitle:nil message:@"请先选择会议室" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alter show];
    }else if ([UIUtils isBlankString:_textFileAry[4]]){
        UIAlertView * alter = [[UIAlertView alloc] initWithTitle:nil message:@"请先选择参加会议的人员" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alter show];
    }else{
        MeetingChooseSeatViewController * z = [[MeetingChooseSeatViewController alloc] init];
        
        z.seatTable = _seatTable;
        
        self.hidesBottomBarWhenPushed = YES;
        
        [self.navigationController pushViewController:z animated:YES];
    }
    
}

#pragma mark UITableViewdelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (_labelAry.count>0) {
        return _labelAry.count+1;
    }
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DefinitionPersonalTableViewCell * cell ;
    if (indexPath.row<_labelAry.count&&indexPath.row!=2) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"DefinitionPersonalTableViewCellFirst"];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"DefinitionPersonalTableViewCell" owner:self options:nil] objectAtIndex:0];
        }
        
        
        [cell addMeetingContentView:_labelAry[indexPath.row] withTextFileText:_textFileAry[indexPath.row] withIndex:(int)indexPath.row];
        
    }else if (indexPath.row == _labelAry.count){
        cell = [tableView dequeueReusableCellWithIdentifier:@"DefinitionPersonalTableViewCellThird"];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"DefinitionPersonalTableViewCell" owner:self options:nil] objectAtIndex:2];
        }
        
    }else if (indexPath.row == 2){
        cell = [tableView dequeueReusableCellWithIdentifier:@"DefinitionPersonalTableViewCellFour"];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"DefinitionPersonalTableViewCell" owner:self options:nil] objectAtIndex:3];
        }
        [cell addSwitchState:_textFileAry[2]];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.delegate = self;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.view endEditing:YES];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
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
