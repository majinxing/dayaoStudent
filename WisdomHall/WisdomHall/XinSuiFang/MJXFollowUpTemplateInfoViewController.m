//
//  MJXFollowUpTemplateInfoViewController.m
//  XinSuiFang
//
//  Created by majinxing on 16/9/20.
//  Copyright © 2016年 majinxing. All rights reserved.
//随访的详细内容，通用

#import "MJXFollowUpTemplateInfoViewController.h"
#import "MJXfollowUpTableViewCell.h"
#import "MJXRootViewController.h"
#import "MJXSetRemindersViewController.h"
#import "MJXRootViewController.h"
#import "MJXTemplate.h"
@interface MJXFollowUpTemplateInfoViewController ()<UITableViewDataSource,UITableViewDelegate,MJXfollowUpTableViewCellDelegate,UITextViewDelegate,UIPickerViewDelegate,UIPickerViewDataSource,UIAlertViewDelegate>
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)NSMutableArray *adviceArray;
@property (nonatomic,strong)NSString *followupId;
@property (nonatomic,assign)CGPoint historyPoint;
@property (nonatomic,strong)UIView *pickerView;
@property (nonatomic,strong)NSMutableArray *timeAry;
@property (nonatomic,strong)NSMutableArray *timeTextAry;
@property (nonatomic,assign)int temp;
@property (nonatomic,strong)NSString *numberStr;
@property (nonatomic,strong)NSString *numberTextStr;
@end

@implementation MJXFollowUpTemplateInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (!_timeAdviceArray) {
        _timeAdviceArray = [NSMutableArray arrayWithCapacity:10];
    }
    _timeAry = [NSMutableArray arrayWithCapacity:10];
    _timeTextAry = [NSMutableArray arrayWithObjects:@"年",@"月",@"周",@"日", nil];
    _numberStr = [[NSString alloc] init];
    _numberTextStr = [[NSString alloc] init];
    for (int i=0; i<50; i++) {
        [_timeAry addObject:[NSString stringWithFormat:@"%d",i]];
    }
    if (_whetherTemplate) {
        [MJXUIUtils addNavigationWithView:self.view withTitle:@"随访模板"];
    }else{
        [MJXUIUtils addNavigationWithView:self.view withTitle:@"自定义模板"];
        MJXTemplate *t = [[MJXTemplate alloc] init];
        [_timeAdviceArray addObject:t];
    }
    
    [self addBackButton];
  
   
    if ([_templateName isEqualToString:@"心衰"]) {
        MJXTemplate *t = [[MJXTemplate alloc] init];
        t.timeYear = @"1";
        t.timeStr = @"Y";
        t.advice = @"28天后去复查";
        [_timeAdviceArray addObject:t];
        
        MJXTemplate *t2 = [[MJXTemplate alloc] init];
        t2.timeDay = @"1";
        t2.timeStr = @"D";
        t2.advice = @"1年后去复查";
        [_timeAdviceArray addObject:t2];
    }
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, APPLICATION_WIDTH, APPLICATION_HEIGHT-64) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    
    //添加键盘监听
    // 键盘将要显示时
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    // 键盘将要隐藏时
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    // Do any additional setup after loading the view.
}
-(void)useTheTemplate{
    if (_templateName.length>0) {
        
    }else{
        UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@""
                                                      message:@"请把随访名称填写完整"
                                                     delegate:self
                                            cancelButtonTitle:@"确认"
                                            otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    if (_whetherTemplate) {
        MJXSetRemindersViewController *sRVC = [[MJXSetRemindersViewController alloc] init];
        sRVC.timeAdviceArray = [NSMutableArray arrayWithCapacity:10];
        sRVC.timeAdviceArray = _timeAdviceArray;
        sRVC.templateName = _templateName;
        sRVC.patients = _patients;
        sRVC.hidesBottomBarWhenPushed = YES;
        
        [self.navigationController pushViewController:sRVC animated:NO];
        
    }else{
    AFHTTPRequestOperationManager *manger = [MJXClient setAFHTTPRequestOperationManagerSomeQuality];
    NSString *url = [NSString stringWithFormat:@"%@/followup/addTemplate",MJXBaseURL];
    NSMutableArray *ary = [NSMutableArray arrayWithCapacity:10];
    for (int i=0; i<_timeAdviceArray.count; i++) {
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        MJXTemplate *tt = _timeAdviceArray[i];
        if (tt.advice.length>0&&[NSString stringWithFormat:@"%@%@%@%@%@",tt.timeYear,tt.timeMonth,tt.timeDay,tt.timeWeeks,tt.timeStr].length>0) {
            [dict setValue:tt.advice forKey:@"content"];
            [dict setValue:[NSString stringWithFormat:@"%@%@%@%@%@",tt.timeYear,tt.timeMonth,tt.timeWeeks,tt.timeDay,tt.timeStr] forKey:@"sendDate"];
            [ary addObject:dict];
        }else{
            UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@""
                                                                  message:@"请把日期和医嘱内容填写完整"
                                                                 delegate:self
                                                        cancelButtonTitle:@"确认"
                                                        otherButtonTitles:nil, nil];
                    [alert show];
            return;
        }
        
    }

    
    
    [manger POST:url parameters:@{
                                  @"username":[[MJXAppsettings sharedInstance] getUserPhone],
                                  @"name" :_templateName,
                                  @"node" :ary
                                  } success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                      NSLog(@"0");
                                      if ([[responseObject objectForKey:@"statusCode"] isEqualToString:@"200"]) {
                                          MJXSetRemindersViewController *sRVC = [[MJXSetRemindersViewController alloc] init];
                                          sRVC.timeAdviceArray = [NSMutableArray arrayWithCapacity:10];
                                          sRVC.timeAdviceArray = _timeAdviceArray;
                                          sRVC.templateName = _templateName;
                                          sRVC.followupId = [[responseObject objectForKey:@"result"] objectForKey:@"templateId"];
                                          sRVC.patients = _patients;
                                          sRVC.hidesBottomBarWhenPushed = YES;
                                          
                                          [self.navigationController pushViewController:sRVC animated:NO];
                                      }
                                      
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"1");
    }];
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
    //底部按钮
    UIButton *useTemplate = [UIButton buttonWithType:UIButtonTypeCustom];
    useTemplate.frame = CGRectMake(APPLICATION_WIDTH-100,20,100, 44);
    [useTemplate setTitle:@"使用模板" forState:UIControlStateNormal];
    [useTemplate setTitleColor:[UIColor colorWithHexString:@"#01aeff"] forState:UIControlStateNormal];
    useTemplate.titleLabel.font = [UIFont systemFontOfSize:13];
    [useTemplate addTarget:self action:@selector(useTheTemplate) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:useTemplate];
    
}

