//
//  TextListViewController.m
//  WisdomHall
//
//  Created by XTU-TI on 2017/5/15.
//  Copyright © 2017年 majinxing. All rights reserved.
//

#import "TextListViewController.h"
#import "TestQuestionsViewController.h"
#import "TextViewController.h"
#import "DYHeader.h"
#import "Questions.h"
#import "QuestionsTableViewCell.h"
#import "contactTool.h"
#import "AnswerModel.h"
#import "ImportTextViewController.h"
#import "SelectQuestion.h"
@interface TextListViewController ()<UITableViewDelegate,UITableViewDataSource,QuestionsTableViewCellDelegate,UIGestureRecognizerDelegate,UIAlertViewDelegate,SelectQuestionDelecate>
@property (nonatomic,strong) UITableView * tableView;
@property (nonatomic,strong) UILabel * qNumLabel;
@property (nonatomic,strong) UILabel * time;
@property (nonatomic,strong) UIButton * allBtn;
@property (nonatomic,strong) UIView * bottom;
@property (nonatomic,strong) NSMutableArray * questionsAry;
@property (nonatomic,strong) NSMutableArray * answerAry;
@property (nonatomic,strong) Questions * q;//问题
@property (nonatomic,assign) int temp;//标志位
@property (nonatomic,assign) int tempSecond;//标志位 表明不是第一次加载数据
@property (nonatomic,assign) BOOL teacherOrStudent;
@property (nonatomic,strong) SelectQuestion * selectQ;
@end

@implementation TextListViewController

-(void)dealloc{
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    _temp = 0;
    
    _teacherOrStudent = YES;
    
    _questionsAry = [NSMutableArray arrayWithCapacity:1];
    
    _answerAry = [NSMutableArray arrayWithCapacity:1];
    
    [self setNavigationTitle];
    
    [self getData];
    
    [self addTableView];
    
    // Do any additional setup after loading the view from its nib.
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
-(void)addQuestions{
    
}
-(void)getData{
    
    NSDictionary * dict = [[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%@",_t.textId],@"id", nil];
    
    [[NetworkRequest sharedInstance] GET:QueryQuestionList dict:dict succeed:^(id data) {
        NSArray * ary = [data objectForKey:@"body"];
        for (int i = 0; i<ary.count; i++) {
            Questions * q = [[Questions alloc] init];
            [q setSelfInfoWithDict:ary[i]];
            q.qid = [NSString stringWithFormat:@"%d",i];
            [_questionsAry addObject:q];
            [_answerAry addObject:[NSString stringWithFormat:@""]];
        }
        [self addNextBtnOrOnBtnView];
        [_tableView reloadData];
    } failure:^(NSError *error) {
        [UIUtils showInfoMessage:@"获取数据失败，请检查网络" withVC:self];

    }];
}
-(void)addTableView{
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, APPLICATION_WIDTH, APPLICATION_HEIGHT-64-50) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.estimatedRowHeight = 70;
    _tableView.rowHeight = UITableViewAutomaticDimension;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.view addSubview:_tableView];
    
    UISwipeGestureRecognizer * priv = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(nextBtn:)];
    [priv setDirection:(UISwipeGestureRecognizerDirectionRight)];
    [_tableView addGestureRecognizer:priv];
    UISwipeGestureRecognizer * recognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(nextBtn:)];
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionLeft)];
    [_tableView addGestureRecognizer:recognizer];
    
}
/**
 *  显示navigation的标题
 **/
-(void)setNavigationTitle{
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
   
    self.title = @"试题列表";
    UIBarButtonItem *myButton = [[UIBarButtonItem alloc] initWithTitle:@"交卷" style:UIBarButtonItemStylePlain target:self action:@selector(theImportQuestionBtn)];
    
    self.navigationItem.rightBarButtonItem = myButton;
    
    //    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithTitle:@"<" style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    //    self.navigationItem.leftBarButtonItem = leftButton;
}
-(void)theImportQuestionBtn{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:nil preferredStyle:  UIAlertControllerStyleActionSheet];
    //分别按顺序放入每个按钮；
    [alert addAction:[UIAlertAction actionWithTitle:@"我要交卷" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            //获取主线程
            [self hideHud];
            [self showHudInView:self.view hint:NSLocalizedString(@"正在交卷数据", @"Load data...")];
        });
        NSMutableArray * ary = [Questions returnText:_questionsAry];
        NSDictionary * dict = [[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%@",_t.textId],@"id",ary,@"examAnswerList", nil];
        [[NetworkRequest sharedInstance] POST:HandIn dict:dict succeed:^(id data) {
            NSString * str = [NSString stringWithFormat:@"%@",[[data objectForKey:@"header"] objectForKey:@"code"]];
            if ([str isEqualToString:@"0000"]) {
                [UIUtils showInfoMessage:@"交卷成功" withVC:self];
            }else if ([str isEqualToString:@"6676"]){
                [UIUtils showInfoMessage:@"考试状态必须是进行中，才能交卷" withVC:self];
            }else{
                [UIUtils showInfoMessage:@"交卷失败" withVC:self];
            }
            [self hideHud];
        } failure:^(NSError *error) {
            NSLog(@"%@",error);
            [self hideHud];
            [UIUtils showInfoMessage:@"发送数据失败，请检查网络" withVC:self];
        }];
       
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
    }]];
    
    //弹出提示框；
    [self presentViewController:alert animated:true completion:nil];
}
-(void)back{
    for (UIViewController *controller in self.navigationController.viewControllers) {
        if ([controller isKindOfClass:[TextViewController class]]) {
            [self.navigationController popToViewController:controller animated:YES];
        }
    }
}
/**
 * 下一题、上一题、全部试题
 **/
