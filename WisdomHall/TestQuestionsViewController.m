//
//  TestQuestionsViewController.m
//  WisdomHall
//
//  Created by XTU-TI on 2017/5/12.
//  Copyright © 2017年 majinxing. All rights reserved.
// 展示试卷内容的

#import "TestQuestionsViewController.h"
#import "DYHeader.h"
#import "CreateTextTableViewCell.h"
#import "Questions.h"
#import "UIUtils.h"
#import "contactTool.h"
#import "FMDBTool.h"
#import "FMDatabase.h"
#import "QuestionsTableViewCell.h"
#import "QuestionListViewController.h"
#import "ImportTextViewController.h"
#import "AllTestViewController.h"

@interface TestQuestionsViewController ()<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate,CreateTextTableViewCellDelegate>
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)NSMutableArray * questionArt;
@property (nonatomic,strong)Questions * q;
@property (nonatomic,strong)NSMutableArray * labelText;
@property (nonatomic,strong)NSArray * ary;
@property (strong, nonatomic) IBOutlet UILabel *questionNumber;

@end

@implementation TestQuestionsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _labelText = [NSMutableArray arrayWithCapacity:1];
    
    [_labelText addObject:@"题目"];
    
    [_labelText addObject:@"答案"];

    _questionArt = [NSMutableArray arrayWithCapacity:1];
    
    _q = [[Questions alloc] init];
    
    [self setNavigationTitle];
    
    [self addTableView];
    
    [self keyboardNotification];
    
    // 1.注册通知
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectQuestion:) name:@"selectQuestion" object:nil];
    
    // Do any additional setup after loading the view from its nib.
}
-(void)selectQuestion:(NSNotification *)dict{
    NSArray * ary = [dict.userInfo objectForKey:@"ary"];
    for (int i = 0; i<ary.count; i++) {
        Questions * q = ary[i];
        [_questionArt addObject:q];
    }
    _questionNumber.text = [NSString stringWithFormat:@"总题数：%lu",(unsigned long)_questionArt.count];
}
/**
 * 键盘监听
 **/
-(void)keyboardNotification{
    //监听键盘出现和消失
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
}
/**
 *  添加tableView
 **/
-(void)addTableView{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64,APPLICATION_WIDTH, APPLICATION_HEIGHT-64-40) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.estimatedRowHeight = 100;
    _tableView.rowHeight = UITableViewAutomaticDimension;
    _tableView.separatorStyle = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.view addSubview:_tableView];
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent
                                                *)event{
    [self.view endEditing:YES];
}
/**
 *  显示navigation的标题
 **/
-(void)setNavigationTitle{
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
    self.title = @"试题";
    
    UIBarButtonItem *myButton = [[UIBarButtonItem alloc] initWithTitle:@"更多" style:UIBarButtonItemStylePlain target:self action:@selector(more)];
    self.navigationItem.rightBarButtonItem = myButton;
}
-(NSMutableArray *)question{
    NSMutableArray * ary = [NSMutableArray arrayWithCapacity:1];
    for (int i = 0; i<_questionArt.count; i++) {
        Questions * q = _questionArt[i];
        NSDictionary * dict = [[NSDictionary alloc] initWithObjectsAndKeys:@"5",@"score", q.questionsID,@"questionId",[NSString stringWithFormat:@"%d",i+1],@"order",nil];
        [ary addObject:dict];
    }
    return ary;
}
-(void)more{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:nil preferredStyle:  UIAlertControllerStyleActionSheet];
    //分别按顺序放入每个按钮；
    [alert addAction:[UIAlertAction actionWithTitle:@"提交创建试卷" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        NSMutableArray * ary = [self question];
        
        NSDictionary * dict = [[NSDictionary alloc] initWithObjectsAndKeys:_t.title,@"name",@"1",@"status",_classModel.sclassId,@"relId",@"1",@"relType",ary,@"examQuestionList",@"0",@"startTime",nil];
        
        [[NetworkRequest sharedInstance] POST:CreateText dict:dict succeed:^(id data) {
            NSString * str = [[data objectForKey:@"header"] objectForKey:@"code"];
            if ([str isEqualToString:@"0000"]) {
                [UIUtils showInfoMessage:@"创建成功" withVC:self];
                for (UIViewController *controller in self.navigationController.viewControllers) {
                    if ([controller isKindOfClass:[AllTestViewController class]]) {
                        [self.navigationController popToViewController:controller animated:YES];
                    }
                }
            }else if ([str isEqualToString:@"6682"]){
                [UIUtils showInfoMessage:@"创建失败，试卷重名" withVC:self];
            }else{
                [UIUtils showInfoMessage:@"创建失败" withVC:self];
            }
        } failure:^(NSError *error) {
            NSLog(@"%@",error);
            [UIUtils showInfoMessage:@"发送数据失败，请检查网络" withVC:self];
        }];
        
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"从题库导入试题" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        ImportTextViewController * VC = [[ImportTextViewController alloc] init];
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:VC animated:YES];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"试题列表" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        QuestionListViewController * q = [[QuestionListViewController alloc] init];
        
        q.questionAry = [[NSMutableArray alloc] initWithArray:_questionArt];
        
        q.isSelect = NO;
        
        self.hidesBottomBarWhenPushed = YES;
        
        [self.navigationController pushViewController:q animated:YES];
        
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    
    //弹出提示框；
    [self presentViewController:alert animated:true completion:nil];
    
}


