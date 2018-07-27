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
#import "JoinViewController.h"

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
@property (nonatomic,strong)SynchronousCourseView * synCourseView;

@end

@implementation SignInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.page = 0;
    self.temp = 0;
    self.view.backgroundColor = [UIColor colorWithHexString:@"#fafafa"];//RGBA_COLOR(231, 231, 231, 1);
    
    _synCourseView = [[SynchronousCourseView alloc] initWithFrame: CGRectMake(0, 0, APPLICATION_WIDTH, 0)];
    
    _synCourseView.delegate = self;
    
    _classAry = [NSMutableArray arrayWithCapacity:10];
    
    _userModel = [[Appsetting sharedInstance] getUsetInfo];
    
//    _dictDay = [UIUtils getWeekTimeWithType:nil];
    //    NSLog(@"%@",dict);
    
    [self addAlterView];
    
    [self setNavigationTitle];
    
    [self addTableView];
    // 1.注册通知
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(UpdateTheClassPage) name:@"UpdateTheClassPage" object:nil];
    
    
    [self addCourseBtn];
    
    [self headerRereshing];

}
-(void)viewDidAppear:(BOOL)animated{
    

}
-(void)addCourseBtn{
    
    UIButton * addcourse = [UIButton buttonWithType:UIButtonTypeCustom];
    
    addcourse.frame = CGRectMake(APPLICATION_WIDTH-80, APPLICATION_HEIGHT-100, 70, 70);
    
    //    [addcourse setBackgroundImage:[UIImage imageNamed:@"加入"] forState:UIControlStateNormal];
    
    [addcourse setImage:[UIImage imageNamed:@"加入"] forState:UIControlStateNormal];
    
    [addcourse addTarget:self action:@selector(joinCourse) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:addcourse];
}
-(void)UpdateTheClassPage{
    [self headerRereshing];
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

-(void)addTableView{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, APPLICATION_WIDTH, APPLICATION_HEIGHT-64) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    _tableView.backgroundColor = [UIColor colorWithHexString:@"#fafafa"];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    __weak SignInViewController * weakSelf = self;
    [_tableView addHeaderWithCallback:^{
        [weakSelf headerRereshing];
        
    }];
    
    [self.view addSubview:_tableView];
//    UISwipeGestureRecognizer * priv = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFrom:)];
//    [priv setDirection:(UISwipeGestureRecognizerDirectionRight)];
//    [_tableView addGestureRecognizer:priv];
//    UISwipeGestureRecognizer * recognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeFrom:)];
//    [recognizer setDirection:(UISwipeGestureRecognizerDirectionLeft)];
//    [_tableView addGestureRecognizer:recognizer];
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
                [strongSelf getSelfJoinClass:aPage];
            });
            
            if (aIsHeader) {
                [strongSelf.tableView headerEndRefreshing];
            }else{
                [strongSelf.tableView footerEndRefreshing];
            }
        }
    });
}

-(void)handleSwipeFrom:(UISwipeGestureRecognizer *)recognizer{
    NSString *subtypeString;
    
    subtypeString = kCATransitionFromRight;
    
    [self transitionWithType:@"pageCurl" WithSubtype:subtypeString ForView:self.view];
}
- (void) transitionWithType:(NSString *) type WithSubtype:(NSString *) subtype ForView : (UIView *) view {
    
    CATransition *animation = [CATransition animation];
    
    animation.duration = 0.7f;
    
    animation.type = type;
    
    if (subtype != nil) {
        animation.subtype = subtype;
        
    }
    animation.timingFunction = UIViewAnimationOptionCurveEaseInOut;
    
    [view.layer addAnimation:animation forKey:@"animation"];
    
}

#pragma mark 获取数据

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
        }else if ([str isEqualToString:@"无效token"]){
            [self hideHud];
            dispatch_async(dispatch_get_main_queue(), ^{
                [UIUtils accountWasUnderTheRoof];
            });
        }
        [self getSelfJoinClassType:page];
    } failure:^(NSError *error) {
        [self hideHud];
        [_tableView reloadData];
        [UIUtils showInfoMessage:@"获取课表失败，请稍后再试" withVC:self];
        
    }];
}

