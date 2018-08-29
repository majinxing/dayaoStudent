
//
//  WorkingLoginViewController.m
//  WisdomHall
//
//  Created by XTU-TI on 2017/9/29.
//  Copyright © 2017年 majinxing. All rights reserved.
//

#import "WorkingLoginViewController.h"
#import "TheLoginViewController.h"
#import "DYHeader.h"
#import "BindPhone.h"
#import "ChatHelper.h"
#import "DYTabBarViewController.h"
#import "JSMSConstant.h"
#import "JSMSSDK.h"
#import "RegisterViewController.h"
#import "SchoolModel.h"
#import "ForgotPasswordViewController.h"
#import "RegisterViewController.h"

#define AnimateTime 0.25f   // 下拉动画时间

#define VIEW_X(aView)            ((aView).frame.origin.x)
#define VIEW_Y(aView)            ((aView).frame.origin.y)

#define VIEW_SIZE(aView)         ((aView).frame.size)
#define VIEW_HEIGHT(aView)       ((aView).frame.size.height)
#define VIEW_WIDTH(aView)        ((aView).frame.size.width)

@interface WorkingLoginViewController ()<BindPhoneDelegate,UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic)  UITextField *workNumber;
@property (strong, nonatomic)  UITextField *password;
@property (strong, nonatomic)  UIButton *selectSchoolBtn;
@property (strong, nonatomic)  UIImageView *selectImage;
@property (strong, nonatomic)  UIButton *registerBtn;
@property (strong, nonatomic)  UIButton *loginBtn;

@property (nonatomic,strong)BindPhone * bindPhone;
@property (nonatomic,copy)NSString * phone;

@property (nonatomic,strong) UIView * listView;//下拉列表背景视图
@property (nonatomic,strong) UITableView * tableView;//下拉列表
@property (nonatomic,strong) NSMutableArray * titleAry;//列表数组
@property (nonatomic,assign)CGFloat rowHeight;
@property (nonatomic,assign) BOOL selectSchoolBtnStatus;
@property (strong, nonatomic)  NSLayoutConstraint *titleLabelTop;
@property (nonatomic,strong) SchoolModel * userSchool;
@property (nonatomic,strong) UserModel * user;
@property (nonatomic,assign)CGFloat h ;
@property (strong, nonatomic)  UIView *titleBackView;
@property (strong, nonatomic)  UIView *btnBackView;
@property (nonatomic,strong)UILabel *titleLabel;
@property (nonatomic,assign)CGFloat titleh ;

@end

