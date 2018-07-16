//
//  CreateCourseViewController.m
//  WisdomHall
//
//  Created by XTU-TI on 2017/5/3.
//  Copyright © 2017年 majinxing. All rights reserved.
//

#import "CreateCourseViewController.h"
#import "DYHeader.h"
#import "DefinitionPersonalTableViewCell.h"
#import "SelectClassRoomViewController.h"
#import "ClassRoomModel.h"
#import "SelectPeopleToClassViewController.h"
#import "SignPeople.h"

@interface CreateCourseViewController ()<UITableViewDelegate,UITableViewDataSource,DefinitionPersonalTableViewCellDelegate,UIPickerViewDelegate,UIPickerViewDataSource>
@property (nonatomic,strong)UITableView * tabelView;
@property (nonatomic,strong)NSMutableArray * labelAry;
@property (nonatomic,strong)NSMutableArray * textFileAry;
@property (nonatomic,strong)UIButton * bView;//滚轮的背景
@property (nonatomic,strong)UIView * pickerView;
@property (nonatomic,assign)int temp;//标志位判断选择的是哪一个滚轮
@property (nonatomic,assign) int n;
@property (nonatomic,assign) int m1;
@property (nonatomic,assign) int m11;
@property (nonatomic,assign) int m2;
@property (nonatomic,assign) int m22;
@property (nonatomic,assign) int m3;
@property (nonatomic,assign) int m33;
@property (nonatomic,assign) int week;
@property (nonatomic,assign) int week1;
@property (nonatomic,assign) int class1;
@property (nonatomic,assign) int class11;
@property (nonatomic,assign) int class2;
@property (nonatomic,assign) int class22;
@property (nonatomic,assign) int year;
@property (nonatomic,assign) int year1;
@property (nonatomic,assign) int month;
@property (nonatomic,assign) int month1;
@property (nonatomic,assign) int day;
@property (nonatomic,assign) int day1;

@property (nonatomic,strong) ClassRoomModel * classRoom;
@property (nonatomic,strong) NSMutableArray * selectPeopleAry;

@property (nonatomic,strong) NSMutableArray * classAry1;
@property (nonatomic,strong) NSMutableArray * classAry2;
@property (nonatomic,strong) NSMutableArray * weekAry;

@property (nonatomic,assign) int numberClass;//一天有多少节课

@property (nonatomic,strong) UserModel * userModel;
@end

@implementation CreateCourseViewController

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _n = 0;
    _m1 = 0;
    _m2 = 0;
    _m3 = 0;
    _week = 0;
    _class1 = 0;
    _class2 = 0;
    _year = 0;
    _month = 0;
    _day = 0;
    _userModel = [[Appsetting sharedInstance] getUsetInfo];
    
    _selectPeopleAry = [NSMutableArray arrayWithCapacity:1];
    _classAry1 = [NSMutableArray arrayWithCapacity:1];
    _classAry2 = [NSMutableArray arrayWithCapacity:1];
    _weekAry = [NSMutableArray arrayWithCapacity:1];
    for (int i = 0; i<12; i++) {
        NSString * s = [NSString stringWithFormat:@"第%d节开始",i+1];
        [_classAry1 addObject:s];
        NSString * s1 = [NSString stringWithFormat:@"第%d节结束",i+1];
        [_classAry2 addObject:s1];
        
        if (i<7) {
            NSString * a = [NSString stringWithFormat:@"星期%d",i+1];
            [_weekAry addObject:a];
        }
    }
    [self setNavigationTitle];
    [self addTabelView];
    [self keyboardNotification];
    [self quertyNumberClass];
    // Do any additional setup after loading the view from its nib.
}

