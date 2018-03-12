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
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    // 定义一个可变属性字符串对象
   // NSMutableAttributedString * str = [[NSMutableAttributedString alloc]initWithString:@"湖南大姚科技有限公司是一家致力于科技改变生活的高新技术研发与销售公司，集高科技创意产品设计、研发与推广的创新创业公司。\n联系我们\n通讯地址：长沙市高新开发区芯城科技园，邮编410000\n服务邮箱：hunandayaokeji@163.com\n我们将随时为您献上真诚的服务。\n网站网址:"];
    NSMutableAttributedString *atbs =[[NSMutableAttributedString alloc] initWithString: @"湖南大姚科技有限公司是一家致力于科技改变生活的高新技术研发与销售公司，集高科技创意产品设计、研发与推广的创新创业公司。\n\n联系我们\n\n通讯地址：长沙市高新开发区芯城科技园\n\n邮编：410000\n\n服务邮箱：hunandayaokeji@163.com\n\n我们将随时为您献上真诚的服务。\n\n网站网址：www.dayaokeji.com"];
    
    [atbs addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:NSMakeRange(0, atbs.length)];
    
    [atbs addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:NSMakeRange(atbs.length-17,17)];
    
    [atbs addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:NSMakeRange(atbs.length-63,24)];

    [atbs addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:NSMakeRange(atbs.length-76,6)];
    
//    self.textView.attributedText= atbs;
//    
//    self.textView.delegate=self;
//    
//    self.textView.editable=NO;
    
    _aboutCompany.attributedText = [atbs copy];
    _aboutCompany.editable = NO;
    _aboutCompany.delegate = self;

    //       [atbs addAttribute: NSLinkAttributeNamevalue:@"www.baidu.com" range: range];
    
        // Do any additional setup after loading the view from its nib.
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
