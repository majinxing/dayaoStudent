//
//  AnswerEssayQuestionViewController.m
//  WisdomHall
//
//  Created by XTU-TI on 2018/5/4.
//  Copyright © 2018年 majinxing. All rights reserved.
//

#import "AnswerEssayQuestionViewController.h"
#import "DYHeader.h"
#import "ChoiceQuestionTableViewCell.h"
#import "optionsModel.h"
#import "EditPageView.h"
#import "imageBigView.h"

@interface AnswerEssayQuestionViewController ()<UITableViewDelegate,UITableViewDataSource,ChoiceQuestionTableViewCellDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIPickerViewDelegate,UIPickerViewDataSource,EditPageViewDelegate,imageBigViewDelegate>

@property (nonatomic,strong)UITableView * tableView;

@property (nonatomic,assign)int temp;//标记选择的模块

@property (nonatomic,assign)int pictureNum;//标记选择那张照片

@property (nonatomic,strong) UserModel * user;

@property (nonatomic,strong)UIButton * bView;//滚轮的背景

@property (nonatomic,strong)UIView * pickerView;

@property (nonatomic,strong)NSArray * scoreAry;//存储分数

@property (nonatomic,assign) int score;//标记转轮的位置@end

@property (nonatomic,strong)EditPageView * editPageView;

@property (nonatomic,strong) imageBigView * v;

@end

@implementation AnswerEssayQuestionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _user = [[Appsetting sharedInstance] getUsetInfo];
    
    _scoreAry = @[@"1",@"2",@"3",@"4",@"5",@"6",@"7"];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];

    
    [self addTableView];
    // Do any additional setup after loading the view from its nib.
}
-(void)addTableView{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,0, APPLICATION_WIDTH, APPLICATION_HEIGHT-104) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    [self.view addSubview:_tableView];
    
    UISwipeGestureRecognizer * priv = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFrom:)];
    [priv setDirection:(UISwipeGestureRecognizerDirectionRight)];
    [_tableView addGestureRecognizer:priv];
    UISwipeGestureRecognizer * recognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeFrom:)];
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionLeft)];
    [_tableView addGestureRecognizer:recognizer];
}
-(void)handleSwipeFrom:(UISwipeGestureRecognizer *)recognizer{
    if (self.delegate&&[self.delegate respondsToSelector:@selector(handleSwipeFromDelegate:)]) {
        [self.delegate handleSwipeFromDelegate:recognizer];
    }
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
    
    if (_temp == 2) {
        _questionModel.qustionScore = [NSString stringWithFormat:@"%@",_scoreAry[_score]];
    }else if (_temp == 3){
        _questionModel.questionDifficulty = [NSString stringWithFormat:@"%@",_scoreAry[_score]];
    }
    //    [_tableView reloadData];
    
    //    NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:1];
    //
    //    [_tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationNone];
    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:0 inSection:1];
    
    [_tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
}


