//
//  CollectionHeadView.m
//  WisdomHall
//
//  Created by XTU-TI on 2017/6/1.
//  Copyright © 2017年 majinxing. All rights reserved.
//

#import "CollectionHeadView.h"
#import "DYHeader.h"
#import "NoticeModel.h"
#import "MBProgressHUD.h"
#import "UIImageView+WebCache.h"

static dispatch_once_t onceToken;

@interface CollectionHeadView()<UIScrollViewDelegate>
@property (nonatomic,strong)NSTimer * rotateTimer;
@property (nonatomic,strong)UIPageControl * myPageControl;
@property (nonatomic,strong)NSMutableArray * ary;
@property (nonatomic,assign) int temp;
@property (nonatomic,strong) UIScrollView * s;
@property (nonatomic,strong)NSMutableArray * aryBananer;
@end
@implementation CollectionHeadView
- (instancetype) init{
    self=[super init];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        _ary = [NSMutableArray arrayWithCapacity:1];
        _temp = 0;
        _aryBananer = [NSMutableArray arrayWithCapacity:1];
//        [self getData];
    }
    return self;
}
+(CollectionHeadView *)sharedInstance{
    static CollectionHeadView * sharedDYTabBarViewControllerInstance = nil;
    dispatch_once(&onceToken, ^{
        sharedDYTabBarViewControllerInstance = [[self alloc] init];
    });
    return sharedDYTabBarViewControllerInstance;
}
-(void)getBananerViewData{
    UserModel * user = [[Appsetting sharedInstance] getUsetInfo];
    NSDictionary * dict = [[NSDictionary alloc] initWithObjectsAndKeys:@"26",@"function",[NSString stringWithFormat:@"%@",user.school],@"universityId",nil];
    [[NetworkRequest sharedInstance] GET:QueryAdvertising dict:dict succeed:^(id data) {
        NSArray * ary = [data objectForKey:@"body"];
        [_aryBananer removeAllObjects];
        for (int i = 0; i<ary.count; i++) {
            NSString * str = [NSString stringWithFormat:@"%@",[ary[i] objectForKey:@"id"]];
            [_aryBananer addObject: str];
        }
        [self addBananerScrollView];
    } failure:^(NSError *error) {
        
    }];
    
    
}
//获取通知数据
-(void)getData{
    //轮播
    NSDictionary * dict = [[NSDictionary alloc] initWithObjectsAndKeys:@"1",@"start",@"5",@"length", nil];
    
    [[NetworkRequest sharedInstance] GET:QueryNotice dict:dict succeed:^(id data) {
        
        NSString * str = [[data objectForKey:@"header"] objectForKey:@"code"];
        if ([str isEqualToString:@"0000"]) {
            NSArray * ary = [[data objectForKey:@"body"] objectForKey:@"list"];
            [_ary removeAllObjects];
            for (int i = 0; i<ary.count; i++) {
                NoticeModel * notice = [[NoticeModel alloc] init];
                notice.noticeTime = [UIUtils timeWithTimeIntervalString:[ary[i] objectForKey:@"time"]];
                notice.noticeContent = [ary[i] objectForKey:@"inform"];
                notice.noticeTitle = [ary[i] objectForKey:@"title"];
                notice.revert = [ary[i] objectForKey:@"revert"];
                notice.noticeId = [ary[i] objectForKey:@"id"];
                notice.messageStatus = [ary[i] objectForKey:@"status"];
                [_ary addObject:notice];
            }
        }else if([str isEqualToString:@"401"]){
            dispatch_async(dispatch_get_main_queue(), ^{
                onceToken = 0;
                [UIUtils accountWasUnderTheRoof];
            });
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self addScrollView];
        });
        
    } failure:^(NSError *error) {

    }];
}
-(void)onceSetNil{
    onceToken = 0;
}
-(void)addBananerScrollView{
    if (_aryBananer.count>0) {
        [_rotateTimer  invalidate];
        _rotateTimer = nil;
        [_s removeFromSuperview];
        _s = nil;
        _temp = (int)_aryBananer.count;
    }else{
        [_rotateTimer  invalidate];
        _rotateTimer = nil;
        [_s removeFromSuperview];
        return;
    }
    self.backgroundColor = [UIColor clearColor];
    if (!_s) {
        _s = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0,APPLICATION_WIDTH, APPLICATION_HEIGHT/4)];

    }
    
    _s.backgroundColor = [UIColor clearColor];
    
    _s.contentSize = CGSizeMake(APPLICATION_WIDTH*_temp, APPLICATION_HEIGHT/4);
    _s.scrollEnabled = YES;//是否可以滚动
    _s.pagingEnabled = YES;//是否整页滚动
    _s.showsVerticalScrollIndicator = NO;//水平方向的滚动条
    _s.showsHorizontalScrollIndicator = NO;
    _s.bounces = NO;
    _s.tag = 1000;
    [self addSubview:_s];
    
    for (int i = 0; i<_temp; i++) {
        
        UIImageView * v = [self bananerView:_aryBananer[i] withInt:i];
        
        [_s addSubview:v];
        
    }
    UserModel * user = [[Appsetting sharedInstance] getUsetInfo];

    UIImageView * imageview = [[UIImageView alloc] initWithFrame:CGRectMake(APPLICATION_WIDTH*_temp, 0, APPLICATION_WIDTH, APPLICATION_HEIGHT/4)];
    
