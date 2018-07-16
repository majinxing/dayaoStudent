//
//  AnswerChoiceQuestionViewController.m
//  WisdomHall
//
//  Created by XTU-TI on 2018/5/4.
//  Copyright © 2018年 majinxing. All rights reserved.
//

#import "AnswerChoiceQuestionViewController.h"
#import "DYHeader.h"
#import "ChoiceQuestionTableViewCell.h"
#import "optionsModel.h"
#import "imageBigView.h"

@interface AnswerChoiceQuestionViewController ()<UITableViewDelegate,UITableViewDataSource,ChoiceQuestionTableViewCellDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIPickerViewDelegate,UIPickerViewDataSource,imageBigViewDelegate>

@property (nonatomic,assign)int temp;//标记选择的模块
@property (nonatomic,assign)int pictureNum;//标记选择那张照片

@property (nonatomic,strong) UserModel * user;

@property (nonatomic,strong)UIButton * bView;//滚轮的背景

@property (nonatomic,strong)UIView * pickerView;

@property (nonatomic,strong)NSArray * scoreAry;//存储分数

@property (nonatomic,assign) int score;//标记转轮的位置

@property (nonatomic,strong) imageBigView * v;
@end

@implementation AnswerChoiceQuestionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    _user = [[Appsetting sharedInstance] getUsetInfo];
    
    _scoreAry = @[@"1",@"2",@"3",@"4",@"5",@"6",@"7"];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    //    [self setQuestionModel];
    
    [self addTableView];
    // Do any additional setup after loading the view from its nib.
}

