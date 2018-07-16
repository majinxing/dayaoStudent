//
//  MJXSetRemindersViewController.m
//  XinSuiFang
//
//  Created by majinxing on 16/9/20.
//  Copyright © 2016年 majinxing. All rights reserved.
//

#import "MJXSetRemindersViewController.h"
#import "MJXRootViewController.h"
#import "MJXRemindTableViewCell.h"
#import "MJXPatientsInfoViewController.h"
#import "MJXTemplate.h"
@interface MJXSetRemindersViewController ()<UITableViewDelegate,UITableViewDataSource,remindTableViewCellDelegate,UIPickerViewDelegate,UIPickerViewDataSource>
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)NSMutableArray *showArray;//展示数据的数组
@property (nonatomic,strong)NSString *buttonTitle;//显示时间
@property (nonatomic,strong)NSMutableArray *year;
@property (nonatomic,strong)NSString *times;//临时的时间节点
@property (nonatomic,strong)UIView *pickerView;
@property (nonatomic,strong)NSMutableArray *allFutureTime;
@property (nonatomic,strong)NSMutableArray *isOKArray;
@property (nonatomic,assign)int yeatInt;
@property (nonatomic,assign)int monthInt;
@property (nonatomic,assign)int dayInt;

@end

@implementation MJXSetRemindersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [MJXUIUtils addNavigationWithView:self.view withTitle:@"设置提醒"];
    self.view.backgroundColor = [UIColor whiteColor];
    [self addBackButton];
    _allFutureTime = [NSMutableArray arrayWithCapacity:10];
    _isOKArray = [NSMutableArray arrayWithCapacity:10];
    _buttonTitle = [NSString stringWithFormat:@"选择基准日期"];
    _year = [NSMutableArray arrayWithCapacity:10];
    _showArray = [NSMutableArray arrayWithCapacity:10];
    
    for (int i=0; i<60; i++) {
        [_year setObject:[NSString stringWithFormat:@"%d",2000+i] atIndexedSubscript:i];
    }
    
    [self arrayTheSortingWithArray:_timeAdviceArray];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, APPLICATION_WIDTH, APPLICATION_HEIGHT-64-50) style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    
    UIButton *sureToSend = [UIButton buttonWithType:UIButtonTypeCustom];
    sureToSend.frame = CGRectMake(0, APPLICATION_HEIGHT-50, APPLICATION_WIDTH, 50);
    [sureToSend addTarget:self action:@selector(sendFutureTime) forControlEvents:UIControlEventTouchUpInside];
    [sureToSend setBackgroundImage:[UIImage imageNamed:@"fas"] forState:UIControlStateNormal];
    [self.view addSubview:sureToSend];
    
    // Do any additional setup after loading the view.
}
/**
 * 确定发送
**/
-(void)sendFutureTime{
    if ([_buttonTitle isEqualToString:@"选择基准日期"]) {
        UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@""
                                                      message:@"请选择基准日期"
                                                     delegate:self
                                            cancelButtonTitle:@"确认"
                                            otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    AFHTTPRequestOperationManager *manger = [MJXClient setAFHTTPRequestOperationManagerSomeQuality];
    NSString *url = [NSString stringWithFormat:@"%@/followup/addPlan",MJXBaseURL];
    NSMutableArray *ary = [NSMutableArray arrayWithCapacity:10];
    for (int i=0; i<_allFutureTime.count; i++) {
        MJXTemplate *tt = _timeAdviceArray[i];
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        [dict setValue:tt.advice forKey:@"content"];
        [dict setValue:_allFutureTime[i] forKey:@"sendDate"];
        [dict setValue:_isOKArray[i] forKey:@"isOK"];
        [ary addObject:dict];
        
    }
    
    [manger POST:url parameters:@{
                                  @"username":[[MJXAppsettings sharedInstance] getUserPhone],
                                  @"patientId": _patients.patientId,
                                  @"baseDate" : _buttonTitle,
                                  @"name": _templateName,
                                  @"node": ary
                                 } success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                     if ([[responseObject objectForKey:@"statusCode"] isEqualToString:@"200"]) {
                                         for (UIViewController *controller in self.navigationController.viewControllers) {
                                             if ([controller isKindOfClass:[MJXPatientsInfoViewController class]]) {
                                                 [self.navigationController popToViewController:controller animated:YES];
                                             }
                                         }
                                         
                                     }
                                 } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                     NSLog(@"1");
                                 }];
}