//    if ([UIUtils isBlankString:[NSString stringWithFormat:@"%@",_aryBananer[0]]]) {
//        _aryBananer[0] = @"A";
//    }
    
    [imageview sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@?resourceId=%@",user.host,FileDownload,_aryBananer[0]]] placeholderImage:[UIImage imageNamed:@"banner"]];
    
    [_s addSubview:imageview];
    
    //    [self addSubview:_myPageControl];
    
    //启动定时器
    _rotateTimer = [NSTimer scheduledTimerWithTimeInterval:4 target:self selector:@selector(changeView1) userInfo:nil repeats:YES];
    
    _s.delegate = self;
}
//通知的竖向滚动
-(void)addScrollView{
    if (_ary.count>0) {
        [_rotateTimer  invalidate];
        _rotateTimer = nil;
        [_s removeFromSuperview];
        _s = nil;
        _temp = (int)_ary.count;
    }else{
        [_rotateTimer  invalidate];
        _rotateTimer = nil;
        [_s removeFromSuperview];
        return;
    }
    self.backgroundColor = [UIColor clearColor];
    if (!_s) {
        _s = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0,ScrollViewW, 70)];

    }
    _s.backgroundColor = [UIColor clearColor];
    
    _s.contentSize = CGSizeMake(ScrollViewW, 70*_temp);
    _s.scrollEnabled = YES;//是否可以滚动
    _s.pagingEnabled = YES;//是否整页滚动
    _s.showsVerticalScrollIndicator = NO;//水平方向的滚动条
    _s.showsHorizontalScrollIndicator = NO;
    _s.bounces = NO;
    
    [self addSubview:_s];

    for (int i = 0; i<_temp; i++) {
       
        UIView * v = [self scrollViewWithInt:i];
        
        [_s addSubview:v];
        
    }
    
    
    UIView * v = [[UIView alloc] initWithFrame:CGRectMake(0, 70*_temp, APPLICATION_WIDTH-20, 70)];
    
    v.backgroundColor = [UIColor clearColor];
    
    _s.tag = 1000;
    
    for (int i = 0; i<3; i++) {
        
        UIImageView * ii = [[UIImageView alloc] initWithFrame:CGRectMake(10+13*i, 10, 10, 10)];
        ii.image = [UIImage imageNamed:@"星 copy 2"];
        [v addSubview:ii];
    }
    UILabel * newNotic = [[UILabel alloc] initWithFrame:CGRectMake(0, 25, 56, 20)];
    newNotic.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    newNotic.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1/1.0];
    newNotic.text = @"最新通知";
    [v addSubview:newNotic];
    
    UIView * line = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(newNotic.frame)+9, 10, 1, 30)];
    line.backgroundColor = [UIColor colorWithHexString:@"#f1f1f1"];
    [v addSubview:line];
    
    UILabel * textLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 0, APPLICATION_WIDTH-80-20, 50)];
    
    textLabel.numberOfLines = 0;
    
    textLabel.font = [UIFont systemFontOfSize:12];
    
    textLabel.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1/1.0];
    
    NoticeModel * notice = _ary[0];
    
    textLabel.text = [NSString stringWithFormat:@"通知:%@",notice.noticeContent];
    
    [v addSubview:textLabel];
    
    textLabel.textColor = [UIColor blackColor];
    
