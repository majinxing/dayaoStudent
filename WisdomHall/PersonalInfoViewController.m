//
//  PersonalInfoViewController.m
//  WisdomHall
//
//  Created by XTU-TI on 2017/5/10.
//  Copyright © 2017年 majinxing. All rights reserved.
//

#import "PersonalInfoViewController.h"
#import "PersonalDataTableViewCell.h"
#import "DYHeader.h"
#import "TFFileUploadManager.h"
#import "HKClipperHelper.h"

@interface PersonalInfoViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,PersonalDataTableViewCellDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>
@property (nonatomic,strong)UITableView * tableView;
@property (nonatomic,strong)UserModel * user;
@property (nonatomic,strong)NSMutableArray * labelAry;
@property (nonatomic,strong)NSMutableArray * textAry;
@property (nonatomic,assign) BOOL isEdictor;
@property (nonatomic,strong)UIBarButtonItem *myButton;
@property (nonatomic,strong)NSString * sex;
@property (nonatomic,strong)UIImage * headImage;
@property (nonatomic,strong)NSString * filePath;
@end

@implementation PersonalInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavigationTitle];
    
    [self getData];
    
    [self addTableView];
    
    _sex = [[NSString alloc] init];
    
    _headImage = [[UIImage alloc] init];
    
    [self keyboardNotification];
       // Do any additional setup after loading the view from its nib.
}
-(void)getData{
    _user = [[Appsetting sharedInstance] getUsetInfo];
    NSDictionary * dict = [[NSDictionary alloc] initWithObjectsAndKeys:_user.peopleId,@"id", nil];
    
    [[NetworkRequest sharedInstance] GET:QuerySelfInfo dict:dict succeed:^(id data) {
//        NSLog(@"%@",data);
        NSDictionary * dict = [data objectForKey:@"body"];
        [[Appsetting sharedInstance] saveUserOtherInfo:dict];
        _user = [[Appsetting sharedInstance] getUsetInfo];
        _textAry =  [UIUtils returnAry:_user];
        UserModel * user = [[Appsetting sharedInstance] getUsetInfo];
        
        NSString * baseURL = user.host;
        
        _headImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@?resourceId=%@",baseURL,FileDownload,user.userHeadImageId]]]];
        [_tableView reloadData];
    } failure:^(NSError *error) {
        [UIUtils showInfoMessage:@"获取数据失败，请检查网络" withVC:self];

    }];
}
-(void)addTableView{
    
    _labelAry = [[NSMutableArray alloc] initWithObjects:@"姓名",@"学号",@"学校",@"院系",@"专业",@"电话",@"邮箱",@"住址",@"性别",@"生日",@"个性签名", nil];
    _textAry = [NSMutableArray arrayWithCapacity:1];
    for (int i = 0; i<11; i++) {
        [_textAry addObject:@""];
    }
    _isEdictor = NO;
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, APPLICATION_WIDTH, APPLICATION_HEIGHT-64) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = NO;
    [self.view addSubview:_tableView];

}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
/**
 *  显示navigation的标题
 **/