-(void)addTabelView{
    _labelAry = [[NSMutableArray alloc] initWithObjects:@"课堂封面",@"课  程  名",@"老师姓名",@"签到方式",@"上课的人",@"教      室", @"课程周期",@"第一周星期一日期",@"上课时间列表",nil];
    _textFileAry = [NSMutableArray arrayWithCapacity:4];
    for (int i = 0; i<9; i++) {
        [_textFileAry addObject:@""];
    }
    [_textFileAry setObject:@"头像" atIndexedSubscript:0];
    
    _tabelView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, APPLICATION_WIDTH, APPLICATION_HEIGHT-64) style:UITableViewStylePlain];
    self.automaticallyAdjustsScrollViewInsets = NO;
    _tabelView.dataSource = self;
    _tabelView.delegate = self;
    [self.view addSubview:_tabelView];
}
-(void)quertyNumberClass{
    NSDictionary * dict = [[NSDictionary alloc] initWithObjectsAndKeys:_userModel.school,@"universityId", nil];
    [[NetworkRequest sharedInstance] GET:QuertyClassNumber dict:dict succeed:^(id data) {

    } failure:^(NSError *error) {
        
    }];
}
/**
 * 键盘监听
 **/
-(void)keyboardNotification{
    //监听键盘出现和消失
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    //点击屏幕 回收键盘
    [self.view endEditing:YES];
}
/**
 *  显示navigation的标题
 **/
