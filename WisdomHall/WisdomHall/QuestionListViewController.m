//
//  QuestionListViewController.m
//  WisdomHall
//
//  Created by XTU-TI on 2017/9/6.
//  Copyright © 2017年 majinxing. All rights reserved.
//

#import "QuestionListViewController.h"
#import "DYHeader.h"
#import "Questions.h"
#import "JoinVoteTableViewCell.h"
#import "TestQuestionsViewController.h"

@interface QuestionListViewController ()<UITableViewDelegate,UITableViewDataSource,JoinVoteTableViewCellDelegate>
@property (nonatomic,strong)UITableView * tableView;
@property (nonatomic,strong)NSMutableArray * selectAry;
@end

@implementation QuestionListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addTableView];
    
    [self setNavigationTitle];
    
    _selectAry = [NSMutableArray arrayWithCapacity:1];
    
    for (int i = 0; i<_questionAry.count; i++) {
        [_selectAry addObject:@"未选中"];
    }
   
    
   

    // Do any additional setup after loading the view from its nib.
}

/**
 *  显示navigation的标题
 **/
-(void)setNavigationTitle{
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
    self.title = @"试题";
    if (_isSelect) {
        UIBarButtonItem *myButton = [[UIBarButtonItem alloc] initWithTitle:@"保存试题" style:UIBarButtonItemStylePlain target:self action:@selector(saveQuestion)];
        [myButton setTintColor:[UIColor whiteColor]];

        self.navigationItem.rightBarButtonItem = myButton;
    }
}
-(void)saveQuestion{
    NSMutableArray * ary = [NSMutableArray arrayWithCapacity:1];
    for (int i = 0; i<_selectAry.count; i++) {
        if ([_selectAry[i] isEqualToString:@"选中"]) {
            Questions * q = _questionAry[i];
            [ary addObject:q];
        }
    }
    if (ary.count>0) {
        
    }else{
        return;
    }
    NSDictionary * dict = [[NSDictionary alloc] initWithObjectsAndKeys:ary,@"ary", nil];
    // 2.创建通知
    NSNotification *notification =[NSNotification notificationWithName:@"selectQuestion" object:nil userInfo:dict];
    // 3.通过 通知中心 发送 通知
    
    [[NSNotificationCenter defaultCenter] postNotification:notification];
    
    for (UIViewController *controller in self.navigationController.viewControllers) {
        if ([controller isKindOfClass:[TestQuestionsViewController class]]) {
            [self.navigationController popToViewController:controller animated:YES];
        }
    }
    

}
-(void)addTableView{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, APPLICATION_WIDTH, APPLICATION_HEIGHT-64) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    self.automaticallyAdjustsScrollViewInsets = NO;
    _tableView.separatorStyle =     UITableViewCellSeparatorStyleNone;
    _tableView.estimatedRowHeight = 70;
    _tableView.rowHeight = UITableViewAutomaticDimension;

    [self.view addSubview:_tableView];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark JoinVoteTableViewCellDelegate
-(void)voteBtnDelegatePressed:(UIButton *)btn{
    if (btn.tag<=_selectAry.count) {
        if ([_selectAry[btn.tag-1] isEqualToString:@"未选中"]) {
            [_selectAry setObject:@"选中" atIndexedSubscript:btn.tag-1];
        }else{
            [_selectAry setObject:@"未选中" atIndexedSubscript:btn.tag-1];
        }
        [_tableView reloadData];
    }
}
#pragma mark UITableViewdelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (_questionAry.count>0) {
        return _questionAry.count;
    }
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    JoinVoteTableViewCell * cell ;
    
    Questions * q = _questionAry[indexPath.row];
    
    if (_isSelect) {
        
        cell = [tableView dequeueReusableCellWithIdentifier:@"JoinVoteTableViewCellSecond"];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"JoinVoteTableViewCell" owner:nil options:nil] objectAtIndex:1];
        }
        [cell setSelectText:[NSString stringWithFormat:@"题目:%@",q.title] withTag:(int)indexPath.row+1 withSelect:_selectAry[indexPath.row]];
    }else{
        cell = [tableView dequeueReusableCellWithIdentifier:@"JoinVoteTableViewCellFirst"];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"JoinVoteTableViewCell" owner:nil options:nil] objectAtIndex:0];
        }
        [cell setQuestionContent:q.title];
    }
    
    cell.delegate = self;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
//-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    return 60;
//}
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
