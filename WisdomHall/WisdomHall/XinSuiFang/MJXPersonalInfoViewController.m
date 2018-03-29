//
//  MJXPersonalInfoViewController.m
//  XinSuiFang
//
//  Created by majinxing on 16/8/15.
//  Copyright © 2016年 majinxing. All rights reserved.
//

#import "MJXPersonalInfoViewController.h"
#import "MJXTabBarController.h"
#import "MJXPersonalInfoView.h"
#import "MJXRegionalViewController.h"
#import "AppDelegate.h"
@interface MJXPersonalInfoViewController ()<personalInfoViewDelegate>
@property (nonatomic,strong) MJXPersonalInfoView *personalInfoView;
@property (nonatomic,strong)MJXRegionalViewController *regionalVC;
@property (nonatomic,assign) int temp;
@end

@implementation MJXPersonalInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    _personalInfoView=[[MJXPersonalInfoView alloc] initWithFrame:CGRectMake(0, 64, APPLICATION_WIDTH, APPLICATION_HEIGHT-64)];
    _personalInfoView.delegate=self;
    [self.view addSubview:_personalInfoView];
    [MJXUIUtils addNavigationWithView:self.view withTitle:@"医生注册"];
    [self addBackButton];
    // Do any additional setup after loading the view from its nib.
}
-(void)addBackButton{
    
    UIImageView *backImage=[[UIImageView alloc] initWithFrame:CGRectMake(20, 20+15, 7, 15)];
    backImage.image=[UIImage imageNamed:@"return"];
    [self.view addSubview:backImage];
    UIButton *back=[UIButton buttonWithType:UIButtonTypeCustom];
    //    [back setImage:[UIImage imageNamed:@"返回"] forState:UIControlStateNormal];
    back.frame=CGRectMake(0,20,60, 44);
    [back addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:back];
}
-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animate{
    if (_temp!=0) {
        UITextField *t=(UITextField *)[_personalInfoView viewWithTag:_temp+1];
        t.text=_regionalVC.str;
    }
    for (int i=1; i<=5; i++) {
        UITextField *t=[_personalInfoView viewWithTag:i];
        if (t.text.length>0) {
            _personalInfoView.complete.backgroundColor=[UIColor colorWithHexString:@"#01aeff"];
            _personalInfoView.userInteractionEnabled=YES;
            return;
        }
        _personalInfoView.complete.backgroundColor=[UIColor colorWithHexString:@"#bfbfbf"];
        _personalInfoView.complete.userInteractionEnabled=NO;

    }
}
#pragma mark personalInfoViewDelegate
-(void)personalInfoViewCompletePressed{
    NSMutableArray *arry=[[NSMutableArray alloc] init];
    for (int i=1; i<=4; i++) {
        UITextField *t=(UITextField *)[_personalInfoView viewWithTag:i];
        [arry setObject:t.text atIndexedSubscript:i-1];
    }
    [arry setObject:_personalInfoView.introduction.text atIndexedSubscript:4];


    NSString *url = [NSString stringWithFormat:@"%@%@",MJXBaseURL,@"/user/doctorInformation"];
    AFHTTPRequestOperationManager *manger = [MJXClient setAFHTTPRequestOperationManagerSomeQuality];
    [manger POST:url parameters:@{
                                  @"username" :[[MJXAppsettings sharedInstance] getUserPhone],
                                  @"doctorName" :arry[0],
                                  @"hospital" : arry[1],
                                  @"department" : arry[2],
                                  @"title" : arry[3],
                                  @"introduction" : arry[4]
                                  } success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                      if ([[responseObject objectForKey:@"errorcode"] isEqualToString:@"200"]) {
                                          MJXTabBarController *rootVC = [[MJXTabBarController alloc] init];
                                          [UIApplication sharedApplication].keyWindow.rootViewController = rootVC;

                                      }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"失败");
    }];
    
    MJXTabBarController *rootVC = [[MJXTabBarController alloc] init];
    [UIApplication sharedApplication].keyWindow.rootViewController = rootVC;
}
-(void)personalInfoViewSkipPressed{
   
    MJXTabBarController *tabbar = [[MJXTabBarController alloc] init];
    [UIApplication sharedApplication].keyWindow.rootViewController = tabbar;
}
//回收键盘的
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    [self.view endEditing:YES];
    
}
-(void)personalInfoViewRegionalPressed:(UIButton *)btn{
    NSLog(@"%ld",(long)btn.tag);
   _regionalVC = [[MJXRegionalViewController alloc] init];
    _regionalVC.type=[NSString stringWithFormat:@"%ld",
                      btn.tag-100];
    _temp=(int)btn.tag-100;
    [self.navigationController pushViewController:_regionalVC animated:NO];
}

////回收键盘的
//-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
//    
//    [self.view endEditing:YES];
//    
//}


@end
