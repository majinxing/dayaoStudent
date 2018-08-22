//
//  HomePageViewController.m
//  WisdomHall
//
//  Created by XTU-TI on 2018/7/3.
//  Copyright © 2018年 majinxing. All rights reserved.
//

#import "HomePageViewController.h"
#import "CourseDetailsViewController.h"

#import "DYHeader.h"

#import "BananerView.h"//轮播图
#import "NoticeView.h"//通知页
#import "HomeButtonView.h"//按钮页
#import "NewMeetingView.h"//最新会议

#import "NoticeModel.h"

#import "AllTheMeetingViewController.h"
#import "NoticeViewController.h"

#import "SignInViewController.h"

#import "TheMeetingInfoViewController.h"

#import "CollectionHeadView.h"

#import "NoticeDetailsViewController.h"

#import "JPUSHService.h"

#import "CourseListALLViewController.h"

#import "MoreImportViewController.h"

#import "ClassModel.h"

@interface HomePageViewController ()<HomeButtonViewDelegate,NewMeetingViewDelegate,CollectionHeadViewDelegate,UIScrollViewDelegate>
@property (nonatomic,strong)UIScrollView * bottomScrollView;
@property (nonatomic,strong)BananerView * bannerView;
@property (nonatomic,strong)NoticeView * noticeView;
@property (nonatomic,strong)HomeButtonView * homeButtonView;
@property (nonatomic,strong)NewMeetingView * meetingView;
@property (nonatomic,strong)UserModel * userModel;

@property (nonatomic,strong)CollectionHeadView *collectionHeadView;

@end

@implementation HomePageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.title = @"律动";
    
    self.navigationController.title = @"首页";
    
    [self addScrollView];
    
    _userModel = [[Appsetting sharedInstance] getUsetInfo];
    
    [self setAlias];
    
    [UIUtils getInternetDate];

    // Do any additional setup after loading the view from its nib.
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self getClass];
    
    [_collectionHeadView getData];
    
//    [_bannerView.collectionHeadView getBananerViewData];
    
}

-(void)setAlias{
#pragma mark - 推送别名设置
    UserModel * user = [[Appsetting sharedInstance] getUsetInfo];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [JPUSHService setAlias:[NSString stringWithFormat:@"%@%@",user.school,user.studentId] completion:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {
            
        } seq:1];
        
    });
    //    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}
