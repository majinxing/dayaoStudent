//
//  MJXModifyInformationViewController.m
//  XinSuiFang
//
//  Created by majinxing on 16/10/10.
//  Copyright © 2016年 majinxing. All rights reserved.
//

#import "MJXModifyInformationViewController.h"
#import "MJXTabBarController.h"
#import "MJXModifyInformation.h"
#import "MJXRegionalViewController.h"
#import "MJXAddPatientsTableViewCell.h"
#import "MJXRegionalViewController.h"
#import "UIImageView+WebCache.h"
#import <AVFoundation/AVFoundation.h>
@interface MJXModifyInformationViewController ()<UITableViewDelegate,UITableViewDataSource,addPatientsTableViewCellDelegate,UITextFieldDelegate,UIActionSheetDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UITextViewDelegate>
@property (nonatomic,strong)UITableView * tableView;
@property (nonatomic,strong)NSArray * labelArray;
@property (nonatomic,strong)NSMutableArray * textApArray;//提示文字
@property (nonatomic,strong)NSMutableArray * textArray;
@property (nonatomic,strong)NSString * describeStr;//描述
@property (nonatomic,strong)UIImageView * headImage;//头像
@property (nonatomic,strong)NSString * headImageUrl;//头像的URL
@property (nonatomic,strong)NSString *sign;
@property (nonatomic,strong)UIView * bView;
@property (nonatomic,assign)double keyHeight;
@property (nonatomic,assign)int textD;