-(void)arrayTheSortingWithArray:(NSMutableArray *)ary{
    for (int i=0; i<_timeAdviceArray.count; i++) {
        MJXTemplate *one = _timeAdviceArray[i];
        for (int j=i+1; j<_timeAdviceArray.count; j++) {
            MJXTemplate *t = _timeAdviceArray[j];
            int a = [t.timeYear intValue]*356+[t.timeMonth intValue]*30+[t.timeDay intValue]+[t.timeWeeks intValue]*7;
            int b = [one.timeYear intValue]*356+[one.timeMonth intValue]*30+[one.timeDay intValue]+[one.timeWeeks intValue]*7;
            if (b>a) {
                MJXTemplate *a = _timeAdviceArray[i];
                [_timeAdviceArray setObject:_timeAdviceArray[j] atIndexedSubscript:i];
                [_timeAdviceArray setObject:a atIndexedSubscript:j];
                one = _timeAdviceArray[i];
            }
        }
    }
}
-(void)addBackButton{
    UIImageView *backImage = [[UIImageView alloc] initWithFrame:CGRectMake(20, 20+15, 7, 15)];
    backImage.image = [UIImage imageNamed:@"return"];
    [self.view addSubview:backImage];
    UIButton *back = [UIButton buttonWithType:UIButtonTypeCustom];
    back.frame = CGRectMake(0,20,60, 44);
    [back addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:back];
    
}

-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
}
/**
 *  获取当地日期
 */
