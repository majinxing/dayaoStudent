//
//  TestAllViewController.m
//  WisdomHall
//
//  Created by XTU-TI on 2018/7/9.
//  Copyright © 2018年 majinxing. All rights reserved.
//

#import "TestAllViewController.h"
#import "AllTestViewController.h"

@interface TestAllViewController ()<UIScrollViewDelegate>
@property (strong, nonatomic)  UIButton *NOTest;
@property (strong, nonatomic)  UIButton *HaveTest;

@property (nonatomic,strong)UIScrollView * btnScrollView;
@property (nonatomic,strong)UIScrollView * textScrollView;

@property (nonatomic,strong)NSMutableArray * vcAry;
@end

@implementation TestAllViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self addScrollView];
    
    self.title = @"测验";
    
    [self addBtn];
    
    // Do any additional setup after loading the view from its nib.
}

-(void)addBtn{
    _NOTest = [UIButton buttonWithType:UIButtonTypeCustom];
    
    _HaveTest = [UIButton buttonWithType:UIButtonTypeCustom];
    
    _NOTest.tag = 1;
    
    _HaveTest.tag = 2;
    
    _NOTest.backgroundColor = [UIColor whiteColor];
    
    _HaveTest.backgroundColor = [UIColor whiteColor];
    
    _NOTest.frame = CGRectMake(0, NaviHeight, APPLICATION_WIDTH/2, 50);
    
    _HaveTest.frame = CGRectMake(APPLICATION_WIDTH/2, NaviHeight, APPLICATION_WIDTH/2, 50);
    
    [_NOTest setTitleColor:[UIColor blackColor]
                  forState:UIControlStateNormal];
    
    [_NOTest setTitleColor:[UIColor colorWithHexString:@"#29a7e1" alpha:1.0f]
                  forState:UIControlStateSelected];
    
    [_NOTest setTitle:@"未测试" forState:UIControlStateNormal];
    
    [_HaveTest setTitle:@"已测试" forState:UIControlStateNormal];
    
    _NOTest.selected = YES;
    
    [_NOTest addTarget:self action:@selector(titleClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [_HaveTest addTarget:self action:@selector(titleClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [_HaveTest setTitleColor:[UIColor blackColor]
                    forState:UIControlStateNormal];
    [_HaveTest setTitleColor:[UIColor colorWithHexString:@"#29a7e1" alpha:1.0f]
                    forState:UIControlStateSelected];
    
    [self.view addSubview:_NOTest];
    
    [self.view addSubview:_HaveTest];
}
-(void)addScrollView{
    _vcAry = [NSMutableArray arrayWithCapacity:2];
    NSArray * ary = [NSArray arrayWithObjects:@"NOTest",@"HaveTest", nil];
    
    for (int i = 0; i<2; i++) {
        AllTestViewController  * vc =  [[AllTestViewController alloc] init];
        vc.classModel = _classModel;
        
        vc.typeText = ary[i];
        
        [_vcAry addObject:vc];
    }
 
    _textScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_HaveTest.frame), APPLICATION_WIDTH, APPLICATION_HEIGHT-CGRectGetMaxY(_HaveTest.frame))];
    _textScrollView.contentOffset = CGPointMake(0, 0);
    _textScrollView.bounces= YES;
    
    _textScrollView.contentSize = CGSizeMake(APPLICATION_WIDTH*2, APPLICATION_HEIGHT-CGRectGetMaxY(_HaveTest.frame));
    _textScrollView.pagingEnabled = YES;
    _textScrollView.delegate = self;
    if (_vcAry.count) {
        UIViewController * vc = _vcAry[0];
        [self addChildViewController:vc];
        vc.view.frame = _textScrollView.bounds;
        [_textScrollView addSubview:vc.view];
    }
    [self.view addSubview:_textScrollView];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//title按钮被点击
-(void)titleClick:(UIButton *)button{
    
    [_textScrollView setContentOffset:CGPointMake((button.tag-1)*APPLICATION_WIDTH, 0) animated:YES];
}
#pragma mark UIScrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView.contentOffset.x/APPLICATION_WIDTH>=0) {
        if (_vcAry) {
            //获得contentScrollView 的长，宽 和偏移坐标X
            CGFloat width = scrollView.frame.size.width;
            CGFloat offsetX = scrollView.contentOffset.x;
            // 向contentScrollView上添加控制器的View 偏移到第几个视图
            NSInteger index = offsetX / width;
            
            // 取出要显示的控制器
            UIViewController *willShowVc = self.vcAry[index];
            
            
            //设置其他点击按钮不选中
            for (int i=1;i<_vcAry.count+1; i++) {
                if (i!=scrollView.contentOffset.x/APPLICATION_WIDTH+1) {
                    UIButton *button=(UIButton *)[self.view viewWithTag:i];
                    button.selected=NO;
                    //                    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                }
                
            }
            
            UIButton *button=(UIButton *)[self.view viewWithTag:scrollView.contentOffset.x/APPLICATION_WIDTH+1];
            
            button.selected=YES;
            
            // 如果当前控制器已经显示过一次就不要再次显示出来 就直接返回;
            if (willShowVc.parentViewController) {
                return;
            }
            
            [self addChildViewController:willShowVc];
            CGFloat height = scrollView.frame.size.height;
            willShowVc.view.frame = CGRectMake(width * index, 0, width, height);
            [_textScrollView addSubview:willShowVc.view];
            
            
            
//            [button setTitleColor:[UIColor colorWithHexString:@"#29a7e1"] forState:UIControlStateNormal];
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
