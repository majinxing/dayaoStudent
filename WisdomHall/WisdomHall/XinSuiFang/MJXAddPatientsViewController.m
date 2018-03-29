//
//  MJXAddPatientsViewController.m
//  XinSuiFang
//
//  Created by majinxing on 16/8/30.
//  Copyright © 2016年 majinxing. All rights reserved.
//

#import "MJXAddPatientsViewController.h"
#import "MJXAddPatientView.h"
#import "MJXAddPatientsTableViewCell.h"
#import <AVFoundation/AVFoundation.h>
#import "MJXRootViewController.h"
#import "MJXPatients.h"
#import "MJXVGroupManagementiewController.h"
@interface MJXAddPatientsViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UIPickerViewDelegate,UIPickerViewDataSource,addPatientsTableViewCellDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (nonatomic,strong)NSMutableArray *lable;//lable的文字
@property (nonatomic,strong)NSMutableArray *text;//text的文字
@property (nonnull,strong)NSMutableArray *textBool;//判断是不是写入文字
@property (nonatomic,strong)MJXAddPatientView *addPatientView;
@property (nonatomic,strong)UIView * pickerView;
@property (nonatomic,assign)int temp;//标志位判断选择的是哪一个滚轮
@property (nonatomic,strong)NSString *pickString;//滚轮返回的字符串
@property (nonatomic,assign)BOOL NN;//判断是否显示分组内容
@property (nonatomic,strong)UIButton * bView;//滚轮的背景
@property (nonatomic,strong)NSMutableArray *YMD;
@property (nonatomic,strong)NSMutableArray *year;
@property (nonatomic,strong)NSString *sign;
@property (nonatomic,strong)UIImage *headImage;
@property (nonatomic,strong)NSString *headUrl;
@end

