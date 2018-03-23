
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

#define AnimateTime 0.25f   // 下拉动画时间

#define VIEW_X(aView)            ((aView).frame.origin.x)
#define VIEW_Y(aView)            ((aView).frame.origin.y)

#define VIEW_SIZE(aView)         ((aView).frame.size)
#define VIEW_HEIGHT(aView)       ((aView).frame.size.height)
#define VIEW_WIDTH(aView)        ((aView).frame.size.width)

@interface WorkingLoginViewController ()<BindPhoneDelegate,UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UITextField *workNumber;
@property (strong, nonatomic) IBOutlet UITextField *password;
@property (strong, nonatomic) IBOutlet UIButton *selectSchoolBtn;
@property (strong, nonatomic) IBOutlet UIImageView *selectImage;

@property (nonatomic,strong)BindPhone * bindPhone;
@property (nonatomic,copy)NSString * phone;

@property (nonatomic,strong) UIView * listView;//下拉列表背景视图
@property (nonatomic,strong) UITableView * tableView;//下拉列表
@property (nonatomic,strong) NSMutableArray * titleAry;//列表数组
@property (nonatomic,assign)CGFloat rowHeight;
@property (nonatomic,assign) BOOL selectSchoolBtnStatus;
@property (nonatomic,strong) SchoolModel * userSchool;
@end

@implementation WorkingLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self getSchoolList];
    
    _password.secureTextEntry = YES;
    
    _selectSchoolBtnStatus = NO;
    
    _titleAry = [NSMutableArray arrayWithCapacity:1];
    
//    _selectSchoolBtn.backgroundColor = [UIColor clearColor];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    UserModel * user = [[Appsetting sharedInstance] getUsetInfo];
    
    _workNumber.text = user.studentId;
    
    _password.text = user.userPassword;
    
    if (![UIUtils isBlankString:user.schoolName]) {
        [_selectSchoolBtn setTitle:user.schoolName forState:UIControlStateNormal];
    }
    _password.textColor = [UIColor blackColor];

    [self setTableView];
    // Do any additional setup after loading the view from its nib.
}
-(void)setTableView{
//    _titleAry = [[NSArray alloc] initWithObjects:@"无",@"湘潭大学", nil];
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
    if (_selectSchoolBtnStatus) {
        [self hideDropDown];
    }
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
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)login:(id)sender {
    [self showHudInView:self.view hint:NSLocalizedString(@"正在登陆请稍后……", @"Load data...")];
    
    NSDictionary * dict = [[NSDictionary alloc] initWithObjectsAndKeys:@"500",@"universityId",_workNumber.text,@"loginStr",_password.text,@"password", nil];
    
    [[NetworkRequest sharedInstance] POST:Login dict:dict succeed:^(id data) {
        NSString * str = [[data objectForKey:@"header"] objectForKey:@"code"];
        if ([str isEqualToString:@"0000"]) {
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
                    [UIUtils showInfoMessage:@"您的身份是老师，本客户端只支持学生使用，请登录“律动校园”"];
                }else{
                    [[Appsetting sharedInstance] sevaUserInfoWithDict:dict withStr:_password.text];
                    
                    ChatHelper * c =[ChatHelper shareHelper];
                    
                    [self saveInfo];
                    
                    DYTabBarViewController *rootVC = [[DYTabBarViewController alloc] init];
                    
                    [UIApplication sharedApplication].keyWindow.rootViewController = rootVC;
                }
                [self hideHud];
            }
        }else if ([str isEqualToString:@"1014"]){
            [UIUtils showInfoMessage:@"用户名或密码错误"];
        }else if ([str isEqualToString:@"9999"]){
            [UIUtils showInfoMessage:@"网络错误或者其他不可知错误"];
        }else{
            [UIUtils showInfoMessage:@"登录失败"];
        }
        [self hideHud];
    } failure:^(NSError *error) {
        [UIUtils showInfoMessage:@"登陆失败，请检查网络"];
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

- (IBAction)selectBtnPressed:(UIButton *)sender {
    [self.view addSubview:_listView]; // 将下拉视图添加到控件的俯视图上
    
    if(_selectSchoolBtnStatus == NO) {
        [self showDropDown];
    }
    else {
        [self hideDropDown];
    }
}
- (void)showDropDown{   // 显示下拉列表
    
    //[_listView.superview bringSubviewToFront:_listView]; // 将下拉列表置于最上层
    
    
    
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
    
    [[Appsetting sharedInstance] saveUserSchool:s];
    
    [self hideDropDown];
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
