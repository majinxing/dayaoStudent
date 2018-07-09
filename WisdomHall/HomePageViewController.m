//
//  HomePageViewController.m
//  WisdomHall
//
//  Created by XTU-TI on 2018/7/3.
//  Copyright © 2018年 majinxing. All rights reserved.
//

#import "HomePageViewController.h"
#import "DYHeader.h"

#import "BananerView.h"//轮播图
#import "NoticeView.h"//通知页
#import "HomeButtonView.h"//按钮页
#import "NewMeetingView.h"//最新会议

#import "NoticeModel.h"

#import "AllTheMeetingViewController.h"
#import "NoticeViewController.h"

#import "SignInViewController.h"

@interface HomePageViewController ()<HomeButtonViewDelegate>
@property (nonatomic,strong)UIScrollView * bottomScrollView;
@property (nonatomic,strong)BananerView * bannerView;
@property (nonatomic,strong)NoticeView * noticeView;
@property (nonatomic,strong)HomeButtonView * homeButtonView;
@property (nonatomic,strong)NewMeetingView * meetingView;
@property (nonatomic,strong)UserModel * userModel;
@end

@implementation HomePageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.title = @"律动";
    
    [self addScrollView];
    
    _userModel = [[Appsetting sharedInstance] getUsetInfo];
    // Do any additional setup after loading the view from its nib.
}
-(void)viewWillAppear:(BOOL)animated{
    [self getNewMeeting];
}
-(void)getNewMeeting{
    _userModel = [[Appsetting sharedInstance] getUsetInfo];
    
     NSDictionary * dict = [[NSDictionary alloc] initWithObjectsAndKeys:_userModel.peopleId,@"userId",[UIUtils getTime],@"startTime",@"",@"endTime",[NSString stringWithFormat:@"1"],@"start",[NSString stringWithFormat:@"%@",_userModel.studentId],@"userId",@"20",@"length",nil];
    
    [[NetworkRequest sharedInstance] GET:QueryMeeting dict:dict succeed:^(id data) {
        
        NSDictionary * dict = [data objectForKey:@"header"];
        
        if ([[dict objectForKey:@"code"] isEqualToString:@"0000"]) {
        
            NSArray * d = [[data objectForKey:@"body"] objectForKey:@"list"];
            for (int i = 0; i<d.count; i++) {
                MeetingModel * m = [[MeetingModel alloc] init];
                [m setMeetingInfoWithDict:d[i]];
                [_meetingView addContentView:m];
                break;
            }
            
        }else if ([[dict objectForKey:@"code"] isEqualToString:@"401"]){
            dispatch_async(dispatch_get_main_queue(), ^{
                [UIUtils accountWasUnderTheRoof];
            });
        }else{
            
        }
    } failure:^(NSError *error) {
       
    }];
}
-(void)getNotice{
    //轮播
    NSDictionary * dict = [[NSDictionary alloc] initWithObjectsAndKeys:@"1",@"start",@"5",@"length", nil];
    
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
                [_noticeView addContentView:notice];
                break;
            }
        }else if([str isEqualToString:@"401"]){
           
        }
        
    } failure:^(NSError *error) {
        
    }];
}
-(void)addScrollView{
    _bottomScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64,APPLICATION_WIDTH, APPLICATION_HEIGHT-64-44)];
    _bottomScrollView.bounces  = YES;//弹簧效果
    _bottomScrollView.contentOffset = CGPointMake(0, 0);
    
    [self.view addSubview:_bottomScrollView];
    
    _bannerView = [[BananerView alloc] initWithFrame:CGRectMake(0, 0, APPLICATION_WIDTH, APPLICATION_HEIGHT/4)];
    _bannerView.backgroundColor = [UIColor grayColor];
    
    [_bottomScrollView addSubview:_bannerView];
    
    _noticeView = [[NoticeView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_bannerView.frame), APPLICATION_WIDTH, 56)];

    [_bottomScrollView addSubview:_noticeView];
    
    _homeButtonView = [[HomeButtonView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_noticeView.frame), APPLICATION_WIDTH, 148)];
    _homeButtonView.backgroundColor = [UIColor whiteColor];

    [_homeButtonView addContentView];
    _homeButtonView.delegate = self;
    [_bottomScrollView addSubview:_homeButtonView];
    
    _meetingView = [[NewMeetingView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_homeButtonView.frame), APPLICATION_WIDTH, APPLICATION_HEIGHT/4)];
    
    [_bottomScrollView addSubview:_meetingView];
    
    _bottomScrollView.contentSize = CGSizeMake(APPLICATION_WIDTH, APPLICATION_HEIGHT*3/4+80);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark OfficeTableViewCellDelegate
-(void)shareButtonClickedDelegate:(NSString *)str{
    if ([str isEqualToString:Meeting]) {
        self.hidesBottomBarWhenPushed = YES;
        AllTheMeetingViewController * s = [[AllTheMeetingViewController alloc] init];
        [self.navigationController pushViewController:s animated:YES];
        self.hidesBottomBarWhenPushed = NO;
    }else if ([str isEqualToString:Announcement]){
        SignInViewController * noticeVC = [[SignInViewController alloc] init];
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:noticeVC animated:YES];
        self.hidesBottomBarWhenPushed = NO;
    }else if ([str isEqualToString:Group]){
//        GroupListViewController * g = [[GroupListViewController alloc] init];
//        self.hidesBottomBarWhenPushed = YES;
//        [self.navigationController pushViewController:g animated:YES];
//        self.hidesBottomBarWhenPushed = NO;
    }else if ([str isEqualToString:Statistical]){
//        StatisticalSelfUIViewController * vc = [[StatisticalSelfUIViewController alloc] init];
//        self.hidesBottomBarWhenPushed = YES;
//        [self.navigationController pushViewController:vc animated:YES];
//        self.hidesBottomBarWhenPushed = NO;
    }else{
        [UIUtils showInfoMessage:@"正在加紧步伐开发中，敬请期待" withVC:self];
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