//临时
-(void)getSelfJoinClassType:(NSInteger)page{
    NSDictionary * dict = [[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%ld",(long)page],@"start",_userModel.peopleId,@"studentId",[NSString stringWithFormat:@"%@ 00:00:00",_dictDay[@"firstDay"]],@"actStartTime",[NSString stringWithFormat:@"%@ 23:59:59",_dictDay[@"lastDay"]],@"actEndTime",@"1000",@"length",_userModel.school,@"universityId",@"1",@"type",@"2",@"courseType",nil];
    [[NetworkRequest sharedInstance] GET:QueryCourse dict:dict succeed:^(id data) {
        //        NSLog(@"4");
        NSString * str = [[data objectForKey:@"header"] objectForKey:@"message"];
        if ([str isEqualToString:@"成功"]) {
            NSArray * ary = [[data objectForKey:@"body"] objectForKey:@"list"];
            for (int i = 0; i<ary.count; i++) {
                ClassModel * c = [[ClassModel alloc] init];
                [c setInfoWithDict:ary[i]];
                [_classAry addObject:c];
            }
        }else{
            [UIUtils showInfoMessage:str withVC:self];
            [self hideHud];
            [_tableView reloadData];
            return ;
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
        
        [self hideHud];

    } failure:^(NSError *error) {
        [self hideHud];
        [_tableView reloadData];
        [UIUtils showInfoMessage:@"获取课表失败，请稍后再试" withVC:self];
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
//    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    

    
    UIBarButtonItem *myButton = [[UIBarButtonItem alloc] initWithTitle:@"..." style:UIBarButtonItemStylePlain target:self action:@selector(selectionBtnPressed)];
    self.navigationItem.rightBarButtonItem = myButton;
    self.title = @"课堂";
//    
//    UIBarButtonItem * selection = [[UIBarButtonItem alloc] initWithTitle:@"搜索" style:UIBarButtonItemStylePlain target:self action:@selector(selectionBtnPressed)];
//    self.navigationItem.leftBarButtonItem = selection;
}
/**
 * 搜索
 **/
-(void)selectionBtnPressed{
    
    SelectClassViewController * s = [[SelectClassViewController alloc] init];
    _selfNavigationVC.hidesBottomBarWhenPushed = YES;
    [_selfNavigationVC.navigationController pushViewController:s animated:YES];
//    self.hidesBottomBarWhenPushed = NO;
    
//    UIBarButtonItem * selection = [[UIBarButtonItem alloc] initWithTitle:@"搜索" style:UIBarButtonItemStylePlain target:self action:@selector(selectionBtnPressed)];
//    self.navigationItem.leftBarButtonItem = selection;
}
/**
 *
 **/
-(void)joinCourse{

    JoinViewController * vc = [[JoinViewController alloc] init];
    _selfNavigationVC.hidesBottomBarWhenPushed = YES;
    [_selfNavigationVC.navigationController pushViewController:vc animated:YES];
    
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
            [UIUtils showInfoMessage:@"同步课程失败，请稍后再试" withVC:self];
        }
        [self hideHud];
    } failure:^(NSError *error) {
        [UIUtils showInfoMessage:@"同步课程失败，请稍后再试" withVC:self];
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

    cell = [tableView dequeueReusableCellWithIdentifier:@"ClassTableViewCellFirst"];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ClassTableViewCell" owner:self options:nil] objectAtIndex:0];
    }
    NSString * str = [NSString stringWithFormat:@"%d",(int)indexPath.row+1];
    NSMutableArray * ary = _dict[str];
    [cell addFirstContentViewWith:(int)indexPath.row withClass:ary];
    //    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.backgroundColor = [UIColor colorWithHexString:@"#fafafa"];
    
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
    
    NSString * month = _monthStr;//[UIUtils getMonth];
    
    NSMutableArray * day = [NSMutableArray arrayWithArray:_weekDayTime];//[UIUtils getWeekAllTimeWithType:nil];
    
    NSMutableArray * ary = [NSMutableArray arrayWithCapacity:1];;
    if (day.count>=7) {
        NSArray *  a = @[month,@"M",@"T",@"W",@"T",@"F",@"S",@"S"];
        for (int i = 0; i<8; i++) {
            if (i == 0) {
                [ary addObject:month];
            }else
                [ary addObject: [NSString stringWithFormat:@"%@", [NSString stringWithFormat:@"%@\n%@",a[i],day[i-1]]]];
        }
    }else{
        ary = [[NSMutableArray alloc] initWithArray:@[month,@"M",@"T",@"W",@"T",@"F",@"S",@"S"]];
    }
    for (int i =0; i<8; i++) {
        UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(i*APPLICATION_WIDTH/8, 0, APPLICATION_WIDTH/8, 50)];
        label.backgroundColor = [UIColor clearColor];
        
        label.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1/1.0];;
        
        label.text = ary[i];
        label.font = [UIFont systemFontOfSize:12];
        label.textAlignment = NSTextAlignmentCenter;
        label.numberOfLines = 0;
        [view addSubview:label];
        UIView * v = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(label.frame)-1, 0, 1, 50)];
        
        v.backgroundColor = RGBA_COLOR(241, 241, 241, 1);
        
        [view addSubview:v];
    }
    UIView * v = [[UIView alloc] initWithFrame:CGRectMake(0, 49, APPLICATION_WIDTH, 1)];
    v.backgroundColor = RGBA_COLOR(241, 241, 241, 1);
    [view addSubview:v];
    return view;
}
#pragma mark Class
-(void)intoTheCurriculumDelegate:(NSString *)str withNumber:(NSMutableArray *)btn{
    NSMutableArray * ary = [_dict objectForKey:str];
    if (btn.count == 1) {
        _selfNavigationVC.hidesBottomBarWhenPushed = YES;
        
        CourseDetailsViewController * cdetailVC = [[CourseDetailsViewController alloc] init];
        
        int n = [btn[0] intValue];
        
        cdetailVC.c = ary[n];
        
        [_selfNavigationVC.navigationController pushViewController:cdetailVC animated:YES];
        
//        self.hidesBottomBarWhenPushed=YES;
        
    }else{
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"有重复课程请选择要查看的课" message:nil preferredStyle:  UIAlertControllerStyleActionSheet];
        for (int i = 0; i<btn.count; i++) {
            //分别按顺序放入每个按钮；
            int n = [btn[i] intValue];
            ClassModel * c =ary[n];
            NSString * str = c.name;
            
            [alert addAction:[UIAlertAction actionWithTitle:str style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                _selfNavigationVC.hidesBottomBarWhenPushed = YES;
                CourseDetailsViewController * cdetailVC = [[CourseDetailsViewController alloc] init];
                int n = [btn[i] intValue];
                cdetailVC.c = ary[n];
                [_selfNavigationVC.navigationController pushViewController:cdetailVC animated:YES];
//                self.hidesBottomBarWhenPushed=NO;
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
