//
//  MJXQrCodeViewController.m
//  XinSuiFang
//
//  Created by majinxing on 16/11/15.
//  Copyright © 2016年 majinxing. All rights reserved.
//

#import "MJXQrCodeViewController.h"
#import "UIImageView+WebCache.h"

@interface MJXQrCodeViewController ()
@property (nonatomic,strong)NSDictionary * dict;
@property (nonatomic,strong)MJXUserModel * userInfo;
@end

@implementation MJXQrCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [MJXUIUtils addNavigationWithView:self.view withTitle:@"我的二维码"];
    [self getDataQrcodeImg];
    [self addBackButton];
    [self getTextWithUserModel];

    // Do any additional setup after loading the view.
}
-(void)addContentView{
    UILabel * name = [[UILabel alloc] initWithFrame:CGRectMake(0, 64+35, APPLICATION_WIDTH/2-10, 15)];
    name.textAlignment = NSTextAlignmentRight;
    name.text = _userInfo.userName;
    [self.view addSubview:name];
    
    UILabel * zhuzhi = [[UILabel alloc] initWithFrame:CGRectMake(APPLICATION_WIDTH/2+10, 64+35, 60, 17)];
    zhuzhi.layer.cornerRadius = 7.5;
    zhuzhi.layer.masksToBounds = YES;
    zhuzhi.layer.borderWidth = 1;
    zhuzhi.layer.borderColor = [[UIColor colorWithHexString:@"#01aeff"] CGColor];
    zhuzhi.text = @"主治医师";
    zhuzhi.textAlignment = NSTextAlignmentCenter;
    zhuzhi.font = [UIFont systemFontOfSize:10];
    zhuzhi.textColor = [UIColor colorWithHexString:@"#01aeff"];
    [self.view addSubview:zhuzhi];
    
    UILabel *hospital = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(zhuzhi.frame)+20, APPLICATION_WIDTH-20, 15)];
    hospital.font = [UIFont systemFontOfSize:15];
    hospital.textColor = [UIColor colorWithHexString:@"#666666"];
    hospital.text = [NSString stringWithFormat:@"%@  %@",_userInfo.hospital,_userInfo.department];
    hospital.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:hospital];
    
    UIImageView * backImage = [[UIImageView alloc] initWithFrame:CGRectMake(80.0/375.0*APPLICATION_WIDTH, CGRectGetMaxY(hospital.frame)+20, APPLICATION_WIDTH - 2*80.0/375.0*APPLICATION_WIDTH, 220)];
    backImage.image = [UIImage imageNamed:@"ewmdb"];
    [self.view addSubview:backImage];
    
    UIImageView * er = [[UIImageView alloc] initWithFrame:CGRectMake(15,47, backImage.frame.size.width-50, backImage.frame.size.height-75)];
    [er sd_setImageWithURL:[NSURL URLWithString:_userInfo.qrcodeimg] placeholderImage:[UIImage imageNamed:@"xc"]];
    [backImage addSubview:er];
    
    UILabel * tishi = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(backImage.frame)+30, APPLICATION_WIDTH, 30)];
    tishi.font = [UIFont systemFontOfSize:13];
    tishi.textColor = [UIColor colorWithHexString:@"#999999"];
    tishi.textAlignment = NSTextAlignmentCenter;
    tishi.text = @"请患者用微信扫一扫，加关注注册即可沟通";
    [self.view addSubview:tishi];
    
}
-(void)getTextWithUserModel{
    _userInfo = [[MJXUserModel alloc] init];
    _userInfo = [[MJXAppsettings sharedInstance] getUserInfo];
    if ([_userInfo.userName isEqualToString:@""]||[_userInfo.userName isKindOfClass:[NSNull class]]||_userInfo.userName == nil) {
        [self getDataQrcodeImg];
    }else{
        [self addContentView];
    }
}
-(void)getDataQrcodeImg{
    AFHTTPRequestOperationManager *manger = [MJXClient setAFHTTPRequestOperationManagerSomeQuality];
    NSString * url = [NSString stringWithFormat:@"%@/user/findDoctorInformation",MJXBaseURL];
    [manger POST:url parameters:@{
                                  @"username" :[[MJXAppsettings sharedInstance] getUserPhone]
                                  } success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                      if ([[responseObject objectForKey:@"statusCode"] isEqualToString:@"200"]) {
                                          NSDictionary * dict = [responseObject objectForKey:@"result"];
                                          [[MJXAppsettings sharedInstance] sevaUserInfoWithDict:dict];
  
                                      }
                                  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                      [MJXUIUtils show404WithDelegate:self];
                                  }];
}
-(void)addBackButton{
    UIImageView *backImage=[[UIImageView alloc] initWithFrame:CGRectMake(20, 20+15, 7, 15)];
    backImage.image=[UIImage imageNamed:@"return"];
    [self.view addSubview:backImage];
    UIButton *back=[UIButton buttonWithType:UIButtonTypeCustom];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