@end
@implementation MJXModifyInformationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _textD = 0;
    self.view.backgroundColor = [UIColor whiteColor];
    [self getArray];
    _describeStr = [[NSString alloc] init];
    _sign = [[NSString alloc] init];
    _headImage = [[UIImageView alloc] init];
    [MJXUIUtils addNavigationWithView:self.view withTitle:@"个人信息"];
    [self addBackButton];
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, APPLICATION_WIDTH, APPLICATION_HEIGHT-64) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    [self.view addSubview:_tableView];
    [self getTextWithUserModel];
    [self getData];
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
-(void)getData{
    AFHTTPRequestOperationManager *manger = [MJXClient setAFHTTPRequestOperationManagerSomeQuality];
    NSString * url = [NSString stringWithFormat:@"%@/user/findDoctorInformation",MJXBaseURL];
    [manger POST:url parameters:@{
                                  @"username" :[[MJXAppsettings sharedInstance] getUserPhone]
                                 } success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                     if ([[responseObject objectForKey:@"statusCode"] isEqualToString:@"200"]) {
                                         [self getText:[responseObject objectForKey:@"result"]];
                                     }
                                     
                                 } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                     
                                 }];
    

}
-(void)getText:(NSDictionary *)dict{
    _textArray[1] = [dict objectForKey:@"name"];
    _textArray[2] = [dict objectForKey:@"phone"];
    _textArray[3] = [dict objectForKey:@"hospital"];
    _textArray[4] = [dict objectForKey:@"departmentid"];
    _textArray[5] = [dict objectForKey:@"titleid"];
    _headImageUrl = [dict objectForKey:@"headimg"];
    _describeStr = [dict objectForKey:@"docintro"];
    [self.headImage sd_setImageWithURL:[NSURL URLWithString:_headImageUrl] placeholderImage:[UIImage imageNamed:@"man"]];
    [_tableView reloadData];
}
-(void)getTextWithUserModel{
    MJXUserModel *userInfo = [[MJXUserModel alloc] init];
    userInfo = [[MJXAppsettings sharedInstance] getUserInfo];
    _textArray[1] = [NSString stringWithFormat:@"%@",userInfo.userName];
    _textArray[2] = [NSString stringWithFormat:@"%@",userInfo.userPhone];
    _textArray[3] = [NSString stringWithFormat:@"%@",userInfo.hospital];
    _textArray[4] = [NSString stringWithFormat:@"%@",userInfo.department];
    _textArray[5] = [NSString stringWithFormat:@"%@",userInfo.position];
    _headImageUrl = userInfo.headimg;
    _describeStr = userInfo.introduction;
    [self.headImage sd_setImageWithURL:[NSURL URLWithString:_headImageUrl] placeholderImage:[UIImage imageNamed:@"man"]];
    [_tableView reloadData];
}
-(void)getArray{
    _labelArray = [[NSArray alloc] initWithObjects:@"头   像",@"姓   名",@"手机号",@"医   院",@"科   室",@"职   称", nil];
    _textApArray = [[NSMutableArray alloc] initWithObjects:@"12321",@"请输入您的真实姓名方便医患交流",@"请输入您的手机号",@"请选择您所在的医院",@"请选择您所在的科室",@"请选择您的职称", nil];
    _textArray = [[NSMutableArray alloc] initWithObjects:@"1a1aqeqewewewewe01",@"1a1aqeqewewewewe01",@"1a1aqeqewewewewe01",@"1a1aqeqewewewewe01",@"1a1aqeqewewewewe01",@"1a1aqeqewewewewe01", nil];

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
    [self.view endEditing:YES];
    AFHTTPRequestOperationManager *manger = [MJXClient setAFHTTPRequestOperationManagerSomeQuality];
    NSString * url = [NSString stringWithFormat:@"%@/image",MJXBaseURL];
    NSData *_data = UIImageJPEGRepresentation(_headImage.image, 0.8f);
    NSString *encodedImageStr = [_data base64Encoding];
    [manger POST:url parameters:@{
                                   @"image" :encodedImageStr
                                  } success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                      if ([[responseObject objectForKey:@"statusCode"] isEqualToString:@"200"]) {
                                          self.headImageUrl = [[responseObject objectForKey:@"result"] objectForKey:@"imagePath_l"];
                                          [self sendInfo];
                                      }
                                  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                      
                                  }];
}
-(void)sendInfo{
    AFHTTPRequestOperationManager *manger = [MJXClient setAFHTTPRequestOperationManagerSomeQuality];
    NSString * url = [NSString stringWithFormat:@"%@/user/updateDoctorInformation",MJXBaseURL];
    NSMutableDictionary * dict = [[NSMutableDictionary alloc] init];
    [dict setValue:[NSString stringWithFormat:@"%@",_headImageUrl] forKey:@"heading"];
    [dict setValue:[NSString stringWithFormat:@"%@",_textArray[1]] forKey:@"doctorName"];
    if ([_textArray[1] isKindOfClass:[NSNull class]]||_textArray[1]==nil||[_textArray[1] isEqualToString:@""]) {
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:@"姓名不能为空"
                                  message:nil
                                  delegate:self
                                  cancelButtonTitle:nil
                                  otherButtonTitles:@"我知道了", nil];
        [alertView show];
    }
    [dict setValue:[NSString stringWithFormat:@"%@",_textArray[3]] forKey:@"hospital"];
    [dict setValue:[NSString stringWithFormat:@"%@",_textArray[4]] forKey:@"department"];
    [dict setValue:[NSString stringWithFormat:@"%@",_textArray[5]] forKey:@"title"];
    [dict setValue:[NSString stringWithFormat:@"%@",_describeStr] forKey:@"introduction"];
    [dict setValue:[[MJXAppsettings sharedInstance] getUserPhone] forKey:@"username"];
    [manger POST:url parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([[responseObject objectForKey:@"statusCode"] isEqualToString:@"200"]) {
            [self back];
        }
                                 } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                     NSLog(@"0");
                                 }];
}
-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

