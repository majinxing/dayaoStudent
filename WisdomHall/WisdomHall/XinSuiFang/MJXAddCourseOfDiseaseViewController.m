//
//  MJXAddCourseOfDiseaseViewController.m
//  XinSuiFang
//
//  Created by majinxing on 16/9/2.
//  Copyright © 2016年 majinxing. All rights reserved.
//新添病程页面

#import "MJXAddCourseOfDiseaseViewController.h"
#import "MJXCourseOfDiseaseTableViewCell.h"
#import "JFImagePickerController.h"
#import "MJXMedicalRecords.h"
#import "MJXRootViewController.h"
#import "JFAlbumVC.h"
#import "MJXChooseCourseViewController.h"
#import "MJXWordProcessingViewController.h"
#import "MJXMedicalHistoryViewController.h"
#import "FMDatabase.h"
#import "FMDBTool.h"
#import "MJRefresh.h"
#import <AVFoundation/AVFoundation.h>
#import "MBProgressHUD.h"

// 选中图片的最大张数
#define MAX_AMOUNT 8

//tableView的cell里面相册的按钮加了tag 数值是cell的行数。使用其他tag的时候要注意，避免重复！

@interface MJXAddCourseOfDiseaseViewController ()<UITableViewDelegate,UITableViewDataSource,courseOfDiseaseTableViewCellDelegate,JFImagePickerControllerDelegate,UIPickerViewDelegate,UIPickerViewDataSource,UITextViewDelegate,UIAlertViewDelegate，>
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)UIView *cover;
@property (nonatomic,assign)int temp;

@property (nonatomic,strong)NSMutableDictionary *aryWithIamgeUrl;

@property (nonatomic,strong)NSString *times;//临时的时间节点
@property (nonatomic,strong)UIView * pickerView;//滚轮承载体
@property (nonatomic,strong)NSMutableArray *year;

@property (nonatomic,strong)FMDatabase *db;//存储图片的数据库
@property (nonatomic,strong)NSString * strText;//悬浮窗的文字
@property (nonatomic,strong)UIView *bView;//悬浮窗的背景图
@property (nonatomic,assign)double keyHeight;
@property (nonatomic,strong) MBProgressHUD * HUD;
@property (nonatomic,copy) NSString * deleate;
@end

@implementation MJXAddCourseOfDiseaseViewController


-(void)dealloc{

}
- (instancetype)init
{
    self = [super init];
    if (self) {
        _classification = [[NSString alloc] init];
        _strText = [[NSString alloc] init];
        _titleStr = [[NSString alloc] init];
        _deleate = [[NSString alloc] init];
        _medicalRecordsArry = [NSMutableArray arrayWithCapacity:4];//数据初始化
        NSArray *ary=[NSArray arrayWithObjects:@"病史",@"化验",@"影像",@"用药", nil];
        for (int i=0; i<4; i++) {
            MJXMedicalRecords *model=[[MJXMedicalRecords alloc] init];
            model.medicaDocType=ary[i];
            [_medicalRecordsArry setObject:model atIndexedSubscript:i];
        }
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    _year = [NSMutableArray arrayWithCapacity:120];
    
    
    for (int i=0; i<122; i++) {
        [_year setObject:[NSString stringWithFormat:@"%d",1895+i] atIndexedSubscript:i];
    }
    
    
    [MJXUIUtils addNavigationWithView:self.view withTitle:_titleStr];
    [self addBackButton];
    _tableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 64, APPLICATION_WIDTH, APPLICATION_HEIGHT-64) style:UITableViewStylePlain];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    //  支持自适应 cell
    self.tableView.estimatedRowHeight = 100;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    [self.view addSubview:_tableView];
    
    if (![_diseaseId isKindOfClass:[NSNull class]]&&![_diseaseId isEqualToString:@""]&&_diseaseId.length>0) {
        
    }else{
        _time = [NSString stringWithFormat:@"%@",[self getCurrentDate]];
        [self getDiseaseId];
        
    }
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