//    UIImageView * nextImage = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(textLabel.frame), 25, 20, 20)];
//    nextImage.image = [UIImage imageNamed:@"通知右_80"];
    
    UIButton * noticeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    noticeBtn.frame = CGRectMake(0, 0, APPLICATION_WIDTH-20, 50);
    
    noticeBtn.tag = 100;
    
    [noticeBtn addTarget:self action:@selector(noticeBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    [v addSubview:noticeBtn];
    
//    [v addSubview:nextImage];
    
//    [v addSubview:i];
    
    [_s addSubview:v];
    
    _myPageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, 50, CGRectGetWidth(self.frame), 20)];
    _myPageControl.numberOfPages = _temp;
    _myPageControl.currentPage = 0;
//    [self addSubview:_myPageControl];
    
    //启动定时器
    _rotateTimer = [NSTimer scheduledTimerWithTimeInterval:4 target:self selector:@selector(changeView) userInfo:nil repeats:YES];
    
    _s.delegate = self;
}
-(UIImageView *)bananerView:(NSString *)url withInt:(int)n{
    
    UserModel * user = [[Appsetting sharedInstance] getUsetInfo];
    
    UIImageView * imageview = [[UIImageView alloc] initWithFrame:CGRectMake(APPLICATION_WIDTH*n, 0, APPLICATION_WIDTH, APPLICATION_HEIGHT/4)];
    
    [imageview sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@?resourceId=%@",user.host,FileDownload,url]] placeholderImage:[UIImage imageNamed:@"banner"]];
    
    return imageview;
    
}
-(UIView *)scrollViewWithInt:(int)i{
    UIView * v = [[UIView alloc] initWithFrame:CGRectMake(0, 70*i, APPLICATION_WIDTH-20, 70)];
    v.backgroundColor = [UIColor clearColor];
    
    for (int i = 0; i<3; i++) {
        
        UIImageView * ii = [[UIImageView alloc] initWithFrame:CGRectMake(10+13*i, 10, 10, 10)];
        ii.image = [UIImage imageNamed:@"星 copy 2"];
        [v addSubview:ii];
    }
    UILabel * newNotic = [[UILabel alloc] initWithFrame:CGRectMake(0, 25, 56, 20)];
    newNotic.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    newNotic.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1/1.0];
    newNotic.text = @"最新通知";
    [v addSubview:newNotic];
    
    UIView * line = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(newNotic.frame)+9, 10, 1, 30)];
    line.backgroundColor = [UIColor colorWithHexString:@"#f1f1f1"];
    [v addSubview:line];
    
    UILabel * textLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 0, APPLICATION_WIDTH-80-20, 50)];
    textLabel.numberOfLines = 0;
    textLabel.font = [UIFont systemFontOfSize:12];
    textLabel.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1/1.0];
    NoticeModel * notice = _ary[i];
    textLabel.text = [NSString stringWithFormat:@"通知:%@",notice.noticeContent];
    [v addSubview:textLabel];
    textLabel.textColor = [UIColor blackColor];
