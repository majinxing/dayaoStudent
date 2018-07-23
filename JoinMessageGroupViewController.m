////
////  JoinMessageGroupViewController.m
////  WisdomHall
////
////  Created by XTU-TI on 2017/10/10.
////  Copyright © 2017年 majinxing. All rights reserved.
////
//
//#import "JoinMessageGroupViewController.h"
//#import "DYHeader.h"
////#import <Hyphenate/EMCursorResult.h>
////#import <Hyphenate/Hyphenate.h>
//#import "DiscussListTableViewCell.h"
//
//@interface JoinMessageGroupViewController ()<UITableViewDelegate,UITableViewDataSource>
//@property (nonatomic,strong)UITableView * tableView;
//@property (nonatomic,strong)NSMutableArray * dataAry;
//@end
//
//@implementation JoinMessageGroupViewController
//
//- (void)viewDidLoad {
//    [super viewDidLoad];
//    self.view.backgroundColor = [UIColor whiteColor];
//    
//    _dataAry = [NSMutableArray arrayWithCapacity:1];
//    
//    [self addTableView];
//    
//    [self getData];
//    
//    // Do any additional setup after loading the view from its nib.
//}
//-(void)getData{
//    EMError *error = nil;
//    EMCursorResult *result = [[EMClient sharedClient].groupManager getPublicGroupsFromServerWithCursor:nil pageSize:50 error:&error];
//    if (!error) {
//        for (int i = 0; i<result.list.count; i++) {
//            EMGroup * g = result.list[i];
//            [_dataAry addObject:g];
//        }
//        [_tableView reloadData];
//    }
//}
//-(void)addTableView{
//    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, APPLICATION_WIDTH, APPLICATION_HEIGHT) style:UITableViewStylePlain];
//    _tableView.delegate = self;
//    _tableView.dataSource = self;
//    self.automaticallyAdjustsScrollViewInsets = NO;
//    [self.view addSubview:_tableView];
//}
//- (void)didReceiveMemoryWarning {
//    [super didReceiveMemoryWarning];
//    // Dispose of any resources that can be recreated.
//}
//#pragma mark UITableViewdelegate
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
//    return 1;
//}
//-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    if (_dataAry.count>0) {
//        return _dataAry.count;
//    }
//    return 0;
//}
//
//-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//    DiscussListTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"DiscussListTableViewCell"];
//    if (!cell) {
//        cell = [[[NSBundle mainBundle] loadNibNamed:@"DiscussListTableViewCell" owner:nil options:nil] objectAtIndex:0];
//    }
//    EMGroup * chatroom = [self.dataAry objectAtIndex:indexPath.row];
//    [cell setImage:@"group_header" withLableTitle:chatroom.subject];
//    
//    return cell;
//}
//-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    
//    EMGroup * c = _dataAry[indexPath.row];
//    
//    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:nil preferredStyle:  UIAlertControllerStyleActionSheet];
//    //分别按顺序放入每个按钮；
//    [alert addAction:[UIAlertAction actionWithTitle:@"加入聊天组" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        //点击按钮的响应事件；
//        EMError *error = nil;
//        [[EMClient sharedClient].groupManager applyJoinPublicGroup:c.groupId message:@"" error:nil];
//        if (!error) {
//            [self.navigationController popViewControllerAnimated:YES];
//        }else{
//            [UIUtils showInfoMessage:@"申请失败或者已经在聊天组中" withVC:self];
//        }
//    }]];
//    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
//        //点击按钮的响应事件；
//    }]];
//    
//    //弹出提示框；
//    [self presentViewController:alert animated:true completion:nil];
//}
//-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    return 50;
//}
//-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    return 10;
//}
///*
//#pragma mark - Navigation
//
//// In a storyboard-based application, you will often want to do a little preparation before navigation
//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    // Get the new view controller using [segue destinationViewController].
//    // Pass the selected object to the new view controller.
//}
//*/
//
//@end

