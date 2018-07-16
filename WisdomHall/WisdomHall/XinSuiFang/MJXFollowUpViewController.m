//
//  MJXFollowUpViewController.m
//  XinSuiFang
//
//  Created by majinxing on 16/8/11.
//  Copyright © 2016年 majinxing. All rights reserved.
//随访管理主控制器

#import "MJXFollowUpViewController.h"
#import "MJXNotRemindViewController.h"
#import "MJXHaveToRemindViewController.h"
#import "MJXHasBeenCompletedViewController.h"
@interface MJXFollowUpViewController ()<UIScrollViewDelegate>
@property (nonatomic,strong)UIButton *lab;
@property (nonatomic,strong)UIScrollView *tableScroll;
@property (nonatomic,strong)UIScrollView *scrollView;
@property (nonatomic,strong)UIView *lineView;//那条蓝线
@property (nonatomic,strong) UIButton *highlight;
@property (nonatomic,assign) BOOL isShowEdit;
@property (nonatomic,strong)NSMutableArray *viewControllerArray;
@end

@implementation MJXFollowUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [MJXUIUtils addNavigationWithView:self.view withTitle:@"随访管理"];
    UIView * line = [[UIView alloc] initWithFrame:CGRectMake(0,63, APPLICATION_WIDTH,1)];
    line.backgroundColor = [UIColor colorWithHexString:@"#f7f7f7"];
    [self.view addSubview:line];

    _viewControllerArray=[NSMutableArray arrayWithCapacity:3];
    MJXNotRemindViewController * notRVC = [[MJXNotRemindViewController alloc] init];
    MJXHaveToRemindViewController * hTRVC = [[MJXHaveToRemindViewController alloc] init];
    MJXHasBeenCompletedViewController * hBCVC = [[MJXHasBeenCompletedViewController alloc] init];
    [_viewControllerArray setObject:notRVC atIndexedSubscript:0];
    [_viewControllerArray setObject:hTRVC atIndexedSubscript:1];
    [_viewControllerArray setObject:hBCVC atIndexedSubscript:2];
    self.view.backgroundColor=[UIColor colorWithHexString:@"#f7f7f7"];
    [self setUpScrollView];
    [self addtableScroll];
        // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}
-(void)setUpScrollView{
    _scrollView=[[UIScrollView alloc] initWithFrame:CGRectMake(0,64, APPLICATION_WIDTH, 40)];
    _scrollView.backgroundColor=[UIColor whiteColor];
    _scrollView.contentSize = CGSizeMake(APPLICATION_WIDTH, 44);
    [self.view addSubview:_scrollView];
    _scrollView.autoresizesSubviews = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    // _scrollView.backgroundColor = [UIColor redColor];
    NSArray *title=[NSArray arrayWithObjects:@"未提醒",@"已提醒",@"已完成",nil];
    //添加点击按钮
    for (int i = 0; i<title.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        //button.backgroundColor = [UIColor greenColor];
        button.frame = CGRectMake(APPLICATION_WIDTH/3*i, 5, APPLICATION_WIDTH/3, 28);
        [button setTitle:title[i] forState:UIControlStateNormal];
        
        [button setTitleColor:[UIColor colorWithHexString:@"#999999" alpha:1.0f]
                     forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithHexString:@"#01aeff" alpha:1.0f]
                     forState:UIControlStateSelected];
        button.titleLabel.textAlignment = NSTextAlignmentCenter;
        if (i==0) {
            button.selected = YES;
        }
        //
        //文字大小
        button.titleLabel.font = [UIFont systemFontOfSize:13];
        button.tag = i+1;
        //设置点击事件
        [button addTarget:self action:@selector(titleClick:) forControlEvents:UIControlEventTouchUpInside];
        [_scrollView addSubview:button];
    }
    _scrollView.bounces = NO;
    
    //设置提示条目
    _lineView = [[UIView alloc]initWithFrame:CGRectMake(25.0/375.0*APPLICATION_WIDTH,35, 75, 1)];
    //背景颜色
    _lineView.backgroundColor = [UIColor colorWithHexString:@"#01aeff"];
    
    [_scrollView addSubview:_lineView];
}
//title按钮被点击
-(void)titleClick:(UIButton *)button{
    
    [_tableScroll setContentOffset:CGPointMake((button.tag-1)*APPLICATION_WIDTH, 0) animated:YES];
}
-(void)addtableScroll{
    //添加滑动视图
    _tableScroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_scrollView.frame), APPLICATION_WIDTH, APPLICATION_HEIGHT-CGRectGetMaxY(_scrollView.frame)-40)];
    
    _tableScroll.contentSize = CGSizeMake(APPLICATION_WIDTH*3,APPLICATION_HEIGHT-CGRectGetMaxY(_scrollView.frame)-40);
    [self.view addSubview:_scrollView];
    _tableScroll.delegate=self;
    _tableScroll.showsVerticalScrollIndicator = NO;
    //设置整页滑动
    _tableScroll.pagingEnabled=YES;
    
    [self.view addSubview:_tableScroll];
    //添加第一个视图
    if (_viewControllerArray.count) {
        UIViewController *willShowVc = self.viewControllerArray[0];
        [self addChildViewController:willShowVc];
        willShowVc.view.frame=_tableScroll.bounds;
        [_tableScroll addSubview:willShowVc.view];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark UIScrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    //    //设定滑动主视图时候滑块随主视图滑动
    _lineView.frame = CGRectMake(scrollView.contentOffset.x/APPLICATION_WIDTH*APPLICATION_WIDTH/3+25.0/375.0*APPLICATION_WIDTH, 35,75,1);
    
    //确定Scroller不为0
    if (scrollView.contentOffset.x/APPLICATION_WIDTH>=0) {
        //将其他已经select状态设置为NO
        int contentOffsetX=scrollView.contentOffset.x;
        int width=APPLICATION_WIDTH;
        //减少不必要操作 整数时候控制
        if (contentOffsetX%width==0) {
            //设置其他点击按钮不选中
            for (int i=1;i<4; i++) {
                if (i!=scrollView.contentOffset.x/APPLICATION_WIDTH+1) {
                    UIButton *button=(UIButton *)[_scrollView viewWithTag:i];
                    button.selected=NO;
                }
                
            }
            //点击按钮选中
            UIButton *button=(UIButton *)[_scrollView viewWithTag:scrollView.contentOffset.x/APPLICATION_WIDTH+1];
            button.selected=YES;
            //
            //            //为减少内存损耗使用懒加载
            //添加视图为空不作处理
            if (_viewControllerArray) {
                
                //获得contentScrollView 的长，宽 和偏移坐标X
                CGFloat width = scrollView.frame.size.width;
                CGFloat offsetX = scrollView.contentOffset.x;
                // 向contentScrollView上添加控制器的View 偏移到第几个视图
                NSInteger index = offsetX / width;
                
                // 取出要显示的控制器
                UIViewController *willShowVc = self.viewControllerArray[index];
                
                // 如果当前控制器已经显示过一次就不要再次显示出来 就直接返回;
                if (willShowVc.parentViewController) {
                    return;
                }
                
                [self addChildViewController:willShowVc];
                CGFloat height = scrollView.frame.size.height;
                willShowVc.view.frame = CGRectMake(width * index, 0, width, height);
                [_tableScroll addSubview:willShowVc.view];
                //[willShowVc didMoveToParentViewController:self];
            }
        }
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