//
//    UIImageView * nextImage = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(textLabel.frame), 25, 20, 20)];
//    nextImage.image = [UIImage imageNamed:@"通知右_80"];
//    [v addSubview:nextImage];
    
    UIButton * noticeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    noticeBtn.frame = CGRectMake(0, 0, APPLICATION_WIDTH-20, 50);
    noticeBtn.tag = 100+i;
    [noticeBtn addTarget:self action:@selector(noticeBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [v addSubview:noticeBtn];
    return v;
}
-(void)noticeBtnPressed:(UIButton *)btn{
    if (self.delegate&&[self.delegate respondsToSelector:@selector(noticeBtnPressedDelegate:)]) {
        NoticeModel * notice = _ary[btn.tag-100];
        [self.delegate noticeBtnPressedDelegate:notice];
    }
}
-(void)changeView1{
    //得到scrollView
    UIScrollView *scrollView = [self viewWithTag:1000];
    //通过改变contentOffset来切换滚动视图的子界面
    float offset_X = scrollView.contentOffset.x;
    //每次切换一个屏幕
    offset_X += CGRectGetWidth(self.frame);
    
    //说明要从最右边的多余视图开始滚动了，最右边的多余视图实际上就是第一个视图。所以偏移量需要更改为第一个视图的偏移量。
    if (offset_X > CGRectGetWidth(self.frame)*_temp) {
        scrollView.contentOffset = CGPointMake(0, 0);
        
    }
    //说明正在显示的就是最右边的多余视图，最右边的多余视图实际上就是第一个视图。所以pageControl的小白点需要在第一个视图的位置。
    if (offset_X == CGRectGetWidth(self.frame)*_temp) {
        self.myPageControl.currentPage = 0;
    }else{
        self.myPageControl.currentPage = offset_X/CGRectGetWidth(self.frame);
    }
    
    //得到最终的偏移量
    CGPoint resultPoint = CGPointMake(offset_X,0);
    //切换视图时带动画效果
    //最右边的多余视图实际上就是第一个视图，现在是要从第一个视图向第二个视图偏移，所以偏移量为一个屏幕宽度
    if (offset_X >CGRectGetWidth(self.frame)*_temp) {
        self.myPageControl.currentPage = 1;
        [scrollView setContentOffset:CGPointMake( CGRectGetWidth(self.frame),0) animated:YES];
    }else{
        [scrollView setContentOffset:resultPoint animated:YES];
    }
}
-(void)changeView{
    //得到scrollView
    UIScrollView *scrollView = [self viewWithTag:1000];
    //通过改变contentOffset来切换滚动视图的子界面
    float offset_Y = scrollView.contentOffset.y;
    //每次切换一个屏幕
    offset_Y += 70;//CGRectGetWidth(self.frame);
    
    //说明要从最右边的多余视图开始滚动了，最右边的多余视图实际上就是第一个视图。所以偏移量需要更改为第一个视图的偏移量。
    if (offset_Y > CGRectGetHeight(self.frame)*_temp) {
        scrollView.contentOffset = CGPointMake(0, 0);
        
    }
    //说明正在显示的就是最右边的多余视图，最右边的多余视图实际上就是第一个视图。所以pageControl的小白点需要在第一个视图的位置。
    if (offset_Y == CGRectGetHeight(self.frame)*_temp) {
        self.myPageControl.currentPage = 0;
    }else{
        self.myPageControl.currentPage = offset_Y/CGRectGetHeight(self.frame);
    }
    
    //得到最终的偏移量
    CGPoint resultPoint = CGPointMake(0, offset_Y);
    //切换视图时带动画效果
    //最右边的多余视图实际上就是第一个视图，现在是要从第一个视图向第二个视图偏移，所以偏移量为一个屏幕宽度
    if (offset_Y >CGRectGetHeight(self.frame)*_temp) {
        self.myPageControl.currentPage = 1;
        [scrollView setContentOffset:CGPointMake(0, CGRectGetHeight(self.frame)) animated:YES];
    }else{
        [scrollView setContentOffset:resultPoint animated:YES];
    }
}

#pragma mark UIScrollerView
//开始拖拽的代理方法，在此方法中暂停定时器。
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    //    NSLog(@"正在拖拽视图，所以需要将自动播放暂停掉");
    //setFireDate：设置定时器在什么时间启动
    //[NSDate distantFuture]:将来的某一时刻
    [self.rotateTimer setFireDate:[NSDate distantFuture]];
}

//视图静止时（没有人在拖拽），开启定时器，让自动轮播
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    //视图静止之后，过1.5秒在开启定时器
    //[NSDate dateWithTimeInterval:1.5 sinceDate:[NSDate date]]  返回值为从现在时刻开始 再过1.5秒的时刻。
    //    NSLog(@"开启定时器");
    [self.rotateTimer setFireDate:[NSDate dateWithTimeInterval:1.5 sinceDate:[NSDate date]]];
    
    //拖拽的时候改变白点的位置
    float offset_Y = scrollView.contentOffset.y;
    
    if (offset_Y == CGRectGetHeight(self.frame)*2) {
        self.myPageControl.currentPage = 0;
    }else{
        self.myPageControl.currentPage = offset_Y/CGRectGetHeight(self.frame);
    }
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end

