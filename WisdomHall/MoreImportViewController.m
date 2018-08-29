//
//  MoreImportViewController.m
//  WisdomHall
//
//  Created by XTU-TI on 2018/8/20.
//  Copyright © 2018年 majinxing. All rights reserved.
//

#import "MoreImportViewController.h"
#import "UIImageView+WebCache.h"
#import "StatisticalViewController.h"
#import "CourseListALLViewController.h"
#import "AllTheMeetingViewController.h"

@interface MoreImportViewController ()
@property (nonatomic,strong)UIScrollView * bottomScrollView;

@end

@implementation MoreImportViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.title = @"重点推荐";
    
    [self addScorllView];
    
    [self addImageView];
    
    [self addBtn];
    // Do any additional setup after loading the view from its nib.
}
-(void)addScorllView{
    _bottomScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, APPLICATION_WIDTH, APPLICATION_HEIGHT/4+30+100*4)];
    _bottomScrollView.contentSize = CGSizeMake(APPLICATION_WIDTH, APPLICATION_HEIGHT);
    _bottomScrollView.contentOffset = CGPointMake(0, 0);
    [self.view addSubview:_bottomScrollView];
}
-(void)addImageView{
    UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, APPLICATION_WIDTH, APPLICATION_HEIGHT/4)];
    
    [imageView sd_setImageWithURL:[NSURL URLWithString:[[Appsetting sharedInstance] getBananerFitstImage]] placeholderImage:[UIImage imageNamed:@"banner"]];
    [_bottomScrollView addSubview:imageView];
}
-(void)addBtn{
    UIView * bline = [[UIView alloc] initWithFrame:CGRectMake(20,APPLICATION_HEIGHT/4+12.5, 3, 15)];
    bline.backgroundColor = [UIColor colorWithHexString:@"#29a7e1"];
    [_bottomScrollView addSubview:bline];
    
    UILabel * important = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(bline.frame)+5, APPLICATION_HEIGHT/4+10, 100, 20)];
    important.text = @"重要推荐";
    [_bottomScrollView addSubview:important];
    
    NSArray * ary = @[@"课堂",@"会议",@"生活",@"社团",@"校办",@"失物",@"校圈"];
    
    NSArray * aryImageName = @[@"课堂圆图",@"会议圆图",@"生活圆图",@"社团圆图",@"校办圆图",@"失物圆图",@"校圈圆图"];
    
    for (int i = 0; i<ary.count; i++) {
        
        if (i%2==0) {
            UIView * line = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(important.frame)+10+100*i/2, APPLICATION_WIDTH, 1)];
            line.backgroundColor = [UIColor colorWithHexString:@"#f1f1f1"];
            [_bottomScrollView addSubview:line];
            UIView * sLine = [[UIView alloc] initWithFrame:CGRectMake(APPLICATION_WIDTH/2, line.frame.origin.y, 1, 100)];
            sLine.backgroundColor = [UIColor colorWithHexString:@"#f1f1f1"];
            [_bottomScrollView addSubview:sLine];
        }
        
        UIImageView *classImage = [[UIImageView alloc] initWithFrame:CGRectMake(APPLICATION_WIDTH/2*(i%2)+15, CGRectGetMaxY(important.frame)+10+100*(i/2)+10, 80, 80)];
        
        classImage.image = [UIImage imageNamed:aryImageName[i]];
        
        [_bottomScrollView addSubview:classImage];
        
        UILabel * nameLable = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(classImage.frame)+20,CGRectGetMaxY(important.frame)+10+100*(i/2)+10+30, 80, 20)];
        
        nameLable.text = ary[i];
        
        [_bottomScrollView addSubview:nameLable];
        
        UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        btn.frame = CGRectMake(APPLICATION_WIDTH/2*(i%2),CGRectGetMaxY(important.frame)+10+100*(i/2), APPLICATION_WIDTH/2, 100);
        
        [btn addTarget:self action:@selector(shareButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        [btn setTitle:ary[i] forState:UIControlStateNormal];
        
        [btn setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
        
        [_bottomScrollView addSubview:btn];
        
        if (i+1==ary.count) {
            UIView * line = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(important.frame)+10+100*(i+2)/2, APPLICATION_WIDTH, 1)];
            line.backgroundColor = [UIColor colorWithHexString:@"#f1f1f1"];
            [_bottomScrollView addSubview:line];
        }
    }
    
}
-(void)shareButtonClicked:(UIButton *)btn {
    NSString * str = btn.titleLabel.text;
    if ([str isEqualToString:@"统计"]) {
        StatisticalViewController * vc = [[StatisticalViewController alloc] init];
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }else if ([str isEqualToString:@"课堂"]){
        CourseListALLViewController * noticeVC = [[CourseListALLViewController alloc] init];
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:noticeVC animated:YES];
        
    }else if ([ str isEqualToString:@"会议"]){
        AllTheMeetingViewController * s = [[AllTheMeetingViewController alloc] init];
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:s animated:YES];
        
    }    else{
        [UIUtils showInfoMessage:@"正在加紧步伐开发者，敬请期待" withVC:self];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