-(void)setNavigationTitle{
//    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
  
    self.title = @"创建课堂";
    UIBarButtonItem *myButton = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(createAcourse)];
    self.navigationItem.rightBarButtonItem = myButton;
}
-(void)createAcourse{
   NSDictionary * dict = [UIUtils createCourseWith:_textFileAry ClassRoom:_classRoom joinClassPeople:_selectPeopleAry m1:_m11 m2:_m22 m3:_m33 week:_week class1:_class1 class2:_class2];
    [self showHudInView:self.view hint:NSLocalizedString(@"正在创建课程", @"Load data...")];
    [[NetworkRequest sharedInstance] POST:CreateCoures dict:dict succeed:^(id data) {
        NSLog(@"%@",data);
        NSString * str = [[data objectForKey:@"header"] objectForKey:@"message"];
        if ([str isEqualToString:@"成功"]) {
            // 2.创建通知
            NSNotification *notification =[NSNotification notificationWithName:@"UpdateTheClassPage" object:nil userInfo:nil];
            // 3.通过 通知中心 发送 通知
            
            [[NSNotificationCenter defaultCenter] postNotification:notification];
            
            [UIUtils showInfoMessage:@"创建成功" withVC:self];
            [self dismissViewControllerAnimated:YES completion:^{
                [self.navigationController popViewControllerAnimated:YES];
            }];
            
            
            
        }else if ([str isEqualToString:@"系统错误"]){
            [UIUtils showInfoMessage:@"系统错误" withVC:self];
        }else{
            [UIUtils showInfoMessage:@"创建失败，请填写完整课堂信息并且按照提示的格式" withVC:self];
        }
        [self hideHud];
    } failure:^(NSError *error) {
        
        [UIUtils showInfoMessage:@"发送数据失败，请检查网络" withVC:self];

        [self hideHud];
    }];
    
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
    self.pickerView = nil;
}
-(void)rightButton{
    [self.bView removeFromSuperview];
    [self.pickerView removeFromSuperview];
    self.pickerView = nil;
    if (_temp == 3) {
        if (_n==0) {
            [_textFileAry setObject:@"一键签到" atIndexedSubscript:3];
        }else if(_n==1){
            [_textFileAry setObject:@"照片签到" atIndexedSubscript:3];
        }
        _n = 0;
    }else if (_temp == 6){
        NSString * str1;
        NSString * str2;
        NSString * str3;
        if (_m1 == 0) {
            str1 = [NSString stringWithFormat:@"1"];
        }else if(_m1!=0){
            str1 =  [NSString stringWithFormat:@"%d",_m1+1];
        }
     
        if (_m2 == 0) {
            str2 = [NSString stringWithFormat:@"1"];
        }else if(_m2!=0){
            str2 =  [NSString stringWithFormat:@"%d",_m2+1];
        }
        if (_m3 == 0) {
            str3 = [NSString stringWithFormat:@"全"];
        }else if(_m3==1){
            str3 =  [NSString stringWithFormat:@"单周"];
        }else if(_m3==2){
            str3 =  [NSString stringWithFormat:@"双周"];
        }
        _m11 = _m1;
        _m22 = _m2;
        _m33 = _m3;
        _m1 = 0;
        _m2 = 0;
        _m3 = 0;
        [_textFileAry setObject:[NSString stringWithFormat:@"第%@周-到%@周-%@上课",str1,str2,str3] atIndexedSubscript:6];
    }else if (_temp == 8){
        [_textFileAry setObject:[NSString stringWithFormat:@"周%d-第%d节-第%d节",_week+1,_class1+1,_class2+1] atIndexedSubscript:8];
    }else if (_temp == 7){
        
        NSString * month;
        if (_month<9) {
            month = [NSString stringWithFormat:@"0%d",_month+1];
        }else{
            month = [NSString stringWithFormat:@"%d",_month+1];
        }
        NSString * day;
        if (_day<9) {
            day = [NSString stringWithFormat:@"0%d",_day+1];
        }else{
            day = [NSString stringWithFormat:@"%d",_day+1];
        }
       NSString * str =  [UIUtils weekdayStringFromDate:[NSString stringWithFormat:@"%d-%@-%@",2017+_year,month,day]];
        if ([str isEqualToString:@"星期一"]) {
           [_textFileAry setObject:[NSString stringWithFormat:@"%d-%@-%@",2017+_year,month,day] atIndexedSubscript:7];
        }else{
            [UIUtils showInfoMessage:@"选择的日期并不是周一，请重新选择日期" withVC:self];
            
            
        }
        _year1 = _year;
        _month1 = _month;
        _day1 = _day;
        
        _year = 0;
        _month = 0;
        _day = 0;
    }
    
    [_tabelView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark UIPickViewDelegate

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    if (_temp == 3) {
        return 1;
    }else if (_temp == 6){
        return 3;
    }else if (_temp == 8){
        return 3;
    }else if (_temp == 7){
        return 3;
    }
    return 0;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (_temp == 3) {
        return 2;
    }else if (_temp == 6){
        if (component == 0||component == 1) {
            return 25;
        }else if(component == 2){
            return 3;
        }
    }else if (_temp == 8){
        if (component == 0) {
            return 7;
        }else if (component == 1 || component == 2){
            return 11;
        }
    }else if (_temp == 7){
        if (component == 0) {
            return 12;
        }else if (component == 1){
            return 12;
        }else if (component == 2){
            return 31;
        }
    }
    return 0;
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (_temp == 3) {
        
        if (row==0) {
            return @"一键签到";
        }else if(row==1){
            return @"照片签到";
        }
    }else if (_temp == 6){
        if (component == 0) {
            return [NSString stringWithFormat:@"第%d周",row+1];
        }else if (component == 1){
            return [NSString stringWithFormat:@"到%d周",row+1];
        }
        else if (component == 2){
            if (row == 0) {
                return @"全";
            }else if (row == 1){
                return @"单周";
            }else if (row == 2){
                return @"双周";
            }
        }
    }else if(_temp == 8){
        if (component == 0) {
            return _weekAry[row];
        }else if (component == 1){
            return _classAry1[row];
        }else if (component == 2){
            return _classAry2[row];
        }
    }else if (_temp == 7){
        if (component == 0) {
            return [NSString stringWithFormat:@"%d",row+2017];
        }else if (component == 1){
            return [NSString stringWithFormat:@"%d",row+1];
        }else if(component == 2){
            return [NSString stringWithFormat:@"%d",row+1];
        }
    }
    return @"2016";
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (_temp == 3) {
        if (row == 1) {
            _n = 1;
        }else{
            _n = 0;
        }
    }else if (_temp == 6){
        if (component == 0) {
            _m1 = (int) row;
        }else if (component == 1){
            _m2 = (int)row;
        }else if (component == 2){
            _m3 = (int)row;
        }
    }else if (_temp == 8){
        if (component == 0) {
            _week = (int) row;
        }else if (component == 1){
            _class1 = (int)row;
        }else if (component == 2){
            _class2 = (int)row;
        }
    }else if (_temp == 7){
        if (component == 0) {
            _year = (int)row;
        }else if (component == 1){
            _month = (int)row;
        }else if (component == 2){
            _day = (int)row;
        }
    }
    
}
#pragma mark 键盘出现
-(void)keyboardWillShow:(NSNotification *)note
{
    CGRect keyBoardRect=[note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    self.tabelView.contentInset = UIEdgeInsetsMake(0, 0, keyBoardRect.size.height, 0);
}
#pragma mark 键盘消失
-(void)keyboardWillHide:(NSNotification *)note
{
    self.tabelView.contentInset = UIEdgeInsetsZero;
}
#pragma mark DefinitionPersonalTableViewCellDelegate
-(void)textFileDidChangeForDPTableViewCellDelegate:(UITextField *)textFile{
    [_textFileAry setObject:textFile.text atIndexedSubscript:textFile.tag];
};
-(void)textFieldDidBeginEditingDPTableViewCellDelegate:(UITextField *)textFile{
    
}
-(void)gggDelegate:(UIButton *)btn{
    if (btn.tag == 3) {
        _temp = 3;
        [self addPickView];
    }else if (btn.tag == 5){
        [self.view endEditing: YES];
        
        SelectClassRoomViewController * s = [[SelectClassRoomViewController alloc] init];
        
        self.hidesBottomBarWhenPushed = YES;
        
        [self.navigationController pushViewController:s animated:YES];
        
        [s returnText:^(ClassRoomModel *returnText) {
            if (returnText) {
                [self.view endEditing:YES];
                if (![UIUtils isBlankString:[NSString stringWithFormat:@"%@",returnText.classRoomId]]) {
                    _classRoom = returnText;
                    [_textFileAry setObject:_classRoom.classRoomName atIndexedSubscript:5];
                    [_tabelView reloadData];
                }
            }
        }];
        
    }else if (btn.tag == 4){
        SelectPeopleToClassViewController * s = [[SelectPeopleToClassViewController alloc] init];
        self.hidesBottomBarWhenPushed = YES;
        
        s.selectPeople = [[NSMutableArray alloc] initWithArray:_selectPeopleAry];

        [self.navigationController pushViewController:s animated:YES];
        
        [_selectPeopleAry removeAllObjects];

        [s returnText:^(NSMutableArray *returnText) {
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
                [_tabelView reloadData];
            }else{
                [_textFileAry setObject:[NSString stringWithFormat:@"已选择0人"] atIndexedSubscript:btn.tag];
                
                [_tabelView reloadData];
            }
            
        }];
    }else if (btn.tag == 6){
        _temp = 6;
        [self addPickView];
    }else if (btn.tag == 8){
        _temp = 8;
        [self addPickView];
    }else if (btn.tag == 7){
        _temp = 7;
        [self addPickView];
    }
    
}


#pragma mark UITableViewdelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 9;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    DefinitionPersonalTableViewCell * cell ;
    if (indexPath.row == 0) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"DefinitionPersonalTableViewCellSecond"];
    }else{
        cell = [tableView dequeueReusableCellWithIdentifier:@"DefinitionPersonalTableViewCellFirst"];
    }
    
    if (!cell) {
        if (indexPath.row == 0) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"DefinitionPersonalTableViewCell" owner:self options:nil] objectAtIndex:1];
        }else{
            cell = [[[NSBundle mainBundle] loadNibNamed:@"DefinitionPersonalTableViewCell" owner:self options:nil] objectAtIndex:0];
        }
        
    }
    [cell addCourseContentView:_labelAry[indexPath.row] withTextFileText:_textFileAry[indexPath.row] withIndex:(int)indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.delegate = self;
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.view endEditing:YES];
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return 80;
    }
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
