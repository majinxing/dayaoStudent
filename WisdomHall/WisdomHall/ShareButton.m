//
//  ShareButton.m
//  WisdomHall
//
//  Created by XTU-TI on 2017/5/4.
//  Copyright © 2017年 majinxing. All rights reserved.
//

#import "ShareButton.h"
#import "DYHeader.h"

#define IMAGE_WH 25

@implementation ShareButton
- (instancetype)initWithFrame:(CGRect)frame andType:(NSString *)type
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self.titleLabel setTextAlignment:NSTextAlignmentCenter];
        [self.titleLabel setFont:[UIFont systemFontOfSize:12]];
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
        [self setImage:[UIImage imageNamed:@"SocialSharePlatformIcon_weixin"] forState:UIControlStateNormal];
    }
    if ([type isEqualToString:InteractionType_Test]) {
        
        UIImage * i = [[Appsetting sharedInstance] grayscale:[UIImage imageNamed:@"text"]];
        [self setImage:i forState:UIControlStateNormal];
    }
    if ([type isEqualToString:InteractionType_Vote]) {
        
        UIImage * i = [[Appsetting sharedInstance] grayscale:[UIImage imageNamed:@"Vote"]];
        [self setImage:i forState:UIControlStateNormal];
    }
    if ([type isEqualToString:InteractionType_Discuss]) {
        
        UIImage * i = [[Appsetting sharedInstance] grayscale:[UIImage imageNamed:@"discussed"]];
        [self setImage:i forState:UIControlStateNormal];
    }
    if ([type isEqualToString:InteractionType_Responder]) {
        UIImage * i = [[Appsetting sharedInstance] grayscale:[UIImage imageNamed:@"answer"]];
        [self setImage:i forState:UIControlStateNormal];
      
    }
    if ([type isEqualToString:InteractionType_Add]) {
        
        UIImage * i = [[Appsetting sharedInstance] grayscale:[UIImage imageNamed:@"add"]];
        
        [self setImage:i forState:UIControlStateNormal];
    }
    if ([type isEqualToString:InteractionType_Data]) {
        UIImage * i = [[Appsetting sharedInstance] grayscale:[UIImage imageNamed:@"form"]];
        
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
        [self setImage:[UIImage imageNamed:@"审批"] forState:UIControlStateNormal];
    }
    if ([type isEqualToString:Group]) {
        UIImage * i = [[Appsetting sharedInstance] grayscale:[UIImage imageNamed:@"群组"]];
        [self setImage:i forState:UIControlStateNormal];    }
    if ([type isEqualToString:InteractionType_Sit]) {
        UIImage * i = [[Appsetting sharedInstance] grayscale:[UIImage imageNamed:@"座次"]];
        [self setImage:i forState:UIControlStateNormal];    }
    if ([type isEqualToString:InteractionType_Picture]) {
        UIImage * i = [[Appsetting sharedInstance] grayscale:[UIImage imageNamed:@"问答"]];
        [self setImage:i forState:UIControlStateNormal];
    }
    if ([type isEqualToString:Statistical]) {
        UIImage * i = [[Appsetting sharedInstance] grayscale:[UIImage imageNamed:@"统计"]];
        [self setImage:i forState:UIControlStateNormal];
    }
    if ([type isEqualToString:InteractionType_Homework]) {
        UIImage * i = [[Appsetting sharedInstance] grayscale:[UIImage imageNamed:@"作业"]];
        [self setImage:i forState:UIControlStateNormal];
    }
    if ([type isEqualToString:CourseCloud]) {
        [self setImage:[UIImage imageNamed:@"云-4"] forState:UIControlStateNormal];
    }
    if ([type isEqualToString:SecondHand]) {
        [self setImage:[UIImage imageNamed:@"商城1"] forState:UIControlStateNormal];
    }
    if ([type isEqualToString:CampusLife]) {
        [self setImage:[UIImage imageNamed:@"生活"] forState:UIControlStateNormal];
    }
    [self setTitle:type forState:UIControlStateNormal];
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    return CGRectMake((self.bounds.size.width - IMAGE_WH) / 2, 0, IMAGE_WH, IMAGE_WH);
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    return CGRectMake(0, IMAGE_WH, self.bounds.size.width, self.bounds.size.height - IMAGE_WH);
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