-(void)back{
   [self.navigationController popViewControllerAnimated:YES];
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event

{
    [self.view endEditing:YES];
    
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
    if (_timeAdviceArray.count>0) {
        if (_whetherTemplate) {
            return _timeAdviceArray.count+1;
        }
        return _timeAdviceArray.count+2;
    }
    return 1;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MJXfollowUpTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!cell) {
        cell=[[MJXfollowUpTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    if (indexPath.row==0) {
        [cell addNameOfTheFollowUpWithName:_templateName];
        if (_whetherTemplate) {
            cell.textField.userInteractionEnabled =NO;
        }
        [cell.textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    }
    else if (indexPath.row==_timeAdviceArray.count+1) {
        cell.delegate = self;
        [cell addRemindButtonView];
    }else{
        MJXTemplate *tt = _timeAdviceArray[indexPath.row-1];
        NSString *time = [[NSString alloc] init];
        if (![tt.timeYear isEqualToString:@""]&&tt.timeYear.length>0) {
            time = [time stringByAppendingFormat:@"%@年",tt.timeYear];
        }
        if (![tt.timeMonth isEqualToString:@""]&&tt.timeMonth.length>0) {
            time = [time stringByAppendingFormat:@"%@月",tt.timeMonth];
        }
        if (![tt.timeDay isEqualToString:@""]&&tt.timeDay.length>0) {
            time = [time stringByAppendingFormat:@"%@日",tt.timeDay];
        }
        if (![tt.timeWeeks isEqualToString:@""]&&tt.timeWeeks.length>0) {
            time = [time stringByAppendingFormat:@"%@周",tt.timeWeeks];
        }
        NSString *str;
        if (![time isEqualToString:@""]&&time.length>0) {
            str = [NSString stringWithFormat:@"定于基准日期：%@后",time];
        }else{
              str = @"";
        }
        
        BOOL n = YES;
        if (_whetherTemplate) {
            n = NO;
        }
        
        cell.delegate = self;
       [cell addContentViewWithTimeStr:str withText:tt.advice withTextEditor:n withDelegateButtonTag:(int)indexPath.row];
        cell.textView.delegate = self;

    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==0) {
        return 90;
    }
    if (indexPath.row==_timeAdviceArray.count+1) {
        return 50;
    }
    return 190;
}
#pragma mark MJXfollowUpTableViewCellDelegate
-(void)changeTimeButtonPressed:(UIButton *)btn{
    [self.view endEditing:YES];
    _temp = (int)btn.tag;
    [self addPickView];
}
-(void)deleteRemindButtonPressed:(UIButton *)btn{
    if (btn.tag!=1) {
        [_timeAdviceArray removeObjectAtIndex:btn.tag-1];
        [_tableView reloadData];
    }
}
-(void)addRemindButtonPressed{
    MJXTemplate *t = [[MJXTemplate alloc] init];
    [_timeAdviceArray addObject:t];
    [_tableView reloadData];
}
-(void)textFieldDidChange:(UITextField *)textField{
    _templateName = textField.text;
    //[_tableView reloadData];
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
    [pickerViewD selectRow:0 inComponent:0 animated:NO];
    [pickerViewD selectRow:3 inComponent:1 animated:NO];
    
    
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
   MJXTemplate *tt = _timeAdviceArray[_temp-2001];
    
    tt.timeYear = @"";
    tt.timeMonth = @"";
    
    tt.timeWeeks = @"";
    tt.timeDay = @"";
    
    if (_numberStr.length>0) {
        
    }else{
        _numberStr = @"0";
    }
    if (_numberTextStr.length>0) {
        
    }else{
        _numberTextStr = @"日";
    }
    
    if ([_numberTextStr isEqualToString:@"日"]) {
        tt.timeStr = @"D";
        tt.timeDay = _numberStr;
    }else if ([_numberTextStr isEqualToString:@"周"]){
        tt.timeStr = @"W";
        tt.timeWeeks = _numberStr;
    }else if ([_numberTextStr isEqualToString:@"月"]){
        tt.timeStr = @"M";
        tt.timeMonth = _numberStr;
    }else if ([_numberTextStr isEqualToString:@"年"]){
        tt.timeStr = @"Y";
        tt.timeYear = _numberStr;
    }
    [self.pickerView removeFromSuperview];
    [_tableView reloadData];
    _numberStr = @"";
    _numberTextStr = @"";
}

#pragma mark UITextViewdelegate
//开始编辑
-(BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@"请输入医嘱内容"]) {
        textView.text = @"";
    }
    return YES;
    
}
-(void)textViewDidChange:(UITextView *)textView{
    MJXTemplate *tt = _timeAdviceArray[textView.tag-1001];
    if ([textView.text isEqualToString:@""]) {
        tt.advice = @"";
    }else{
        tt.advice = [NSString stringWithFormat:@"%@",textView.text];
    }

}
-(void)textViewDidEndEditing:(UITextView *)textView{
    if ([textView.text isEqualToString:@""]) {
        textView.text = @"请输入医嘱内容";
    }
}
#pragma mark UIPickerViewDelegate

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 2;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component==0) {
        return [_timeAry count];
    }if (component==1) {
        return [_timeTextAry count];
    }
    return 0;
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    
    if (component==0) {
        return [_timeAry objectAtIndex:row];
    }else if (component==1){
        return [_timeTextAry objectAtIndex:row];
    }
    return 0;
    
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{

    if(component==0) {
        _numberStr =  [NSString stringWithFormat:@"%@",_timeAry[row]];
    }else if(component==1){
        _numberTextStr = [NSString stringWithFormat:@"%@",_timeTextAry[row]];
    }

}

#pragma mark key
- (void)keyboardWillShow:(NSNotification*)notification{
    
    NSDictionary *userInfo = [notification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    double keyBoardHeight = keyboardRect.size.height;
    //记录当前的位置,在键盘消失之后恢复当前的位置
    self.historyPoint = self.tableView.contentOffset;
    //位置可根据自己的实际情况来计算
    self.tableView.contentOffset = CGPointMake(0, self.tableView.contentSize.height-(APPLICATION_HEIGHT-124)+keyBoardHeight);
    //[_tableView reloadData];
}
- (void)keyboardWillHide:(NSNotification*)notification{
    //键盘消失,恢复原来的位置
    self.tableView.contentOffset = self.historyPoint;
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