@implementation MJXAddPatientsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _sign = [[NSString alloc] init];
    _headImage = [[UIImage alloc] init];
    _headUrl = [[NSString alloc] init];
    _NN = NO;
    [self addArray];
    [self changeArray:_textBool];
    self.view.backgroundColor = [UIColor whiteColor];
    
    _YMD=[NSMutableArray arrayWithCapacity:12];
    [_YMD setObject:@"0" atIndexedSubscript:0];
    [_YMD setObject:@"0" atIndexedSubscript:1];
    [_YMD setObject:@"0" atIndexedSubscript:2]
    ;
    [MJXUIUtils addNavigationWithView:self.view withTitle:_titleStr];
    [self addBackButton];
    
    _addPatientView = [[MJXAddPatientView alloc] initWithFrame:CGRectMake(0, 64, APPLICATION_WIDTH, APPLICATION_HEIGHT-64)];
    [self.view addSubview:_addPatientView];
    _addPatientView.tableView.delegate = self;
    _addPatientView.tableView.dataSource = self;
    
    _year = [NSMutableArray arrayWithCapacity:120];
    
    [_year setObject:@"0" atIndexedSubscript:0];
    for (int i=1; i<=122; i++) {
        [_year setObject:[NSString stringWithFormat:@"%d",1895+i] atIndexedSubscript:i];
    }
}
-(void)addPickView{
    if (!self.pickerView) {
        self.bView = [UIButton buttonWithType:UIButtonTypeCustom];
        self.bView.frame = CGRectMake(0, 0, APPLICATION_WIDTH, APPLICATION_HEIGHT);
        self.bView.backgroundColor = [UIColor blackColor];
        [self.bView addTarget:self action:@selector(outView) forControlEvents:UIControlEventTouchUpInside];
        self.bView.alpha = 0.5;
        [self.view addSubview:_bView];
        self.pickerView = [[UIView alloc] initWithFrame:CGRectMake(0, APPLICATION_HEIGHT - 150 - 30, APPLICATION_WIDTH, 150 + 30)];
        
        UIPickerView * pickerViewD = [[UIPickerView alloc] initWithFrame:CGRectMake(0.0,30,APPLICATION_WIDTH,150)];
        pickerViewD.backgroundColor=[UIColor whiteColor];
        pickerViewD.delegate = self;
        pickerViewD.dataSource =  self;
        pickerViewD.showsSelectionIndicator = YES;
        self.pickerView.backgroundColor=[UIColor whiteColor];
        [self.view addSubview:self.pickerView];
        
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
}
-(void)outView{
    [self.bView removeFromSuperview];
    [self.pickerView removeFromSuperview];
}
-(void)leftButton{
    [self.bView removeFromSuperview];
    [self.pickerView removeFromSuperview];
    _pickString=@"";
    [_YMD removeAllObjects];
}
-(void)rightButton{
    [self.bView removeFromSuperview];
    [self.pickerView removeFromSuperview];
    if (_temp==1) {
        UITextField *t=(UITextField *)[self.view viewWithTag:4];
        t.text=_pickString;
    }else if (_temp==2){
        UITextField *t=(UITextField *)[self.view viewWithTag:5];
        t.text=[NSString stringWithFormat:@"%@-%@-%@",_YMD[0],_YMD[1],_YMD[2]];
    }else if (_temp==3){
        UITextField *t=(UITextField *)[self.view viewWithTag:23];
        t.text=_pickString;
    }
    
    _pickString=@"";
    
}
-(void)addArray{
    //    NSArray *ary=[[NSArray alloc] initWithObjects:@"头像",@"姓名",@"手机号",@"病历",@"性别",@"出生日期", nil];
    //    NSArray *ary2=[[NSArray alloc] initWithObjects:@"分组", nil];
    
    //提前开辟空间
    _textBool=[[NSMutableArray alloc] initWithCapacity:3];
    for (int i = 0; i<3; i++) {
        NSMutableArray *a=[[NSMutableArray alloc]initWithObjects:@"1a1aqeqewewewewe01",@"1a1aqeqewewewewe01",@"1a1aqeqewewewewe01",@"1a1aqeqewewewewe01",@"1a1aqeqewewewewe01",@"1a1aqeqewewewewe01",@"1a1aqeqewewewewe01", nil];
        [_textBool setObject:a atIndexedSubscript:i];
    }
    //[_textBool setObject:a atIndexedSubscript:1];
    //[_textBool setObject:a atIndexedSubscript:2];
    
    _lable=[[NSMutableArray alloc] initWithCapacity:3];
    [_lable setObject:@[@"头       像",@" 姓      名",@"手  机  号",@"病  历  号",@"性       别",@"出生日期",@""] atIndexedSubscript:0];
    
    [_lable setObject:@[@"分       组"] atIndexedSubscript:1];
    [_lable setObject:@[@"诊断信息",@"现居住地",@"身份证号",@"婚姻状况",@"民       族",@"职       业",@""] atIndexedSubscript:2];
    
    _text=[[NSMutableArray alloc] initWithCapacity:3];
    
    NSString *time=[self getCurrentDate];
    
    [_text setObject:@[@"h",@"请输入患者的姓名",@"请输入患者手机号",@"请输入患者的病历号",@"男",time,@""] atIndexedSubscript:0];
    [_text setObject:@[@"请选择分组"] atIndexedSubscript:1];
    [_text setObject:@[@"请输入患者诊断信息",@"请输入患者现居住地址",@"请输入患者身份证号",@"已婚",@"请选择选择民族",@"请输入患者职业",@""] atIndexedSubscript:2];
}
-(void)changeArray:(NSMutableArray *)ary{
    if (![_patients.patientHeadImageUrl isKindOfClass:[NSNull class]]&&_patients.patientHeadImageUrl!=nil&&![_patients.patientHeadImageUrl isEqualToString:@""]) {
        NSURL *url=[NSURL URLWithString:_patients.patientHeadImageUrl];
        _headImage =[[UIImage alloc]initWithData:[NSData dataWithContentsOfURL:url]];
        //_headImage = [[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:_patients.patientHeadImageUrl]]];
    }
    NSMutableArray * ary1 = ary[0];
    NSString * name = [NSString stringWithFormat:@"%@",_patients.patientsName];
    [ary1 setObject:name atIndexedSubscript:1];
    [ary1 setObject:[NSString stringWithFormat:@"%@",_patients.patientNumberPhone] atIndexedSubscript:2];
    [ary1 setObject:[NSString stringWithFormat:@"%@",_patients.medicalRecordNumber] atIndexedSubscript:3];
    [ary1 setObject:[NSString stringWithFormat:@"%@",_patients.patientSex] atIndexedSubscript:4];
    [ary1 setObject:[NSString stringWithFormat:@"%@",_patients.dateOfBirth] atIndexedSubscript:5];
    NSMutableArray * ary2 = ary[1];
    [ary2 setObject:[NSString stringWithFormat:@"%@",_patients.groupNameStr] atIndexedSubscript:0];
    NSMutableArray * ary3 = ary[2];
    [ary3 setObject:[NSString stringWithFormat:@"%@",_patients.patientDiagnosis] atIndexedSubscript:0];
    [ary3 setObject:[NSString stringWithFormat:@"%@",_patients.address] atIndexedSubscript:1];
    [ary3 setObject:[NSString stringWithFormat:@"%@",_patients.idCard] atIndexedSubscript:2];
    [ary3 setObject:[NSString stringWithFormat:@"%@",_patients.MaritalStatus] atIndexedSubscript:3];
    [ary3 setObject:[NSString stringWithFormat:@"%@",_patients.national] atIndexedSubscript:4];
    [ary3 setObject:[NSString stringWithFormat:@"%@",_patients.professional] atIndexedSubscript:5];
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
    NSString *nowDate = [NSString stringWithFormat:@"%ld-%ld-%ld",(long)nowCmps.year,(long)nowCmps.month,(long)nowCmps.day];
    return nowDate;
}
-(void)addBackButton{
    UIImageView *backImage=[[UIImageView alloc] initWithFrame:CGRectMake(20, 20+15, 7, 15)];
    backImage.image=[UIImage imageNamed:@"return"];
    [self.view addSubview:backImage];
    UIButton *back=[UIButton buttonWithType:UIButtonTypeCustom];
    back.frame=CGRectMake(0,20,60, 44);
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
-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)save{
    AFHTTPRequestOperationManager *manger = [MJXClient setAFHTTPRequestOperationManagerSomeQuality];
    NSString *url = [NSString stringWithFormat:@"%@/image",MJXBaseURL];
    if (_headImage.size.height>0) {
        NSData *_data = UIImageJPEGRepresentation(_headImage, 0.8f);
        NSString *encodedImageStr = [_data base64Encoding];
        
        [manger POST:url parameters:@{
                                      @"image" :encodedImageStr
                                      } success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                          
                                          if ([[responseObject objectForKey:@"statusCode"] isEqualToString:@"200"]) {
                                              NSDictionary *dic = [[NSDictionary alloc] init];
                                              dic = [responseObject objectForKey:@"result"];
                                              _headUrl = [dic objectForKey:@"imagePath_s"];
                                              [self sendPatientInfo];
                                          }
                                      } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                         [MJXUIUtils show404WithDelegate:self];
                                      }];
    }else{
        [self sendPatientInfo];
    }
}
//保存患者信息
-(void)sendPatientInfo{
    NSArray *aryTag=[[NSArray alloc] init];
    aryTag=[NSArray arrayWithObjects:@"0",@"1",@"2",@"3",@"4",@"5",@"10",@"20",@"21",@"22",@"23",@"24",@"25",nil];
    NSArray *key=[NSArray arrayWithObjects:@"patientName",@"patientPhone",@"medicalRecordNum",@"gender",@"birthday",@"group",@"diagnosticInfo",@"address",@"idcard",@"marriageInfo",@"national",@"professional", nil];
    NSMutableDictionary *dict=[[NSMutableDictionary alloc] init];
    for (int i=1; i<[aryTag count ]; i++) {
        UITextField *t=(UITextField *)[self.view viewWithTag:[aryTag[i] integerValue]];
        NSString *str=[[NSString alloc] init];
        if ((long)t.text.length<0||[t.text isEqualToString:@""]||t.text==NULL) {
            str=@"";
        }else{
            str=t.text;
        }
        [dict setValue:str forKey:key[i-1]];
    }
    if ([[dict valueForKey:@"group"] isEqualToString:@""]) {
        [dict removeObjectForKey:@"group"];
    }
    if (_headUrl.length>0) {
        [dict setValue:_headUrl forKey:@"heading"];
    }else{
        [dict setValue:@"" forKey:@"heading"];
    }
    [dict setValue:[[MJXAppsettings sharedInstance] getUserPhone] forKey:@"username"];
    
    if ([[dict valueForKey:@"patientName"] isEqualToString:@""]) {
        UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@""
                                                      message:@"请填写患者姓名"
                                                     delegate:self
                                            cancelButtonTitle:@"确认"
                                            otherButtonTitles:nil, nil];
        [alert show];
        return;
        
    }
    
    AFHTTPRequestOperationManager *manger = [MJXClient setAFHTTPRequestOperationManagerSomeQuality];
    NSString *url = [[NSString alloc] init];
    if ([_titleStr isEqualToString:@"添加患者"]) {
        url = [NSString stringWithFormat:@"%@%@",MJXBaseURL,@"/patient/addNewPatient"];
        [manger POST:url parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [self back];
            NSLog(@"成功");
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"失败");
        }];
    }else if ([_titleStr isEqualToString:@"修改信息"]){
        url = [NSString stringWithFormat:@"%@%@",MJXBaseURL,@"/patient/editPatient"];
        [dict setObject:_patients.patientId forKey:@"patientId"];
        [manger POST:url parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [self back];
            NSLog(@"成功");
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [MJXUIUtils show404WithDelegate:self];
            NSLog(@"失败");
        }];
    }
    
    
}
-(void)selectGroup{
    NSMutableArray *ary1 = [NSMutableArray arrayWithCapacity:10];
    AFHTTPRequestOperationManager *manger = [MJXClient setAFHTTPRequestOperationManagerSomeQuality];
    NSString * url = [NSString stringWithFormat:@"%@/group/showAllGroup",MJXBaseURL];
    [manger POST:url parameters:@{
                                  @"username":[[MJXAppsettings sharedInstance] getUserPhone]
                                  } success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                      NSArray *ary = [[NSArray alloc] init];
                                      ary = [responseObject objectForKey:@"result"];
                                      for (int i=0; i<ary.count; i++) {
                                          MJXPatients *p=[[MJXPatients alloc] init];
                                          p.groupName = [ary[i] objectForKey:@"gname"];
                                          p.gruopOpen = NO;
                                          [ary1 setObject:p atIndexedSubscript:i];
                                      }
                                      MJXVGroupManagementiewController *groupM = [[MJXVGroupManagementiewController alloc] init];
                                      groupM.array = ary1;
                                      groupM.hidesBottomBarWhenPushed = YES;
                                      groupM.NN = @"NO";
                                      groupM.choose = _textBool[1][0];
                                      [self.navigationController pushViewController:groupM animated:YES];
                                      [groupM returnText:^(NSString *showText) {
                                          [_textBool setObject:@[[NSString stringWithFormat:@"%@",showText]] atIndexedSubscript:1];
                                          
                                          // _NN = YES;
                                          [_addPatientView.tableView reloadData];
                                      }];
                                      
                                  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                      
                                  }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark UITableViewdelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==0) {
        return 6;
    }else if (section==1){
        return 1;
    }else if (section==2){
        return 6;
    }else{
        return 10;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section==0) {
        return 35;
    }else if (section==1){
        return 10;
    }else if (section==2){
        return 35;
    }else{
        return 10;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MJXAddPatientsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!cell) {
        cell = [[MJXAddPatientsTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    }
    BOOL n=NO;
    if (indexPath.section==0&&(indexPath.row==4||indexPath.row==5)) {
        n=YES;
    }else if (indexPath.section==2&&indexPath.row==3){
        n=YES;
    }
    if (indexPath.section ==1) {
        n = _NN;
    }
    [cell setLableAndTextFiledWithLableText:_lable[indexPath.section][indexPath.row] withTextfiledText:_text[indexPath.section][indexPath.row] withEditable:n withText:_textBool[indexPath.section][indexPath.row] withImage:_headImage];
    if (indexPath.section ==1) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }else{
        
    }
    cell.delegate = self;
    cell.textField.delegate=self;
    cell.textField.tag=indexPath.section*10+indexPath.row;
    [cell.textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section ==1) {
        [self selectGroup];
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==2&&indexPath.row==6) {
        return 74;
    }
    return 50;
}
#pragma mark addPatientsTableViewCellDelegate
-(void)headImageButtonPressed{
    [self.view endEditing:YES];
    UIActionSheet *myActionSheet;
    myActionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照", @"从手机相册里选择", nil];
    [myActionSheet showInView:self.view];
}
#pragma mark actionSheet点击事件
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    //  UIAlertView *alertView;
    switch (buttonIndex) {
        case 0:
            _sign = @"0";
            [self vistCameraAction];
            break;
        case 1:
            _sign = @"1";
            [self vistPhotoAlbum];
            break;
        default:
            break;
    }
}
-(void)vistPhotoAlbum{
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.delegate = self;
    imagePickerController.allowsEditing = YES;
    imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:imagePickerController animated:YES completion:^{
        
    }];
}
-(void)vistCameraAction{
    [self visitCamera];
}
#pragma mark 访问相机