-(NSString *)getCurrentDate
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    int unit = NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    
    //获得当前时间的年月日时分
    NSDateComponents *nowCmps = [calendar components:unit fromDate:[NSDate date]];
    NSString *nowDate = [NSString stringWithFormat:@"%ld-%ld-%ld",nowCmps.year,nowCmps.month,nowCmps.day];
    return nowDate;
}
-(NSDateComponents *)getnowDate
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    int unit = NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    
    //获得当前时间的年月日时分
    NSDateComponents *nowCmps = [calendar components:unit fromDate:[NSDate date]];
    //NSString *nowDate = [NSString stringWithFormat:@"%ld-%ld-%ld",nowCmps.year,nowCmps.month,nowCmps.day];
    return nowCmps;
}
//计算天数后的新日期
- (NSString *)computeDateWithDays:(NSInteger)days withTime:(NSString *)time
{
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *myDate = [dateFormatter dateFromString:time];
    NSDate *newDate = [myDate dateByAddingTimeInterval:60 * 60 * 24 * days];
    
    return [dateFormatter stringFromDate:newDate];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark UITableViewdelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==0) {
        return 1;
    }
    return _showArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MJXRemindTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!cell) {
        cell=[[MJXRemindTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    }
    if (indexPath.section==0) {
        [cell addTimeButtonWithButtonTitle:_buttonTitle];
        cell.delegate = self;
    }
    else if (indexPath.section==1){
        MJXTemplate *one = _showArray[indexPath.row];
        NSString *str = [[NSString alloc] init];
        if ([one.timeStr isEqualToString:@"D"]) {
            str = @"天";
        }else if ([one.timeStr isEqualToString:@"M"]){
            str = @"月";
        }else if ([one.timeStr isEqualToString:@"W"]){
            str = @"周";
        }else if ([one.timeStr isEqualToString:@"Y"]){
            str = @"年";
        }
        [cell addInformTheContentWithSendTime:one.futureTime withTime:[NSString stringWithFormat:@"%@%@%@%@%@",one.timeYear,one.timeMonth,one.timeWeeks,one.timeDay,str] withPatientName:_patients.patientsName];
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.section==0) {
        MJXRemindTableViewCell *cell = (MJXRemindTableViewCell *)[self tableView:tableView cellForRowAtIndexPath:indexPath];
        return cell.height;
    }
    return 100;
}

#pragma mrak remindTableViewCellDelegate
-(void)chanageTimeButtonPressed:(UIButton *)btn{
    [self addPickView];
}
#pragma mark addPickView
-(void)addPickView{
    self.pickerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, APPLICATION_WIDTH,APPLICATION_HEIGHT)];
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, APPLICATION_WIDTH,APPLICATION_HEIGHT)];
    backView.backgroundColor =[UIColor blackColor];
    backView.alpha = 0.8;
    [self.pickerView addSubview:backView];
    UIView *pickerView = [[UIView alloc] initWithFrame:CGRectMake(0, APPLICATION_HEIGHT - 150 - 30, APPLICATION_WIDTH, 150 + 30)];
    [self.pickerView addSubview:pickerView];
    
    UIPickerView * pickerViewD = [[UIPickerView alloc] initWithFrame:CGRectMake(0.0,30,APPLICATION_WIDTH,150)];
    pickerViewD.backgroundColor=[UIColor whiteColor];
    pickerViewD.delegate = self;
    pickerViewD.dataSource =  self;
    pickerViewD.showsSelectionIndicator = YES;
    NSDateComponents *d = [self getnowDate];
    [pickerViewD selectRow:d.year-2000 inComponent:0 animated:NO];
    [pickerViewD selectRow:d.month-1 inComponent:1 animated:NO];
    [pickerViewD selectRow:d.day-1 inComponent:2 animated:NO];
    
    pickerView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:self.pickerView];
    
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.frame = CGRectMake(0, 0, 50, 30);
    [leftButton setTitle:@"取消" forState:UIControlStateNormal];
    [leftButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(leftButton) forControlEvents:UIControlEventTouchUpInside];
    [pickerView addSubview:leftButton];
    
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.frame = CGRectMake(APPLICATION_WIDTH - 50, 0, 50, 30);
    [rightButton setTitle:@"确认" forState:UIControlStateNormal];
    [rightButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(rightButton) forControlEvents:UIControlEventTouchUpInside];
    [pickerView addSubview:rightButton];
    [pickerView addSubview:pickerViewD];
    
}
-(void)leftButton{
    [self.pickerView removeFromSuperview];
}
-(void)rightButton{
    [self.pickerView removeFromSuperview];
    [_showArray removeAllObjects];
    [_isOKArray removeAllObjects];
    [_allFutureTime removeAllObjects];
    if (_times.length>0) {
        _buttonTitle=_times;
    }else{
        _buttonTitle = [NSString stringWithFormat:@"%@",[self getCurrentDate]];
        NSDateComponents *d = [self getnowDate];
        _yeatInt = (int)d.year ;
        _monthInt = (int)d.month;
        _dayInt = (int)d.day;
    }
    for (int i=0; i<_timeAdviceArray.count; i++) {
        MJXTemplate *one = _timeAdviceArray[i];
        int n = [one.timeDay intValue]+[one.timeWeeks intValue]*7+[one.timeMonth intValue]*30+[one.timeYear intValue]*356;
        NSString *fTime = [self getTimeStr:_yeatInt withMonth:_monthInt withDay:_dayInt];
        
        NSString * str1 = [self computeDateWithDays:n withTime:fTime];
        
        NSDateComponents *d = [self getnowDate];
        NSString *nowTime = [self getTimeStr:(int)d.year withMonth:(int)d.month withDay:(int)d.day];
        [_allFutureTime addObject:str1];
        if ([str1 compare:nowTime]==NSOrderedAscending) {
            NSLog(@"%@",str1);//小
            [_isOKArray addObject:@"1"];
        }else{
            one.futureTime = str1;
            [_showArray addObject:one];
            [_isOKArray addObject:@"0"];
        }
    
    }
    [_tableView reloadData];
    _times = @"";
}
-(NSString *)getTimeStr:(int)year withMonth:(int)month withDay:(int)day{
    NSString *m = [[NSString alloc] init];
    if (month<10) {
        m = [NSString stringWithFormat:@"0%d",month];
    }else{
        m = [NSString stringWithFormat:@"%d",month];
    }
    NSString *d = [[NSString alloc] init];
    if (day<10) {
        d = [NSString stringWithFormat:@"0%d",day];
    }else{
        d = [NSString stringWithFormat:@"%d",day];
    }
    NSString *timeStr = [NSString stringWithFormat:@"%d-%@-%@",year,m,d];
    return timeStr;
}
#pragma mark UIPickerViewDelegate

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 3;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component==0) {
        return [_year count];
    }if (component==1) {
        return 12;
    }else if (component==2)
    {
        return 30;
    }
    return 0;
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    
    if (component==0) {
        return [_year objectAtIndex:row];
    }else if (component==1){
        return [NSString stringWithFormat:@"%ld",(long)row+1];
    }else if (component==2)
    {
        return [NSString stringWithFormat:@"%ld",(long)row+1];
    }
    return 0;
    
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    NSDateComponents *d = [self getnowDate];
    NSString *year = [NSString stringWithFormat:@"%ld",d.year];
    NSString *month = [NSString stringWithFormat:@"%ld",d.month];
    NSString *day = [NSString stringWithFormat:@"%ld",d.day];
    if (component==0) {
        year =  [NSString stringWithFormat:@"%@",_year[row]];
    }else if(component==1){
        month = [NSString stringWithFormat:@"%ld",row+1];
    }else{
        day = [NSString stringWithFormat:@"%ld",row+1];
    }
    _times = [NSString stringWithFormat:@"%@-%@-%@",year,month,day];
    _yeatInt = [year intValue];
    _monthInt = [month intValue];
    _dayInt = [day intValue];
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