-(void)questionAnswer:(NSMutableArray*)ary{
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark ---------------------------UITableViewdelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CreateTextTableViewCell * cell;
    if (indexPath.row<2) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"CreateTextTableViewCellFirst"];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"CreateTextTableViewCell" owner:nil options:nil] objectAtIndex:0];
        }
        if (indexPath.row == 0) {
            [cell addContentView:_labelText[indexPath.row] withTextViewStr:_q.title];
        }else{
            [cell addContentView:_labelText[indexPath.row] withTextViewStr:_q.answer];
        }
        
    }else{
        cell = [tableView dequeueReusableCellWithIdentifier:@"CreateTextTableViewCellSecond"];
        if (!cell) {
            if (!cell) {
                cell = [[[NSBundle mainBundle] loadNibNamed:@"CreateTextTableViewCell" owner:nil options:nil] objectAtIndex:1];
            }
        }
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.delegate = self;
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.view endEditing:YES];
}
//-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    if (indexPath.section == 2) {
//        return 50;
//    }
//    return 60;
//}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
}
#pragma mark ----------------------CreateTextTableViewCellDelegate
-(void)createTopicPressedDelegate{
    Questions *q = [[Questions alloc] init];
    if ([UIUtils isBlankString:_q.title]||[UIUtils isBlankString:_q.answer]) {
        [UIUtils showInfoMessage:@"题目和答案请填写完整" withVC:self];
        return;
    }
    q.title = _q.title;
    
    q.answer = _q.answer;
    
    [_questionArt addObject:q];
    
    NSDictionary * dict = [[NSDictionary alloc] initWithObjectsAndKeys:_qBank.libId,@"libId",@"5",@"type",q.answer,@"answer",@"5",@"difficulty",q.title,@"content", nil];
    dispatch_async(dispatch_get_main_queue(), ^{
        //获取主线程
        [self hideHud];
        [self showHudInView:self.view hint:NSLocalizedString(@"正在加载数据", @"Load data...")];
    });
    [[NetworkRequest sharedInstance] POST:CreateQuestion dict:dict succeed:^(id data) {
        NSString * str = [NSString stringWithFormat:@"%@",[[data objectForKey:@"header"] objectForKey:@"code"]];
        if ([str isEqualToString:@"0000"]) {
            q.questionsID = [data objectForKey:@"body"];
            _q = nil;
            _q = [[Questions alloc] init];
            _questionNumber.text = [NSString stringWithFormat:@"总题数：%lu",(unsigned long)_questionArt.count];
            [_tableView reloadData];
        }else{
            [UIUtils showInfoMessage:@"创建失败" withVC:self];
        }
        [self hideHud];
    } failure:^(NSError *error) {
        [self hideHud];
        [UIUtils showInfoMessage:@"创建失败，请检查网络" withVC:self];
    }];
}

-(void)returnTextViewTextWithLabelDelegate:(NSString *)labelText withTextViewText:(NSString *)textViewText{
    if ([labelText isEqualToString:@"题目"]) {
        _q.title = textViewText;
    }else{
        _q.answer = textViewText;
    }
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


/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