-(void)getDiseaseId{
    AFHTTPRequestOperationManager *manger = [MJXClient setAFHTTPRequestOperationManagerSomeQuality];
    NSString *url = [NSString stringWithFormat:@"%@/patient/addMedicaStage",MJXBaseURL];
    [manger POST:url parameters:@{
                                  @"username": [[MJXAppsettings sharedInstance] getUserPhone],                                                    @"patientId": _patients.patientId,                                                    @"medicalStage": @"复诊",                                                      @"createTime": _time,
                                  @"blxq" : @"" ,
                                  @"medicalDocTypeList":@""
                                  }   success:^( AFHTTPRequestOperation *operation, id responseObject) {
                                      NSLog(@"00");
                                      if ([[responseObject objectForKey:@"statusCode"] isEqualToString:@"200"]) {
                                          id date = [responseObject objectForKey:@"result"];
                                          if (![date isEqual:@""]) {
                                              _diseaseId = [NSString stringWithFormat:@"%@",[date objectForKey:@"medicalStageId"]];
                                              NSArray *ary = [NSArray arrayWithObjects:@"bsId",@"hyId",@"yxId",@"yyId", nil];
                                              for (int i=0; i<4; i++) {
                                                  MJXMedicalRecords *model=_medicalRecordsArry[i];
                                                  model.medicaDocID = [date objectForKey:ary[i]];
                                                  NSLog(@"-");
                                              }
                                          }else{
                                              [self prohibitOperation];
                                          }
                                          
                                      }
                                      
                                  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                     // [self prohibitOperation];
                                      NSLog(@"111");
                                  }];
}
//无网络禁止创建新病程
-(void)prohibitOperation{
    UIView * b = [[UIView alloc] initWithFrame:CGRectMake(0, 0, APPLICATION_WIDTH, APPLICATION_HEIGHT)];
    b.backgroundColor = [UIColor blackColor];
    b.alpha = 0.6;
    
    [self.view addSubview:b];
    UIAlertView *alertView = [[UIAlertView alloc]
                              initWithTitle:@"网络连接失败"
                              message:nil
                              delegate:self
                              cancelButtonTitle:nil
                              otherButtonTitles:@"我知道了", nil];
    alertView.tag = 100;
    [alertView show];
}

