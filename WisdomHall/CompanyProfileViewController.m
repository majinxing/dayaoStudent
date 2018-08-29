//
//  CompanyProfileViewController.m
//  WisdomHall
//
//  Created by XTU-TI on 2017/7/29.
//  Copyright © 2017年 majinxing. All rights reserved.
//

#import "CompanyProfileViewController.h"

@interface CompanyProfileViewController ()<UITextViewDelegate>
@property (strong, nonatomic) IBOutlet UITextView *aboutCompany;

@end

@implementation CompanyProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = RGBA_COLOR(249, 249, 249, 1);
    [self addContentView];
    //       [atbs addAttribute: NSLinkAttributeNamevalue:@"www.baidu.com" range: range];
    
        // Do any additional setup after loading the view from its nib.
}
-(void)addContentView{
    UIView * whiteBackView  = [[UIView alloc] initWithFrame:CGRectMake(10, NaviHeight+10, APPLICATION_WIDTH-20, APPLICATION_HEIGHT-100-80)];
    whiteBackView.layer.masksToBounds = YES;
    whiteBackView.layer.cornerRadius = 5;
    [self.view addSubview:whiteBackView];
    UILabel * name = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 200, 20)];
    name.text = @"湖南简拓科技有限公司";
    name.font = [UIFont systemFontOfSize:16];
    [whiteBackView addSubview:name];
    
    UIView * b = [[UIView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(name.frame)+20, whiteBackView.frame.size.width-20, 100)];
    b.backgroundColor = [UIColor colorWithHexString:@"#f1f1f1"];
    [whiteBackView addSubview:b];
    
    UILabel * attention = [[UILabel alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(name.frame)+20, whiteBackView.frame.size.width-30, 100)];
    attention.backgroundColor = [UIColor clearColor];
    attention.text = @"湖南简拓科技有限公司是一家致力于科技改变生活的高新技术研发与销售公司，集高科技创意产品设计、研发与推广的创新创业公司。";
    attention.font = [UIFont systemFontOfSize:13];
    attention.numberOfLines = 0;
    attention.alpha = 0.7;
    [whiteBackView addSubview:attention];
    NSArray * ary = @[@"地址：长沙市高新开发区芯城科技园",@"邮编：410000",@"邮箱：jiantuokeji@163.com",@"网址：http://www.jiantuokeji.com"];
    
    for (int i = 0; i<ary.count; i++) {
        UILabel * l = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(attention.frame)+20+40*i, whiteBackView.frame.size.width-20, 20)];
        l.text = ary[i];
        l.font = [UIFont systemFontOfSize:14];
        [whiteBackView addSubview:l];
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