//回收键盘的
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    [self.view endEditing:YES];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark addPatientsTableViewCellDelegate
-(void)headImageButtonPressed{
    UIActionSheet *myActionSheet;
    myActionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照", @"从手机相册里选择", nil];
    [myActionSheet showInView:self.view];
}
-(void)textViewTextDidChange:(UITextView *)text{
    _describeStr = text.text;
    
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
-(void)vistCameraAction{
    [self visitCamera];
}
-(void)vistPhotoAlbum{
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.delegate = self;
    imagePickerController.allowsEditing = YES;
    imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:imagePickerController animated:YES completion:^{
        
    }];
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
        _headImage.image = image;
        [_tableView reloadData];
    }//相机拍照 de
    else if([self.sign isEqualToString:@"0"]){
        UIImage *image=info[@"UIImagePickerControllerOriginalImage"];
        _headImage.image = image;
        [_tableView reloadData];
    }
    [self dismissViewControllerAnimated:YES completion:NULL];
    
}
#pragma mark UITableViewdelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 6;
    }else if (section == 1){
    return 2;
    }
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MJXAddPatientsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!cell) {
        cell=[[MJXAddPatientsTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    }
    cell.delegate = self;
    BOOL n=NO;
    if (indexPath.section==0&&indexPath.row>2) {
        n=YES;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    if (indexPath.section == 0) {
        
        [cell setLableAndTextFiledWithLableText:_labelArray[indexPath.row] withTextfiledText:_textApArray[indexPath.row] withEditable:n withText:_textArray[indexPath.row] withImageView:_headImageUrl withUIImage:_headImage.image];
        
    }else if (indexPath.section == 1 &&indexPath.row == 0){
        cell.textLabel.text = @"简  介";
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        cell.textLabel.textColor = [UIColor colorWithHexString:@"#666666"];

    }else if (indexPath.section == 1 && indexPath.row == 1){
        [cell setUITextViewWithText:_describeStr];
        cell.textView.delegate = self;
    }
    cell.delegate = self;
    cell.textField.delegate=self;
    cell.textField.tag=indexPath.section*10+indexPath.row;
    [cell.textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1 && indexPath.row == 1) {
        return 80;
    }
    return 50;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}
#pragma mark UITextViewDelegate
-(void)textViewDidBeginEditing:(UITextView *)textView{
    if (_textD != 0) {
        return;
    }
    _textD = 1;
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
    textV.text = _describeStr;
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
-(void)textViewDidChange:(UITextView *)textView{
    if (_textD == 1) {
        _describeStr = textView.text;
    }
}
-(void)chooseBtn:(UIButton *)btn{
    _textD = 0;
    [_tableView reloadData];
    [self.view endEditing: YES];
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
#pragma mark UITextFileDelegate
-(void)textFieldDidChange:(UITextField *)textField{
    if (textField.tag == 1) {
        _textArray[1] = textField.text;
    }else if (textField.tag == 2){
        _textArray[2] = textField.text;
    }

}
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    
    MJXRegionalViewController * rVC = [[MJXRegionalViewController alloc] init];
    rVC.hidesBottomBarWhenPushed = YES;
    if (textField.tag == 3) {
        rVC.type = @"1";
        [self.navigationController pushViewController:rVC animated:YES];
        [rVC returnText:^(NSString *showText) {
            if (showText.length>0) {
                [_textArray setObject:showText atIndexedSubscript:3];
                [self.tableView reloadData];
            }
        }];
        [self.view endEditing:YES];
    }else if (textField.tag == 4){
        rVC.type = @"2";
        [self.navigationController pushViewController:rVC animated:YES];
        [rVC returnText:^(NSString *showText) {
            if (showText.length>0) {
                [_textArray setObject:showText atIndexedSubscript:4];
                [self.tableView reloadData];
            }
        }];
        [self.view endEditing:YES];
    }else if (textField.tag == 5){
        rVC.type = @"3";
        [self.navigationController pushViewController:rVC animated:YES];
        [rVC returnText:^(NSString *showText) {
            if (showText.length>0) {
                [_textArray setObject:showText atIndexedSubscript:5];
                [self.tableView reloadData];
            }
        }];
        [self.view endEditing:YES];
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