-(void)addBackButton{
    UIImageView *backImage = [[UIImageView alloc] initWithFrame:CGRectMake(20, 20+15, 7, 15)];
    backImage.image = [UIImage imageNamed:@"return"];
    [self.view addSubview:backImage];
    UIButton *back = [UIButton buttonWithType:UIButtonTypeCustom];
    back.frame = CGRectMake(0,20,60, 44);
    [back addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:back];
    UIButton *save=[UIButton buttonWithType:UIButtonTypeCustom];
    save.frame=CGRectMake(APPLICATION_WIDTH-70,20,60, 44);
    [save setTitle:@"保 存" forState:UIControlStateNormal];
    [save setTitleColor:[UIColor colorWithHexString:@"#01aeff"] forState:UIControlStateNormal];
    save.titleLabel.font=[UIFont systemFontOfSize:15];
    [save addTarget:self action:@selector(save) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:save];
    
}
-(void)save{
    _deleate = @"NO";
    NSMutableArray *array1 = [NSMutableArray arrayWithCapacity:4];
    for (int i=0; i<_medicalRecordsArry.count; i++) {
        MJXMedicalRecords *model=_medicalRecordsArry[i];
        NSString *str = [[NSString alloc] init];
        if (![model.illnessDescription isKindOfClass:[NSNull class]]&&![model.illnessDescription isEqualToString:@""]&&model.illnessDescription!=nil) {
            str = model.illnessDescription;
        }else{
            str = @"";
        }
        //if ([model.imageSArray count]>0||![str isEqualToString:@""]) {
        NSDictionary *mydic=@{
                              @"medicaDocType":model.medicaDocType,
                              @"imagesL":@"",
                              @"imagesS":@"",
                              @"description":str,
                              @"medicaDocTypeId" : model.medicaDocID
                              };
        [array1 addObject:mydic];
        //        //}else
        //            if (![_blxq isEqualToString:@""]&&_blxq.length>0&&i==0){
        //            NSDictionary *mydic=@{
        //                                  @"medicaDocType":model.medicaDocType,
        //                                  @"imagesL":@"",
        //                                  @"imagesS":@"",
        //                                  @"description":str
        //                                  };
        //
        //            [array1 setObject:mydic atIndexedSubscript:i];
        //        }
    }
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:array1 options:NSJSONWritingPrettyPrinted error:nil];
    
    NSString *str = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    if(![_blxq isEqualToString:@""]&&![_blxq isKindOfClass:[NSNull class]]&&_blxq!=nil){
        
    }else{
        _blxq = @"";
    }
    
    AFHTTPRequestOperationManager *manger = [MJXClient setAFHTTPRequestOperationManagerSomeQuality];
    NSString *url = [NSString stringWithFormat:@"%@/patient/updateMedicaStage",MJXBaseURL];
    [manger POST:url parameters:@{
                                  @"username": [[MJXAppsettings sharedInstance] getUserPhone],                                                    @"patientId": _patients.patientId,                                                    @"medicalStage": _classification,                                                      @"createTime": _time,
                                  @"blxq" : _blxq ,
                                  @"medicaStageId":_diseaseId,
                                  @"medicalDocTypeList":str
                                  }   success:^( AFHTTPRequestOperation *operation, id responseObject) {
                                      if ([[responseObject objectForKey:@"statusCode"] isEqualToString:@"200"]) {
                                          [self back];
                                      }else{
                                          [MJXUIUtils show404WithDelegate:self];
                                          ;
                                      }
                                      NSLog(@"00");
                                  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                      [MJXUIUtils show404WithDelegate:self];
                                      NSLog(@"111");
                                  }];
    //[self back];
}
-(void)back{
    if ([_deleate isEqualToString:@"NO"]||[_titleStr isEqualToString:@"修改病程"]) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        for (int i = 0; i<_medicalRecordsArry.count; i++) {
            MJXMedicalRecords *model=_medicalRecordsArry[i];
            if ((model.imageAllArray!=nil&&model.imageAllArray.count>0)||(![model.illnessDescription isKindOfClass:[NSNull class]]&&![model.illnessDescription isEqualToString:@""]&&model.illnessDescription!=nil)||(![_blxq isKindOfClass:[NSNull class]]&&![_blxq isEqualToString:@""]&&_blxq!=nil)) {
                _deleate = @"YES";
                break;
            }
        }
        if (![_deleate isEqualToString:@"YES"]&&![_titleStr isEqualToString:@"修改病程"]&&![_diseaseId isKindOfClass:[NSNull class]]&&![_diseaseId isEqualToString:@""]&&_diseaseId!=nil) {
            [self deleteCourseOfTheDisease];
        }else{
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}
-(void)deleteCourseOfTheDisease{
    AFHTTPRequestOperationManager *manger = [MJXClient setAFHTTPRequestOperationManagerSomeQuality];
    NSString *url = [NSString stringWithFormat:@"%@/patient/deleteMedicaStage",MJXBaseURL];
    [manger POST:url parameters:@{
                                  @"username" : [[MJXAppsettings sharedInstance] getUserPhone],
                                  @"medicaStageId" : _diseaseId
                                  } success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                      [self.navigationController popViewControllerAnimated:YES];
                                      NSLog(@"2");
                                  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                      [self.navigationController popViewControllerAnimated:YES];//服务器连接失败未删除
                                      NSLog(@"1");
                                  }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
//回收键盘的
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    [self.view endEditing:YES];
    
}
#pragma mark UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 100) {
        _deleate = @"NO";
        [self back];
    }
}
#pragma mark addPickView
-(void)addPickView{
    [self.view endEditing:YES];
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
    [pickerViewD selectRow:_year.count-1 inComponent:0 animated:NO];
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
    if (_times.length>0) {
        _time=_times;
    }else{
        _time = [NSString stringWithFormat:@"%@",[self getCurrentDate]];
    }
    
    [_tableView reloadData];
    _times = @"";
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
        return 31;
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
    NSString *year = [NSString stringWithFormat:@"%ld",(long)d.year];
    NSString *month = [NSString stringWithFormat:@"%ld",(long)d.month];
    NSString *day = [NSString stringWithFormat:@"%ld",(long)d.day];
    if (component==0) {
        year =  [NSString stringWithFormat:@"%@",_year[row]];
    }else if(component==1){
        month = [NSString stringWithFormat:@"%d",(int)row+1];
    }else{
        day = [NSString stringWithFormat:@"%ld",row+1];
    }
    _times = [NSString stringWithFormat:@"%@-%@-%@",year,month,day];
}

