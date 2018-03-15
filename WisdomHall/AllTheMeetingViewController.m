//
//  AllTheMeetingViewController.m
//  WisdomHall
//
//  Created by XTU-TI on 2017/5/4.
//  Copyright © 2017年 majinxing. All rights reserved.
//

#import "AllTheMeetingViewController.h"
#import "CourseCollectionViewCell.h"
#import "CollectionFlowLayout.h"
#import "DYHeader.h"
#import "TheMeetingInfoViewController.h"
#import "MeetingModel.h"
#import "MJRefresh.h"
#import "SelectMeetingOrClassViewController.h"
#import "AlterView.h"
#import "CreateMeetingViewController.h"
#import "JoinCours.h"

static NSString * cellIdentifier = @"cellIdentifier";

@interface AllTheMeetingViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,AlterViewDelegate,JoinCoursDelegate>
@property (nonatomic,strong) UICollectionView * collection;
@property (nonatomic,strong) NSMutableArray * meetingModelAry;
@property (nonatomic,strong) UserModel * userModel;
/** @brief 当前加载的页数 */
@property (nonatomic,assign) int page;
@property (nonatomic,assign) int temp;

@property (nonatomic,assign) int page1;

@property (nonatomic,assign) int page2;

@property (nonatomic,strong)AlterView * alterView;

@property (nonatomic,strong)JoinCours * join;

@end

@implementation AllTheMeetingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _meetingModelAry = [NSMutableArray arrayWithCapacity:12];
    
    _temp = 0;
    
    _page1 = 1;
    
    _page2 = 2;
    
    [self addAlterView];
    
    [self setNavigationTitle];
    
    [self addCollection];

    self.view.backgroundColor = RGBA_COLOR(231, 231, 231, 1);
    // 1.注册通知
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(headerRereshing) name:@"UpdateTheMeetingPage" object:nil];
    
    // Do any additional setup after loading the view from its nib.
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
-(void)viewWillAppear:(BOOL)animated{
    
}
/**
 *  显示navigation的标题
 **/
-(void)setNavigationTitle{
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
    self.title = @"会议";
    
    //    UIBarButtonItem * selection = [[UIBarButtonItem alloc] initWithTitle:@"搜索" style:UIBarButtonItemStylePlain target:self action:@selector(selectionBtnPressed)];
    //    self.navigationItem.leftBarButtonItem = selection;
    UIBarButtonItem * createMeeting = [[UIBarButtonItem alloc] initWithTitle:@"更多" style:UIBarButtonItemStylePlain target:self action:@selector(createMeeting)];
    self.navigationItem.rightBarButtonItem = createMeeting;
}
-(void)createMeeting{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:nil preferredStyle:  UIAlertControllerStyleActionSheet];
//    //分别按顺序放入每个按钮；
//    [alert addAction:[UIAlertAction actionWithTitle:@"创建会议" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        //点击按钮的响应事件；
//        CreateMeetingViewController * c = [[CreateMeetingViewController alloc] init];
//        self.hidesBottomBarWhenPushed = YES;
//        [self.navigationController pushViewController:c animated:YES];
//        //        self.hidesBottomBarWhenPushed = NO;
//    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"加入会议" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (_join==nil) {
            _join = [[JoinCours alloc] init];
            _join.delegate = self;
            _join.frame = CGRectMake(0, 0, APPLICATION_WIDTH, APPLICATION_HEIGHT);
            [self.view addSubview:_join];
        }
        
        
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"搜索会议" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self selectionBtnPressed];
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        //点击按钮的响应事件；
    }]];
    
    //弹出提示框；
    [self presentViewController:alert animated:true completion:nil];
    
}

-(void)selectionBtnPressed{
    SelectMeetingOrClassViewController * s = [[SelectMeetingOrClassViewController alloc] init];
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:s animated:YES];
    self.hidesBottomBarWhenPushed = NO;
    UIBarButtonItem * selection = [[UIBarButtonItem alloc] initWithTitle:@"搜索" style:UIBarButtonItemStylePlain target:self action:@selector(selectionBtnPressed)];
    self.navigationItem.leftBarButtonItem = selection;

}
-(void)addAlterView{
    _alterView = [[AlterView alloc] initWithFrame:CGRectMake(60, 200, APPLICATION_WIDTH-120, 120) withLabelText:@"暂无会议"];
    _alterView.layer.masksToBounds = YES;
    _alterView.layer.cornerRadius = 10;
    _alterView.delegate = self;
    
}
/**
 * 添加collection
 **/
