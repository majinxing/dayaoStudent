//
//  CreateHomeworkViewController.m
//  WisdomHall
//
//  Created by XTU-TI on 2018/3/23.
//  Copyright © 2018年 majinxing. All rights reserved.
//

#import "CreateHomeworkViewController.h"
#import "HomeworkCreateTableViewCell.h"
#import "DYHeader.h"
//#import "CalendarViewController.h"
//#import "ImageBrowserViewController.h"
#import "imageBigView.h"

@interface CreateHomeworkViewController ()<UITableViewDelegate,UITableViewDataSource,HomeworkCreateTableViewCellDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,imageBigViewDelegate>
@property (nonatomic,strong) UITableView * tableView;
@property (nonatomic,strong) NSMutableArray * imageAry;
@property (nonatomic,strong) UserModel * user;
@property (nonatomic,strong) NSString * endTime;
@property (nonatomic,strong) NSString * homeworkStr;
@property (nonatomic,strong) NSString * homeworkId;
@property (nonatomic,assign) int imageNum;
@property (nonatomic,strong) NSMutableArray * failureAry;
@property (nonatomic,weak) UIViewController *handleVC;
@property (nonatomic,strong) imageBigView * v;

@end

@implementation CreateHomeworkViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    _imageAry = [NSMutableArray arrayWithCapacity:1];
    
    _endTime = [[NSString alloc] init];
    
    _homeworkStr = [[NSString alloc] init];
    
    _homeworkId = [[NSString alloc] init];
    
    _imageNum = 0;
    
    _failureAry = [NSMutableArray arrayWithCapacity:1];
    
    if (_homeworkModel) {
        _homeworkStr = _homeworkModel.homeworkInfo;
        
        _endTime = _homeworkModel.endTime;
        
        _imageAry = _homeworkModel.homeworkAry;
    }
    [self addTableView];
    // Do any additional setup after loading the view from its nib.
}
-(void)addTableView{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, NaviHeight, APPLICATION_WIDTH,APPLICATION_HEIGHT-64) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark imageBigViewDelegate
-(void)outViewDelegate{
    [_v removeFromSuperview];
    _v = nil;
}
#pragma mark HomeworkCreateTableViewCellDelegate
-(void)textViewDidChangeDelegate:(UITextView *)textView{
    _homeworkStr = textView.text;
}
-(void)selectImageBtnDelegate:(UIButton *)btn{
    
    _imageNum = (int)btn.tag;
    if (_edit) {
        [self getPicture];
    }else{
        if (!_v) {
            _v = [[imageBigView alloc] initWithFrame:CGRectMake(0,64, APPLICATION_WIDTH, APPLICATION_HEIGHT)];
        }
    if(_homeworkModel.homeworkAry.count>0&&(_imageNum-2)<_homeworkModel.homeworkAry.count) {
            [_v addImageView:_homeworkModel.homeworkAry[_imageNum -2]];
            _v.delegate = self;
            [self.view addSubview:_v];
        }
        
    }
}

