//
//  DetailsButton.m
//  WisdomHall
//
//  Created by XTU-TI on 2018/7/5.
//  Copyright © 2018年 majinxing. All rights reserved.
//

#import "DetailsButton.h"
#import "DYHeader.h"

#define IMAGE_WH 40

@implementation DetailsButton
- (instancetype)initWithFrame:(CGRect)frame andType:(NSString *)type
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self.titleLabel setTextAlignment:NSTextAlignmentCenter];
        
        self.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
        
        self.titleLabel.textColor = [UIColor colorWithRed:13/255.0 green:14/255.0 blue:21/255.0 alpha:1/1.0];
        
        [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        [self setContentWithType:type];
    }
    return self;
}

//设置显示内容
- (void)setContentWithType:(NSString *)type
{
    if ([type isEqualToString:ShareType_Copy])
    {
        [self setImage:[UIImage imageNamed:@"SocialSharePlatformIcon_copy"] forState:UIControlStateNormal];
    }
    if ([type isEqualToString:ShareType_Email])
    {
        [self setImage:[UIImage imageNamed:@"SocialSharePlatformIcon_email"] forState:UIControlStateNormal];
    }
    if ([type isEqualToString:ShareType_Message])
    {
        [self setImage:[UIImage imageNamed:@"SocialSharePlatformIcon_sms"] forState:UIControlStateNormal];
    }
    if ([type isEqualToString:ShareType_QQ_Friend])
    {
        [self setImage:[UIImage imageNamed:@"SocialSharePlatformIcon_qqfriend"] forState:UIControlStateNormal];
    }
    if ([type isEqualToString:ShareType_QQ_Zone])
    {
        [self setImage:[UIImage imageNamed:@"SocialSharePlatformIcon_qzone"] forState:UIControlStateNormal];
    }
    if ([type isEqualToString:ShareType_Weibo])
    {
        [self setImage:[UIImage imageNamed:@"SocialSharePlatformIcon_sinaweibo"] forState:UIControlStateNormal];
    }
    if ([type isEqualToString:ShareType_Weixin_Circle])
    {
        [self setImage:[UIImage imageNamed:@"SocialSharePlatformIcon_weixinTimeline"] forState:UIControlStateNormal];
    }
    if ([type isEqualToString:ShareType_Weixin_Friend])
    {
        UIImage * i = [[Appsetting sharedInstance] grayscale:[UIImage imageNamed:@"SocialSharePlatformIcon_weixin"]];
        [self setImage:i forState:UIControlStateNormal];
        
    }
    if ([type isEqualToString:InteractionType_Test]) {
        UIImage * i = [[Appsetting sharedInstance] grayscale:[UIImage imageNamed:@"测验"]];
        [self setImage:i forState:UIControlStateNormal];
        
    }
    if ([type isEqualToString:InteractionType_Vote]) {
        UIImage * i = [[Appsetting sharedInstance] grayscale:[UIImage imageNamed:@"投票"]];
        [self setImage:i forState:UIControlStateNormal];
        
    }
    if ([type isEqualToString:InteractionType_Discuss]) {
        UIImage * i = [[Appsetting sharedInstance] grayscale:[UIImage imageNamed:@"讨论"]];
        [self setImage:i forState:UIControlStateNormal];
    }
    if ([type isEqualToString:InteractionType_Responder]) {
        UIImage * i = [[Appsetting sharedInstance] grayscale:[UIImage imageNamed:@"抢答"]];
        [self setImage:i forState:UIControlStateNormal];
    }
    if ([type isEqualToString:InteractionType_Add]) {
        UIImage * i = [[Appsetting sharedInstance] grayscale:[UIImage imageNamed:@"add"]];
        
        [self setImage:i forState:UIControlStateNormal];
    }
    if ([type isEqualToString:InteractionType_Data]) {
        UIImage * i = [[Appsetting sharedInstance] grayscale:[UIImage imageNamed:@"文件"]];
        
        [self setImage:i forState:UIControlStateNormal];
    }
    if ([type isEqualToString:Vote_Stop]) {
        UIImage * i = [[Appsetting sharedInstance] grayscale:[UIImage imageNamed:@"stop"]];
        
        [self setImage:i forState:UIControlStateNormal];
    }
    if ([type isEqualToString:Vote_Stare]) {
        UIImage * i = [[Appsetting sharedInstance] grayscale:[UIImage imageNamed:@"start"]];
        
        [self setImage:i forState:UIControlStateNormal];
    }
    if ([type isEqualToString:Vote_delecate]) {
        UIImage * i = [[Appsetting sharedInstance] grayscale:[UIImage imageNamed:@"delect"]];
        
        [self setImage:i forState:UIControlStateNormal];
    }
    if ([type isEqualToString:Vote_Modify]) {
        UIImage * i = [[Appsetting sharedInstance] grayscale:[UIImage imageNamed:@"modify"]];
        
        [self setImage:i forState:UIControlStateNormal];
    }
    if ([type isEqualToString:Test_Scores_Query]) {
        UIImage * i = [[Appsetting sharedInstance] grayscale:[UIImage imageNamed:@"查询"]];
        [self setImage:i forState:UIControlStateNormal];
    }
    if ([type isEqualToString:Meeting]) {
        UIImage * i = [[Appsetting sharedInstance] grayscale:[UIImage imageNamed:@"会议"]];
        [self setImage:i forState:UIControlStateNormal];
    }
    if ([type isEqualToString:Announcement]) {
        UIImage * i = [[Appsetting sharedInstance] grayscale:[UIImage imageNamed:@"通知"]];
        [self setImage:i forState:UIControlStateNormal];
    }
    if ([type isEqualToString:Leave]) {
        [self setImage:[UIImage imageNamed:@"请假"] forState:UIControlStateNormal];
    }if ([type isEqualToString:Business]) {
        [self setImage:[UIImage imageNamed:@"出差"] forState:UIControlStateNormal];
    }if ([type isEqualToString:Lotus]) {
        UIImage * i = [[Appsetting sharedInstance] grayscale:[UIImage imageNamed:@"审批"]];
        [self setImage:i forState:UIControlStateNormal];
    }
    if ([type isEqualToString:Group]) {
        UIImage * i = [[Appsetting sharedInstance] grayscale:[UIImage imageNamed:@"群组"]];
        [self setImage:i forState:UIControlStateNormal];
    }
    if ([type isEqualToString:InteractionType_Sit]) {
        UIImage * i = [[Appsetting sharedInstance] grayscale:[UIImage imageNamed:@"座次"]];
        [self setImage:i forState:UIControlStateNormal];
    }
    if ([type isEqualToString:InteractionType_Picture]) {
        UIImage * i = [[Appsetting sharedInstance] grayscale:[UIImage imageNamed:@"问答"]];
        [self setImage:i forState:UIControlStateNormal];
    }
    if ([type isEqualToString:SchoolRun]) {
        //        UIImage * i = [[Appsetting sharedInstance] grayscale:[UIImage imageNamed:@"校办"]];
        [self setImage:[UIImage imageNamed:@"办公"] forState:UIControlStateNormal];
    }
    if ([type isEqualToString:CampusLife]) {
        //        UIImage * i = [[Appsetting sharedInstance] grayscale:[UIImage imageNamed:@"生活"]];
        [self setImage:[UIImage imageNamed:@"bed"] forState:UIControlStateNormal];
    }
    if ([type isEqualToString:SchoolCommunity]) {
        [self setImage:[UIImage imageNamed:@"好房拓 400 iconfont_朋友圈"] forState:UIControlStateNormal];
    }
    if ([type isEqualToString:Community]) {
        [self setImage:[UIImage imageNamed:@"社团"] forState:UIControlStateNormal];
    }
    if ([type isEqualToString:AroundSchool]) {
        
        [self setImage:[UIImage imageNamed:@"ic_school_around"] forState:UIControlStateNormal];
    }
    if ([type isEqualToString:Statistical]) {
        UIImage * i = [[Appsetting sharedInstance] grayscale:[UIImage imageNamed:@"统计"]];
        [self setImage:i forState:UIControlStateNormal];
    }
    if ([type isEqualToString:InteractionType_Homework]) {
        UIImage * i = [[Appsetting sharedInstance] grayscale:[UIImage imageNamed:@"作业"]];
        [self setImage:i forState:UIControlStateNormal];
    }
    if ([type isEqualToString:Classroom]) {
        [self setImage:[UIImage imageNamed:@"班级&课堂"] forState:UIControlStateNormal];
    }
    if ([type isEqualToString:LostANDFound]) {
        [self setImage:[UIImage imageNamed:@"代付款"] forState:UIControlStateNormal];
    }
    
    [self setTitle:type forState:UIControlStateNormal];
}
- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    return CGRectMake(self.bounds.size.width/2-40, 10, IMAGE_WH, IMAGE_WH);
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    return CGRectMake(self.bounds.size.width/2, self.bounds.size.height/2-10, self.bounds.size.width/2, 20);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