#pragma mark UITableViewdelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 7;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MJXCourseOfDiseaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!cell) {
        cell=[[MJXCourseOfDiseaseTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    }
    if (indexPath.row==0) {
        if (![_time isKindOfClass:[NSNull class]]&&_time!=nil) {
            
        }else{
            _time = @"";
        }
        [cell setTimeClassificationWithTitle:[NSString stringWithFormat:@"创建时间        %@",_time] withImageName:@"shijian"];
    }else if(indexPath.row==1) {
        [cell setTimeClassificationWithTitle:@"病程分类" withImageName:@"首"];
    }else if (indexPath.row==2){
        if ([_classification isEqualToString:@""]||[_classification isKindOfClass:[NSNull class]]) {
            _classification = @"首诊";
        }
        [cell setFirstOptionWith:_classification];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator; //显示最右边的箭头
    }else{
        MJXMedicalRecords *model=_medicalRecordsArry[indexPath.row-3];
        [cell setTitle:model.medicaDocType Button:YES withButtonTag:indexPath.row ImageUrlArray:model.imageAllArray Description:model.illnessDescription history:@""];
        cell.delegate = self;
        cell.descriptionTextView.delegate =self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.handleVC = self;
    }
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    MJXCourseOfDiseaseTableViewCell *cell = (MJXCourseOfDiseaseTableViewCell *)[self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.height;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row==0) {
        [self addPickView];
    }else if (indexPath.row==2) {
        
        MJXChooseCourseViewController *CCVC=[[MJXChooseCourseViewController alloc] init];
        CCVC.hidesBottomBarWhenPushed = YES;
        
        [self.navigationController pushViewController:CCVC animated:YES];
        
        [CCVC returnText:^(NSString *showText) {
            self.classification = showText;
            [self.tableView reloadData];
        }];
    }
}
#pragma mark 监听键盘
//当键盘出现或改变时调用
- (void)keyboardWillShow:(NSNotification *)aNotification
{
    //获取键盘的高度
    
    NSDictionary *userInfo = [aNotification userInfo];
    
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    
    CGRect keyboardRect = [aValue CGRectValue];
    
    _keyHeight = keyboardRect.size.height;
    
    //    NSLog(@"%lf",height);
}
//当键退出时调用
- (void)keyboardWillHide:(NSNotification *)aNotification
{
    [_bView removeFromSuperview];
}
#pragma mark UITextViewDelegate
-(void)textViewDidBeginEditing:(UITextView *)textView{
    if (textView.tag>=3&&textView.tag<=6&&textView.tag!=nil) {
        [self.view endEditing:YES];
        _bView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, APPLICATION_WIDTH, APPLICATION_HEIGHT)];
        [self.view addSubview:_bView];
        UIView * block = [[UIView alloc] initWithFrame:CGRectMake(0, 0, APPLICATION_WIDTH, APPLICATION_HEIGHT)];
        block.backgroundColor = [UIColor blackColor];
        block.alpha = 0.6;
        [_bView addSubview:block];
        
        UIView * textViewEditor = [[UIView alloc] initWithFrame:CGRectMake(10, 70.0/667.0*APPLICATION_HEIGHT, APPLICATION_WIDTH-20, APPLICATION_HEIGHT-70-_keyHeight-30)];
        textViewEditor.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
        textViewEditor.layer.cornerRadius = 10;
        textViewEditor.layer.masksToBounds = YES;
        [_bView addSubview:textViewEditor];
        UITextView * textV = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, textViewEditor.frame.size.width, textViewEditor.frame.size.height-40)];
        textV.delegate = self;
        MJXMedicalRecords *model=_medicalRecordsArry[textView.tag-3];
        _strText = model.illnessDescription;
        textV.text = _strText;
        textV.font = [UIFont systemFontOfSize:15];
        textV.textColor = [UIColor colorWithHexString:@"#999999"];
        [textV becomeFirstResponder];
        [textViewEditor addSubview:textV];
        UIView * lineW = [[UIView alloc] initWithFrame:CGRectMake(0, textViewEditor.frame.size.height-40, textViewEditor.frame.size.width, 1)];
        lineW.backgroundColor = [UIColor colorWithHexString:@"#e5e5e5"];
        [textViewEditor addSubview:lineW];
        UIView * lineH = [[UIView alloc] initWithFrame:CGRectMake(textViewEditor.frame.size.width/2, textViewEditor.frame.size.height-40, 1, 40)];
        lineH.backgroundColor = [UIColor colorWithHexString:@"#e5e5e5"];
        [textViewEditor addSubview:lineH];
        UIButton * cancel = [UIButton buttonWithType:UIButtonTypeCustom];
        cancel.frame = CGRectMake(0, textViewEditor.frame.size.height-40, textViewEditor.frame.size.width/2, 40);
        [cancel setTitle:@"取消" forState:UIControlStateNormal];
        [cancel setTitleColor:[UIColor colorWithHexString:@"#999999"] forState:UIControlStateNormal];
        cancel.titleLabel.font = [UIFont systemFontOfSize:17];
        [textViewEditor addSubview:cancel];
        UIButton * determine = [UIButton buttonWithType:UIButtonTypeCustom];
        determine.frame = CGRectMake(textViewEditor.frame.size.width/2, textViewEditor.frame.size.height-40, textViewEditor.frame.size.width/2, 40);
        [determine setTitle:@"确定" forState:UIControlStateNormal];
        [determine setTitleColor:[UIColor colorWithHexString:@"#01aeff"] forState:UIControlStateNormal];
        determine.titleLabel.font = [UIFont systemFontOfSize:17];
        determine.tag = textView.tag;
        [textViewEditor addSubview:determine];
        [cancel addTarget:self action:@selector(chooseBtn:) forControlEvents:UIControlEventTouchUpInside];
        [determine addTarget:self action:@selector(chooseBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
}
-(void)chooseBtn:(UIButton *)btn{
    [self.view endEditing: YES];
    if ([btn.titleLabel.text isEqualToString:@"取消"]) {
        [self.view endEditing:NO];
        [_bView removeFromSuperview];
    }else if([btn.titleLabel.text isEqualToString:@"确定"]){
        [self.view endEditing:NO];
        [_bView removeFromSuperview];
        MJXMedicalRecords *model=_medicalRecordsArry[btn.tag-3];
        model.illnessDescription = _strText;
        [_tableView reloadData];
    }
}
-(void)textViewDidChange:(UITextView *)textView{
    _strText = textView.text;
}
-(CGSize)heightForString:(NSString *)value fontSize:(float)fontSize andWidth:(float)width{
    UITextView *detailTextView = [[UITextView alloc]initWithFrame:CGRectMake(0, 0, width, 0)];
    detailTextView.font = [UIFont systemFontOfSize:fontSize];    detailTextView.text = value;
    CGSize deSize = [detailTextView sizeThatFits:CGSizeMake(width,CGFLOAT_MAX)];
    return deSize;
}
#pragma mark courseOfDiseaseTableViewCellDelegate
-(void)delecateImagefromBrowsePicturesCollectionViewCellDelegated:(UIButton *)btn{
    NSLog(@"%ld",(long)btn.tag);
    NSString * number = [NSString stringWithFormat:@"%ld",(long)btn.tag];
    int a = [[number substringWithRange:NSMakeRange(0,1)] intValue];
    int b = [[number substringFromIndex:1] intValue];
    MJXMedicalRecords *model=_medicalRecordsArry[a-3];
    if (b<(model.imageAllArray.count-model.imageUrlLArray.count)) {
        
        [model.imageAllArray removeObjectAtIndex:b];
        
        [_tableView reloadData];
        
        [self delecateFileImageWithSmallClassID:[NSString stringWithFormat:@"%d",a] withImageID:[NSString stringWithFormat:@"%d",b]];
    }
}
//删除本地图片文件文件
-(void)delecateFileImageWithSmallClassID:(NSString *)smallClassID withImageID:(NSString *)imageID{
    //获取草稿文件夹路径
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    
    NSString * str = [NSString stringWithFormat:@"%d",[smallClassID intValue]-3];
    //缓存的路径
    NSString *draftPath = [docPath stringByAppendingPathComponent:[NSString stringWithFormat:@"Draft/patient%@/diseaseCourse%@/smallClassId%@",_patients.patientId,_diseaseId,str]];
    //草稿图片的路径
    NSString *draftImagePath = [draftPath stringByAppendingPathComponent:@"image"];
    
    NSString * draftimageIdPatth = [draftImagePath stringByAppendingPathComponent:[NSString stringWithFormat:@"image%@",imageID]];
   
    if (![[NSFileManager defaultManager] fileExistsAtPath:draftimageIdPatth]) {
        return;
    }
    //删除草稿图片文件夹
    if ([[NSFileManager defaultManager] fileExistsAtPath:draftImagePath]) {
        [[NSFileManager defaultManager] removeItemAtPath:draftImagePath error:nil];
    }
    
    int a = [smallClassID intValue];
    MJXMedicalRecords *model=_medicalRecordsArry[a-3];
    [self createDB];//创建数据库
    [self createTable];//创建表
    int imageCount=0;//记录照片数值
    NSMutableArray * array = [NSMutableArray arrayWithCapacity:10];
    array = model.imageSArray;
    if ([_db open])
    {
        FMResultSet *rs = [FMDBTool queryWithDB:_db tableName:TABLE_NAME withPatientId:_patients.patientId withDiseaseCourse:_diseaseId withSmallClass:[NSString stringWithFormat:@"%d",a-3]];
        if(!rs.next)
        {
            //imageCount = [rs intForColumn:@"imagecount"];
            MJXMedicalRecords *model=_medicalRecordsArry[a-3];
            BOOL result = [FMDBTool insertWithDB:_db tableName:TABLE_NAME patientId:_patients.patientId imageCount:[NSString stringWithFormat:@"%lu",(unsigned long)array.count] diseaseCourse:_diseaseId smallClass:[NSString stringWithFormat:@"%d",a-3] smallClassId:model.medicaDocID];
            if (result) {
                
            }
        }else{
            //imageCount = [rs intForColumn:@"imagecount"];
            BOOL result = [FMDBTool updateWithDB:_db tableName:TABLE_NAME withPatientId:_patients.patientId withDiseaseCourse:_diseaseId withSmallClass:[NSString stringWithFormat:@"%d",a-3] imageCount:[NSString stringWithFormat:@"%d",(int)array.count]];
            if (result) {
                
            }
        }
        [_db close];
    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self saveImageWithArray:array patientId:_patients.patientId diseaseCourse:_diseaseId smallClassId:[NSString stringWithFormat:@"%d",a-3] startCount:(int)0];
    });
}
-(void)descriptionButtonPressedCD:(UIButton *)btn{
    MJXMedicalRecords *model=_medicalRecordsArry[btn.tag-3];
    MJXWordProcessingViewController *wPVC = [[MJXWordProcessingViewController alloc] init];
    wPVC.titleStr = @"病情描述";
    
    wPVC.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:wPVC animated:YES];
    
    [wPVC returnText:^(NSString *showText) {
        model.illnessDescription = showText;
        [self.tableView reloadData];
    }];
    
}
-(void)historyButtonPressed{
    MJXMedicalHistoryViewController *hVC = [[MJXMedicalHistoryViewController alloc] init];
    hVC.patients=_patients;
    hVC.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:hVC animated:YES];
    [hVC returnText:^(NSString *showText) {
        _blxq = showText;
        [self.tableView reloadData];
    }];
}