-(void)selectTimeBtnPressedDelegate{
//    CalendarViewController * vc = [[CalendarViewController alloc] init];
//    self.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:vc animated:YES];
//    [vc returnText:^(NSString *str) {
//        if (![UIUtils isBlankString:str]) {
//            _endTime = str;
//            [_tableView reloadData];
//        }
//    }];
}
-(void)sendHomeworkPressedDelegate:(NSString *)homeworkText{
    if ([UIUtils isBlankString:_homeworkStr]) {
        [UIUtils showInfoMessage:@"请输入作业内容" withVC:self];
        return;
    }else if ([UIUtils isBlankString:_endTime]){
        [UIUtils showInfoMessage:@"请输入作业截止时间" withVC:self];
        return;
    }
   
    [self showHudInView:self.view hint:NSLocalizedString(@"正在上传数据", @"Load data...")];
    
    NSDictionary * dict = [[NSDictionary alloc] initWithObjectsAndKeys:_homeworkStr,@"content",@"作业",@"describe",[NSString stringWithFormat:@"%@",_c.sclassId],@"courseId",[NSString stringWithFormat:@"%@ 00:00:00",_endTime],@"finishTime", nil];
    
    [[NetworkRequest sharedInstance] POST:CreateHomework dict:dict succeed:^(id data) {
        NSLog(@"%@",data);
        NSString *code = [[data objectForKey:@"header"] objectForKey:@"code"];
        if (![UIUtils isBlankString:code]) {
            if ([code isEqualToString:@"0000"]) {
                _homeworkId = [data objectForKey:@"body"];
                if (_imageAry.count>0) {
                    [self sendImageWithImage:_imageAry[0]];
                }
            }else{
                [UIUtils showInfoMessage:@"作业创建失败" withVC:self];
            }
        }else{
            [UIUtils showInfoMessage:@"作业创建失败" withVC:self];
        }
        
    } failure:^(NSError *error) {
        [UIUtils showInfoMessage:@"创建数据失败，请检查网络" withVC:self];
    }];
}
-(void)sendImageWithImage:(UIImage *)image{
    NSString * str = [NSString stringWithFormat:@"%@-%@-%@",_user.userName,_user.studentId,[UIUtils getTime]];
    NSDictionary * dict1 = [[NSDictionary alloc] initWithObjectsAndKeys:@"1",@"type",str,@"description",@"11",@"function",_homeworkId,@"relId",@"false",@"deleteOld",nil];
    
    [[NetworkRequest sharedInstance] POSTImage:FileUpload image:image dict:dict1 succeed:^(id data) {
        NSString * code = [NSString stringWithFormat:@"%@",[[data objectForKey:@"header"] objectForKey:@"code"]];
        if ([code isEqualToString:@"0000"]) {
//            [UIUtils showInfoMessage:@"上传成功"];
            if (_imageAry.count>1) {
                [_imageAry removeObjectAtIndex:0];
                [self sendImageWithImage:_imageAry[0]];
                
            }else if(_imageAry.count == 1){
                if (_failureAry.count>0) {
                     [self hideHud];
                    [UIUtils showInfoMessage:[NSString stringWithFormat:@"有%ld张照片上传失败",_failureAry.count] withVC:self];
                    
                }else{
                     [self hideHud];
                    [UIUtils showInfoMessage:@"上传成功" withVC:self];
                }
            }
            
        }else{
            if (_imageAry.count>1) {
                [_failureAry addObject:_imageAry[0]];
                [_imageAry removeObjectAtIndex:0];
                [self sendImageWithImage:_imageAry[0]];
            }else if(_imageAry.count == 1){
                [_failureAry addObject:_imageAry[0]];
                if (_failureAry.count>0) {
                     [self hideHud];
                    [UIUtils showInfoMessage:[NSString stringWithFormat:@"有%ld张照片上传失败",_failureAry.count] withVC:self];
                }else{
                     [self hideHud];
                    [UIUtils showInfoMessage:@"上传成功" withVC:self];
                }
            }
        }
    } failure:^(NSError *error) {
        if (_imageAry.count>1) {
            [_failureAry addObject:_imageAry[0]];
            [_imageAry removeObjectAtIndex:0];
            [self sendImageWithImage:_imageAry[0]];
        }else if(_imageAry.count == 1){
            [_failureAry addObject:_imageAry[0]];
            if (_failureAry.count>0) {
                 [self hideHud];
                [UIUtils showInfoMessage:[NSString stringWithFormat:@"有%ld张照片上传失败",_failureAry.count] withVC:self];
            }else{
                 [self hideHud];
                [UIUtils showInfoMessage:@"上传成功" withVC:self];
            }
        }
    }];
}
-(void)getPicture{
    //实现button点事件的回调方法
    //调用系统相册的类
    UIImagePickerController *pickerController = [[UIImagePickerController alloc]init];
    
    //设置选取的照片是否可编辑
    
    //   pickerController.allowsEditing = YES;
    
    //设置相册呈现的样式
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:nil preferredStyle:  UIAlertControllerStyleActionSheet];
    //分别按顺序放入每个按钮；
    [alert addAction:[UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        pickerController.sourceType =  UIImagePickerControllerSourceTypeCamera;//图片分组列表样式
        pickerController.cameraDevice = UIImagePickerControllerCameraDeviceRear;
        
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
    
    UIImage *resultImage = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    
    
    //    UserModel * user = [[Appsetting sharedInstance] getUsetInfo];
    dispatch_async(dispatch_get_main_queue(), ^{
        
        if ((_imageNum-2)<_imageAry.count) {
            [_imageAry replaceObjectAtIndex:(_imageNum-2) withObject:resultImage];
        }else{
            [_imageAry addObject:resultImage];
        }
        [_tableView reloadData];
    });
    
    
    //使用模态返回到软件界面
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    
}
#pragma mark UITableViewdelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HomeworkCreateTableViewCell * cell;
    if (indexPath.row ==0) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"HomeworkCreateTableViewCellFirst"];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"HomeworkCreateTableViewCell" owner:self options:nil] objectAtIndex:0];
        }
        [cell addContentFirstView:_homeworkStr];
    }else if (indexPath.row ==1){
        cell = [tableView dequeueReusableCellWithIdentifier:@"HomeworkCreateTableViewCellSecond"];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"HomeworkCreateTableViewCell" owner:self options:nil] objectAtIndex:1];
        }
        [cell setbtnImageWithAry:_imageAry withEndTime:_endTime edit:_edit];
        
    }else if (indexPath.row == 2){
        cell = [tableView dequeueReusableCellWithIdentifier:@"HomeworkCreateTableViewCellThird"];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"HomeworkCreateTableViewCell" owner:self options:nil] objectAtIndex:2];
        }
        if (!_edit) {
            [cell.sendHomework setHidden:YES];
        }
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.delegate = self;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return 200;
    }else if (indexPath.row == 1){
        if (_imageAry.count<3) {
            return APPLICATION_WIDTH/3+70;
        }else{
            return APPLICATION_WIDTH/3*2+70;
        }
        
    }else if (indexPath.row == 2) {
        return 60;
    }
    return 0;
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
