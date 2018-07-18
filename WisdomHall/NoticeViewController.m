//
//  NoticeViewController.m
//  WisdomHall
//
//  Created by XTU-TI on 2017/5/10.
//  Copyright © 2017年 majinxing. All rights reserved.
//

#import "NoticeViewController.h"
#import "NoticeTableViewCell.h"
#import "DYHeader.h"
#import "FMDBTool.h"
#import "NoticeModel.h"
#import "DYTabBarViewController.h"
#import "ChatHelper.h"
#import "MJRefresh.h"
#import "NoticeDetailsViewController.h"

@interface NoticeViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView * tableView;
@property (nonatomic,strong)FMDatabase * db;
@property (nonatomic,strong)NSMutableArray * noticeAry;
@property (nonatomic,assign) int page;

@end

@implementation NoticeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _noticeAry = [NSMutableArray arrayWithCapacity:1];
    
    [self addTableView];
    
    [self setNavigationTitle];
    // Do any additional setup after loading the view from its nib.
}
-(void)viewWillAppear:(BOOL)animated{
    
//    self.navigationController.navigationBarHidden = NO; //设置隐藏
    
//    [self.navigationController setNavigationBarHidden:YES];

}
-(void)addTableView{
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, APPLICATION_WIDTH, APPLICATION_HEIGHT-64) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.estimatedRowHeight = 80;
    _tableView.rowHeight = UITableViewAutomaticDimension;
    [self.view addSubview:_tableView];
    __weak NoticeViewController * weakSelf = self;
    [_tableView addHeaderWithCallback:^{
        [weakSelf headerRereshing];
    }];
    [_tableView addFooterWithCallback:^{
        [weakSelf footerRereshing];
    }];
    [self headerRereshing];
}
-(void)headerRereshing{
    self.page = 1;
    [self fetchChatRoomsWithPage:self.page isHeader:YES];
}
-(void)footerRereshing{
    self.page +=1;
    [self fetchChatRoomsWithPage:self.page isHeader:NO];
}
/**
 *  显示navigation的标题
 **/
-(void)setNavigationTitle{
    
//    UIView * navigationBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, APPLICATION_WIDTH, 64)];
//    navigationBar.backgroundColor = [[Appsetting sharedInstance] getThemeColor];
//
//    [self.view addSubview:navigationBar];
//
//    UILabel * titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(APPLICATION_WIDTH/2-40, 30, 80, 20)];
//    titleLabel.text = @"通知";
//    titleLabel.textAlignment = NSTextAlignmentCenter;
//    titleLabel.textColor = [UIColor blackColor];
//    titleLabel.font = [UIFont systemFontOfSize:18];
//    [self.view addSubview:titleLabel];
//
//
//    UIImageView * b = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ic_arrow_left"]];
//    b.frame = CGRectMake(3, 30, 25, 20);
//    [self.view addSubview:b];
//
//    UIButton * backBtn = [UIButton buttonWithType:UIButtonTypeSystem];
//    backBtn.frame = CGRectMake(13,18, 60, 44);
//    [backBtn setTitle:@"返回" forState:UIControlStateNormal];
//    [backBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//
//    backBtn.titleLabel.font = [UIFont systemFontOfSize:17];//[UIFont fontWithName:@"Helvetica-Bold" size:17];
//
//    backBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
//    [self.view addSubview:backBtn];
//    [backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
//    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
//
    self.title = @"通知";
//    UIBarButtonItem * myButton = [[UIBarButtonItem alloc] initWithTitle:@"<返回" style:UIBarButtonItemStylePlain target:self action:@selector(back)];
//
//    self.navigationItem.leftBarButtonItem = myButton;
}
-(void)back{
    if ([_backType isEqualToString:@"TabBar"]) {
        
        ChatHelper * c =[ChatHelper shareHelper];
        
        DYTabBarViewController *rootVC = [[DYTabBarViewController alloc] init];
        
        [UIApplication sharedApplication].keyWindow.rootViewController = rootVC;
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}
- (void)fetchChatRoomsWithPage:(NSInteger)aPage
                      isHeader:(BOOL)aIsHeader{
    [self hideHud];
    [self showHudInView:self.view hint:NSLocalizedString(@"正在加载数据", @"Load data...")];
    __weak typeof(self)weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if (weakSelf) {
            NoticeViewController * strongSelf = weakSelf;
            if (aIsHeader) {
                [_noticeAry removeAllObjects];
                _noticeAry = [NSMutableArray arrayWithCapacity:1];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [strongSelf addDataWithPage:aPage];
            });
            
            if (aIsHeader) {
                [strongSelf.tableView headerEndRefreshing];
            }else{
                [strongSelf.tableView footerEndRefreshing];
            }
        }
    });
}
-(void)addDataWithPage:(NSInteger)page{
    
    NSDictionary * dict = [[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%ld",(long)page],@"start",@"50",@"length", nil];
    
    [[NetworkRequest sharedInstance] GET:QueryNotice dict:dict succeed:^(id data) {
    
        NSString * str = [[data objectForKey:@"header"] objectForKey:@"code"];
        if ([str isEqualToString:@"0000"]) {
            NSArray * ary = [[data objectForKey:@"body"] objectForKey:@"list"];
            for (int i = 0; i<ary.count; i++) {
                NoticeModel * notice = [[NoticeModel alloc] init];
                notice.noticeTime = [UIUtils timeWithTimeIntervalString:[ary[i] objectForKey:@"time"]];
                notice.noticeContent = [ary[i] objectForKey:@"inform"];
                notice.noticeTitle = [ary[i] objectForKey:@"title"];
                notice.revert = [ary[i] objectForKey:@"revert"];
                notice.noticeId = [ary[i] objectForKey:@"id"];
                notice.messageStatus = [ary[i] objectForKey:@"status"];
                [_noticeAry addObject:notice];
            }
        }
        [_tableView reloadData];
        [self hideHud];
    } failure:^(NSError *error) {
        [UIUtils showInfoMessage:@"获取数据失败，请检查网络" withVC:self];

        [self hideHud];
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark UITableViewdelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (_noticeAry.count>0) {
        return _noticeAry.count;
    }
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NoticeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NoticeTableViewCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"NoticeTableViewCell" owner:self options:nil] objectAtIndex:0];
    }
    cell.backgroundColor = [UIColor clearColor];
    if ((_noticeAry.count-indexPath.row-1)<_noticeAry.count) {
        NoticeModel * notice = _noticeAry[indexPath.row];
        [cell setContentView:notice];
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NoticeDetailsViewController * notice = [[NoticeDetailsViewController alloc] initWithActionBlock:^(NSString *str) {
        [self headerRereshing];
    }];
    notice.notice = _noticeAry[indexPath.row];
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:notice animated:YES];
    //    self.hidesBottomBarWhenPushed = NO;
}
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"删除";
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
//点击删除
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    //在这里实现删除操作
    NoticeModel * notice = _noticeAry[indexPath.row];
    NSDictionary * dict = [[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%@",notice.noticeId],@"id", nil];
    
    [[NetworkRequest sharedInstance] POST:Noticedelect dict:dict succeed:^(id data) {
        
        NSString * str = [NSString stringWithFormat:@"%@",[[data objectForKey:@"header"] objectForKey:@"code"]];
        if ([str isEqualToString:@"0000"]) {
            [self headerRereshing];
        }else{
            [UIUtils showInfoMessage:@"删除失败" withVC:self];
        }
    } failure:^(NSError *error) {
        [UIUtils showInfoMessage:@"删除失败，请检查网络" withVC:self];
    }];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
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

