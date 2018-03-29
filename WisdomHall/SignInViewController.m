//
//  SignInViewController.m
//  WisdomHall
//
//  Created by XTU-TI on 2017/4/24.
//  Copyright © 2017年 majinxing. All rights reserved.
//

#import "SignInViewController.h"
#import "SignPromptView.h"
#import "CreateCourseViewController.h"

#import "CourseCollectionViewCell.h"
#import "CollectionFlowLayout.h"
#import "DYHeader.h"
#import "CourseDetailsViewController.h"

#import <Hyphenate/Hyphenate.h>

#import "CollectionHeadView.h"
#import "UserModel.h"
#import "ClassModel.h"
#import "MJRefresh.h"
#import "CreateTemporaryCourseViewController.h"
#import "SelectClassViewController.h"
#import "AlterView.h"
#import "DYTabBarViewController.h"
#import "ChatHelper.h"
#import "TheLoginViewController.h"
#import "JoinCours.h"
#import "WorkingLoginViewController.h"
#import "ClassTableViewCell.h"
#import "SynchronousCourseView.h"

static NSString *cellIdentifier = @"cellIdentifier";

@interface SignInViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,AlterViewDelegate,JoinCoursDelegate,UITableViewDelegate,UITableViewDataSource,ClassTableViewCellDelegate,SynchronousCourseViewDelegate>
@property (nonatomic,strong) UICollectionView * collection;
@property (nonatomic,strong) UserModel * userModel;
@property (nonatomic,strong) NSMutableArray * classAry;
/** @brief 当前加载的页数 */
@property (nonatomic,assign) int page;

@property (nonatomic,assign) int temp;

@property (nonatomic,strong)AlterView * alterView;

@property (nonatomic,strong)JoinCours * join;

@property (nonatomic,strong)UITableView * tableView;

@property (nonatomic,strong)NSMutableDictionary * dict;
@property (nonatomic,strong)NSDictionary * dictDay;
@property (nonatomic,strong)SynchronousCourseView * synCourseView;

@end