#pragma mark UIPickViewDelegate

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    
    return 1;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    
    return _scoreAry.count;
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return _scoreAry[row];
    
    return @"2016";
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    _score = (int)row;
    
}
#pragma mark imageBigViewDelegate
-(void)outViewDelegate{
    [_v removeFromSuperview];
}
#pragma mark EditPageViewDelegate
-(void)saveTextStrDelegate:(UIButton *)btn{
    if (btn.tag ==1) {
        
    }else{
        _questionModel.questionAnswer = _editPageView.textView.text;
        
        [_tableView reloadData];
    }
    
    [self.view endEditing:YES];
    
    [_editPageView removeFromSuperview];
    
    _editPageView  = nil;
    
}
#pragma mark ChoiceQuestionTableViewCellDelegate
-(void)deleAnswerImageDelegate:(UIButton *)sender{
    if (![_t.statusName isEqualToString:@"进行中"]) {
//        [self.view endEditing:YES];
        return;
    }
    int n = (int)sender.tag-1001;
    if (n<_questionModel.questionAnswerImageAry.count&&n>=0) {
        [_questionModel.questionAnswerImageAry removeObjectAtIndex:n];
    }
    
    if (n<_questionModel.questionAnswerImageIdAry.count&&n>=0) {
        
        [_questionModel.questionAnswerImageIdAry removeObjectAtIndex:n];
    }
    [_tableView reloadData];
}
-(void)textViewDidChangeDelegate:(UITextView *)textView{
    if (![_t.statusName isEqualToString:@"进行中"]) {
        [self.view endEditing:YES];
        return;
    }
    
    if (!_editPageView) {
        _editPageView = [[EditPageView alloc] init];
    }
    _editPageView.textView.text = _questionModel.questionAnswer;
    
    _editPageView.frame = CGRectMake(0, 0, APPLICATION_WIDTH, APPLICATION_HEIGHT);
    
    _editPageView.delegate = self;
    
    [self.view addSubview:_editPageView];
}
//选分数
-(void)selectScoreDeleate:(UIButton *)sender{
    _temp = 2;
    _score = 0;
    [self addPickView];
}
//选难度
-(void)selectDifficultyDelegate:(UIButton *)sender{
    _temp = 3;
    _score = 0;
    [self addPickView];
}
//题干选择图片
-(void)firstSelectImageBtnDelegate:(UIButton *)sender{
    
    UIImage *i = sender.currentBackgroundImage;
    
    float f = i.size.width;
    if (!_v) {
        _v = [[imageBigView alloc] initWithFrame:CGRectMake(0, 0, APPLICATION_WIDTH, APPLICATION_HEIGHT-104)];
    }
    
    _v.delegate = self;
    
    if (f>0) {
        if((sender.tag-101)<_questionModel.questionAnswerImageAry.count&&_questionModel.questionAnswerImageAry.count>0) {
            
            [_v addImageViewWithImage:_questionModel.questionAnswerImageAry[sender.tag-101]];
            
            [self.view addSubview:_v];
            
        }else{
            if (![_t.statusName isEqualToString:@"进行中"]) {
                return;
            }
            _temp = 1;
            _pictureNum = (int)sender.tag;
            [self selectPicture];
        }
    }else{
        
        if ((sender.tag-101)<_questionModel.questionTitleImageIdAry.count&&_questionModel.questionTitleImageIdAry.count>0) {
            
            [_v addImageView:_questionModel.questionTitleImageIdAry[sender.tag-101]];
            
            [self.view addSubview:_v];
            
        }
    }
}
-(void)selectPicture{
    //实现button点事件的回调方法
    //调用系统相册的类
    UIImagePickerController *pickerController = [[UIImagePickerController alloc]init];
    
    //设置选取的照片是否可编辑
    
    //   pickerController.allowsEditing = YES;
    pickerController.sourceType =  UIImagePickerControllerSourceTypeCamera;//图片分组列表样式
    pickerController.cameraDevice = UIImagePickerControllerCameraDeviceRear;
    
    //选择完成图片或者点击取消按钮都是通过代理来操作我们所需要的逻辑过程
    pickerController.delegate = self;
    //使用模态呈现相册
    [self.navigationController presentViewController:pickerController animated:YES completion:^{
        
    }];
    //    //实现button点事件的回调方法
    //    //调用系统相册的类
    //    UIImagePickerController *pickerController = [[UIImagePickerController alloc]init];
    //
    //    //设置选取的照片是否可编辑
    //
    //    //   pickerController.allowsEditing = YES;
    //
    //    //设置相册呈现的样式
    //
    //    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:nil preferredStyle:  UIAlertControllerStyleActionSheet];
    //    //分别按顺序放入每个按钮；
    //    [alert addAction:[UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    //        pickerController.sourceType =  UIImagePickerControllerSourceTypeCamera;//图片分组列表样式
    //        pickerController.cameraDevice = UIImagePickerControllerCameraDeviceRear;
    //
    //        //选择完成图片或者点击取消按钮都是通过代理来操作我们所需要的逻辑过程
    //        pickerController.delegate = self;
    //        //使用模态呈现相册
    //        [self.navigationController presentViewController:pickerController animated:YES completion:^{
    //
    //        }];
    //    }]];
    //
    //    [alert addAction:[UIAlertAction actionWithTitle:@"从相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    //
    //        pickerController.sourceType =  UIImagePickerControllerSourceTypeSavedPhotosAlbum;//图片分组列表样式
    //        //照片的选取样式还有以下两种
    //        //UIImagePickerControllerSourceTypePhotoLibrary,直接全部呈现系统相册UIImagePickerControllerSourceTypeSavedPhotosAlbum
    //        //UIImagePickerControllerSourceTypeCamera//调取摄像头
    //
    //        //选择完成图片或者点击取消按钮都是通过代理来操作我们所需要的逻辑过程
    //        pickerController.delegate = self;
    //        //使用模态呈现相册
    //        [self.navigationController presentViewController:pickerController animated:YES completion:^{
    //
    //        }];
    //
    //    }]];
    //
    //
    //    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
    //        //点击按钮的响应事件；
    //    }]];
    //
    //    //弹出提示框；
    //    [self presentViewController:alert animated:true completion:nil];
}
#pragma mark UITableViewdelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section ==0) {
        return 1;
    }else if (section == 1){
        if ([_questionModel.titleType isEqualToString:@"4"]) {
            if (_editable) {
                return _questionModel.blankAry.count+3;
            }else{
                return 1;//_questionModel.blankAry.count;
            }
        }else{
            if (_editable) {
                return 2;
            }
            return 1;
        }
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
            
            if ([_questionModel.titleType  isEqualToString:@"4"]) {
                cell = [tableView dequeueReusableCellWithIdentifier:@"ChoiceQuestionTableViewCellSeventh"];
                
                cell = [[[NSBundle mainBundle] loadNibNamed:@"ChoiceQuestionTableViewCell" owner:nil options:nil] objectAtIndex:6];
                //                }
            }else{
                if (indexPath.row ==1) {
                    cell = [tableView dequeueReusableCellWithIdentifier:@"ChoiceQuestionTableViewCellSixth"];
                    
                    cell = [[[NSBundle mainBundle] loadNibNamed:@"ChoiceQuestionTableViewCell" owner:nil options:nil] objectAtIndex:5];
                }else{
                    cell = [tableView dequeueReusableCellWithIdentifier:@"ChoiceQuestionTableViewCellFirst"];
                    
                    cell = [[[NSBundle mainBundle] loadNibNamed:@"ChoiceQuestionTableViewCell" owner:nil options:nil] objectAtIndex:0];
                }
            }
            
        }
    }
    cell.delegate = self;
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    if (indexPath.section == 0) {
        if (_editable) {
            [cell addFirstTitleTextView:_questionModel.questionTitle withImageAry:_questionModel.questionTitleImageAry withIsEdit:_editable];
            
        }else{
            [cell addFirstTitleTextView:_questionModel.questionTitle withImageAry:_questionModel.questionTitleImageIdAry withIsEdit:_editable];
        }
    }else if(indexPath.section == 1){
        if ([_questionModel.titleType  isEqualToString:@"5"]) {
            if (![_t.statusName isEqualToString:@"进行中"]) {
                [cell addFirstTitleTextView:_questionModel.questionAnswer withImageAry:_questionModel.questionAnswerImageAry withIsEdit:YES];
            }else{
                //问答。可上传图片
                [cell addFirstTitleTextView:_questionModel.questionAnswer withImageAry:_questionModel.questionAnswerImageAry withIsEdit:YES];
            }
           
        }else{
            [cell addSeventhTextViewWithStr:_questionModel.questionAnswer];
        }
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (_editable) {
            return 200;
        }else{
            return [_questionModel returnTitleHeight];
        }
    }else if (indexPath.section == 1){
//        if ([_questionModel.titleType  isEqualToString:@"5"]) {
        
            return [_questionModel returnAnswerHeight];
            
//        }
//        return 110;
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
    UILabel * l = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 200, 20)];
    l.font = [UIFont systemFontOfSize:15];
    
    [view addSubview:l];
    
    l.text = ary[(int)section];
    if ((int)section == 0) {
        UILabel * ll = [[UILabel alloc] initWithFrame:CGRectMake(APPLICATION_WIDTH-200, 5, 180, 20)];
        ll.textAlignment = NSTextAlignmentRight;
        
        ll.font = [UIFont systemFontOfSize:15];
        
        [view addSubview:ll];
        if ([_questionModel.titleType isEqualToString:@"4"]) {
            ll.text = [NSString stringWithFormat:@"题型：填空 %@ 分",_questionModel.qustionScore];
        }else{
            ll.text = [NSString stringWithFormat:@"题型：问答 %@ 分",_questionModel.qustionScore];
        }
        
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
    
    UIImage *resultImage = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    
    //刚才已经看了info中的键值对，可以从info中取出一个UIImage对象，将取出的对象赋给按钮的image
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    // 异步执行任务创建方法
    dispatch_async(queue, ^{
        
        
        if (_temp == 1) {
            if ((_pictureNum - 101)<_questionModel.questionAnswerImageAry.count) {
                [_questionModel.questionAnswerImageAry replaceObjectAtIndex:(_pictureNum - 101) withObject:resultImage];
            }else{
                [_questionModel.questionAnswerImageAry addObject:resultImage];
            }
        }
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            
            [_tableView reloadData];
            
        });
        
    });
    
    //使用模态返回到软件界面
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        
        [self sendImage:resultImage with:_pictureNum];
        
    }];
    
    
}
-(void)sendImage:(UIImage *)image with:(int)index{
    
    [self showHudInView:self.view hint:NSLocalizedString(@"正在上传数据", @"Load data...")];
    
    
    __weak AnswerEssayQuestionViewController * weakSelf = self;
    
    NSData *imageData = UIImageJPEGRepresentation(image,0.1);
    
    NSArray * ary = [NSArray arrayWithObject:imageData];
    
    NSDictionary * dict = [[NSDictionary alloc] initWithObjectsAndKeys:ary,@"myfiles", nil];
    
    if (self.delegate&&[self.delegate respondsToSelector:@selector(sendImageBeginDelegate)]) {
        [self.delegate sendImageBeginDelegate];
    }
    
    [[NetworkRequest sharedInstance] POSTImage:UploadTemp image:image dict:dict succeed:^(id data) {
        NSString * str = [NSString stringWithFormat:@"%@",[[data objectForKey:@"header"] objectForKey:@"code"]];
        if ([str isEqualToString:@"0000"]) {
            
            NSArray * ary = [data objectForKey:@"body"];
            
            NSString * idid = @"";
            
            if (ary.count>0) {
                
                idid = [NSString stringWithFormat:@"%@",ary[0]];
            }
            if ((_pictureNum - 101)<_questionModel.questionAnswerImageIdAry.count) {
                
                [_questionModel.questionAnswerImageIdAry replaceObjectAtIndex:(_pictureNum - 101) withObject:idid];
                
            }else{
                
                [_questionModel.questionAnswerImageIdAry addObject:idid];
                
            }
            [self hideHud];
        }else{
            [weakSelf sendImage:image with:index];
        }
        if (self.delegate&&[self.delegate respondsToSelector:@selector(sendImageEndDelegate)]) {
            [self.delegate sendImageEndDelegate];
        }
    } failure:^(NSError *error) {
        
        [self hideHud];
        if (self.delegate&&[self.delegate respondsToSelector:@selector(sendImageEndDelegate)]) {
            [self.delegate sendImageEndDelegate];
        }
        [UIUtils showInfoMessage:@"上传失败，请检查网络" withVC:self];
    }];
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