-(void)setNavigationTitle{
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
    self.title = @"个人资料";
    _myButton = [[UIBarButtonItem alloc] initWithTitle:@"修改" style:UIBarButtonItemStylePlain target:self action:@selector(changeInfo:)];
    self.navigationItem.rightBarButtonItem = _myButton;
}
-(void)changeInfo:(UIBarButtonItem *)btn{
    if ([_myButton.title isEqualToString:@"修改"]) {
        [_myButton setTitle:@"保存"];
        _isEdictor = YES;
        [_tableView reloadData];
    }else{
        [_myButton setTitle:@"修改"];
        _isEdictor = NO;
        [_tableView reloadData];
        NSDictionary * dict = [[NSDictionary alloc] initWithObjectsAndKeys:_user.peopleId,@"id",_textAry[6],@"email",_textAry[7],@"region",_sex,@"sex",_textAry[9],@"birthday",_textAry[10],@"sign",nil];
        [[NetworkRequest sharedInstance] POST:ChangeSelfInfo dict:dict succeed:^(id data) {
//            NSLog(@"%@",data);
            NSString * str = [NSString stringWithFormat:@"%@",[[data objectForKey:@"header"] objectForKey:@"code"]];
            if ([str isEqualToString:@"0000"]) {
                [UIUtils showInfoMessage:@"修改成功" withVC:self];
            }
        } failure:^(NSError *error) {
            
        }];
        
        NSDictionary * dict1 = [[NSDictionary alloc] initWithObjectsAndKeys:@"1",@"type",@"www",@"description",@"4",@"function",nil];
        if (_headImage) {
            [[NetworkRequest sharedInstance] POSTImage:FileUpload image:_headImage dict:dict1 succeed:^(id data) {
                NSString * code = [NSString stringWithFormat:@"%@",[[data objectForKey:@"header"] objectForKey:@"code"]];
                if ([code isEqualToString:@"0000"]) {
                    
                    NSArray * ary = [data objectForKey:@"body"];
                    [[Appsetting sharedInstance].mySettingData setValue:ary[0] forKey:@"user_pictureId"];
                }
            } failure:^(NSError *error) {
                
                [UIUtils showInfoMessage:@"发送数据失败，请检查网络" withVC:self];
                
            }];
        }
        
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    CGRect keyBoardRect=[note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, keyBoardRect.size.height, 0);
}
#pragma mark 键盘消失
-(void)keyboardWillHide:(NSNotification *)note
{
    self.tableView.contentInset = UIEdgeInsetsZero;
}
#pragma mark - HKClipperHelper

- (void)configHelperWithNav:(UINavigationController *)nav
                    imgSize:(CGSize)size
                 imgHandler:(void(^)(UIImage *img))handler {
    [HKClipperHelper shareManager].nav = nav;
    [HKClipperHelper shareManager].clippedImgSize = size;
    [HKClipperHelper shareManager].clippedImageHandler = handler;
}

#pragma mark PersonalDataTableViewCellDelegate
-(void)changeHeadImageDelegate:(UIButton *)btn{
    CGSize s = CGSizeMake(30, 30);
    [self configHelperWithNav:self.navigationController
                      imgSize:s
                   imgHandler:^(UIImage *img) {
                       _headImage = img;
                       [_tableView reloadData];
                   }];
    [HKClipperHelper shareManager].clipperType = ClipperTypeImgMove;
    [HKClipperHelper shareManager].systemEditing = NO;
    [HKClipperHelper shareManager].isSystemType = NO;
    [self selectImage];
}
//实现button点击事件的回调方法
- (void)selectImage{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:nil preferredStyle:  UIAlertControllerStyleActionSheet];
    //分别按顺序放入每个按钮；
    [alert addAction:[UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [[HKClipperHelper shareManager] photoWithSourceType:UIImagePickerControllerSourceTypeCamera];
        
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"从相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [[HKClipperHelper shareManager] photoWithSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
        
    }]];
    
    
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        //点击按钮的响应事件；
    }]];
    
    //弹出提示框；
    [self presentViewController:alert animated:true completion:nil];
}

-(void)textFieldDidChangeDelegate:(UITextField *)textFile{
    if ([UIUtils isBlankString:textFile.text]) {
        [_textAry setObject:@"" atIndexedSubscript:textFile.tag];
    }else{
        [_textAry setObject:textFile.text atIndexedSubscript:textFile.tag];
    }
}
-(void)changeSexBtnPressed:(UIButton *)btn{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:nil preferredStyle:  UIAlertControllerStyleActionSheet];
    //分别按顺序放入每个按钮；
    [alert addAction:[UIAlertAction actionWithTitle:@"男" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //点击按钮的响应事件；
        _textAry[8] = @"男";
        _sex = @"1";
        [_tableView reloadData];
        
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"女" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //点击按钮的响应事件；
        _textAry[8] = @"女";
        _sex = @"2";
        [_tableView reloadData];
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        //点击按钮的响应事件；
    }]];
    //弹出提示框；
    [self presentViewController:alert animated:true completion:nil];
}
#pragma mark UITableViewdelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }else if (section == 1){
        return 11;
    }
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PersonalDataTableViewCell * cell = [PersonalDataTableViewCell tempTableViewCellWith:tableView indexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.delegate = self;
    if (indexPath.section == 0) {
        
        [cell changeImageIsBool:_isEdictor withImage:_headImage];
    }
    if (indexPath.section == 1) {
        [cell setInfo:_labelAry[indexPath.row] withTextAry:_textAry[indexPath.row] isEdictor:_isEdictor withRow:indexPath.row];
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.view endEditing:YES];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}
#pragma mark UITextFieldDelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
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
