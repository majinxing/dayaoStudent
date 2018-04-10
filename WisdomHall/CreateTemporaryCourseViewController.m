//
//  CreateTemporaryCourseViewController.m
//  WisdomHall
//
//  Created by XTU-TI on 2017/7/15.
//  Copyright © 2017年 majinxing. All rights reserved.
//
#import "CreateTemporaryCourseViewController.h"
#import "DYHeader.h"
#import "DefinitionPersonalTableViewCell.h"
#import "SelectClassRoomViewController.h"
#import "ClassRoomModel.h"
#import "SelectPeopleToClassViewController.h"
#import "SignPeople.h"

@interface CreateTemporaryCourseViewController ()<UITableViewDelegate,UITableViewDataSource,DefinitionPersonalTableViewCellDelegate,UIPickerViewDelegate,UIPickerViewDataSource>
@property (nonatomic,strong)UITableView * tabelView;
@property (nonatomic,strong)NSMutableArray * labelAry;
@property (nonatomic,strong)NSMutableArray * textFileAry;
@property (nonatomic,strong)UIButton * bView;//滚轮的背景
@property (nonatomic,strong)UIView * pickerView;
@property (nonatomic,assign)int temp;//标志位判断选择的是哪一个滚轮
@property (nonatomic,assign) int n;
@property (nonatomic,assign) int m1;
@property (nonatomic,assign) int m2;
@property (nonatomic,assign) int m3;
@property (nonatomic,assign) int week;
@property (nonatomic,assign) int class1;
@property (nonatomic,assign) int class2;
@property (nonatomic,assign) int year;
@property (nonatomic,assign) int month;
@property (nonatomic,assign) int day;

@property (nonatomic,strong) ClassRoomModel * classRoom;
@property (nonatomic,strong) NSMutableArray * selectPeopleAry;

@property (nonatomic,strong) NSMutableArray * classAry1;
@property (nonatomic,strong) NSMutableArray * classAry2;
@property (nonatomic,strong) NSMutableArray * weekAry;


@end

@implementation CreateTemporaryCourseViewController
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
            NSString * a = [NSString stringWithFormat:@"周%d",i+1];
            [_weekAry addObject:a];
        }
    }
    [self setNavigationTitle];
    [self addTabelView];
    [self keyboardNotification];
    // Do any additional setup after loading the view from its nib.
}
-(void)addTabelView{
    _labelAry = [[NSMutableArray alloc] initWithObjects:@"课堂封面",@"课  程  名",@"老师姓名",@"签到方式",@"上课的人",@"教      室",@"上课时间列表",@"上课的时间",nil];
    _textFileAry = [NSMutableArray arrayWithCapacity:4];
    for (int i = 0; i<8; i++) {
        [_textFileAry addObject:@""];
    }
    [_textFileAry setObject:@"头像" atIndexedSubscript:0];
    
    _tabelView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, APPLICATION_WIDTH, APPLICATION_HEIGHT-64) style:UITableViewStylePlain];
    self.automaticallyAdjustsScrollViewInsets = NO;
    _tabelView.dataSource = self;
    _tabelView.delegate = self;
    [self.view addSubview:_tabelView];
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
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
    self.title = @"创建课堂";
    UIBarButtonItem *myButton = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(createAcourse)];
    self.navigationItem.rightBarButtonItem = myButton;
}
-(void)createAcourse{
    NSDictionary * dict = [UIUtils createTemporaryCourseWith:_textFileAry ClassRoom:_classRoom joinClassPeople:_selectPeopleAry week:_week class1:_class1 class2:_class2];
    [self showHudInView:self.view hint:NSLocalizedString(@"正在创建课程", @"Load data...")];
    [[NetworkRequest sharedInstance] POST:CreateTemporaryCourse dict:dict succeed:^(id data) {
        NSString * str =[[data objectForKey:@"header"] objectForKey:@"code"];
        if ([[NSString stringWithFormat:@"%@",str] isEqualToString:@"0000"]) {
            // 2.创建通知
            NSNotification *notification =[NSNotification notificationWithName:@"UpdateTheClassPage" object:nil userInfo:nil];
            // 3.通过 通知中心 发送 通知
            
            [[NSNotificationCenter defaultCenter] postNotification:notification];
            
            [self.navigationController popViewControllerAnimated:YES];
        }else if ([[NSString stringWithFormat:@"%@",str] isEqualToString:@"9999"]){
            [UIUtils showInfoMessage:@"系统错误" withVC:self];
        }
        else{
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"创建失败，请填写完整课堂信息并且按照提示的格式" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alertView show];
        }
        [self hideHud];
    } failure:^(NSError *error) {
        [UIUtils showInfoMessage:@"创建数据失败，请检查网络" withVC:self];
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
            [_textFileAry setObject:@"头像签到" atIndexedSubscript:3];
        }
        _n = 0;
    }else if (_temp == 6){
        [_textFileAry setObject:[NSString stringWithFormat:@"第%d节-第%d节",_class1+1,_class2+1] atIndexedSubscript:6];
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
        [_textFileAry setObject:[NSString stringWithFormat:@"%d-%@-%@",2017+_year,month,day] atIndexedSubscript:7];
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
        return 2;
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
        return 11;
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
    }else if(_temp == 6){
       if (component == 0){
            return _classAry1[row];
        }else if (component == 1){
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
    return @"2017";
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
        if (component == 0){
            _class1 = (int)row;
        }else if (component == 1){
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
                [_textFileAry setObject:[NSString stringWithFormat:@"已选择%ld人",_selectPeopleAry.count] atIndexedSubscript:btn.tag];
                [_tabelView reloadData];
            }
            
        }];
    }else if (btn.tag == 6){
        _temp = 6;
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
    return 8;
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
    [cell addTemporaryCourseContentView:_labelAry[indexPath.row] withTextFileText:_textFileAry[indexPath.row] withIndex:(int)indexPath.row];
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