-(void)viewWillAppear:(BOOL)animated{
    [self getClass];
    if (_collectionHeadView) {
        [_collectionHeadView getData];
        [_bannerView.collectionHeadView getBananerViewData];
    }
}
-(void)getClass{
//    NSDictionary * dict = [[NSDictionary alloc] initWithObjectsAndKeys:@"1",@"start",_userModel.peopleId,@"studentId",[NSString stringWithFormat:@"%@ 00:00:00",[UIUtils getTime]],@"actStartTime",@"1000",@"length",_userModel.school,@"universityId",@"2",@"type",[NSString stringWithFormat:@"%d",[UIUtils getTermId]],@"termId",@"1",@"courseType",nil];
    
    NSDictionary * dict = [[NSDictionary alloc] initWithObjectsAndKeys:@"1",@"start",_userModel.peopleId,@"studentId",[NSString stringWithFormat:@"%@ 00:00:00",[UIUtils getTime]],@"actStartTime",@"1000",@"length",_userModel.school,@"universityId",@"1",@"type",[NSString stringWithFormat:@"%d",[UIUtils getTermId]],@"termId",@"1",@"courseType",nil];
    
    [[NetworkRequest sharedInstance] GET:QueryCourse dict:dict succeed:^(id data) {
        //        NSLog(@"1");
        NSString * str = [[data objectForKey:@"header"] objectForKey:@"message"];
        if ([str isEqualToString:@"成功"]) {
            NSArray * ary = [[data objectForKey:@"body"] objectForKey:@"list"];
            if (ary.count>0) {
                
                ClassModel * c = [[ClassModel alloc] init];
                
                [c setInfoWithDict:ary[0]];
                
                [_meetingView addContentClassView:c];
                
            }else{
                [self getNewMeeting];
            }
            
        }
    } failure:^(NSError *error) {
        
        
        [UIUtils showInfoMessage:@"请求失败，请检查网络" withVC:self];
    }];
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

-(void)addScrollView{
    _bottomScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64,APPLICATION_WIDTH, APPLICATION_HEIGHT-64-44)];
    _bottomScrollView.bounces  = YES;//弹簧效果
    _bottomScrollView.contentOffset = CGPointMake(0, 0);
    _bottomScrollView.delegate = self;
    [self.view addSubview:_bottomScrollView];
    
    _bannerView = [[BananerView alloc] initWithFrame:CGRectMake(0, 0, APPLICATION_WIDTH, APPLICATION_HEIGHT/4)];
    
    _bannerView.backgroundColor = [UIColor grayColor];
    
    
    [_bannerView addContentView];
    
    [_bottomScrollView addSubview:_bannerView];
    
    _noticeView = [[NoticeView alloc] init];
    
    _noticeView.frame =  CGRectMake(10, CGRectGetMaxY(_bannerView.frame), APPLICATION_WIDTH, 70);

    [_bottomScrollView addSubview:_noticeView];
    
    _collectionHeadView = [[CollectionHeadView alloc] init];
    
    _collectionHeadView.frame = CGRectMake(90,CGRectGetMaxY(_bannerView.frame)+10, ScrollViewW-90,ScrollViewH);
    _collectionHeadView.delegate = self;
    
    [_bottomScrollView addSubview:_collectionHeadView];
    
    _homeButtonView = [[HomeButtonView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_noticeView.frame), APPLICATION_WIDTH, 148)];
    _homeButtonView.backgroundColor = [UIColor whiteColor];

    [_homeButtonView addContentView];
    _homeButtonView.delegate = self;
    [_bottomScrollView addSubview:_homeButtonView];
    
    _meetingView = [[NewMeetingView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_homeButtonView.frame), APPLICATION_WIDTH, APPLICATION_HEIGHT/4)];
    _meetingView.delegate = self;
    
    [_bottomScrollView addSubview:_meetingView];
    
    _bottomScrollView.contentSize = CGSizeMake(APPLICATION_WIDTH, APPLICATION_HEIGHT*3/4+80);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)noticeBtnPressedDelegate:(NoticeModel *)notice{
    NoticeDetailsViewController * notice1 = [[NoticeDetailsViewController alloc] initWithActionBlock:^(NSString *str) {
        
    }];
    notice1.notice = notice;
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:notice1 animated:YES];
    self.hidesBottomBarWhenPushed = NO;
    
}

#pragma mark NewMeetingDelegate

-(void)intoClassBtnPressedDelegate:(ClassModel *)classModel{
    self.hidesBottomBarWhenPushed = YES;
    CourseDetailsViewController * cdetailVC = [[CourseDetailsViewController alloc] init];
    cdetailVC.c = classModel;
    [self.navigationController pushViewController:cdetailVC animated:YES];
    self.hidesBottomBarWhenPushed = NO;
    
}
-(void)intoMeetingBtnPressedDelegate:(MeetingModel *)meetingModel{
    TheMeetingInfoViewController * mInfo = [[TheMeetingInfoViewController alloc] init];
    self.hidesBottomBarWhenPushed = YES;
    mInfo.meetingModel = meetingModel;
    [self.navigationController pushViewController:mInfo animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}
#pragma mark OfficeTableViewCellDelegate
-(void)shareButtonClickedDelegate:(NSString *)str{
    if ([str isEqualToString:Meeting]) {
        self.hidesBottomBarWhenPushed = YES;
        AllTheMeetingViewController * s = [[AllTheMeetingViewController alloc] init];
        [self.navigationController pushViewController:s animated:YES];
        self.hidesBottomBarWhenPushed = NO;
    }else if ([str isEqualToString:Classroom]){
        
        CourseListALLViewController * noticeVC = [[CourseListALLViewController alloc] init];
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
-(void)moreBtnPressedDelegate:(UIButton *)btn{
    MoreImportViewController * vc = [[MoreImportViewController alloc] init];
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
    self.hidesBottomBarWhenPushed = NO;
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