@implementation WorkingLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self addContentView];
    
    _titleAry = [NSMutableArray arrayWithCapacity:1];

    [self getSchoolList];
    
    _password.secureTextEntry = YES;
    
    _selectSchoolBtnStatus = NO;
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    _user = [[Appsetting sharedInstance] getUsetInfo];
    
    _workNumber.text = _user.studentId;
    
    _password.text = _user.userPassword;
    
    _loginBtn.layer.masksToBounds = YES;
    _loginBtn.layer.cornerRadius = 22;
    
    if (![UIUtils isBlankString:_user.schoolName]&&![UIUtils isBlankString:_user.host]) {
        [_selectSchoolBtn setTitle:_user.schoolName forState:UIControlStateNormal];
    }else{
        [_selectSchoolBtn setTitle:@"请选择" forState:UIControlStateNormal];

    }


    [self setTableView];
    
    [_registerBtn setHidden:YES];
    
    [self keyboardNotification];
    // Do any additional setup after loading the view from its nib.
}
-(void)addContentView{
    _titleBackView  = [[UIView alloc] initWithFrame:CGRectMake(30, 115, APPLICATION_WIDTH-60, 80)];
    _titleBackView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_titleBackView];
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, APPLICATION_WIDTH-60, 80)];
    _titleLabel.text = @"欢迎来到\n律动学生版";
    _titleLabel.font = [UIFont systemFontOfSize:30];
    _titleLabel.textColor = [UIColor whiteColor];
    _titleLabel.numberOfLines = 0;
    [_titleBackView addSubview:_titleLabel];
    
    _btnBackView = [[UIView alloc] initWithFrame:CGRectMake(30, 115+100, APPLICATION_WIDTH-60, 300)];
    
    _btnBackView.backgroundColor = [UIColor clearColor];
    
    [self.view addSubview:_btnBackView];
    
    NSArray * ary = @[@"学     校",@"学     号",@"密     码"];
    for (int i= 0; i<3; i++) {
        UILabel * a = [[UILabel alloc] initWithFrame:CGRectMake(0, 13+47*i, 70, 20)];
        a.textColor = [UIColor whiteColor];
        a.font = [UIFont systemFontOfSize:15];
        a.text = ary[i];
        
        [_btnBackView addSubview:a];
        UIView * line = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(a.frame)+13, _btnBackView.frame.size.width, 1)];
        line.backgroundColor = [UIColor whiteColor];
        [_btnBackView addSubview:line];
    }
    _selectSchoolBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    _selectSchoolBtn.frame = CGRectMake(70, 13, _btnBackView.frame.size.width-70, 30);
    _selectSchoolBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    _selectSchoolBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
    _selectSchoolBtn.backgroundColor = [UIColor clearColor];
    
    [_selectSchoolBtn addTarget:self action:@selector(selectBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    [_btnBackView addSubview:_selectSchoolBtn];
    
    _workNumber = [[UITextField alloc] initWithFrame:CGRectMake(70, CGRectGetMaxY(_selectSchoolBtn.frame)+12, _btnBackView.frame.size.width-70, 30)];
    _workNumber.textColor = [UIColor whiteColor];
    _workNumber.font = [UIFont systemFontOfSize:15];
    
    [_btnBackView addSubview:_workNumber];
    
    _password = [[UITextField alloc] initWithFrame:CGRectMake(70, CGRectGetMaxY(_workNumber.frame)+14, _btnBackView.frame.size.width-70, 30)];
    _password.textColor = [UIColor whiteColor];
    _password.font = [UIFont systemFontOfSize:15];
    
    [_btnBackView addSubview:_password];
    
    _registerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _registerBtn.frame = CGRectMake(0, CGRectGetMaxY(_password.frame)+13+1+20, 70, 20);
    _registerBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [_registerBtn setTitle:@"注册" forState:UIControlStateNormal];
    [_registerBtn addTarget:self action:@selector(registerBtn:) forControlEvents:UIControlEventTouchUpInside];
    [_btnBackView addSubview:_registerBtn];
    
    UIButton * forget = [UIButton buttonWithType:UIButtonTypeCustom];
    forget.frame = CGRectMake(_btnBackView.frame.size.width-70, CGRectGetMaxY(_password.frame)+13+1+20, 70, 20);
    forget.titleLabel.font = [UIFont systemFontOfSize:15];
    [forget setTitle:@"忘记密码" forState:UIControlStateNormal];
    [forget addTarget:self action:@selector(forgetPassword:) forControlEvents:UIControlEventTouchUpInside];
    [_btnBackView addSubview:forget];
    
    _loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _loginBtn.frame = CGRectMake(60, CGRectGetMaxY(forget.frame)+40, _btnBackView.frame.size.width-120, 40);
    _loginBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [_loginBtn setBackgroundImage:[UIImage imageNamed:@"Rectangle3"] forState:UIControlStateNormal];
    [_loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    [_loginBtn addTarget:self action:@selector(login:) forControlEvents:UIControlEventTouchUpInside];
    [_btnBackView addSubview:_loginBtn];
    
    _h = _titleBackView.frame.origin.y;
    
    _titleh = _btnBackView.frame.origin.y;
    
}
/**
 * 键盘监听
 **/
-(void)keyboardNotification{
    //监听键盘出现和消失
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
}
#pragma mark 键盘出现
-(void)keyboardWillShow:(NSNotification *)note
{
    [UIView animateWithDuration:1.5 animations:^{
        
        CGRect keyBoardRect=[note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
        
        CGFloat hh = CGRectGetMaxY(_btnBackView.frame);
        
        hh = APPLICATION_HEIGHT - hh;
        
        hh = keyBoardRect.size.height -hh;
        
        self.titleBackView.frame = CGRectMake(self.titleBackView.frame.origin.x, -self.titleBackView.frame.size.height, self.titleBackView.frame.size.width, self.titleBackView.frame.size.height);
        
        self.btnBackView.frame = CGRectMake(30, _btnBackView.frame.origin.y-hh, self.btnBackView.frame.size.width, _btnBackView.frame.size.height);
        
    }completion:^(BOOL finished) {
        
        
    }];
    
}
#pragma mark 键盘消失
-(void)keyboardWillHide:(NSNotification *)note
{
//    CGRect keyBoardRect=[note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    [UIView animateWithDuration:1.5 animations:^{
        
        
        self.titleBackView.frame = CGRectMake(self.titleBackView.frame.origin.x, _h, self.titleBackView.frame.size.width, self.titleBackView.frame.size.height);
        
        self.btnBackView.frame = CGRectMake(30, _titleh, self.btnBackView.frame.size.width, _btnBackView.frame.size.height);
        
    }completion:^(BOOL finished) {
        
        
    }];
    [self hideDropDown];
}

-(void)setTableView{

    _listView = [[UIView alloc] init];
    _listView.frame = CGRectMake(VIEW_X(self.selectSchoolBtn), CGRectGetMaxY(self.selectSchoolBtn.frame), VIEW_WIDTH(self.selectSchoolBtn), 0);
    _listView.clipsToBounds = YES;
    _listView.layer.masksToBounds = NO;
    _listView.layer.borderColor = [UIColor lightTextColor].CGColor;
    _listView.layer.borderWidth = 0.5f;
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, VIEW_WIDTH(_listView), VIEW_HEIGHT(_listView)) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.bounces = NO;
    
    [_listView addSubview:_tableView];
    
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
//    if (_selectSchoolBtnStatus) {
//        [self hideDropDown];
//    }
}
-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = YES;
}
-(void)getSchoolList{
    [[NetworkRequest sharedInstance] GETSchool:SchoolList dict:nil succeed:^(id data) {
        NSArray * ary = [data objectForKey:@"body"];
        for (int i = 0; i<ary.count; i++) {
            SchoolModel * s = [[SchoolModel alloc] init];
            [s setInfoWithDict:ary[i]];
            [_titleAry addObject:s];
        }
        [_tableView reloadData];
    } failure:^(NSError *error) {
        
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)login:(id)sender {
    [self showHudInView:self.view hint:NSLocalizedString(@"正在登陆请稍后……", @"Load data...")];
    
    _user = [[Appsetting sharedInstance] getUsetInfo];
    
    if ([UIUtils isBlankString:_user.host]) {
        [UIUtils showInfoMessage:@"请先选择学校" withVC:self];
        [self hideHud];
        return;
    }
    NSDictionary * dict = [[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%@",_user.school],@"universityId",_workNumber.text,@"loginStr",_password.text,@"password", nil];//大学id要灵活
    
    [[NetworkRequest sharedInstance] POST:Login dict:dict succeed:^(id data) {
        NSString * str = [[data objectForKey:@"header"] objectForKey:@"code"];
        if ([str isEqualToString:@"0000"]) {
            
            [[NSNotificationCenter defaultCenter] postNotificationName:InApp object:nil];

            
            NSString * ss = [[data objectForKey:@"body"] objectForKey:@"bind"];
            if ([ss isEqualToString:@"true"]) {
                RegisterViewController * r = [[RegisterViewController alloc] init];
                r.type = @"bindPhone";
                r.workNo = _workNumber.text;
                r.password = _password.text;
                [self.navigationController pushViewController:r animated:YES];
            }else{
                NSMutableDictionary * dict = [[NSMutableDictionary alloc] init];
                dict = [data objectForKey:@"body"];
                NSString * type = [NSString stringWithFormat:@"%@",[dict objectForKey:@"type"]];
                if ([type isEqualToString:@"1"]) {
                    [UIUtils showInfoMessage:@"您的身份是老师，本客户端只支持学生使用，请登录“律动校园”" withVC:self];
                }else{
                    [[Appsetting sharedInstance] sevaUserInfoWithDict:dict withStr:_password.text];
                    
                    
                    [self saveInfo];
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        DYTabBarViewController *rootVC = [DYTabBarViewController sharedInstance];
                        
                        [UIApplication sharedApplication].keyWindow.rootViewController = rootVC;
                    });
                }
                [self hideHud];
            }
        }else{
            NSString * strMessage = [[data objectForKey:@"header"] objectForKey:@"message"];
            [UIUtils showInfoMessage:strMessage withVC:self];
        }
        [self hideHud];
    } failure:^(NSError *error) {
        [UIUtils showInfoMessage:@"登陆失败，请检查网络" withVC:self];
        [self hideHud];
    }];
}
-(void)saveInfo{
    //手机型号
    NSString * phoneModel =  [UIUtils deviceVersion];
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *app_build = [infoDictionary objectForKey:@"CFBundleVersion"];
    NSString *system = [infoDictionary objectForKey:@"DTSDKName"];
    
    UserModel * user = [[Appsetting sharedInstance] getUsetInfo];
    
    NSDictionary * dict = [[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%@",user.userPhone],@"contact",[NSString stringWithFormat:@"手机厂商：Apple\n手机型号：%@\n产品型号：\n设备型号：\n系统版本：ios %@\n App版本：律动课堂 %@",phoneModel,system,app_build],@"retroaction",phoneModel,@"phoneModels",app_build,@"version",user.peopleId,@"userId",@"2",@"type",nil];
    
    [[NetworkRequest sharedInstance] POST:FeedBack dict:dict succeed:^(id data) {
        NSLog(@"%@",data);
        
    } failure:^(NSError *error) {
        
    }];
}
- (IBAction)phoneLogin:(id)sender {
    TheLoginViewController * login = [[TheLoginViewController alloc] init];
    [self.navigationController pushViewController:login animated:YES];
}
- (IBAction)registerBtn:(id)sender {
    _user = [[Appsetting sharedInstance] getUsetInfo];

    RegisterViewController * registerVC = [[RegisterViewController alloc] init];
    UIBarButtonItem * backButtonItem = [[UIBarButtonItem alloc] init];
    backButtonItem.title = @"取消";
    registerVC.schoolId = _user.school;
    self.navigationItem.backBarButtonItem = backButtonItem;
    [self.navigationController pushViewController:registerVC animated:YES];
}
- (IBAction)forgetPassword:(id)sender {
    ForgotPasswordViewController * forgetVC = [[ForgotPasswordViewController alloc] init];
    // self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:nil action:nil];
    // 方式二
    UIBarButtonItem * backButtonItem = [[UIBarButtonItem alloc] init];
    backButtonItem.title = @"返回";
    self.navigationItem.backBarButtonItem = backButtonItem;
    [self.navigationController pushViewController:forgetVC animated:YES];
}

- (IBAction)selectBtnPressed:(UIButton *)sender {
    [_btnBackView addSubview:_listView]; // 将下拉视图添加到控件的俯视图上

    if(_selectSchoolBtnStatus == NO) {
        if (_titleAry.count>0) {
            [self showDropDown];
        }else{
            [self showHudInView:self.view hint:NSLocalizedString(@"正在加载数据", @"Load data...")];
            [[NetworkRequest sharedInstance] GETSchool:SchoolList dict:nil succeed:^(id data) {
                NSString * str = [NSString stringWithFormat:@"%@",[[data objectForKey:@"header"] objectForKey:@"message"]];
                if ([str isEqualToString:@"成功"]) {
                    NSArray * ary = [data objectForKey:@"body"];
                    for (int i = 0; i<ary.count; i++) {
                        SchoolModel * s = [[SchoolModel alloc] init];
                        [s setInfoWithDict:ary[i]];
                        [_titleAry addObject:s];
                    }
                    
                    [self showDropDown];
                    
                }else{
                    [UIUtils showInfoMessage:str withVC:self];
                }
                [self hideHud];
                [_tableView reloadData];
            } failure:^(NSError *error) {
                [self hideHud];
                [UIUtils showInfoMessage:@"网络连接失败，请检查网络" withVC:self];
            }];
        }
    }
    else {
        [self hideDropDown];
    }
}
- (void)showDropDown{   // 显示下拉列表
    
    //[_listView.superview bringSubviewToFront:_listView]; // 将下拉列表置于最上层
    
    
    _listView.frame = CGRectMake(VIEW_X(self.selectSchoolBtn), CGRectGetMaxY(self.selectSchoolBtn.frame), VIEW_WIDTH(self.selectSchoolBtn), 0);

    [UIView animateWithDuration:AnimateTime animations:^{
        
        _selectImage.transform = CGAffineTransformMakeRotation(M_PI);
        _listView.frame  = CGRectMake(VIEW_X(_listView), VIEW_Y(_listView), VIEW_WIDTH(self.selectSchoolBtn), 150);
        _tableView.frame = CGRectMake(0, 0, VIEW_WIDTH(_listView), VIEW_HEIGHT(_listView));
        
    }completion:^(BOOL finished) {
        
       
    }];
    
    _selectSchoolBtnStatus = YES;
}
- (void)hideDropDown{  // 隐藏下拉列表
    
    [UIView animateWithDuration:AnimateTime animations:^{
        
        _selectImage.transform = CGAffineTransformIdentity;
        _listView.frame  = CGRectMake(VIEW_X(_listView), VIEW_Y(_listView), VIEW_WIDTH(_listView), 0);
        _tableView.frame = CGRectMake(0, 0, VIEW_WIDTH(_listView), VIEW_HEIGHT(_listView));
        
    }completion:^(BOOL finished) {
        
      
    }];
    
    
    
    _selectSchoolBtnStatus = NO;
}
#pragma mark UITableViewdelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _titleAry.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Cell";

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        //---------------------------下拉选项样式，可在此处自定义-------------------------
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.textLabel.font          = [UIFont systemFontOfSize:11.f];
        cell.textLabel.textColor     = [UIColor blackColor];
        cell.selectionStyle          = UITableViewCellSelectionStyleNone;
        
        UIView * line = [[UIView alloc] initWithFrame:CGRectMake(0, _rowHeight -0.5, VIEW_WIDTH(cell), 0.5)];
        line.backgroundColor = [UIColor blackColor];
        [cell addSubview:line];
        //---------------------------------------------------------------------------
    }
    SchoolModel * s = _titleAry[indexPath.row];
    
    cell.textLabel.text = s.schoolName;
    
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    
    cell.alpha = 0.9;
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    SchoolModel * s = _titleAry[indexPath.row];
    
    [_selectSchoolBtn setTitle:s.schoolName forState:UIControlStateNormal];
    
//    if (indexPath.row == 1) {
//    s.schoolHost = @"http://192.168.1.100:8080";
//    }else if (indexPath.row == 0){
//        s.schoolHost = @"http://api.dayaokeji.com";
//    }
//
    [[Appsetting sharedInstance] saveUserSchool:s];
    
    [self hideDropDown];
    
    if ([[NSString stringWithFormat:@"%@",s.allowregister] isEqualToString:@"true"]||[[NSString stringWithFormat:@"%@",s.allowregister] isEqualToString:@"1"]) {
        [_registerBtn setHidden:NO];
    }else{
        [_registerBtn setHidden:YES];
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
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
