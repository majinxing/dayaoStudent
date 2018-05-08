//
//  AnswerTOFQuestionViewController.m
//  WisdomHall
//
//  Created by XTU-TI on 2018/5/4.
//  Copyright © 2018年 majinxing. All rights reserved.
//

#import "AnswerTOFQuestionViewController.h"
#import "DYHeader.h"
#import "ChoiceQuestionTableViewCell.h"
#import "optionsModel.h"
@interface AnswerTOFQuestionViewController ()<UITableViewDelegate,UITableViewDataSource,ChoiceQuestionTableViewCellDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIPickerViewDelegate,UIPickerViewDataSource>
@property (nonatomic,strong)UITableView * tableView;

@property (nonatomic,assign)int temp;//标记选择的模块
@property (nonatomic,assign)int pictureNum;//标记选择那张照片

@property (nonatomic,strong) UserModel * user;

@property (nonatomic,strong)UIButton * bView;//滚轮的背景

@property (nonatomic,strong)UIView * pickerView;

@property (nonatomic,strong)NSArray * scoreAry;//存储分数

@property (nonatomic,assign) int score;//标记转轮的位置

@end

@implementation AnswerTOFQuestionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _user = [[Appsetting sharedInstance] getUsetInfo];
    
    [self.view.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];

    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self addTableView];

    // Do any additional setup after loading the view from its nib.
}
-(void)addTableView{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,0, APPLICATION_WIDTH, APPLICATION_HEIGHT-104) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self.view addSubview:_tableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)addPickView{
    [self.view endEditing: YES];
    if (!self.pickerView) {
        self.bView = [UIButton buttonWithType:UIButtonTypeCustom];
        self.bView.frame = CGRectMake(0, 0, APPLICATION_WIDTH, APPLICATION_HEIGHT-104);
        self.bView.backgroundColor = [UIColor blackColor];
        [self.bView addTarget:self action:@selector(outView) forControlEvents:UIControlEventTouchUpInside];
        self.bView.alpha = 0.5;
        self.pickerView = [[UIView alloc] initWithFrame:CGRectMake(0, APPLICATION_HEIGHT - 200 - 30 - 104, APPLICATION_WIDTH, 200 + 30)];
        
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
    
    
    _questionModel.questionAnswer = [NSString stringWithFormat:@"%@",_questionModel.answerOptions[_score]];
    
    [_tableView reloadData];
//    }else if (_temp == 3){
//        _questionModel.questionDifficulty = [NSString stringWithFormat:@"%@",_scoreAry[_score]];
//    }
//    //    [_tableView reloadData];
//
//    //    NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:1];
//    //
//    //    [_tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationNone];
//    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:0 inSection:1];
//
//    [_tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
}


#pragma mark UIPickViewDelegate

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    
    return 1;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (_questionModel.answerOptions.count>0) {
        return _questionModel.answerOptions.count;
    }
    
    return 2;
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (_questionModel.answerOptions.count == 2) {
        return _questionModel.answerOptions[row];
    }
    
    return @"2016";
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    _score = (int)row;
    
}
#pragma mark ChoiceQuestionTableViewCellDelegate
-(void)textViewDidChangeDelegate:(UITextView *)textView{
    if (![_t.statusName isEqualToString:@"进行中"]) {
        [self.view endEditing:YES];
        return;
    }
    _score = 0;
    [self addPickView];
}