-(void)vistCameraButtonPressed:(UIButton *)btn{
    NSLog(@"%ld",btn.tag);
    
    _temp=(int)btn.tag;
    _cover = [[UIView alloc] initWithFrame:CGRectMake(0, 0, APPLICATION_WIDTH, APPLICATION_HEIGHT)];
    _cover.backgroundColor = [UIColor clearColor];
    
    UIView *black = [[UIView alloc] initWithFrame:_cover.frame];
    black.backgroundColor = [UIColor blackColor];
    black.alpha = 0.5;
    [_cover addSubview:black];
    
    UIView *camera = [[UIView alloc] initWithFrame:CGRectMake(0,APPLICATION_HEIGHT-310, APPLICATION_WIDTH, 240)];
    camera.backgroundColor = [UIColor whiteColor];
    
    [_cover addSubview:camera];
    
    NSMutableArray *titleArry = [[NSMutableArray alloc] initWithObjects:@"相机",@"相册",@"录音",@"视频", nil];
    NSMutableArray *pictures = [[NSMutableArray alloc] initWithObjects:@"xj",@"xc",@"ly",@"sp", nil];
    
    for (int i=0; i<2; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(0,i*60, APPLICATION_WIDTH, 60);
        btn.tag=i+1;
        [btn addTarget:self action:@selector(intoMultimedia:) forControlEvents:UIControlEventTouchUpInside];
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, i*60, APPLICATION_WIDTH, 1)];
        line.backgroundColor = [UIColor colorWithHexString:@"#eaeaea"];
        UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(36.0/375.0*APPLICATION_WIDTH, 20+i*60, 22, 19)];
        if (i==2) {
            CGRect frame = image.frame;
            frame.size.height = 26.0;
            frame.origin.y = 17.0+i*60;
            image.frame = frame;
        }else if (i==3){
            CGRect frame = image.frame;
            frame.size.width = 26.0;
            image.frame = frame;
        }
        image.image = [UIImage imageNamed:pictures[i]];
        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(image.frame)+30, 23+i*60, 60, 13)];
        title.font = [UIFont systemFontOfSize:15];
        title.textColor = [UIColor colorWithHexString:@"#999999"];
        title.text = titleArry[i];
        [camera addSubview:image];
        [camera addSubview:title];
        [camera addSubview:btn];
        [camera addSubview:line];
        
    }
    
    UIButton *cancel = [UIButton buttonWithType:UIButtonTypeCustom];
    cancel.frame = CGRectMake(0, APPLICATION_HEIGHT-60, APPLICATION_WIDTH, 60);
    cancel.backgroundColor=[UIColor whiteColor];
    [cancel setTitle:@"取消" forState:UIControlStateNormal];
    [cancel setTitleColor:[UIColor colorWithHexString:@"#999999"] forState:UIControlStateNormal];
    cancel.titleLabel.font = [UIFont systemFontOfSize:15];
    [cancel addTarget:self action:@selector(cancelButton) forControlEvents:UIControlEventTouchUpInside];
    [_cover addSubview:cancel];
    [self.view addSubview:_cover];
}
-(void)intoMultimedia:(UIButton *)btn{
    [_cover removeFromSuperview];
    NSLog(@"%ld",(long)btn.tag);
    
    if (btn.tag==2) {
        [self visitLibraryWithMaxAmount:MAX_AMOUNT];
    }else if (btn.tag==1){
        [self visC];
    }
}
-(void)cancelButton{
    [_cover removeFromSuperview];
}
-(void)visC{
    
    //  NSLog(@"%s",__func__);
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        AVAuthorizationStatus author = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        if (author == AVAuthorizationStatusRestricted || author == AVAuthorizationStatusDenied)
        {
            //[self showLibraryOrCameraAuthorAlert:@"相机"];
        }
        else
        {
            //[self showLibraryOrCamera:UIImagePickerControllerSourceTypeCamera];
        }
        
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePicker.delegate = self;
        [self presentViewController:imagePicker animated:YES completion:nil];
    }
    else
    {
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:@"您的设备没有相机功能"
                                  message:nil
                                  delegate:self
                                  cancelButtonTitle:nil
                                  otherButtonTitles:@"我知道了", nil];
        [alertView show];
    }
    
}
//访问相册
- (void)visitLibraryWithMaxAmount:(int)maxAmount
{
    
    JFAlbumVC *pickerController = [[JFAlbumVC alloc] init];
    
    pickerController.maxAmount = maxAmount;
    pickerController.delegate = self;
    
    pickerController.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:pickerController animated:YES];
    
    
}
//创建数据库
- (void)createDB
{
    if (!_db)
    {
        _db = [FMDBTool createDBWithName:SQLITE_NAME];
    }
}
//创建表
- (void)createTable
{
    if ([_db open])
    {
        BOOL result = [FMDBTool createTableWithDB:_db tableName:TABLE_NAME
                                       parameters:@{
                                                    @"patient" : @"integer",
                                                    @"imagecount" : @"integer",
                                                    @"diseaseCourse" : @"integer",
                                                    @"smallClass" : @"integer",
                                                    @"username" : @"text",
                                                    @"smallClassId" :@"text"
                                                    }];
        if (result)
        {
            NSLog(@"建表成功");
        }
        else
        {
            NSLog(@"建表失败");
        }
        [_db close];
    }
}
//照片缓存成功！！！O(∩_∩)O哈哈~
-(void)saveImageWithArray:(NSArray *)array patientId:(NSString *)patientId diseaseCourse:(NSString *)diseaseCourseId smallClassId:(NSString *)smallClassId startCount:(int) N{
    NSMutableArray *ary = [NSMutableArray arrayWithCapacity:10];
    //获取的最新图片转换成NSData
    for (int i=0; i<array.count; i++) {
        UIImage *image = array[i];
        image = [MJXUIUtils scaleImage:image toScale:0.8];
        NSData *imageData = UIImageJPEGRepresentation(image, 0.5f);
        //NSData *imageData =  UIImagePNGRepresentation(image);//UIImageJPEGRepresentation(image, 1.0f);
        if (imageData) {
            [ary addObject:imageData];
        }
    }
    
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    //缓存的路径
    NSString *draftPath = [docPath stringByAppendingPathComponent:[NSString stringWithFormat:@"Draft/patient%@/diseaseCourse%@/smallClassId%@",patientId,diseaseCourseId,smallClassId]];
    //草稿图片的路径
    NSString *draftImagePath = [draftPath stringByAppendingPathComponent:@"image"];
    //判断文件夹是否存在，若不存在创建路径中的文件夹
    if (![[NSFileManager defaultManager] fileExistsAtPath:draftImagePath])
    {
        [[NSFileManager defaultManager] createDirectoryAtPath:draftImagePath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    for (int i = 0; i < ary.count; i++)
    {
        NSString *imagePath = [draftImagePath stringByAppendingPathComponent:[NSString stringWithFormat:@"image%d",i+N]];
        [ary[i] writeToFile:imagePath atomically:YES];
        //可以做视频和音频的缓存
        NSLog(@"-%d",i);
    }
}
- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    //    if ([self.sign isEqualToString:@"1"]) {
    //        UIImage * image = [info objectForKey:UIImagePickerControllerEditedImage];
    //        _headImage.image = image;
    //        [_tableView reloadData];
    //    }//相机拍照 de
    //   // else if([self.sign isEqualToString:@"0"]){
    UIImage *image=info[@"UIImagePickerControllerOriginalImage"];
    NSArray * ary = [NSArray arrayWithObjects:image, nil];
    [self imagePickerControllerDidFinishWithArray:ary];
    //        _headImage.image = image;
    //    }
    [self dismissViewControllerAnimated:YES completion:NULL];
    
}

#pragma mark JFImagePickerControllerDelegate

- (void)imagePickerControllerDidFinishWithArray:(NSArray *)array
{
    //展示风火轮
    // [self showHUD:self.view mode:MBProgressHUDModeIndeterminate text:nil detailText:nil];
    
    MJXMedicalRecords *model=_medicalRecordsArry[_temp-3];
    [model.imageLArray addObjectsFromArray:array];
    [model.imageAllArray removeAllObjects];
    [model.imageAllArray addObjectsFromArray:model.imageLArray];
    [model.imageAllArray addObjectsFromArray:model.imageUrlLArray];
    [self.tableView reloadData];
    [self createDB];//创建数据库
    [self createTable];//创建表
    int imageCount=0;//记录照片数值
    if ([_db open])
    {
        FMResultSet *rs = [FMDBTool queryWithDB:_db tableName:TABLE_NAME withPatientId:_patients.patientId withDiseaseCourse:_diseaseId withSmallClass:[NSString stringWithFormat:@"%d",_temp-3]];
        if(!rs.next)
        {
            //imageCount = [rs intForColumn:@"imagecount"];
            
            BOOL result = [FMDBTool insertWithDB:_db tableName:TABLE_NAME patientId:_patients.patientId imageCount:[NSString stringWithFormat:@"%lu",(unsigned long)array.count] diseaseCourse:_diseaseId smallClass:[NSString stringWithFormat:@"%d",_temp-3] smallClassId:model.medicaDocID];
            if (result) {
                
            }
        }else{
            imageCount = [rs intForColumn:@"imagecount"];
            BOOL result = [FMDBTool updateWithDB:_db tableName:TABLE_NAME withPatientId:_patients.patientId withDiseaseCourse:_diseaseId withSmallClass:[NSString stringWithFormat:@"%d",_temp-3] imageCount:[NSString stringWithFormat:@"%d",imageCount+(int)array.count]];
            if (result) {
                
            }
            
        }
        [_db close];
    }
    [self saveImageWithArray:array patientId:_patients.patientId diseaseCourse:_diseaseId smallClassId:[NSString stringWithFormat:@"%d",_temp-3] startCount:imageCount];
    
    //    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    //        [self saveImageWithArray:array patientId:_patients.patientId diseaseCourse:_diseaseId smallClassId:[NSString stringWithFormat:@"%d",_temp-3] startCount:imageCount];
    //
    //    });
    
}

#pragma mark HUD
//展示风火轮HUD
- (void)showHUD:(UIView *)view mode:(MBProgressHUDMode)mode text:(NSString *)text detailText:(NSString *)detailText
{
    _HUD = [MBProgressHUD showHUDAddedTo:view animated:YES];
    [_HUD setMode:mode];
    [_HUD setLabelText:text];
    [_HUD setDetailsLabelText:detailText];
}

//隐藏风火轮HUD
- (void)hide:(CGFloat)delay
{
    [_HUD hide:YES afterDelay:delay];
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
