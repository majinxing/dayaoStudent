//
//  TestCompletedViewController.m
//  WisdomHall
//
//  Created by XTU-TI on 2018/7/30.
//  Copyright © 2018年 majinxing. All rights reserved.
//

#import "TestCompletedViewController.h"
#import "SelfAnswerViewController.h"
#import "CorrectAnswerViewController.h"
#import "SelectQuestion.h"

@interface TestCompletedViewController ()<UIScrollViewDelegate>

@property (nonatomic,strong)UIScrollView * btnScrollView;
@property (nonatomic,strong)UIScrollView * textScrollView;
@property (strong, nonatomic) IBOutlet UIButton *selfAnswerBtn;
@property (strong, nonatomic) IBOutlet UIButton *correctAnswerBtn;
@property (strong, nonatomic) IBOutlet UIButton *onQuestion;
@property (strong, nonatomic) IBOutlet UIButton *nextQuestion;
@property (nonatomic,strong)NSMutableArray * vcAry;
@property (nonatomic,assign)int  temp;//标明单道题目时候的题号
@property (nonatomic,strong)SelectQuestion * selectQView;

@property (nonatomic,strong)SelfAnswerViewController * svc;
@property (nonatomic,strong)CorrectAnswerViewController * cvc;

@end

@implementation TestCompletedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [_selfAnswerBtn setTitleColor:[UIColor blackColor]
                  forState:UIControlStateNormal];
    
    [_selfAnswerBtn setTitleColor:[UIColor colorWithHexString:@"#29a7e1" alpha:1.0f]
                  forState:UIControlStateSelected];
    
    _selfAnswerBtn.selected = YES;
    
    [_selfAnswerBtn addTarget:self action:@selector(titleClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [_correctAnswerBtn addTarget:self action:@selector(titleClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [_correctAnswerBtn setTitleColor:[UIColor blackColor]
                    forState:UIControlStateNormal];
    [_correctAnswerBtn setTitleColor:[UIColor colorWithHexString:@"#29a7e1" alpha:1.0f]
                    forState:UIControlStateSelected];
    
    [self initVCArray];
    
    [self addScrollView];
    
    _temp = 0;
    
    [_onQuestion setEnabled:NO];

    // Do any additional setup after loading the view from its nib.
}
- (IBAction)allQuestionPressed:(id)sender {
    if (!_selectQView) {
        _selectQView = [[SelectQuestion alloc] initWithFrame:CGRectMake(0, 0, APPLICATION_WIDTH, APPLICATION_HEIGHT)];
        _selectQView.delegate = self;
    }
    [_selectQView addScrollViewWithBtnNumber:(int)_svc.allQuestionAry.count];
    [self.view addSubview:_selectQView];
}
- (IBAction)onQuestionbtnPressed:(id)sender {
    if (_temp==1) {
        _temp = 0;
        [_onQuestion setEnabled:NO];
        _svc.temp = _temp;
        [_svc.tableView reloadData];
        _cvc.temp = _temp;
        [_cvc.tableView reloadData];
    }else{
        _temp = _temp - 1;
        _svc.temp = _temp;
        [_svc.tableView reloadData];
        _cvc.temp = _temp;
        [_cvc.tableView reloadData];
    }
    [_nextQuestion setEnabled:YES];

}
- (IBAction)nextQuestionBtnPressed:(id)sender {
    if (_temp+2 ==_svc.allQuestionAry.count) {
        _temp = _temp + 1;
        
        _svc.temp = _temp;
        
        [_svc.tableView reloadData];
        
        _cvc.temp = _temp;
        
        [_cvc.tableView reloadData];
        
        [_nextQuestion setEnabled:NO];
    }else{
        _temp = _temp + 1;
        
        _svc.temp = _temp;
        
        [_svc.tableView reloadData];
        
        _cvc.temp = _temp;
        
        [_cvc.tableView reloadData];
    }
    
    [_onQuestion setEnabled:YES];
}
//title按钮被点击
-(void)titleClick:(UIButton *)button{
    
    [_textScrollView setContentOffset:CGPointMake((button.tag-1)*APPLICATION_WIDTH, 0) animated:YES];
}
/**
 *  初始化vc
 **/
-(void)initVCArray{
    _vcAry = [NSMutableArray arrayWithCapacity:1];
    _svc = [[SelfAnswerViewController alloc] init];
    
    _svc.t = _t;
    
    _svc.isAbleAnswer = NO;
  
    _svc.editable = NO;
    
    _svc.titleStr = @"试题";
    [_vcAry addObject:_svc];
    
    _cvc = [[CorrectAnswerViewController alloc] init];
    
    _cvc.t = _t;
    
    _cvc.isAbleAnswer = NO;
    
    _cvc.editable = NO;
    
    _cvc.titleStr = @"试题";
    
    [_vcAry addObject:_cvc];
}
-(void)addScrollView{
    
    _textScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64+44, APPLICATION_WIDTH, APPLICATION_HEIGHT-64-44-44)];
    _textScrollView.contentOffset = CGPointMake(0, 0);
    _textScrollView.bounces= YES;
    
    _textScrollView.contentSize = CGSizeMake(APPLICATION_WIDTH*2, APPLICATION_HEIGHT-64-50);
    _textScrollView.pagingEnabled = YES;
    _textScrollView.delegate = self;
    if (_vcAry.count) {
        UIViewController * vc = _vcAry[0];
        [self addChildViewController:vc];
        vc.view.frame = _textScrollView.bounds;
        [_textScrollView addSubview:vc.view];
        
        UIViewController * willShowVc = _vcAry[1];
        [self addChildViewController:willShowVc];
        willShowVc.view.frame = CGRectMake(APPLICATION_WIDTH , 0, APPLICATION_WIDTH, _textScrollView.frame.size.height);
        [_textScrollView addSubview:willShowVc.view];
    }
    [self.view addSubview:_textScrollView];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)selectQViewOutViewDelegate{
    [_selectQView removeFromSuperview];
    _selectQView = nil;
}

-(void)selectEdDelegate:(UIButton *)btn{
    _temp = (int)btn.tag - 1;
    if (_temp == 0) {
        [_onQuestion setEnabled:NO];
        [_nextQuestion setEnabled:YES];
    }
    if (_temp+1 == _svc.allQuestionAry.count) {
        [_onQuestion setEnabled:YES];
        [_nextQuestion setEnabled:NO];
    }
    _cvc.temp = _temp;
    _svc.temp = _temp;
    [_svc.tableView reloadData];
    [_cvc.tableView reloadData];

    [_selectQView removeFromSuperview];
    _selectQView = nil;
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