-(void)addNextBtnOrOnBtnView{
    
    if (!_allBtn) {
        _allBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    }
    
    _allBtn.frame = CGRectMake(0, APPLICATION_HEIGHT-50, APPLICATION_WIDTH, 50);
    
    [_allBtn setTitle:@"全部试题" forState:UIControlStateNormal];
    
    [_allBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    _allBtn.backgroundColor = [UIColor colorWithHexString:@"#29a7e1"];
    
    [_allBtn addTarget:self action:@selector(allQuestion:) forControlEvents:UIControlEventTouchUpInside];
    
    _allBtn.tag = 2;
    
    [self.view addSubview:_allBtn];
    
    if (!_qNumLabel) {
        _qNumLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, APPLICATION_HEIGHT-50, 100, 50)];
    }
    _qNumLabel.text = [NSString stringWithFormat:@"%d/%lu",_temp+1,(unsigned long)_questionsAry.count];
    
    _qNumLabel.backgroundColor = [UIColor colorWithHexString:@"#29a7e1"];
    
    _qNumLabel.textAlignment = NSTextAlignmentCenter;
    
    _qNumLabel.textColor = [UIColor whiteColor];
    
    [self.view addSubview:_qNumLabel];
}
-(void)allQuestion:(UIButton *)btn{
    if (!_selectQ) {
        _selectQ = [[SelectQuestion alloc] initWithFrame:CGRectMake(0, 0, APPLICATION_WIDTH, APPLICATION_HEIGHT)];
    }
    //    _selectQ.backgroundColor = [UIColor grayColor];
    
    [_selectQ addScrollViewWithBtnNumber:(int)_questionsAry.count];
    _selectQ.delegate = self;
    [self.view addSubview:_selectQ];
}
-(void)nextBtn:(UISwipeGestureRecognizer *)recognizer{
    if(recognizer.direction == UISwipeGestureRecognizerDirectionLeft) {
        if (_temp == _questionsAry.count-1) {
            
        }else{
            _temp = _temp + 1;
            _q = _questionsAry[_temp];
            [_tableView reloadData];
        }
    }
    if(recognizer.direction == UISwipeGestureRecognizerDirectionRight) {
        if (_temp==0) {
            _temp = 0;
        }else{
            _temp = _temp - 1;
            _q = _questionsAry[_temp];
            [_tableView reloadData];
        }
    }
    _qNumLabel.text = [NSString stringWithFormat:@"%d/%lu",_temp+1,(unsigned long)_questionsAry.count];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark SelectQuestionDelecate
-(void)outViewDelegate{
    [_selectQ removeFromSuperview];
}
-(void)selectEdDelegate:(UIButton *)btn{
    
    _temp = (int)btn.tag - 1;
    
    _qNumLabel.text = [NSString stringWithFormat:@"%d/%lu",_temp+1,(unsigned long)_questionsAry.count];
    
    [_selectQ removeFromSuperview];
    
    [_tableView reloadData];
}
#pragma mark QuestionsTableViewCellDelegate
//答案收集
-(void)textViewDidChangeDelegate:(UITextView *)textView{
    if (textView.tag<=_questionsAry.count) {
        Questions * q = _questionsAry[textView.tag-1];
        q.answer = textView.text;
        [_questionsAry setObject:q atIndexedSubscript:textView.tag-1];
    }
}
#pragma mark UITableViewdelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (_questionsAry.count>=1) {
        return 3;
    }
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    QuestionsTableViewCell * cell ;
    Questions * q = _questionsAry[_temp];
    
    if (indexPath.row == 0) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"QuestionsTableViewCellFirst"];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"QuestionsTableViewCell" owner:nil options:nil] objectAtIndex:0];
        }
        [cell settitleTextViewText:[NSString stringWithFormat:@"试题%d：%@",[q.qid intValue]+1,q.title] withAllQuestionNumber:(int)indexPath.row+1];
    }else if(indexPath.row == 1){
        cell = [tableView dequeueReusableCellWithIdentifier:@"QuestionsTableViewCellSecond"];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"QuestionsTableViewCell" owner:nil options:nil] objectAtIndex:1];
        }
        [cell setQuestionAnswer:q.answer withIndex:[q.qid intValue]+1];
    }else{
        cell = [tableView dequeueReusableCellWithIdentifier:@"QuestionsTableViewCellThird"];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"QuestionsTableViewCell" owner:nil options:nil] objectAtIndex:2];
        }
    }
    cell.delegate = self;
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.view endEditing:YES];
}
//-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    return 60;
//}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
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
