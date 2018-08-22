//
//  HomeButtonView.m
//  WisdomHall
//
//  Created by XTU-TI on 2018/7/4.
//  Copyright © 2018年 majinxing. All rights reserved.
//

#import "HomeButtonView.h"
#import "DYHeader.h"
#import "ShareButton.h"

#define columns 4
#define buttonWH 59
#define marginHeight 8

@implementation HomeButtonView
-(instancetype)init{
    self = [super init];
    if (self) {
        
    }
    return self;
}
-(void)addContentView{
    UIView * bline = [[UIView alloc] initWithFrame:CGRectMake(20, 12.5, 3, 15)];
    bline.backgroundColor = [UIColor colorWithHexString:@"#29a7e1"];
    [self addSubview:bline];
    
    UILabel * important = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(bline.frame)+5, 10, 100, 20)];
    important.text = @"重要推荐";
    [self addSubview:important];
    
    UIImageView * image = [[UIImageView alloc] initWithFrame:CGRectMake(APPLICATION_WIDTH-25, 15, 15, 15)];
    image.image = [UIImage imageNamed:@"右箭头"];
    [self addSubview:image];
    
    UIButton * moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    moreBtn.frame = CGRectMake(CGRectGetMaxX(important.frame)+40, 0, APPLICATION_HEIGHT-CGRectGetMaxX(important.frame)-40, 40);
    [moreBtn addTarget:self action:@selector(moreBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:moreBtn];
    
    UIView * hLine1 = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(moreBtn.frame), APPLICATION_WIDTH, 1)];
    hLine1.backgroundColor = [UIColor colorWithHexString:@"#f1f1f1"];
    [self addSubview:hLine1];
    NSArray *  ary = @[@"课堂圆图",@"课堂",@"会议圆图",@"会议"];
    NSArray * aryTitle = @[Classroom,Meeting];
    for (int i = 0; i<2; i++) {
        UIImageView *classImage = [[UIImageView alloc] initWithFrame:CGRectMake(APPLICATION_WIDTH/2*i+15, CGRectGetMaxY(hLine1.frame)+10, 80, 80)];
        classImage.image = [UIImage imageNamed:ary[i*2]];
        [self addSubview:classImage];
        
        UILabel * nameLable = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(classImage.frame)+20, CGRectGetMaxY(hLine1.frame)+10+30, 80, 20)];
        nameLable.text = ary[i*2+1];
        [self addSubview:nameLable];
        UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(APPLICATION_WIDTH/2*i, CGRectGetMaxY(hLine1.frame), APPLICATION_WIDTH/2, 100);
        [btn addTarget:self action:@selector(shareButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [btn setTitle:aryTitle[i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
        [self addSubview:btn];
    }
    
    UIView *sLine = [[UIView alloc] initWithFrame:CGRectMake(APPLICATION_WIDTH/2, CGRectGetMaxY(hLine1.frame), 1, 100)];
    
    sLine.backgroundColor = [UIColor colorWithHexString:@"#f1f1f1"];
    [self addSubview:sLine];
    
    UIView * hLine2 = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(moreBtn.frame)+100, APPLICATION_WIDTH, 1)];
    
    hLine2.backgroundColor = [UIColor colorWithHexString:@"#f1f1f1"];
    
    [self addSubview:hLine2];
}
-(void)shareButtonClicked:(UIButton *)btn{
    if (self.delegate&&[self.delegate respondsToSelector:@selector(shareButtonClickedDelegate:) ]) {
        [self.delegate shareButtonClickedDelegate:btn.titleLabel.text];
    }
}
-(void)moreBtnPressed:(UIButton *)btn{
    if (self.delegate&&[self.delegate respondsToSelector:@selector(moreBtnPressedDelegate:)]) {
        [self.delegate moreBtnPressedDelegate:btn];
    }
}
/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