-(void)visitCamera
{
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
#pragma  UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    if ([self.sign isEqualToString:@"1"]) {
        UIImage * image = [info objectForKey:UIImagePickerControllerEditedImage];
        _headImage = image;
        [_addPatientView.tableView reloadData];
    }//相机拍照 de
    else if([self.sign isEqualToString:@"0"]){
        UIImage *image=info[@"UIImagePickerControllerOriginalImage"];
        _headImage = image;
        [_addPatientView.tableView reloadData];
    }
    [self dismissViewControllerAnimated:YES completion:NULL];
    
}
#pragma mark UITextFiledDelegate
-(void)textFieldDidEndEditing:(UITextField *)textField{
    int a=(int)textField.tag/10;
    int b=textField.tag%10;
    _textBool[a][b]=textField.text;
    [_addPatientView.tableView reloadData];
}
-(void)textFieldDidChange:(UITextField *)textField{
    int a=(int)textField.tag/10;
    int b=textField.tag%10;
    _textBool[a][b]=textField.text;
    
    //    if (textField.tag==1&&textField.text.length>0) {
    //        UIButton *btn=(UIButton *)[self.view viewWithTag:26];
    //        btn.userInteractionEnabled=YES;
    //    }
    
}
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    [_pickerView removeFromSuperview];
    
    if (textField.tag==5) {
        _temp = 2;
        self.pickerView=nil;
        _YMD[0] = @"1896";
        _YMD[1] = @"1";
        _YMD[2] = @"1";
        [self addPickView];
        [self.view endEditing:YES];
        return NO;
    }else if (textField.tag==4){
        _temp = 1;
        _pickString = @"男";
        self.pickerView=nil;//_pickString
        [self.view endEditing:YES];
        [self addPickView];
        return NO;
    }else if (textField.tag==23){
        _temp = 3;
        self.pickerView=nil;
        _pickString = @"已婚";
        [self.view endEditing:YES];
        [self addPickView];
        return NO;
    }
    return YES;
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    return YES;
}

