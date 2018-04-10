//
//  ImportTextViewController.m
//  WisdomHall
//
//  Created by XTU-TI on 2017/5/25.
//  Copyright © 2017年 majinxing. All rights reserved.
//

#import "ImportTextViewController.h"
#import "contactTool.h"
#import "FMDBTool.h"
#import "FMDatabase.h"
#import "DYHeader.h"
#import "Questions.h"
#import "QuestionsTableViewCell.h"
#import "ContactModel.h"
#import "QuestionBank.h"
#import "Questions.h"
#import "QuestionListViewController.h"

@interface ImportTextViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)NSMutableArray * questionsAry;
@property (nonatomic,strong)NSMutableArray * selected;//是否被选中的状态
@property (nonatomic,strong)NSMutableArray * selectQuestiond;//已经选中的题，移除
@property (nonatomic,strong)FMDatabase * db;
@property (nonatomic,strong)UITableView * tableView;
@end

@implementation ImportTextViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    _questionsAry = [NSMutableArray arrayWithCapacity:1];
    
    [self getData];
    
    [self addTableView];
    
    [self setNavigationTitle];
    
    // Do any additional setup after loading the view from its vnib.
}
-(void)getData{
    NSDictionary * dict = [[NSDictionary alloc] initWithObjectsAndKeys:@"1",@"start",@"1000",@"length",nil];
    [[NetworkRequest sharedInstance] GET:QuertyQusetionBank dict:dict succeed:^(id data) {
        NSArray * ary = [data objectForKey:@"body"];
        for (int i = 0; i<ary.count; i++) {
            QuestionBank * q = [[QuestionBank alloc] init];
            [q setSelfInfoWithDict:ary[i]];
            [_questionsAry addObject:q];
        }
        [_tableView reloadData];
    } failure:^(NSError *error) {
        [UIUtils showInfoMessage:@"获取数据失败，请检查网络" withVC:self];

    }];
}
-(void)addTableView{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, APPLICATION_WIDTH, APPLICATION_HEIGHT-64) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.estimatedRowHeight = 50;
    _tableView.rowHeight = UITableViewAutomaticDimension;
    _tableView.separatorStyle = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.view addSubview:_tableView];
}
/**
 *  显示navigation的标题
 **/
-(void)setNavigationTitle{
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
    self.title = @"题库";
//    UIBarButtonItem *myButton = [[UIBarButtonItem alloc] initWithTitle:@"添加试题" style:UIBarButtonItemStylePlain target:self action:@selector(back)];
//    self.navigationItem.rightBarButtonItem = myButton;
//    UIBarButtonItem * backbtn = [[UIBarButtonItem alloc] initWithTitle:nil style:UIBarButtonItemStylePlain target:self action:@selector(back)];
//    self.navigationItem.leftBarButtonItem = backbtn;
}

-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark ---------------------UITableViewdelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (_questionsAry.count>0) {
        return _questionsAry.count;
    }
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    }
    
    QuestionBank * q = _questionsAry[indexPath.row];
    
    cell.textLabel.text = [NSString stringWithFormat:@"题库：%@",q.libName];
    return cell;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    QuestionBank * q = _questionsAry[indexPath.row];
    NSDictionary * dict = [[NSDictionary alloc] initWithObjectsAndKeys:q.libId,@"libId",@"1000",@"length",@"1",@"start",nil];
    [[NetworkRequest sharedInstance] GET:QuertyBankQuestionList dict:dict succeed:^(id data) {
        NSLog(@"%@",data);
        NSString  * str = [NSString stringWithFormat:@"%@",[[data objectForKey:@"header"] objectForKey:@"code"]];
        if ([str isEqualToString:@"0000"]) {
            NSArray * ary = [data objectForKey:@"body"];
            NSMutableArray * d = [NSMutableArray arrayWithCapacity:1];
            for (int i = 0; i<ary.count; i++) {
                Questions * q = [[Questions alloc] init];
                [q getSelfInfo:ary[i]];
                [d addObject:q];
            }
            QuestionListViewController * qVC = [[QuestionListViewController alloc] init];
            qVC.questionAry = [[NSMutableArray alloc] initWithArray:d];
            qVC.isSelect = YES;
            self.hidesBottomBarWhenPushed  = YES;
            [self.navigationController pushViewController:qVC animated:YES];
        }
        
    } failure:^(NSError *error) {
        [UIUtils showInfoMessage:@"请求失败，请检查网络" withVC:self];
    }];
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