-(void)addCollection{
    _collection = [[UICollectionView alloc] initWithFrame:CGRectMake(0,64,APPLICATION_WIDTH,APPLICATION_HEIGHT-64-44) collectionViewLayout:[[CollectionFlowLayout alloc] init]];
    //注册
    [_collection registerClass:[CourseCollectionViewCell class] forCellWithReuseIdentifier:cellIdentifier];
    
    _collection.delegate = self;
    _collection.dataSource = self;
    _collection.allowsMultipleSelection = YES;
    _collection.showsVerticalScrollIndicator = NO;
    _collection.showsHorizontalScrollIndicator = NO;
    _collection.layer.masksToBounds = YES;
    _collection.layer.cornerRadius = 0;
    //取消滑动的滚动条
    _collection.decelerationRate = UIScrollViewDecelerationRateNormal;
    _collection.backgroundColor = [UIColor clearColor];
    self.collection.alwaysBounceVertical = YES; //垂直方向遇到边框是否总是反弹
    __weak AllTheMeetingViewController * weakSelf = self;
    [self.collection addHeaderWithCallback:^{
        [weakSelf headerRereshing];
    }];
    [self.collection addFooterWithCallback:^{
        [weakSelf footerRereshing];
    }];
    
    [self headerRereshing];
    [self.view addSubview:_collection];
}
#pragma mrak MJR
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
            AllTheMeetingViewController * strongSelf = weakSelf;
            dispatch_async(dispatch_get_main_queue(), ^{
                [strongSelf getDataWithPage:aPage isHeader:aIsHeader];
            });
            if (aIsHeader) {
                [strongSelf.collection headerEndRefreshing];
            }else{
                [strongSelf.collection footerEndRefreshing];
            }
        }
    });
}
#pragma mark JoinCoursDelegate
-(void)joinCourseDelegete:(UIButton *)btn{
    [self.view endEditing:YES];
    if (btn.tag == 1) {
        [_join removeFromSuperview];
        _join = nil;
    }else if (btn.tag == 2){
        NSDictionary * dict = [[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%@",_join.courseNumber.text],@"id",_userModel.peopleId,@"userId", nil];
        [self showHudInView:self.view hint:NSLocalizedString(@"正在加载数据", @"Load data...")];

        [[NetworkRequest sharedInstance] POST:JoinMeeting dict:dict succeed:^(id data) {
            NSString * str = [[data objectForKey:@"header"] objectForKey:@"code"];
            if ([[NSString stringWithFormat:@"%@",str] isEqualToString:@"6680"]) {
                [UIUtils showInfoMessage:@"该用户已经添加,不能重复添加"];
            }else if([[NSString stringWithFormat:@"%@",str] isEqualToString:@"0000"]){
                [UIUtils showInfoMessage:@"加入成功"];
                [self headerRereshing];
                [_join removeFromSuperview];
                _join = nil;
            }else{
                [UIUtils showInfoMessage:@"会议不存在或会议被删除"];
            }
            [self hideHud];

        } failure:^(NSError *error) {
            [UIUtils showInfoMessage:@"加入失败"];
            [self hideHud];

        }];
    }
}
#pragma mark 获取数据
-(void)getDataWithPage:(NSInteger)page isHeader:(BOOL)isHeader{
    if (page>_page1) {
        [self hideHud];
        return;
    }
    _userModel = [[Appsetting sharedInstance] getUsetInfo];
    
    NSDictionary * dict = [[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%ld",(long)page],@"start",_userModel.peopleId,@"createUser",[UIUtils getTime],@"startTime",@"",@"endTime",@"20",@"length", nil];
    
    [[NetworkRequest sharedInstance] GET:QueryMeetingSelfCreate dict:dict succeed:^(id data) {
        NSDictionary * dict = [data objectForKey:@"header"];
        if ([[dict objectForKey:@"code"] isEqualToString:@"0000"]) {
            if (isHeader) {
                [_meetingModelAry removeAllObjects];
            }
            NSArray * d = [[data objectForKey:@"body"] objectForKey:@"list"];
            for (int i = 0; i<d.count; i++) {
                MeetingModel * m = [[MeetingModel alloc] init];
                [m setMeetingInfoWithDict:d[i]];
                [_meetingModelAry addObject:m];
            }
            [self getSelfCreateMeetingList:page];
            [_collection reloadData];
        }else if ([[dict objectForKey:@"code"] isEqualToString:@"401"]){
            dispatch_async(dispatch_get_main_queue(), ^{
                [UIUtils accountWasUnderTheRoof];
            });
            [self hideHud];
            
        }else{
            [self hideHud];
        }
        
    } failure:^(NSError *error) {
        NSLog(@"error %@",error);
        [self hideHud];
        
    }];
}
-(void)getSelfCreateMeetingList:(NSInteger)page{
    // UserModel * user = [[Appsetting sharedInstance] getUsetInfo];
    
    if (page>_page2) {
        [self hideHud];
        return;
    }
    UserModel * user = [[Appsetting sharedInstance] getUsetInfo];
    
    NSDictionary * dict = [[NSDictionary alloc] initWithObjectsAndKeys:_userModel.peopleId,@"userId",[UIUtils getTime],@"startTime",@"",@"endTime",[NSString stringWithFormat:@"%ld",(long)page],@"start",[NSString stringWithFormat:@"%@",user.studentId],@"userId",@"20",@"length",nil];
    
    [[NetworkRequest sharedInstance] GET:QueryMeeting dict:dict succeed:^(id data) {
        NSArray * d = [[data objectForKey:@"body"] objectForKey:@"list"];
        for (int i = 0; i<d.count; i++) {
            MeetingModel * m = [[MeetingModel alloc] init];
            [m setMeetingInfoWithDict:d[i]];
            if (_meetingModelAry.count>0) {
                for (int i = 0; i<d.count; i++) {
                    MeetingModel * m = [[MeetingModel alloc] init];
                    [m setMeetingInfoWithDict:d[i]];
                    if (_meetingModelAry.count>0) {
                        for (int j = 0; j<_meetingModelAry.count; j++) {
                            MeetingModel * n = _meetingModelAry[j];
                            if ([[NSString stringWithFormat:@"%@",n.meetingId] isEqualToString:[NSString stringWithFormat:@"%@",m.meetingId]]) {
                                break;
                            }else if(j == (_meetingModelAry.count - 1)){
                                [_meetingModelAry addObject:m];
                            }
                        }
                    }else{
                        [_meetingModelAry addObject:m];
                    }
                    
                }
            }else{
                [_meetingModelAry addObject:m];
            }
        }
        for (int i = 0 ; i<_meetingModelAry.count; i++) {
            MeetingModel * c = _meetingModelAry[i];
            
            for (int j = i; j<_meetingModelAry.count; j++) {
                MeetingModel * c1 = _meetingModelAry[j];
                //date02比date01小
                if ([[UIUtils compareTimeStartTime:c.meetingTime withExpireTime:c1.meetingTime] isEqualToString:@"-1"]) {
                    //                    c2 = c1;
                    MeetingModel *c2 = [[MeetingModel alloc] init];
                    c2 = c;
                    [_meetingModelAry setObject:c1 atIndexedSubscript:i];
                    [_meetingModelAry setObject:c2 atIndexedSubscript:j];
                    c = _meetingModelAry[i];
                }
            }
        }
        
        [self hideHud];
        
        [_collection reloadData];
    } failure:^(NSError *error) {
        NSLog(@"失败%@",error);
        [self hideHud];
        
    }];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark AlterViewDelegate
-(void)alterViewDeleageRemove{
    [_alterView removeFromSuperview];
}
#pragma mark UICollectionViewDataSource
//定义每个Section的四边间距
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(10, 0, 10, 0);//分别为上、左、下、右
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (_meetingModelAry.count>0) {
        [_alterView removeFromSuperview];
        return _meetingModelAry.count;
    }else{
        [self.view addSubview:_alterView];
    }
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CourseCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    cell.layer.borderColor = [UIColor clearColor].CGColor;
    [cell setInfoForContentView:_meetingModelAry[indexPath.row]];
    return cell;
}
#pragma mark UICollectionViewDelegate
//初次点击走
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    TheMeetingInfoViewController * mInfo = [[TheMeetingInfoViewController alloc] init];
    self.hidesBottomBarWhenPushed = YES;
    mInfo.meetingModel = _meetingModelAry[indexPath.row];
    [self.navigationController pushViewController:mInfo animated:YES];
    self.hidesBottomBarWhenPushed=NO;
    
}
//有了初次点击再走这个
- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    TheMeetingInfoViewController * mInfo = [[TheMeetingInfoViewController alloc] init];
    self.hidesBottomBarWhenPushed = YES;
    mInfo.meetingModel = _meetingModelAry[indexPath.row];
    [self.navigationController pushViewController:mInfo animated:YES];
    self.hidesBottomBarWhenPushed=NO;
    
}
#pragma mark UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(nonnull UICollectionView *)collectionView layout:(nonnull UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    return CGSizeMake(APPLICATION_WIDTH, Collection_height);
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
