//
//  MJXMyPatientsViewController.m
//  XinSuiFang
//
//  Created by majinxing on 16/8/11.
//  Copyright © 2016年 majinxing. All rights reserved.
//

#import "MJXMyPatientsViewController.h"
#import "MJXUserLoginViewController.h"
#import "MJXRootViewController.h"
#import "MJXAllPatientsViewController.h"
#import "MJXPatientGroupsViewController.h"
#import "MJXAddPatientsViewController.h"
#import "UIImageView+WebCache.h"
#import "MJXQrCodeViewController.h"

@interface MJXMyPatientsViewController ()<UIScrollViewDelegate>
@property (nonatomic,strong) UIButton *lab;
@property (nonatomic,strong) UIScrollView *tableScroll;
@property (nonatomic,strong) UIScrollView *scrollView;
@property (nonatomic,strong) UIView *lineView;//那条蓝线
@property (nonatomic,strong) UIButton *highlight;
@property (nonatomic,assign) BOOL isShowEdit;
@property (nonatomic,strong) NSMutableArray *viewControllerArray;
@property (nonatomic,strong) UIButton * bView;
@property (nonatomic,strong) UIButton * erView;
@end

@implementation MJXMyPatientsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIView * line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, APPLICATION_WIDTH, 64)];
    line.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:line];
    
    
    _viewControllerArray=[NSMutableArray arrayWithCapacity:2];
    MJXAllPatientsViewController *allPatientsVC=[[MJXAllPatientsViewController alloc] init];
    MJXPatientGroupsViewController *patientsGroupsVC=[[MJXPatientGroupsViewController alloc] init];
    
    [_viewControllerArray setObject:allPatientsVC atIndexedSubscript:0];
    [_viewControllerArray setObject:patientsGroupsVC atIndexedSubscript:1];
    // self.view.backgroundColor=[UIColor colorWithHexString:@"#01aeff"];
    [self setUpScrollView];
    [self addtableScroll];
    [self addPatientsButton];
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated{
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}
-(void)addPatientsButton{
    
    UIImageView *btn=[[UIImageView alloc] initWithFrame:CGRectMake(APPLICATION_WIDTH-40, 35, 20, 20)];
    btn.image=[UIImage imageNamed:@"addP"];
    [self.view addSubview:btn];
    UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
    button.frame=CGRectMake(APPLICATION_WIDTH-60,22, 60, 44);
    [button addTarget:self action:@selector(addPatientsButtonVC) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}
-(void)addPatientsButtonVC{
    
    _bView = [UIButton buttonWithType:UIButtonTypeCustom];
    _bView.frame = CGRectMake(0, 0, APPLICATION_WIDTH, APPLICATION_HEIGHT);
    _bView.backgroundColor = [UIColor clearColor];
    
    [_bView addTarget:self action:@selector(outBView) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_bView];

    UIButton * b = [UIButton buttonWithType:UIButtonTypeCustom];
    b.frame = CGRectMake(0, 0, APPLICATION_WIDTH, APPLICATION_HEIGHT);
    b.backgroundColor = [UIColor blackColor];
    b.alpha = 0.4;
    [b addTarget:self action:@selector(outBView) forControlEvents:UIControlEventTouchUpInside];
    [_bView addSubview:b];
    
    UIView * blackView = [[UIView alloc] initWithFrame:CGRectMake(APPLICATION_WIDTH - 190, 70, 185, 130)];
    blackView.backgroundColor = [UIColor whiteColor];
    [_bView addSubview:blackView];
    NSArray * ary = [NSArray arrayWithObjects:@"手动添加患者",@"邀请患者扫码", nil];
    NSArray * imageName = [NSArray arrayWithObjects:@"ewm",@"sdtj", nil];
    for (int i = 0; i<2; i++) {
        UIImageView * image = [[UIImageView alloc] initWithFrame:CGRectMake(15, 20+i*60, 36, 36)];
        image.backgroundColor = [UIColor whiteColor];
        image.image = [UIImage imageNamed:imageName[i]];
        [blackView addSubview:image];
        
        UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(image.frame)+10, 20+i*60, 170, 40)];
        label.textColor = [UIColor colorWithHexString:@"#666666"];
        label.backgroundColor = [UIColor clearColor];
        label.font = [UIFont systemFontOfSize:13];
        label.text = ary[i];
        [blackView addSubview:label];
        UIButton * btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 20+i*60, 185, 40)];
        [btn addTarget:self action:@selector(addPatientsOrInvitation:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = i+1;
        [blackView addSubview:btn];
    }
    
    
}
-(void)addPatientsOrInvitation:(UIButton *)btn{
    NSLog(@"%ld",btn.tag);
    if (btn.tag == 1) {
        MJXAddPatientsViewController *addPatientVC=[[MJXAddPatientsViewController alloc] init];
        addPatientVC.hidesBottomBarWhenPushed = YES;
        addPatientVC.titleStr = @"添加患者";
        [self.navigationController pushViewController:addPatientVC animated:YES];
    }else if (btn.tag == 2){
        MJXQrCodeViewController * vc = [[MJXQrCodeViewController alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
    [self outBView];
}
-(void)outBView{
    [_bView removeFromSuperview];
}
-(void)setUpScrollView{
    _scrollView=[[UIScrollView alloc] initWithFrame:CGRectMake(0,20, APPLICATION_WIDTH, 44)];
    _scrollView.backgroundColor=[UIColor whiteColor];
    _scrollView.contentSize = CGSizeMake(APPLICATION_WIDTH, 44);
    [self.view addSubview:_scrollView];
    _scrollView.autoresizesSubviews = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    // _scrollView.backgroundColor = [UIColor redColor];
    NSArray *title=[NSArray arrayWithObjects:@"我的患者",@"患者分组",nil];
    //添加点击按钮
    for (int i = 0; i<2; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        //button.backgroundColor = [UIColor greenColor];
        button.frame = CGRectMake(APPLICATION_WIDTH/2+(i*2-1)*36+(i-1)*80, 10.0, 80, 30);
        [button setTitle:title[i] forState:UIControlStateNormal];
        button.titleLabel.textAlignment = NSTextAlignmentCenter;
        [button setTitleColor:[UIColor colorWithHexString:@"#999999" alpha:1.0f]
                     forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithHexString:@"#01aeff" alpha:1.0f]
                     forState:UIControlStateSelected];
        if (i==0) {
            button.selected = YES;
        }
        //
        //文字大小
        button.titleLabel.font = [UIFont systemFontOfSize:15];
        button.tag = i+1;
        //设置点击事件
        [button addTarget:self action:@selector(titleClick:) forControlEvents:UIControlEventTouchUpInside];
        [_scrollView addSubview:button];
    }
    _scrollView.bounces = NO;
    
    //设置提示条目
    _lineView = [[UIView alloc]initWithFrame:CGRectMake(APPLICATION_WIDTH/2-90-21.0-10,43, 90, 1)];
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
    _tableScroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_scrollView.frame)+10, APPLICATION_WIDTH, APPLICATION_HEIGHT-CGRectGetMaxY(_scrollView.frame))];
    
    _tableScroll.contentSize = CGSizeMake(APPLICATION_WIDTH*2,APPLICATION_HEIGHT-CGRectGetMaxY(_scrollView.frame) );
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
-(void)l{
    //[self.navigationController popToRootViewControllerAnimated:YES];
    _lab.backgroundColor=[UIColor redColor];
    MJXUserLoginViewController *userLogin=[[MJXUserLoginViewController alloc] init];
    [UIApplication sharedApplication].keyWindow.rootViewController=[[UINavigationController alloc]initWithRootViewController:userLogin];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark UIScrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    //    //设定滑动主视图时候滑块随主视图滑动
    _lineView.frame = CGRectMake(scrollView.contentOffset.x/APPLICATION_WIDTH*(111+21+20)+APPLICATION_WIDTH/2-90-21.0-10, 43,90,1);
    
    //确定Scroller不为0
    if (scrollView.contentOffset.x/APPLICATION_WIDTH>=0) {
        //将其他已经select状态设置为NO
        int contentOffsetX=scrollView.contentOffset.x;
        int width=APPLICATION_WIDTH;
        //减少不必要操作 整数时候控制
        if (contentOffsetX%width==0) {
            //设置其他点击按钮不选中
            for (int i=1;i<3; i++) {
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