@implementation SignInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.page = 0;
    self.temp = 0;
    self.view.backgroundColor = [UIColor whiteColor];//RGBA_COLOR(231, 231, 231, 1);
    
    _synCourseView = [[SynchronousCourseView alloc] initWithFrame: CGRectMake(0, 0, APPLICATION_WIDTH, 0)];
    
    _synCourseView.delegate = self;
    
    _classAry = [NSMutableArray arrayWithCapacity:10];
    
    _userModel = [[Appsetting sharedInstance] getUsetInfo];
    
    _dictDay = [UIUtils getWeekTimeWithType:nil];
    //    NSLog(@"%@",dict);
    
    [self addAlterView];
    
    [self setNavigationTitle];
    
    //    [self addCollection];
    [self headerRereshing];
    
    
    [self addTableView];
    // 1.注册通知
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(UpdateTheClassPage) name:@"UpdateTheClassPage" object:nil];
    
    [UIUtils getInternetDate];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    //NSString *homeDir = NSHomeDirectory();沙盒路径
    // Do any additional setup after loading the view from its nib.
}
-(void)UpdateTheClassPage{
    [self headerRereshing];
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
-(void)viewWillAppear:(BOOL)animated{
    [UIUtils tokenThePeriodOfValidity];
}
-(void)addTableView{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, APPLICATION_WIDTH, APPLICATION_HEIGHT-64-44) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = [UIColor clearColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    __weak SignInViewController * weakSelf = self;
    [_tableView addHeaderWithCallback:^{
        [weakSelf headerRereshing];
        
    }];
    
    [self.view addSubview:_tableView];
    
}
-(void)addAlterView{
    _alterView = [[AlterView alloc] initWithFrame:CGRectMake(60, 200, APPLICATION_WIDTH-120, 120) withLabelText:@"暂无课程"];
    _alterView.layer.masksToBounds = YES;
    _alterView.layer.cornerRadius = 10;
    _alterView.delegate = self;
}


-(void)headerRereshing{
    self.page = 1;
    [self fetchChatRoomsWithPage:self.page isHeader:YES];
}
-(void)footerRereshing{
    self.page +=1;
    [self fetchChatRoomsWithPage:self.page isHeader:NO];
}
- (void)fetchChatRoomsWithPage:(NSInteger)aPage
                      isHeader:(BOOL)aIsHeader{
    [self hideHud];
    [self showHudInView:self.view hint:NSLocalizedString(@"正在加载数据", @"Load data...")];
    __weak typeof(self)weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if (weakSelf) {
            SignInViewController * strongSelf = weakSelf;
            if (aIsHeader) {
                [_classAry removeAllObjects];
                _classAry = [NSMutableArray arrayWithCapacity:1];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [strongSelf getDataWithPage:aPage];
            });
            
            if (aIsHeader) {
                [strongSelf.tableView headerEndRefreshing];
            }else{
                [strongSelf.tableView footerEndRefreshing];
            }
        }
    });
}
#pragma mark 获取数据
-(void)getDataWithPage:(NSInteger)page{
    
    
    NSDictionary * dict = [[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%ld",(long)page],@"start",_userModel.peopleId,@"teacherId",[NSString stringWithFormat:@"%@ 00:00:00",_dictDay[@"firstDay"]],@"actStartTime",[NSString stringWithFormat:@"%@ 23:59:59",_dictDay[@"lastDay"]],@"actEndTime",@"1000",@"length",_userModel.school,@"universityId",@"2",@"type",[NSString stringWithFormat:@"%d",[UIUtils getTermId]],@"termId",@"1",@"courseType",nil];
    
    [[NetworkRequest sharedInstance] GET:QueryCourse dict:dict succeed:^(id data) {
        //        NSLog(@"1");
        NSString * str = [[data objectForKey:@"header"] objectForKey:@"message"];
        if ([str isEqualToString:@"成功"]) {
            NSArray * ary = [[data objectForKey:@"body"] objectForKey:@"list"];
            for (int i = 0; i<ary.count; i++) {
                
                ClassModel * c = [[ClassModel alloc] init];
                [c setInfoWithDict:ary[i]];
                [_classAry addObject:c];
            }
            
            [self getSelfJoinClass:page];
            //            [self hideHud];
        }else if ([str isEqualToString:@"无效token"]){
            [self hideHud];
            dispatch_async(dispatch_get_main_queue(), ^{
                [UIUtils accountWasUnderTheRoof];
            });
        }else{
            [self hideHud];
            
        }
    } failure:^(NSError *error) {
        [self hideHud];
        [UIUtils showInfoMessage:@"获取课表失败，请稍后再试"];
    }];
}
-(void)getSelfJoinClass:(NSInteger)page{
    NSDictionary * dict = [[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%ld",(long)page],@"start",_userModel.peopleId,@"studentId",[NSString stringWithFormat:@"%@ 00:00:00",_dictDay[@"firstDay"]],@"actStartTime",[NSString stringWithFormat:@"%@ 23:59:59",_dictDay[@"lastDay"]],@"actEndTime",@"1000",@"length",_userModel.school,@"universityId",@"1",@"type",[NSString stringWithFormat:@"%d",[UIUtils getTermId]],@"termId",@"1",@"courseType",nil];
    
    [[NetworkRequest sharedInstance] GET:QueryCourse dict:dict succeed:^(id data) {
        NSString * str = [[data objectForKey:@"header"] objectForKey:@"message"];
        if ([str isEqualToString:@"成功"]) {
            NSArray * ary = [[data objectForKey:@"body"] objectForKey:@"list"];
            for (int i = 0; i<ary.count; i++) {
                ClassModel * c = [[ClassModel alloc] init];
                [c setInfoWithDict:ary[i]];
                [_classAry addObject:c];
            }
        }
        [self getSelfCreateClassType:page];
    } failure:^(NSError *error) {
        [self hideHud];
        [UIUtils showInfoMessage:@"获取课表失败，请稍后再试"];
    }];
}
//临时
-(void)getSelfCreateClassType:(NSInteger)page{
    
    NSDictionary * dict = [[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%ld",(long)page],@"start",_userModel.peopleId,@"teacherId",[NSString stringWithFormat:@"%@ 00:00:00",_dictDay[@"firstDay"]],@"actStartTime",[NSString stringWithFormat:@"%@ 23:59:59",_dictDay[@"lastDay"]],@"actEndTime",@"1000",@"length",_userModel.school,@"universityId",@"2",@"type",@"2",@"courseType",nil];
    
    [[NetworkRequest sharedInstance] GET:QueryCourse dict:dict succeed:^(id data) {
        NSString * str = [[data objectForKey:@"header"] objectForKey:@"message"];
        if ([str isEqualToString:@"成功"]) {
            NSArray * ary = [[data objectForKey:@"body"] objectForKey:@"list"];
            for (int i = 0; i<ary.count; i++) {
                ClassModel * c = [[ClassModel alloc] init];
                [c setInfoWithDict:ary[i]];
                [_classAry addObject:c];
            }
        }
        [self getSelfJoinClassType:page];
    } failure:^(NSError *error) {
        [self hideHud];
        [UIUtils showInfoMessage:@"获取课表失败，请稍后再试"];
        
    }];
}
//临时
-(void)getSelfJoinClassType:(NSInteger)page{
    NSDictionary * dict = [[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%ld",(long)page],@"start",_userModel.peopleId,@"studentId",[NSString stringWithFormat:@"%@ 00:00:00",_dictDay[@"firstDay"]],@"actStartTime",[NSString stringWithFormat:@"%@ 23:59:59",_dictDay[@"lastDay"]],@"actEndTime",@"1000",@"length",_userModel.school,@"universityId",@"1",@"type",@"2",@"courseType",nil];
    [[NetworkRequest sharedInstance] GET:QueryCourse dict:dict succeed:^(id data) {
        //        NSLog(@"4");
        [self hideHud];
        NSString * str = [[data objectForKey:@"header"] objectForKey:@"message"];
        if ([str isEqualToString:@"成功"]) {
            NSArray * ary = [[data objectForKey:@"body"] objectForKey:@"list"];
            for (int i = 0; i<ary.count; i++) {
                ClassModel * c = [[ClassModel alloc] init];
                [c setInfoWithDict:ary[i]];
                [_classAry addObject:c];
            }
        }
        for (int i = 0 ; i<_classAry.count; i++) {
            ClassModel * c = _classAry[i];
            
            for (int j = i; j<_classAry.count; j++) {
                ClassModel * c1 = _classAry[j];
                //date02比date01小
                if ([[UIUtils compareTimeStartTime:c.actStarTime withExpireTime:c1.actStarTime] isEqualToString:@"-1"]) {
                    //                    c2 = c1;
                    ClassModel *c2 = [[ClassModel alloc] init];
                    c2 = c;
                    [_classAry setObject:c1 atIndexedSubscript:i];
                    [_classAry setObject:c2 atIndexedSubscript:j];
                    c = _classAry[i];
                }
            }
        }
        
        _dict = [[NSMutableDictionary alloc] initWithDictionary:[UIUtils CurriculumGroup:_classAry]];
        
        [_tableView reloadData];
        
        
    } failure:^(NSError *error) {
        [self hideHud];
        [UIUtils showInfoMessage:@"获取课表失败，请稍后再试"];
        
    }];
    
}
-(void)deleteTheDuplicateData{
    for (int i = 0; i<_classAry.count; i++) {
        ClassModel * c = _classAry[i];
        for (int j = i+1; j<_classAry.count; j++) {
            ClassModel * d = _classAry[j];
            NSString * s1 = [NSString stringWithFormat:@"%@",c.sclassId];
            NSString * s2 = [NSString stringWithFormat:@"%@",d.sclassId];
            if ([s1 isEqualToString:s2]) {
                [_classAry removeObjectAtIndex:j];
            }
        }
    }
    
}
/**
 *  显示navigation的标题
 **/
-(void)setNavigationTitle{
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
    self.title = @"本周课程";
    
    UIBarButtonItem *myButton = [[UIBarButtonItem alloc] initWithTitle:@"加入课程" style:UIBarButtonItemStylePlain target:self action:@selector(joinCourse)];
    self.navigationItem.rightBarButtonItem = myButton;
    
    
    UIBarButtonItem * selection = [[UIBarButtonItem alloc] initWithTitle:@"搜索" style:UIBarButtonItemStylePlain target:self action:@selector(selectionBtnPressed)];
    self.navigationItem.leftBarButtonItem = selection;
}
/**
 * 搜索
 **/
-(void)selectionBtnPressed{
    
    SelectClassViewController * s = [[SelectClassViewController alloc] init];
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:s animated:YES];
    self.hidesBottomBarWhenPushed = NO;
    
    UIBarButtonItem * selection = [[UIBarButtonItem alloc] initWithTitle:@"搜索" style:UIBarButtonItemStylePlain target:self action:@selector(selectionBtnPressed)];
    self.navigationItem.leftBarButtonItem = selection;
}
/**
 *
 **/
-(void)joinCourse{
    if (_join==nil) {
        _join = [[JoinCours alloc] init];
        _join.delegate = self;
        _join.frame = CGRectMake(0, 0, APPLICATION_WIDTH, APPLICATION_HEIGHT);
        [self.view addSubview:_join];
    }
    //    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:nil preferredStyle:  UIAlertControllerStyleActionSheet];
    //
    //    //分别按顺序放入每个按钮；
    //    [alert addAction:[UIAlertAction actionWithTitle:@"同步课程" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    //        //点击按钮的响应事件；
    //        [UIView animateWithDuration:2.5 animations:^{
    //
    //            _synCourseView.frame = CGRectMake(0, 0, APPLICATION_WIDTH, APPLICATION_HEIGHT);
    //            [self.view addSubview:_synCourseView];
    //        }completion:^(BOOL finished) {
    //
    //
    //        }];
    //    }]];
    //    //分别按顺序放入每个按钮；
    //    [alert addAction:[UIAlertAction actionWithTitle:@"加入课程" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    //
    //    }]];
    //    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
    //
    //
    //        //点击按钮的响应事件；
    //    }]];
    //    //弹出提示框；
    //    [self presentViewController:alert animated:true completion:nil];
    
}
/**
 *  创建课程
 **/
-(void)createAcourse{
    [self setAlterAction];
}
-(void)setAlterAction{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:nil preferredStyle:  UIAlertControllerStyleActionSheet];
    //分别按顺序放入每个按钮；
    [alert addAction:[UIAlertAction actionWithTitle:@"创建周期性课堂" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //点击按钮的响应事件；
        CreateCourseViewController * cCourseVC = [[CreateCourseViewController alloc] init];
        self.hidesBottomBarWhenPushed = YES;
        //    self.tabBarController.tabBar.hidden=YES;
        [self.navigationController pushViewController:cCourseVC animated:YES];
        self.hidesBottomBarWhenPushed = NO;
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"创建临时性课堂" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //点击按钮的响应事件；
        CreateTemporaryCourseViewController * c = [[CreateTemporaryCourseViewController alloc] init];
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:c animated:YES];
        self.hidesBottomBarWhenPushed = NO;
        
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        //点击按钮的响应事件；
    }]];
    //弹出提示框；
    [self presentViewController:alert animated:true completion:nil];
}
#pragma mark JoinCoursDelegate
-(void)joinCourseDelegete:(UIButton *)btn{
    [self.view endEditing:YES];
    if (btn.tag == 1) {
        [_join removeFromSuperview];
        _join = nil;
    }else if (btn.tag == 2){
        NSDictionary * dict = [[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%@",_join.courseNumber.text],@"id",_userModel.peopleId,@"studentId", nil];
        [self showHudInView:self.view hint:NSLocalizedString(@"正在加载数据", @"Load data...")];
        [[NetworkRequest sharedInstance] POST:JoinCourse dict:dict succeed:^(id data) {
            NSString * str = [[data objectForKey:@"header"] objectForKey:@"code"];
            if ([[NSString stringWithFormat:@"%@",str] isEqualToString:@"6680"]) {
                [UIUtils showInfoMessage:@"该用户已经添加,不能重复添加"];
            }else if ([[NSString stringWithFormat:@"%@",str] isEqualToString:@"6676"]){
                [UIUtils showInfoMessage:@"数据异常"];
            }else if([[NSString stringWithFormat:@"%@",str] isEqualToString:@"0000"]){
                [UIUtils showInfoMessage:@"加入成功"];
                [self headerRereshing];
                [_join removeFromSuperview];
                _join = nil;
            }else{
                [UIUtils showInfoMessage:@"加入失败"];
            }
            [self hideHud];
            
        } failure:^(NSError *error) {
            [UIUtils showInfoMessage:@"加入失败"];
            [self hideHud];
            
        }];
    }
}
#pragma mark SynchronousCourseViewDelegate
-(void)submitDelegateWithAccount:(NSString *)count withPassword:(NSString *)password{
    
    NSDictionary * dict = [[NSDictionary alloc] initWithObjectsAndKeys:count,@"loginStr",password,@"password",[NSString stringWithFormat:@"%@",_userModel.school],@"universityId", nil];
    
    [self showHudInView:self.view hint:NSLocalizedString(@"正在加载数据", @"Load data...")];
    [[NetworkRequest sharedInstance] POST:SyncCourse dict:dict succeed:^(id data) {
        NSString * code  = [[data objectForKey:@"header"] objectForKey:@"code"];
        if (![UIUtils isBlankString:code]) {
            if ([code isEqualToString:@"0000"]) {
                [self headerRereshing];
                [_synCourseView removeFromSuperview];
            }
        }else{
            [UIUtils showInfoMessage:@"同步课程失败，请稍后再试"];
        }
        [self hideHud];
    } failure:^(NSError *error) {
        [UIUtils showInfoMessage:@"同步课程失败，请稍后再试"];
        [_synCourseView removeFromSuperview];
        [self hideHud];
    }];
}
-(void)outViewDelegate{
    [_synCourseView removeFromSuperview];
}
#pragma mark AlterViewDelegate
-(void)alterViewDeleageRemove{
    [_alterView removeFromSuperview];
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
    return 6;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ClassTableViewCell * cell ;
    //    if (indexPath.row == 0) {
    ////        cell = [tableView dequeueReusableCellWithIdentifier:@"ClassTableViewCellSecond"];
    ////        if (!cell) {
    ////            cell = [[[NSBundle mainBundle] loadNibNamed:@"ClassTableViewCell" owner:self options:nil] objectAtIndex:1];
    ////        }
    //    }else{
    cell = [tableView dequeueReusableCellWithIdentifier:@"ClassTableViewCellFirst"];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ClassTableViewCell" owner:self options:nil] objectAtIndex:0];
    }
    NSString * str = [NSString stringWithFormat:@"%d",(int)indexPath.row+1];
    NSMutableArray * ary = _dict[str];
    [cell addFirstContentViewWith:(int)indexPath.row withClass:ary];
    //    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor clearColor];
    cell.delegate = self;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 50;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView * view = [[UIView alloc] init];
    view.backgroundColor = [UIColor whiteColor];//RGBA_COLOR(201, 242, 253, 1);
    NSString * month = [UIUtils getMonth];
    NSMutableArray * day = [UIUtils getWeekAllTimeWithType:nil];
    NSMutableArray * ary = [NSMutableArray arrayWithCapacity:1];;
    if (day.count==7) {
        NSArray *  a = @[month,@"周一",@"周二",@"周三",@"周四",@"周五",@"周六",@"周日"];
        for (int i = 0; i<8; i++) {
            if (i == 0) {
                [ary addObject:month];
            }else
                [ary addObject: [NSString stringWithFormat:@"%@", [NSString stringWithFormat:@"%@\n%@",day[i-1],a[i]]]];
        }
    }else{
        ary = [[NSMutableArray alloc] initWithArray:@[month,@"周一",@"周二",@"周三",@"周四",@"周五",@"周六",@"周日"]];
    }
    for (int i =0; i<8; i++) {
        UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(i*APPLICATION_WIDTH/8, 0, APPLICATION_WIDTH/8, 50)];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = RGBA_COLOR(57, 114, 172, 1);
        label.text = ary[i];
        label.font = [UIFont systemFontOfSize:14];
        label.textAlignment = NSTextAlignmentCenter;
        label.numberOfLines = 0;
        [view addSubview:label];
        UIView * v = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(label.frame)-1, 0, 1, 50)];
        v.backgroundColor = RGBA_COLOR(184, 216, 248, 1);
        [view addSubview:v];
    }
    UIView * v = [[UIView alloc] initWithFrame:CGRectMake(0, 49, APPLICATION_WIDTH, 1)];
    v.backgroundColor = RGBA_COLOR(184, 216, 248, 1);
    [view addSubview:v];
    return view;
}
#pragma mark Class
-(void)intoTheCurriculumDelegate:(NSString *)str withNumber:(NSMutableArray *)btn{
    NSMutableArray * ary = [_dict objectForKey:str];
    if (btn.count == 1) {
        self.hidesBottomBarWhenPushed = YES;
        CourseDetailsViewController * cdetailVC = [[CourseDetailsViewController alloc] init];
        int n = [btn[0] intValue];
        cdetailVC.c = ary[n];
        [self.navigationController pushViewController:cdetailVC animated:YES];
        self.hidesBottomBarWhenPushed=NO;
    }else{
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"有重复课程请选择要查看的课" message:nil preferredStyle:  UIAlertControllerStyleActionSheet];
        for (int i = 0; i<btn.count; i++) {
            //分别按顺序放入每个按钮；
            int n = [btn[i] intValue];
            ClassModel * c =ary[n];
            NSString * str = c.name;
            
            [alert addAction:[UIAlertAction actionWithTitle:str style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                self.hidesBottomBarWhenPushed = YES;
                CourseDetailsViewController * cdetailVC = [[CourseDetailsViewController alloc] init];
                int n = [btn[i] intValue];
                cdetailVC.c = ary[n];
                [self.navigationController pushViewController:cdetailVC animated:YES];
                self.hidesBottomBarWhenPushed=NO;
            }]];
            
        }
        [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            //点击按钮的响应事件；
        }]];
        //弹出提示框；
        [self presentViewController:alert animated:true completion:nil];
    }
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
