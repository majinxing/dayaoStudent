//
//  JoinMeetingViewController.m
//  WisdomHall
//
//  Created by XTU-TI on 2018/7/26.
//  Copyright © 2018年 majinxing. All rights reserved.
//

#import "JoinMeetingViewController.h"
#import "CourseCollectionViewCell.h"
#import "CollectionFlowLayout.h"
#import "DYHeader.h"
#import "TheMeetingInfoViewController.h"
#import "MeetingModel.h"
#import "MJRefresh.h"

static NSString * cellIdentifier = @"cellIdentifier";

@interface JoinMeetingViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (strong, nonatomic) IBOutlet UITextField *textFile;
@property (strong, nonatomic) IBOutlet UIButton *searchBtn;

@property (nonatomic,strong) UICollectionView * collection;
@property (nonatomic,strong) NSMutableArray * meetingModelAry;
@property (nonatomic,strong) UserModel * userModel;
@property (nonatomic,strong)UISearchBar * mySearchBar;
@property (nonatomic,copy) NSString * selectStr;
@property (nonatomic,copy) NSString * keyWord;
/** @brief 当前加载的页数 */
@property (nonatomic) int page;

@property (nonatomic,assign) int page1;

@property (nonatomic,assign) int page2;

@end

@implementation JoinMeetingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _searchBtn.layer.masksToBounds = YES;
    _searchBtn.layer.cornerRadius = 22;
    
    _meetingModelAry = [NSMutableArray arrayWithCapacity:12];
    
    _userModel = [[Appsetting sharedInstance] getUsetInfo];
    
    _page1 = 1;
    
    _page2 = 1;
    
    
    [self addCollection];
    // Do any additional setup after loading the view from its nib.
}
- (IBAction)searchBtnPressed:(id)sender {
    _keyWord = _textFile.text;
    [self headerRereshing];
    [self.view endEditing:YES];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
    
}
/**
 * 添加collection
 **/
