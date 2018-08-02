//
//  HelpViewController.m
//  WisdomHall
//
//  Created by XTU-TI on 2018/5/10.
//  Copyright © 2018年 majinxing. All rights reserved.
//

#import "HelpViewController.h"
#import "DYHeader.h"

@interface HelpViewController ()
@property (nonatomic,strong)UIWebView * webView;
@end

@implementation HelpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    if (!_webView) {
        _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 64, APPLICATION_WIDTH, APPLICATION_HEIGHT-64)];
        
        _webView.dataDetectorTypes = UIDataDetectorTypeAll;
        
    }
    self.view = _webView;
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    dispatch_async(queue, ^{
        [self loadString];

    });
    
    // Do any additional setup after loading the view from its nib.
}


// 让浏览器加载指定的字符串,使用m.baidu.com进行搜索
- (void)loadString{
    // 1. URL 定位资源,需要资源的地址
    NSString *urlStr = [NSString stringWithFormat:@"http://www.jiantuokeji.com/LvDongXiaoYuan/m/article_category.php?id=2"];
    
    
    NSURL *url = [NSURL URLWithString:urlStr];
    
    // 2. 把URL告诉给服务器,请求,从m.baidu.com请求数据
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    dispatch_async(dispatch_get_main_queue(), ^{
        // 3. 发送请求给服务器
        [self.webView loadRequest:request];
    });
    
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