#pragma mark pick

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    if (_temp==2) {
        return 3;
    }
    return 1;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (_temp==2) {
        if (component==0) {
            return [_year count];
        }if (component==1) {
            return 13;
        }else if (component==2)
        {
            return 32;
        }
    }
    return 2;
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (_temp==2) {
        if (component==0) {
            return [_year objectAtIndex:row+1];
        }else if (component==1){
            return [NSString stringWithFormat:@"%ld",(long)row+1];
        }else if (component==2)
        {
            return [NSString stringWithFormat:@"%ld",(long)row+1];
        }
    }else if (_temp==1){
        if (row==0) {
            return @"男";
        }else if(row==1){
            return @"女";
        }
    }else if (_temp==3){
        if (row==0) {
            return @"已婚";
        }else if(row==1){
            return @"未婚";
        }
    }
    return @"2016";
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    NSLog(@"%ld_%ld",(long)row,(long)component);
    if (_temp==1) {
        if (row==0) {
            _pickString=@"男";
        }else if(row==1){
            _pickString=@"女";
        }
    }else if (_temp==2){
        if (component==0) {
            
            [_YMD setObject:[NSString stringWithFormat:@"%d",1895+(int)row+1] atIndexedSubscript:component];
        }else{
            [_YMD setObject:[NSString stringWithFormat:@"%d",(int)row+1] atIndexedSubscript:component];
        }
    }else if(_temp==3){
        if (row==0) {
            _pickString=@"已婚";
        }else if(row==1){
            _pickString=@"未婚";
        }
    }
    
}
//回收键盘的
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    [self.view endEditing:YES];
    
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