-(void)addCollection{
    
    _collection = [[UICollectionView alloc] initWithFrame:CGRectMake(0,64+CGRectGetMaxY(_searchBtn.frame),APPLICATION_WIDTH,APPLICATION_HEIGHT-64-54) collectionViewLayout:[[CollectionFlowLayout alloc] init]];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.collection.alwaysBounceVertical = YES; //垂直方向遇到边框是否总是反弹
    
    //注册
    [_collection registerClass:[CourseCollectionViewCell class] forCellWithReuseIdentifier:cellIdentifier];
    
    _collection.delegate = self;
    _collection.dataSource = self;
    _collection.allowsMultipleSelection = YES;
    _collection.showsVerticalScrollIndicator = NO;
    _collection.showsHorizontalScrollIndicator = NO;
    //取消滑动的滚动条
    _collection.decelerationRate = UIScrollViewDecelerationRateNormal;
    _collection.backgroundColor = [UIColor clearColor];
    __weak JoinMeetingViewController * weakSelf = self;
    [self.collection addHeaderWithCallback:^{
        [weakSelf headerRereshing];
    }];
    [self.collection addFooterWithCallback:^{
        [weakSelf footerRereshing];
    }];
    
    //    [self headerRereshing];
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
            JoinMeetingViewController * strongSelf = weakSelf;
            if (aIsHeader) {
                [_meetingModelAry removeAllObjects];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [strongSelf hideHud];
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
-(void)getDataWithPage:(NSInteger)page isHeader:(BOOL)isHeader{
    if (page>_page1) {
        [self getSelfCreateMeetingList:page];
        return;
    }
    
    _userModel = [[Appsetting sharedInstance] getUsetInfo];
    
    NSDictionary * dict = [[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%ld",(long)page],@"start",_userModel.peopleId,@"createUser",[UIUtils getTime],@"startTime",@"",@"endTime",@"20",@"length",_keyWord,@"id", nil];
    
    [[NetworkRequest sharedInstance] GET:QueryMeetingSelfCreate dict:dict succeed:^(id data) {
        NSDictionary * dict = [data objectForKey:@"header"];
        
        _page1 = [[[data objectForKey:@"body"] objectForKey:@"pages"] intValue];
        
        if ([[dict objectForKey:@"code"] isEqualToString:@"0000"]) {
            if (isHeader) {
                [_meetingModelAry removeAllObjects];
            }
            NSArray * d = [[data objectForKey:@"body"] objectForKey:@"list"];
            
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
            [self getSelfCreateMeetingList:page];
            [_collection reloadData];
        }else if ([[dict objectForKey:@"code"] isEqualToString:@"401"]){
            dispatch_async(dispatch_get_main_queue(), ^{
                [UIUtils accountWasUnderTheRoof];
            });
            
        }
        
    } failure:^(NSError *error) {
        [UIUtils showInfoMessage:@"获取数据失败，请检查网络" withVC:self];
        
        [self hideHud];
        
    }];
}
-(void)getSelfCreateMeetingList:(NSInteger)page{
    if (page>_page2) {
        [_collection reloadData];
        [self hideHud];
        return;
    }
    UserModel * user = [[Appsetting sharedInstance] getUsetInfo];
    
    NSDictionary * dict = [[NSDictionary alloc] initWithObjectsAndKeys:_userModel.peopleId,@"userId",[UIUtils getTime],@"startTime",@"",@"endTime",[NSString stringWithFormat:@"%ld",(long)page],@"start",[NSString stringWithFormat:@"%@",user.studentId],@"userId",@"20",@"length",_keyWord,@"id",nil];
    
    [[NetworkRequest sharedInstance] GET:QueryMeeting dict:dict succeed:^(id data) {
        NSArray * d = [[data objectForKey:@"body"] objectForKey:@"list"];
        
        _page2 = [[[data objectForKey:@"body"] objectForKey:@"pages"] intValue];
        
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
        if (_meetingModelAry.count>0) {
            
        }else{
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"没有搜索到对应的会议" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alertView show];
        }
        [_collection reloadData];
    } failure:^(NSError *error) {
        [UIUtils showInfoMessage:@"获取数据失败，请检查网络" withVC:self];
        
        [self hideHud];
        
    }];
    //    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    // Dispose of any resources that can be recreated.
}
#pragma mark UICollectionViewDataSource
//定义每个Section的四边间距
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(15, 15, 15, 15);//分别为上、左、下、右
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (_meetingModelAry.count>0) {
        return _meetingModelAry.count;
    }
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CourseCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    
    cell.backgroundColor = [UIColor whiteColor];
    
    if (indexPath.row<_meetingModelAry.count) {
        [cell setInfoForContentView:_meetingModelAry[indexPath.row]];
    }
    return cell;
}
#pragma mark UICollectionViewDelegate
//初次点击走
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:nil preferredStyle:  UIAlertControllerStyleActionSheet];
    
    MeetingModel * meeting = _meetingModelAry[indexPath.row];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"加入会议" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSDictionary * dict = [[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%@",meeting.meetingId],@"id",_userModel.peopleId,@"userId", nil];
        [self showHudInView:self.view hint:NSLocalizedString(@"正在加载数据", @"Load data...")];
        
        [[NetworkRequest sharedInstance] POST:JoinMeeting dict:dict succeed:^(id data) {
            NSString * str = [[data objectForKey:@"header"] objectForKey:@"code"];
            NSString * message = [[data objectForKey:@"header"] objectForKey:@"message"];
            
            if([[NSString stringWithFormat:@"%@",str] isEqualToString:@"0000"]){
                [UIUtils showInfoMessage:@"加入成功" withVC:self];
                [self headerRereshing];
                
            }else{
                [UIUtils showInfoMessage:message withVC:self];
            }
            [self hideHud];
            
        } failure:^(NSError *error) {
            [UIUtils showInfoMessage:@"加入失败，请检查网络" withVC:self];
            [self hideHud];
            
        }];
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        //点击按钮的响应事件；
    }]];
    
    //弹出提示框；
    [self presentViewController:alert animated:true completion:nil];
    
}
//有了初次点击再走这个
- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:nil preferredStyle:  UIAlertControllerStyleActionSheet];

    
    MeetingModel * meeting = _meetingModelAry[indexPath.row];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"加入会议" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSDictionary * dict = [[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%@",meeting.meetingId],@"id",_userModel.peopleId,@"userId", nil];
        [self showHudInView:self.view hint:NSLocalizedString(@"正在加载数据", @"Load data...")];
        
        [[NetworkRequest sharedInstance] POST:JoinMeeting dict:dict succeed:^(id data) {
            NSString * str = [[data objectForKey:@"header"] objectForKey:@"code"];
            NSString * message = [[data objectForKey:@"header"] objectForKey:@"message"];
            
            if([[NSString stringWithFormat:@"%@",str] isEqualToString:@"0000"]){
                [UIUtils showInfoMessage:@"加入成功" withVC:self];
                [self headerRereshing];
                
            }else{
                [UIUtils showInfoMessage:message withVC:self];
            }
            [self hideHud];
            
        } failure:^(NSError *error) {
            [UIUtils showInfoMessage:@"加入失败，请检查网络" withVC:self];
            [self hideHud];
            
        }];
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        //点击按钮的响应事件；
    }]];
    
    //弹出提示框；
    [self presentViewController:alert animated:true completion:nil];
    
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