-(void)setQuestionModel{
    _questionModel = [[QuestionModel alloc] init];
    
}
-(void)addTableView{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,0, APPLICATION_WIDTH, APPLICATION_HEIGHT-104) style:UITableViewStylePlain];
    
    _tableView.delegate = self;
    
    _tableView.dataSource = self;
    
    _tableView.userInteractionEnabled = YES;
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
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
#pragma mark imageBigViewDelegate
-(void)outViewDelegate{
    [_v removeFromSuperview];
    _v = nil;
}
#pragma mark ChoiceQuestionTableViewCellDelegate
-(void)firstSelectImageBtnDelegate:(UIButton *)sender{
    if (!_v) {
        _v = [[imageBigView alloc] initWithFrame:CGRectMake(0, 0, APPLICATION_WIDTH, APPLICATION_HEIGHT)];
    }
    _v.delegate = self;

    if ((sender.tag-101)<_questionModel.questionTitleImageIdAry.count&&_questionModel.questionTitleImageIdAry.count>0) {
        
        [_v addImageView:_questionModel.questionTitleImageIdAry[sender.tag-101]];
        
        [self.view addSubview:_v];
        
    }
}
//被选中
-(void)thirthSelectOptionDelegate:(UIButton *)sender{
    if (![_t.statusName isEqualToString:@"进行中"]) {
        return;
    }
    if ([_questionModel.titleType isEqualToString:@"1"]) {
        
        NSString * s = [NSString stringWithFormat:@"%c",(int)sender.tag];
        
        if ([[NSString stringWithFormat:@"%@",_questionModel.questionAnswer] isEqualToString:s]) {
            _questionModel.questionAnswer = @"";
        }else{
            _questionModel.questionAnswer = [NSString stringWithFormat:@"%c",(int)sender.tag];
        }
    }else{
        NSString *string = [NSString stringWithFormat:@"%@",_questionModel.questionAnswer];
        
        NSString * s = [NSString stringWithFormat:@"%c",(int)sender.tag];
        //字条串是否包含有某字符串
        if ([string rangeOfString:s].location == NSNotFound) {
            if ([UIUtils isBlankString:string]) {
                _questionModel.questionAnswer = [NSString stringWithFormat:@"%c",(int)sender.tag];
            }else{
                _questionModel.questionAnswer = [_questionModel.questionAnswer stringByAppendingString:[NSString stringWithFormat:@",%c",(int)sender.tag]];
            }
        } else {
            NSMutableArray *array = [[NSMutableArray alloc] initWithArray:[string componentsSeparatedByString:@","]];
            [array removeObject:s];
            _questionModel.questionAnswer = @"";
            for (int i = 0; i<array.count; i++) {
                if (i == 0) {
                    _questionModel.questionAnswer = [NSString stringWithFormat:@"%@",array[0]];
                }else{
                    _questionModel.questionAnswer = [_questionModel.questionAnswer stringByAppendingString:[NSString stringWithFormat:@"%@",array[i]]];
                }

            }
            NSLog(@"string 包含 martin");
        }
    }
    [_tableView reloadData];
}
-(void)addOptionsDelegate:(UIButton *)sender{
    
    optionsModel * option = [[optionsModel alloc] init];
    
    [_questionModel.qustionOptionsAry addObject:option];
    
    [_tableView reloadData];
}
-(void)thirthSelectOptionsImageBtnDelegate:(UIButton *)sender{
    if (_editable) {
        _temp = (int)sender.tag/1000+4;
        
        _pictureNum = (int)sender.tag%1000;
        
        [self selectPicture];
    }else{
        if (!_v) {
            _v = [[imageBigView alloc] initWithFrame:CGRectMake(0, 0, APPLICATION_WIDTH, APPLICATION_HEIGHT)];
        }
        _v.delegate = self;
        
        _temp = (int)sender.tag/1000+4;
        
        _pictureNum = (int)sender.tag%1000;
        
        optionsModel * opt = _questionModel.qustionOptionsAry[_temp-5];
        
        if ((_pictureNum-1)<opt.optionsImageIdAry.count&&opt.optionsImageIdAry.count>0) {
            
            [_v addImageView:opt.optionsImageIdAry[_pictureNum-1]];
            
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
        if (_editable) {
            return _questionModel.qustionOptionsAry.count+1;
        }else{
            return _questionModel.qustionOptionsAry.count;
            
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
            
        }else if(indexPath.section == 1){
            if (indexPath.row==_questionModel.qustionOptionsAry.count) {
                cell = [tableView dequeueReusableCellWithIdentifier:@"ChoiceQuestionTableViewCellFifth"];
                
                cell = [[[NSBundle mainBundle] loadNibNamed:@"ChoiceQuestionTableViewCell" owner:nil options:nil] objectAtIndex:4];
            }else{
                cell = [tableView dequeueReusableCellWithIdentifier:@"ChoiceQuestionTableViewCellThird"];
                
                cell = [[[NSBundle mainBundle] loadNibNamed:@"ChoiceQuestionTableViewCell" owner:nil options:nil] objectAtIndex:2];
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
        
    }else if (indexPath.section == 1){
        if (indexPath.row==_questionModel.qustionOptionsAry.count) {
            
        }else{
            NSString *string = [NSString stringWithFormat:@"%@",_questionModel.questionAnswer];
            
            NSString * s = [NSString stringWithFormat:@"%c",65+(int)indexPath.row];
            //字条串是否包含有某字符串
            if ([string rangeOfString:s].location == NSNotFound) {
                [cell addOptionWithModel:_questionModel.qustionOptionsAry[indexPath.row] withEdit:_editable withIndexRow:(int)indexPath.row withISelected:NO];

                NSLog(@"string 不存在 martin");
            } else {
                [cell addOptionWithModel:_questionModel.qustionOptionsAry[indexPath.row] withEdit:_editable withIndexRow:(int)indexPath.row withISelected:YES];

                NSLog(@"string 包含 martin");
            }
        }
    }
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        
        return [_questionModel returnTitleHeight];
        
    }else if (indexPath.section == 1){
        return [_questionModel returnOptionHeight:(int)indexPath.row];
    }
    return 60;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    NSArray * ary = @[[NSString stringWithFormat:@"第%d题 题目内容",_titleNum],@"选项",@"参考答案"];
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
        if ([_questionModel.titleType isEqualToString:@"1"]) {
            ll.text = [NSString stringWithFormat:@"题型：单选 %@ 分",_questionModel.qustionScore];
        }else{
            ll.text = [NSString stringWithFormat:@"题型：多选 %@ 分",_questionModel.qustionScore];
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
