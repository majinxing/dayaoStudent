//
//  NewAnswerViewController.m
//  WisdomHall
//
//  Created by XTU-TI on 2018/7/9.
//  Copyright © 2018年 majinxing. All rights reserved.
//

#import "NewAnswerViewController.h"
#import "DYHeader.h"

#import "ChoiceQuestionTableViewCell.h"

#import "QuestionModel.h"

#import "EditPageView.h"

#import "imageBigView.h"

@interface NewAnswerViewController ()<UITableViewDelegate,UITableViewDataSource,ChoiceQuestionTableViewCellDelegate,EditPageViewDelegate,UIPickerViewDelegate,UIPickerViewDataSource,imageBigViewDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>

@property (nonatomic,strong)UITableView * tableView;

@property (nonatomic,strong)NSString * testType;

@property (nonatomic,strong)NSMutableArray * allQuestionAry;//存储所有试题

@property (nonatomic,strong)UserModel * user;

@property (nonatomic,assign)int  temp;//标明单道题目时候的题号

@property (nonatomic,assign)int temp1;//标记选择的模块

@property (nonatomic,assign)int questionNumber;//问题编号

@property (nonatomic,strong)EditPageView * editPageView;

@property (nonatomic,strong)UIView * pickerView;

@property (nonatomic,strong)UIButton * bView;//滚轮的背景

@property (nonatomic,assign) int score;//标记转轮的位置

@property (nonatomic,assign) QuestionModel * questionModel;

@property (nonatomic,assign)int pictureNum;//标记选择那张照片

@property (nonatomic,strong) imageBigView * v;//查看大图

@property (strong, nonatomic) IBOutlet UIButton *nextQuestion;
@property (strong, nonatomic) IBOutlet UIButton *OnQuestion;

@end

