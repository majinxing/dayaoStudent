//
//  NoticeDetailsViewController.m
//  WisdomHall
//
//  Created by XTU-TI on 2017/12/19.
//  Copyright © 2017年 majinxing. All rights reserved.
//

#import "NoticeDetailsViewController.h"
#import "DYHeader.h"

@interface NoticeDetailsViewController ()
@property (strong, nonatomic) IBOutlet UILabel *noticeTitle;
@property (strong, nonatomic) IBOutlet UITextView *noticeInfo;
@property (strong, nonatomic) IBOutlet UIImageView *revetImage;
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;
@property (strong, nonatomic) IBOutlet UIView *backView;
@property (nonatomic,copy) void (^actionBlock)(NSString *);
@end

@implementation NoticeDetailsViewController

-(instancetype)initWithActionBlock:(void(^)(NSString * str))actionBlock{
    self = [super init];
    if (self) {
        self.actionBlock = actionBlock;
    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated{
        self.navigationController.navigationBarHidden = NO; //设置隐藏

}
/**
 *  显示navigation的标题
 **/
-(void)setNavigationTitle{
//    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
    self.title = @"通知详情";
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = RGBA_COLOR(249, 249, 249, 1);
    _backView.layer.masksToBounds = YES;
    _backView.layer.cornerRadius = 5;
    [self addContentView];
    [self sendRevert];
    [self setNavigationTitle];
    _timeLabel.textColor = [UIColor colorWithRed:128/255.0 green:128/255.0 blue:128/255.0 alpha:1/1.0];
    // Do any additional setup after loading the view from its nib.
}
-(void)addContentView{
    _noticeTitle.text = _notice.noticeTitle;
    _noticeInfo.text = _notice.noticeContent;
    NSMutableString * str = [NSMutableString stringWithFormat:@"%@",_notice.noticeTime];
    if (![UIUtils isBlankString:str]) {
        [str deleteCharactersInRange:NSMakeRange(0, 5)];
        _timeLabel.text = str;
    }
}
-(void)sendRevert{
    if ([[NSString stringWithFormat:@"%@",_notice.revert] isEqualToString:@"2"]) {
        if ([[NSString stringWithFormat:@"%@",_notice.messageStatus] isEqualToString:@"1"]) {
            NSDictionary * dict = [[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%@",_notice.noticeId],@"messageId",@"2",@"status", nil];
            [[NetworkRequest sharedInstance] POST:NoticeReceive dict:dict succeed:^(id data) {
//                NSLog(@"%@",data);
                NSString * str = [NSString stringWithFormat:@"%@",[[data objectForKey:@"header"] objectForKey:@"code"]];
                if ([str isEqualToString:@"0000"]) {
                    _revetImage.image = [UIImage imageNamed:@"revet"];
                    self.actionBlock(str);
                }else{
                    [UIUtils showInfoMessage:@"通知回执失败" withVC:self];
                }
            } failure:^(NSError *error) {
                [UIUtils showInfoMessage:@"通知回执失败，请检查网络" withVC:self];
            }];
        }else{
            _revetImage.image = [UIImage imageNamed:@"revet"];
        }
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