//题干选择图片
-(void)firstSelectImageBtnDelegate:(UIButton *)sender{
    _temp = 1;
    _pictureNum = (int)sender.tag;
    [self selectPicture];
}
-(void)selectPicture{
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
#pragma mark UITableViewdelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section ==0) {
        return 1;
    }else if (section == 1){
        return 1;
    }
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ChoiceQuestionTableViewCell * cell;
    
    if (!cell) {
        if (indexPath.section == 0) {
            cell = [tableView dequeueReusableCellWithIdentifier:@"ChoiceQuestionTableViewCellFirst"];
            
            cell = [[[NSBundle mainBundle] loadNibNamed:@"ChoiceQuestionTableViewCell" owner:nil options:nil] objectAtIndex:0];
            
        }else if (indexPath.section == 1){
            if (indexPath.row == 0) {
                cell = [tableView dequeueReusableCellWithIdentifier:@"ChoiceQuestionTableViewCellSeventh"];
                
                cell = [[[NSBundle mainBundle] loadNibNamed:@"ChoiceQuestionTableViewCell" owner:nil options:nil] objectAtIndex:6];
            }else{
                cell = [tableView dequeueReusableCellWithIdentifier:@"ChoiceQuestionTableViewCellFourth"];
                
                cell = [[[NSBundle mainBundle] loadNibNamed:@"ChoiceQuestionTableViewCell" owner:nil options:nil] objectAtIndex:3];
            }
            
        }
    }
    cell.delegate = self;
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    if (indexPath.section == 0) {
        
        [cell addFirstTitleTextView:_questionModel.questionTitle withImageAry:_questionModel.questionTitleImageAry withIsEdit:_editable];
    }else{
        [cell addSeventhTextViewWithStr:_questionModel.questionAnswer];
    }
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (_editable) {
            return 480;
        }else{
            if (_questionModel.questionTitleImageIdAry.count>0||_questionModel.questionTitleImageAry.count>0) {
                return 480;
            }
            return 200;
        }
    }
    return 60;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    NSArray * ary = @[[NSString stringWithFormat:@"第%d题 题目内容",_titleNum],@"答案"];
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, APPLICATION_WIDTH, 30)];
    view.backgroundColor = RGBA_COLOR(236, 236, 236, 1);
    UILabel * l = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 300, 20)];
    l.font = [UIFont systemFontOfSize:15];
    
    [view addSubview:l];
    
    l.text = ary[(int)section];
    if ((int)section == 0) {
        UILabel * ll = [[UILabel alloc] initWithFrame:CGRectMake(APPLICATION_WIDTH-200, 5, 180, 20)];
        ll.textAlignment = NSTextAlignmentRight;
        
        ll.font = [UIFont systemFontOfSize:15];
        
        [view addSubview:ll];
        
        ll.text = [NSString stringWithFormat:@"题型：判断 %@ 分",_questionModel.qustionScore];
        
    }
    return view;
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
}
#pragma mark 选取后的图片处理
//选择照片完成之后的代理方法

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    
    //info是所选择照片的信息
    
    //    UIImagePickerControllerEditedImage//编辑过的图片
    //    UIImagePickerControllerOriginalImage//原图
    
    
    //刚才已经看了info中的键值对，可以从info中取出一个UIImage对象，将取出的对象赋给按钮的image
    
    UIImage *resultImage = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if (_temp == 1) {
            if ((_pictureNum - 101)<_questionModel.questionTitleImageAry.count&&(_pictureNum-101>=0)) {
                [_questionModel.questionTitleImageAry replaceObjectAtIndex:(_pictureNum - 101) withObject:resultImage];
            }else{
                [_questionModel.questionTitleImageAry addObject:resultImage];
            }
            [_tableView reloadData];
            
        }else if (_temp>4){
            if ((_temp-5)<_questionModel.qustionOptionsAry.count&&(_temp-5)>=0) {
                
                optionsModel * optionModel = _questionModel.qustionOptionsAry[_temp-5];
                if ((_pictureNum-1)<optionModel.optionsImageAry.count&&(_pictureNum-1)>=0) {
                    
                    [optionModel.optionsImageAry replaceObjectAtIndex:(_pictureNum - 1) withObject:resultImage];
                    
                }else{
                    
                    [optionModel.optionsImageAry addObject:resultImage];
                    
                }
                [_questionModel.qustionOptionsAry replaceObjectAtIndex:_temp-5 withObject:optionModel];
            }
        }
        [_tableView reloadData];
    });
    
    
    //使用模态返回到软件界面
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    
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
