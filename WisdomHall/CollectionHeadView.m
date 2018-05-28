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

static dispatch_once_t onceToken;

@interface CollectionHeadView()<UIScrollViewDelegate>
@property (nonatomic,strong)NSTimer * rotateTimer;
@property (nonatomic,strong)UIPageControl * myPageControl;
@property (nonatomic,strong)NSMutableArray * ary;
@property (nonatomic,assign) int temp;
@property (nonatomic,strong) UIScrollView * s;
@end
@implementation CollectionHeadView
- (instancetype) init{
    self=[super init];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        _ary = [NSMutableArray arrayWithCapacity:1];
        _temp = 0;
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
-(void)getData{
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
-(void)addScrollView{
    if (_ary.count>0) {
        [_rotateTimer  invalidate];
        _rotateTimer = nil;
        [_s removeFromSuperview];
        _temp = (int)_ary.count;
    }else{
        [_rotateTimer  invalidate];
        _rotateTimer = nil;
        [_s removeFromSuperview];
        return;
    }
    self.backgroundColor = [UIColor clearColor];
    
    _s = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0,ScrollViewW, 70)];
    
    
    _s.backgroundColor = [UIColor clearColor];
    
    _s.contentSize = CGSizeMake(ScrollViewW*_temp, 70);
    _s.scrollEnabled = YES;//是否可以滚动
    _s.pagingEnabled = YES;//是否整页滚动
    _s.showsVerticalScrollIndicator = NO;//水平方向的滚动条
    _s.showsHorizontalScrollIndicator = NO;
    _s.bounces = NO;
    [self addSubview:_s];

    for (int i = 0; i<_temp; i++) {
        UIView * vBlack = [[UIView alloc] initWithFrame:CGRectMake((APPLICATION_WIDTH-20)*i, 0, APPLICATION_WIDTH-20, 70)];
        
        vBlack.backgroundColor = [UIColor blackColor];
        
        vBlack.alpha = 0.25;
        
        [_s addSubview:vBlack];
        
        UIView * v = [self scrollViewWithInt:i];
        
        [_s addSubview:v];
    }
    UIView * vBlack = [[UIView alloc] initWithFrame:CGRectMake((APPLICATION_WIDTH-20)*_temp, 0, APPLICATION_WIDTH-20, 70)];
    
    vBlack.backgroundColor = [UIColor blackColor];
    
    vBlack.alpha = 0.25;
    
    [_s addSubview:vBlack];
    
    UIView * v = [[UIView alloc] initWithFrame:CGRectMake((APPLICATION_WIDTH-20)*_temp, 0, APPLICATION_WIDTH-20, 70)];
    
    v.backgroundColor = [UIColor clearColor];
    
    _s.tag = 1000;
    
    UIImageView * i = [[UIImageView alloc] initWithFrame:CGRectMake(10, 20, 30, 30)];
    
    i.image = [UIImage imageNamed:@"通知会议"];
    
    UILabel * textLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(i.frame)+10, 10, APPLICATION_WIDTH-20-30-30-10-10, 50)];
    
    textLabel.numberOfLines = 0;
    
    textLabel.font = [UIFont systemFontOfSize:14];
    
    NoticeModel * notice = _ary[0];
    
    textLabel.text = [NSString stringWithFormat:@"会议通知:%@",notice.noticeContent];
    [v addSubview:textLabel];
    
    textLabel.textColor = [UIColor whiteColor];
    
    UIImageView * nextImage = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(textLabel.frame), 25, 20, 20)];
    nextImage.image = [UIImage imageNamed:@"通知右_80"];
    
    UIButton * noticeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    noticeBtn.frame = CGRectMake(0, 0, APPLICATION_WIDTH-20, 50);
    
    noticeBtn.tag = 100;
    
    [noticeBtn addTarget:self action:@selector(noticeBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    [v addSubview:noticeBtn];
    
    [v addSubview:nextImage];
    
    [v addSubview:i];
    
    [_s addSubview:v];
    
    _myPageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, 50, CGRectGetWidth(self.frame), 20)];
    _myPageControl.numberOfPages = _temp;
    _myPageControl.currentPage = 0;
//    [self addSubview:_myPageControl];
    
    //启动定时器
    _rotateTimer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(changeView) userInfo:nil repeats:YES];
    
    _s.delegate = self;
}
-(UIView *)scrollViewWithInt:(int)i{
    UIView * v = [[UIView alloc] initWithFrame:CGRectMake((APPLICATION_WIDTH-20)*i, 0, APPLICATION_WIDTH-20, 70)];
    v.backgroundColor = [UIColor clearColor];
    UIImageView * ii = [[UIImageView alloc] initWithFrame:CGRectMake(10, 20, 30, 30)];
    ii.image = [UIImage imageNamed:@"通知会议"];
    [v addSubview:ii];
    
    UILabel * textLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(ii.frame)+10, 10, APPLICATION_WIDTH-20-30-30-10-10, 50)];
    textLabel.numberOfLines = 0;
    textLabel.font = [UIFont systemFontOfSize:14];
    
    NoticeModel * notice = _ary[i];
    textLabel.text = [NSString stringWithFormat:@"会议通知:%@",notice.noticeContent];
    [v addSubview:textLabel];
    textLabel.textColor = [UIColor whiteColor];
    
    UIImageView * nextImage = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(textLabel.frame), 25, 20, 20)];
    nextImage.image = [UIImage imageNamed:@"通知右_80"];
    [v addSubview:nextImage];
    
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
-(void)changeView{
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
    CGPoint resultPoint = CGPointMake(offset_X, 0);
    //切换视图时带动画效果
    //最右边的多余视图实际上就是第一个视图，现在是要从第一个视图向第二个视图偏移，所以偏移量为一个屏幕宽度
    if (offset_X >CGRectGetWidth(self.frame)*_temp) {
        self.myPageControl.currentPage = 1;
        [scrollView setContentOffset:CGPointMake(CGRectGetWidth(self.frame), 0) animated:YES];
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
    float offset_X = scrollView.contentOffset.x;
    
    if (offset_X == CGRectGetWidth(self.frame)*2) {
        self.myPageControl.currentPage = 0;
    }else{
        self.myPageControl.currentPage = offset_X/CGRectGetWidth(self.frame);
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

