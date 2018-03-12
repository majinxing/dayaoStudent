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
        _headImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@?resourceId=%@",BaseURL,FileDownload,user.userHeadImageId]]]];
        [_tableView reloadData];
    } failure:^(NSError *error) {
        
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
    //[self.navigationController.navigationBar setBarTintColor:[UIColor blackColor]];
    [self.navigationController.navigationBar setTitleTextAttributes:@{
                                                                      NSFontAttributeName:[UIFont systemFontOfSize:17],
                                                                      NSForegroundColorAttributeName:[UIColor blackColor]}];
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
        } failure:^(NSError *error) {
            
        }];
        
        NSDictionary * dict1 = [[NSDictionary alloc] initWithObjectsAndKeys:@"1",@"type",@"www",@"description",@"4",@"function",nil];

        [[NetworkRequest sharedInstance] POSTImage:FileUpload image:_headImage dict:dict1 succeed:^(id data) {
            NSString * code = [NSString stringWithFormat:@"%@",[[data objectForKey:@"header"] objectForKey:@"code"]];
            if ([code isEqualToString:@"0000"]) {
                
                NSArray * ary = [data objectForKey:@"body"];
                [[Appsetting sharedInstance].mySettingData setValue:ary[0] forKey:@"user_pictureId"];
            }
        } failure:^(NSError *error) {
            
        }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark PersonalDataTableViewCellDelegate
-(void)changeHeadImageDelegate:(UIButton *)btn{
    [self selectImage];
}
//实现button点击事件的回调方法
- (void)selectImage{
    
    //调用系统相册的类
    UIImagePickerController *pickerController = [[UIImagePickerController alloc]init];
    
    //设置选取的照片是否可编辑
    pickerController.allowsEditing = YES;
    //设置相册呈现的样式
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:nil preferredStyle:  UIAlertControllerStyleActionSheet];
    //分别按顺序放入每个按钮；
    [alert addAction:[UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        pickerController.sourceType =  UIImagePickerControllerSourceTypeCamera;//图片分组列表样式
        
        //选择完成图片或者点击取消按钮都是通过代理来操作我们所需要的逻辑过程
        pickerController.delegate = self;
        //使用模态呈现相册
        [self.navigationController presentViewController:pickerController animated:YES completion:^{
            
        }];
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"从相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        pickerController.sourceType =  UIImagePickerControllerSourceTypeSavedPhotosAlbum;//图片分组列表样式
        //照片的选取样式还有以下两种
        //UIImagePickerControllerSourceTypePhotoLibrary,直接全部呈现系统相册UIImagePickerControllerSourceTypeSavedPhotosAlbum
        //UIImagePickerControllerSourceTypeCamera//调取摄像头
        
        //选择完成图片或者点击取消按钮都是通过代理来操作我们所需要的逻辑过程
        pickerController.delegate = self;
        //使用模态呈现相册
        [self.navigationController presentViewController:pickerController animated:YES completion:^{
            
        }];
        
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        //点击按钮的响应事件；
    }]];
    
    //弹出提示框；
    [self presentViewController:alert animated:true completion:nil];
    
}
//选择照片完成之后的代理方法

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    
    //info是所选择照片的信息
    
    //    UIImagePickerControllerEditedImage//编辑过的图片
    //    UIImagePickerControllerOriginalImage//原图
    
    
    //刚才已经看了info中的键值对，可以从info中取出一个UIImage对象，将取出的对象赋给按钮的image
    
    UIImage *resultImage = [info objectForKey:@"UIImagePickerControllerEditedImage"];
   
    NSString * filePath = [info objectForKey:@"UIImagePickerControllerReferenceURL"];
    
    _filePath = [NSString stringWithFormat:@"%@",filePath];
    
    _headImage = resultImage;
    [_tableView reloadData];
    //使用模态返回到软件界面
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    
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
