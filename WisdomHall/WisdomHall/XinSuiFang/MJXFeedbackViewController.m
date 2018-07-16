//
//  MJXFeedbackViewController.m
//  XinSuiFang
//
//  Created by majinxing on 16/10/10.
//  Copyright © 2016年 majinxing. All rights reserved.
//

#import "MJXFeedbackViewController.h"

@interface MJXFeedbackViewController ()

@end

@implementation MJXFeedbackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [MJXUIUtils addNavigationWithView:self.view withTitle:_titleString];
    [self addBackButton];
    if ([_titleString isEqualToString:@"意见反馈"]) {
        [self addContentView];
    }else if ([_titleString isEqualToString:@"关于我们"]) {
        [self addAboutUsView];
    }
    // Do any additional setup after loading the view.
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
-(void)addAboutUsView{
    UIView * line = [[UIView alloc] initWithFrame:CGRectMake(0, 64, APPLICATION_WIDTH, 10)];
    line.backgroundColor = [UIColor colorWithHexString:@"#f7f7f7"];
    [self.view addSubview:line];
    UIImageView * icon = [[UIImageView alloc] initWithFrame:CGRectMake(APPLICATION_WIDTH/2-40, 30+64, 80, 80)];
    icon.layer.cornerRadius = 5;
    icon.layer.masksToBounds = YES;
    icon.image = [UIImage imageNamed:@"app-icon"];
    [self.view addSubview:icon];
    UILabel * title = [[UILabel alloc] initWithFrame:CGRectMake(APPLICATION_WIDTH/2-40, CGRectGetMaxY(icon.frame)+10, 50, 15)];
    title.font = [UIFont systemFontOfSize:15];
    title.textColor = [UIColor colorWithHexString:@"#333333"];
    title.text = @"心随访";
    [self.view addSubview:title];
    UIImageView * image = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(title.frame), CGRectGetMaxY(icon.frame)+10, 19, 11)];
    image.image = [UIImage imageNamed:@"gf"];
    [self.view addSubview:image];
    UILabel * title2 = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(title.frame)+7, APPLICATION_WIDTH, 10)];
    title2.textAlignment = NSTextAlignmentCenter;
    title2.text = @"医生的随访利器  患者的健康管家";
    title2.font = [UIFont systemFontOfSize:10];
    title2.textColor = [UIColor colorWithHexString:@"#666666"];
    [self.view addSubview:title2];
    UILabel * textView = [[UILabel alloc] init];
    textView.font = [UIFont systemFontOfSize:13];
    textView.textColor = [UIColor colorWithHexString:@"#666666"];
    textView.text = @"  “新随访”   APP是一款帮助医生进行患者随访管理的工具利器。通过医患扫二维码扫描、手机拍照、制定随访计划等简单几步，即可以实现患者管理、随访跟踪提醒以及病历采集等功能，通过ORC(文字自动识别)、语音识别等智能技术，大大简化医生工作，是医生实现远程咨询、患者跟踪、慢性病管理的最佳工具。";
    CGSize size = [self boundingRectWithSize:CGSizeMake(APPLICATION_WIDTH-42, 0) withText:textView.text withFont:[UIFont systemFontOfSize:13]];
    textView.frame = CGRectMake(21, CGRectGetMaxY(title2.frame)+14, size.width, size.height);
    textView.numberOfLines = 0;
    [self.view addSubview:textView];
}
-(void)addContentView{
    UIView * line = [[UIView alloc] initWithFrame:CGRectMake(0, 64, APPLICATION_WIDTH, 10)];
    line.backgroundColor = [UIColor colorWithHexString:@"#f7f7f7"];
    [self.view addSubview:line];
    
    UILabel * title = [[UILabel alloc] initWithFrame:CGRectMake(21, 20+64, APPLICATION_WIDTH-42, 15)];
    title.text = @"欢迎投递宝贵的意见";
    title.textColor = [UIColor colorWithHexString:@"#01aeff"];
    title.backgroundColor = [UIColor clearColor];
    [self.view addSubview:title];
    NSArray * nameImage = [[NSArray alloc] initWithObjects:@"kf",@"yx",@"qq", nil];
    NSArray *titleAry = [[NSArray alloc] initWithObjects:@"010-82826700",@"bj_hyhl@163.com",@"171721291", nil];
    CGFloat heigt = CGRectGetMaxY(title.frame)+19;
    for (int i=0; i<3; i++) {
        [self setWithImageName:nameImage[i] withTitle:titleAry[i] withFrame:heigt+37*i];
    }
    UILabel * textView = [[UILabel alloc] init];
    textView.font = [UIFont systemFontOfSize:12];
    textView.textColor = [UIColor colorWithHexString:@"#999999"];
    textView.text = @"客服工作时间：周一至周五9：00-18：00";
    textView.numberOfLines = 0;
    CGSize size = [self boundingRectWithSize:CGSizeMake(APPLICATION_WIDTH-42, 0) withText:textView.text withFont:[UIFont systemFontOfSize:12]];
    textView.frame = CGRectMake(21, heigt+37*3, size.width, size.height);
    [self.view addSubview:textView];
    UILabel * t = [[UILabel alloc] init];
    t.font = [UIFont systemFontOfSize:12];
    t.textColor = [UIColor colorWithHexString:@"#999999"];
    t.text = @"非工作时间您可以发邮件或QQ形式反馈，请谅解，谢谢！";
    t.numberOfLines = 0;
    CGSize size1 = [self boundingRectWithSize:CGSizeMake(APPLICATION_WIDTH-42, 0) withText:t.text withFont:[UIFont systemFontOfSize:12]];
    t.frame = CGRectMake(21, CGRectGetMaxY(textView.frame)+3, size1.width, size1.height);
    [self.view addSubview:t];
    
}
- (CGSize)boundingRectWithSize:(CGSize)size withText:(NSString *)text withFont:(UIFont *)font
{
    NSDictionary *attribute = @{NSFontAttributeName: font};
    
    CGSize retSize = [text boundingRectWithSize:size
                                             options:\
                      NSStringDrawingTruncatesLastVisibleLine |
                      NSStringDrawingUsesLineFragmentOrigin |
                      NSStringDrawingUsesFontLeading
                                          attributes:attribute
                                             context:nil].size;
    
    return retSize;
}
-(void)setWithImageName:(NSString *)nameIamge withTitle:(NSString *)title withFrame:(CGFloat)height{
    UIImageView * image = [[UIImageView alloc] initWithFrame:CGRectMake(21, height, 14, 16)];
    if ([nameIamge isEqualToString:@"yx"]) {
        image.frame = CGRectMake(21, height, 15, 16);
    }
    image.image = [UIImage imageNamed:nameIamge];
    [self.view addSubview:image];
    UILabel * titlelabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(image.frame)+7, height, 150, 16)];
    titlelabel.font = [UIFont systemFontOfSize:15];
    titlelabel.textColor = [UIColor colorWithHexString:@"#333333"];
    titlelabel.text = [NSString stringWithFormat:@": %@",title];
    [self.view addSubview:titlelabel];
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