@implementation NewAnswerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _user = [[Appsetting sharedInstance] getUsetInfo];
    
    _allQuestionAry = [NSMutableArray arrayWithCapacity:1];
    _testType = @"single";
    
    _temp = 0;
    
    _questionNumber = 0;
    
    [self getData];
    
    [self addTableView];
    
    if ((_temp+1) == _allQuestionAry.count) {
        [_nextQuestion setTitle:@"提交" forState:UIControlStateNormal];
    }
   
    // Do any additional setup after loading the view from its nib.
}
-(void)addTableView{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, APPLICATION_WIDTH, APPLICATION_HEIGHT-64-44) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
}
-(void)getData{
    [self showHudInView:self.view hint:NSLocalizedString(@"正在加载数据", @"Load data...")];
    
    if ([_t.statusName isEqualToString:@"进行中"]) {
        
        NSDictionary * dict = [[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%@",_t.textId],@"examId",[NSString stringWithFormat:@"%@",_user.peopleId],@"userId",nil];
        
        [[NetworkRequest sharedInstance] GET:QueryQuestionList dict:dict succeed:^(id data) {
            NSLog(@"%@",data);
            NSString * str = [NSString stringWithFormat:@"%@",[[data objectForKey:@"header"] objectForKey:@"code"]];
            if ([str isEqualToString:@"0000"]) {
                NSArray * ary = [data objectForKey:@"body"];
                for (int i = 0; i<ary.count; i++) {
                    QuestionModel * q = [[QuestionModel alloc] init];
                    
                    [q addContenWithDict:ary[i]];
                    
                    q.edit = NO;
                    
                    [_allQuestionAry addObject:q];
                }
                [_tableView reloadData];
            }else{
                [UIUtils showInfoMessage:[NSString stringWithFormat:@"%@",[[data objectForKey:@"header"] objectForKey:@"message"]] withVC:self];
            }
            [self hideHud];
            
        } failure:^(NSError *error) {
            [self hideHud];
            
            [UIUtils showInfoMessage:@"获取数据失败请检查网络" withVC:self];
        }];
    }else{
        NSDictionary * d = [[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%@",_t.textId],@"examId",[NSString stringWithFormat:@"%@",_user.peopleId] ,@"userId",nil];
        [[NetworkRequest sharedInstance] GET:QueryStudentAnswer dict:d succeed:^(id data) {
            NSLog(@"%@",data);
            NSString * str = [NSString stringWithFormat:@"%@",[[data objectForKey:@"header"] objectForKey:@"code"]];
            if ([str isEqualToString:@"0000"]) {
                NSArray * ary = [data objectForKey:@"body"];
                for (int i = 0; i<ary.count; i++) {
                    QuestionModel * q = [[QuestionModel alloc] init];
                    
                    [q addContenWithDict:ary[i]];
                    
                    q.edit = NO;
                    
                    [_allQuestionAry addObject:q];
                }
                [_tableView reloadData];
                
            }else{
                [UIUtils showInfoMessage:[NSString stringWithFormat:@"%@",[[data objectForKey:@"header"] objectForKey:@"message"]] withVC:self];
            }
            [self hideHud];
            
        } failure:^(NSError *error) {
            [self hideHud];
            
            [UIUtils showInfoMessage:@"获取数据失败请检查网络" withVC:self];
        }];
    }
}
//交卷
-(void)more{
   
    NSMutableArray * dataAry = [NSMutableArray arrayWithCapacity:1];
    
    for (int i = 0;i<_allQuestionAry.count; i++) {
        QuestionModel *q = _allQuestionAry[i];
        
        NSMutableDictionary * dict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%@",q.questionId],@"examQuestionId",[NSString stringWithFormat:@"%@",q.questionAnswer],@"answer",nil];
        
        if (q.questionAnswerImageIdAry.count>0) {
            [dict setObject:q.questionAnswerImageIdAry forKey:@"resourceList"];
        }
        
        [dataAry addObject:dict];
    }
    NSDictionary * d = [[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%@",_t.textId],@"id",dataAry,@"examAnswerList",nil];
    
    [[NetworkRequest sharedInstance] POST:HandIn dict:d succeed:^(id data) {
        NSLog(@"%@",data);
        NSString * message = [NSString stringWithFormat:@"%@",[[data objectForKey:@"header"] objectForKey:@"message"]];
        [UIUtils showInfoMessage:message withVC:self];
        if ([message isEqualToString:@"成功"]) {
            [self.navigationController dismissViewControllerAnimated:YES completion:^{
                [self.navigationController popViewControllerAnimated:YES];
            }];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)AllQuestionBtnPressed:(id)sender {
    if ([_testType isEqualToString:@"single"]) {
        _testType = @"All";
        [_nextQuestion setTitle:@"提交" forState:UIControlStateNormal];

    }else{
        _testType = @"single";
        _temp = 0;
        [_nextQuestion setTitle:@"下一题" forState:UIControlStateNormal];

    }
    [_tableView reloadData];
}
- (IBAction)OnQuestionBtnPressed:(id)sender {
 
}
- (IBAction)NextQuestionBtnPressed:(id)sender {
    if ((_temp+1)<_allQuestionAry.count) {
        _temp = _temp + 1;
        [_tableView reloadData];
    }
    if (_temp+1 ==_allQuestionAry.count){
        [_nextQuestion setTitle:@"提交" forState:UIControlStateNormal];
    }else{
        [_nextQuestion setTitle:@"下一题" forState:UIControlStateNormal];
    }
    
    if ([_nextQuestion.titleLabel.text isEqualToString:@"提交"]) {
        [self more];
    }
}
-(void)addPickView{
    [self.view endEditing: YES];
    if (!self.pickerView) {
        self.bView = [UIButton buttonWithType:UIButtonTypeCustom];
        self.bView.frame = CGRectMake(0, 0, APPLICATION_WIDTH, APPLICATION_HEIGHT);
        self.bView.backgroundColor = [UIColor blackColor];
        [self.bView addTarget:self action:@selector(outView) forControlEvents:UIControlEventTouchUpInside];
        self.bView.alpha = 0.5;
        self.pickerView = [[UIView alloc] initWithFrame:CGRectMake(0, APPLICATION_HEIGHT - 200 - 30 , APPLICATION_WIDTH, 200 + 30)];
        
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
    
}
#pragma mark imageBigViewDelegate
-(void)outViewDelegate{
    [_v removeFromSuperview];
    _v = nil;
    
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
        
        
        if (_temp1 == 1) {
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
    
    
    __weak NewAnswerViewController * weakSelf = self;
    
    NSData *imageData = UIImageJPEGRepresentation(image,0.1);
    
    NSArray * ary = [NSArray arrayWithObject:imageData];
    
    NSDictionary * dict = [[NSDictionary alloc] initWithObjectsAndKeys:ary,@"myfiles", nil];
    
    
    
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
        
    } failure:^(NSError *error) {
        
        [self hideHud];
        
        [UIUtils showInfoMessage:@"上传失败，请检查网络" withVC:self];
    }];
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
#pragma mark EditPageViewDelegate
-(void)saveTextStrDelegate:(UIButton *)btn{
    if (btn.tag ==1) {
        
    }else{
        QuestionModel * q;
        if ([_testType isEqualToString:@"single"]) {
            q = _allQuestionAry[_temp];
        }else{
            q = _allQuestionAry[_editPageView.textView.tag];
        }
        q.questionAnswer = _editPageView.textView.text;
        
        [_tableView reloadData];
    }
    
    [self.view endEditing:YES];
    
    [_editPageView removeFromSuperview];
    
    _editPageView  = nil;
    
}
#pragma mark CellDelegate

-(void)thirthSelectOptionsImageBtnDelegate:(UIButton *)sender{
    
    if (!_v) {
        _v = [[imageBigView alloc] initWithFrame:CGRectMake(0, 0, APPLICATION_WIDTH, APPLICATION_HEIGHT)];
    }
    _v.delegate = self;
    
//    _temp = (int)sender.tag/1000+4;
    
    _pictureNum = ((int)sender.tag%1000)%1000;
    
    QuestionModel * q;
    
    if ([_testType isEqualToString:@"single"]) {
        q = _allQuestionAry[_temp];
    }else{
        q = _allQuestionAry[sender.tag/(1000*1000)];
    }
    
    optionsModel * opt = q.qustionOptionsAry[(sender.tag/1000)%1000-1];
    
    if ((_pictureNum-1)<opt.optionsImageIdAry.count&&opt.optionsImageIdAry.count>0) {
        
        [_v addImageView:opt.optionsImageIdAry[_pictureNum-1]];
        
        [self.view addSubview:_v];
    }
    
    
}
-(void)deleAnswerImageDelegate:(UIButton *)sender{
    if (![_t.statusName isEqualToString:@"进行中"]) {
        //        [self.view endEditing:YES];
        return;
    }
    int n = (int)sender.tag-1001;
    
    if ([_testType isEqualToString:@"single"]) {
        _questionModel = _allQuestionAry[_temp];
    }else{
        _questionModel = _allQuestionAry[[sender.titleLabel.text intValue]];
    }
    
    if (n<_questionModel.questionAnswerImageAry.count&&n>=0) {
        [_questionModel.questionAnswerImageAry removeObjectAtIndex:n];
    }
    
    if (n<_questionModel.questionAnswerImageIdAry.count&&n>=0) {
        
        [_questionModel.questionAnswerImageIdAry removeObjectAtIndex:n];
    }
    [_tableView reloadData];
}
//题干选择图片
-(void)firstSelectImageBtnDelegate:(UIButton *)sender{
    
    UIImage *i = sender.currentBackgroundImage;
    
    float f = i.size.width;
    if ([_testType isEqualToString:@"single"]) {
        _questionModel = _allQuestionAry[_temp];
    }else{
        _questionModel = _allQuestionAry[[sender.titleLabel.text intValue]];
    }
    if (!_v) {
        _v = [[imageBigView alloc] initWithFrame:CGRectMake(0, 0, APPLICATION_WIDTH, APPLICATION_HEIGHT)];
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
            _temp1 = 1;
            _pictureNum = (int)sender.tag;
            [self selectPicture];
        }
    }else{
        
        if (((sender.tag-101)<_questionModel.questionTitleImageIdAry.count)&&_questionModel.questionTitleImageIdAry.count>0) {
            
            [_v addImageView:_questionModel.questionTitleImageIdAry[sender.tag-101]];
            
            [self.view addSubview:_v];
            
        }
    }
}
-(void)textViewDidChangeDelegate:(UITextView *)textView{
    if (!_editPageView) {
        _editPageView = [[EditPageView alloc] init];
    }
    
    QuestionModel * q;
    
    if ([_testType isEqualToString:@"single"]) {
        q = _allQuestionAry[_temp];
    }else{
        q = _allQuestionAry[textView.tag];
    }
    
    if ([q.titleType isEqualToString:@"3"]) {
        
        _questionModel = q;
        
        _score = 0;
        
        [self addPickView];
        
    }else{
        _editPageView.textView.tag = textView.tag;
        
        _editPageView.textView.text = q.questionAnswer;
        
        _editPageView.frame = CGRectMake(0, 0, APPLICATION_WIDTH, APPLICATION_HEIGHT);
        
        _editPageView.delegate = self;
        
        [self.view addSubview:_editPageView];
    }
}
-(void)thirthSelectOptionDelegate:(UIButton *)sender{
    QuestionModel * q;
    if ([_testType isEqualToString:@"single"]) {
        q = _allQuestionAry[_temp];
    }else{
        q = _allQuestionAry[sender.tag/1000];
    }
    
    if ([q.titleType isEqualToString:@"1"]) {
        
        NSString * s = [NSString stringWithFormat:@"%c",(int)sender.tag%1000];
        
        if ([[NSString stringWithFormat:@"%@",q.questionAnswer] isEqualToString:s]) {
            q.questionAnswer = @"";
        }else{
            q.questionAnswer = [NSString stringWithFormat:@"%c",(int)sender.tag%1000];
        }
    }else{
        NSString *string = [NSString stringWithFormat:@"%@",q.questionAnswer];
        
        NSString * s = [NSString stringWithFormat:@"%c",(int)sender.tag%1000];
        //字条串是否包含有某字符串
        if ([string rangeOfString:s].location == NSNotFound) {
            if ([UIUtils isBlankString:string]) {
                q.questionAnswer = [NSString stringWithFormat:@"%c",(int)sender.tag%1000];
            }else{
                q.questionAnswer = [q.questionAnswer stringByAppendingString:[NSString stringWithFormat:@",%c",(int)sender.tag%1000]];
            }
        } else {
            NSMutableArray *array = [[NSMutableArray alloc] initWithArray:[string componentsSeparatedByString:@","]];
            [array removeObject:s];
            q.questionAnswer = @"";
            for (int i = 0; i<array.count; i++) {
                if (i == 0) {
                    q.questionAnswer = [NSString stringWithFormat:@"%@",array[0]];
                }else{
                    q.questionAnswer = [q.questionAnswer stringByAppendingString:[NSString stringWithFormat:@",%@",array[i]]];
                }
                
            }
            NSLog(@"string 包含 martin");
        }
    }
    [_tableView reloadData];
    
}
#pragma mark UITableViewdelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if ([_testType isEqualToString:@"single"]) {
        return 1;
    }else{
        if (_allQuestionAry>0) {
            return _allQuestionAry.count;
        }
    }
    return 0;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ([_testType isEqualToString:@"single"]) {
        if (_allQuestionAry.count>0) {
            //1.单选 2.多选 3.判断 4.填空 5.问答
            QuestionModel * q = _allQuestionAry[_temp];
            if ([q.titleType isEqualToString:@"1"]||[q.titleType isEqualToString:@"2"]) {
                return 2+q.qustionOptionsAry.count;
            }
            return 3;
        }
    }else{
        if (_allQuestionAry>0) {
            //1.单选 2.多选 3.判断 4.填空 5.问答
            QuestionModel * q = _allQuestionAry[section];
            if ([q.titleType isEqualToString:@"1"]||[q.titleType isEqualToString:@"2"]) {
                return 2+q.qustionOptionsAry.count;
            }
            return 3;
        }
    }
    
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ChoiceQuestionTableViewCell * cell ;
    
    QuestionModel * q;
    
    if ([_testType isEqualToString:@"single"]) {
        q = _allQuestionAry[_temp];
    }else{
        q = _allQuestionAry[indexPath.section];
    }
    
    
    if (!cell) {
        if (indexPath.row == 0) {
            cell = [tableView dequeueReusableCellWithIdentifier:@"ChoiceQuestionTableViewCellEighth"];
            cell = [[[NSBundle mainBundle] loadNibNamed:@"ChoiceQuestionTableViewCell" owner:nil options:nil] objectAtIndex:7];
            
        }else if (indexPath.row == 1){
            
            cell = [tableView dequeueReusableCellWithIdentifier:@"ChoiceQuestionTableViewCellFirst"];
            
            cell = [[[NSBundle mainBundle] loadNibNamed:@"ChoiceQuestionTableViewCell" owner:nil options:nil] objectAtIndex:0];
        }
        else if (indexPath.row == 2+q.qustionOptionsAry.count){
            if ([q.titleType  isEqualToString:@"5"]) {
                cell = [tableView dequeueReusableCellWithIdentifier:@"ChoiceQuestionTableViewCellFirst"];
                
                cell = [[[NSBundle mainBundle] loadNibNamed:@"ChoiceQuestionTableViewCell" owner:nil options:nil] objectAtIndex:0];
            }else{
                cell = [tableView dequeueReusableCellWithIdentifier:@"ChoiceQuestionTableViewCellSeventh"];
                
                cell = [[[NSBundle mainBundle] loadNibNamed:@"ChoiceQuestionTableViewCell" owner:nil options:nil] objectAtIndex:6];
            }
        }else{
            cell = [tableView dequeueReusableCellWithIdentifier:@"ChoiceQuestionTableViewCellThird"];
            
            cell = [[[NSBundle mainBundle] loadNibNamed:@"ChoiceQuestionTableViewCell" owner:nil options:nil] objectAtIndex:2];
        }
    }
    if (indexPath.row == 0) {
        
        [cell eigthTitleType:q.titleTypeName withScore:q.qustionScore isSelect:NO btnTag:(int)indexPath.section+1];
        
    }
    if (indexPath.row==1) {
        
        [cell addFirstTitleTextView:q.questionTitle withImageAry:q.questionTitleImageIdAry withIsEdit:NO withIndexRow:(int)indexPath.section];
        
    }else if(indexPath.row>1&&indexPath.row<2+q.qustionOptionsAry.count) {
        NSString *string = [NSString stringWithFormat:@"%@",q.questionAnswer];
        
        optionsModel * opt = q.qustionOptionsAry[indexPath.row-2];
        
        if (![_testType isEqualToString:@"single"]) {
            _questionNumber = (int)(indexPath.section*1000+indexPath.row-2);
        }else{
            _questionNumber = (int)indexPath.row-2;
        }
        //字条串是否包含有某字符串
        if ([string rangeOfString:opt.index].location == NSNotFound) {
            
            [cell addOptionWithModel:q.qustionOptionsAry[indexPath.row-2] withEdit:_editable withIndexRow:_questionNumber withISelected:NO];
            
        }else{
            
            [cell addOptionWithModel:q.qustionOptionsAry[indexPath.row-2] withEdit:_editable withIndexRow:_questionNumber withISelected:YES];
        }
    }else if (indexPath.row == 2+q.qustionOptionsAry.count){
        if ([q.titleType  isEqualToString:@"5"]) {
            //问答。可上传图片
            if (_isAbleAnswer) {
                [cell addFirstTitleTextView:q.questionAnswer withImageAry:q.questionAnswerImageAry withIsEdit:YES withIndexRow:(int)indexPath.section];
            }else{
                [cell addFirstTitleTextView:q.questionAnswer withImageAry:q.questionAnswerImageIdAry withIsEdit:NO withIndexRow:(int)indexPath.section];
            }
//
        }else{
            if (![_testType isEqualToString:@"single"]) {
                _questionNumber = (int)(indexPath.section);
            }else{
                _questionNumber = _temp;
            }
            
            [cell addSeventhTextViewWithStr:q.questionAnswer withIndexRow:_questionNumber];
        }
        
    }
    
    cell.delegate = self;
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    QuestionModel * q;
//    if ([_testType isEqualToString:@"single"]) {
//        q = _allQuestionAry[_temp];
//    }else{
//        q = _allQuestionAry[indexPath.section];
//    }
//
//    if ([q.titleType isEqualToString:@"1"]) {
//
//        NSString * s = [NSString stringWithFormat:@"%c",65+(int)indexPath.row];//[NSString stringWithFormat:@"%c",(int)sender.tag%1000];
//
//        if ([[NSString stringWithFormat:@"%@",q.questionAnswer] isEqualToString:s]) {
//            q.questionAnswer = @"";
//        }else{
//            q.questionAnswer = [NSString stringWithFormat:@"%c",65+(int)indexPath.row];;
//        }
//    }else{
//        NSString *string = [NSString stringWithFormat:@"%@",q.questionAnswer];
//
//        NSString * s = [NSString stringWithFormat:@"%c",65+(int)indexPath.row];;
//        //字条串是否包含有某字符串
//        if ([string rangeOfString:s].location == NSNotFound) {
//            if ([UIUtils isBlankString:string]) {
//                q.questionAnswer = [NSString stringWithFormat:@"%c",65+(int)indexPath.row];
//            }else{
//                q.questionAnswer = [q.questionAnswer stringByAppendingString:[NSString stringWithFormat:@",%c",65+(int)indexPath.row]];
//            }
//        } else {
//            NSMutableArray *array = [[NSMutableArray alloc] initWithArray:[string componentsSeparatedByString:@","]];
//            [array removeObject:s];
//            q.questionAnswer = @"";
//            for (int i = 0; i<array.count; i++) {
//                if (i == 0) {
//                    q.questionAnswer = [NSString stringWithFormat:@"%@",array[0]];
//                }else{
//                    q.questionAnswer = [q.questionAnswer stringByAppendingString:[NSString stringWithFormat:@",%@",array[i]]];
//                }
//
//            }
//            NSLog(@"string 包含 martin");
//        }
//    }
//    [_tableView reloadData];
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_allQuestionAry.count>0) {
        
        QuestionModel * q ;//= _allQuestionAry[indexPath.section];
        if ([_testType isEqualToString:@"single"]) {
            q = _allQuestionAry[_temp];
        }else{
            q = _allQuestionAry[indexPath.section];
        }
        if (indexPath.row == 0) {
            return 40;
        }else if(indexPath.row == 1){
            
            return [q returnTitleHeight];
            
        }else if (indexPath.row == 2+q.qustionOptionsAry.count){
            if ([q.titleType isEqualToString:@"5"]) {
                float h = [q returnAnswerHeight];
                if (h<400) {
                    return 400;
                }else{
                    return h;
                }
            }else{
                float h = [q returnAnswerHeightZone];
                
                if (h<60) {
                    return 60;
                }else{
                    return h;
                }
            }
        }else{
            return [q returnOptionHeight:(int)indexPath.row-2];
        }
        return 60;
    }
    return 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0;
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
