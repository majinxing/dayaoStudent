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
#define buttonWH 52
#define marginHeight 8

@implementation HomeButtonView
-(instancetype)init{
    self = [super init];
    if (self) {
        
    }
    return self;
}
-(void)addContentView{
    NSArray * array = @[
                        Meeting,
                        Classroom,
                        LostANDFound,
                        SchoolCommunity,
                        CampusLife,
                        Community,
                        SchoolRun
                        ];
    NSArray * imageAry = @[@"会议圆图",@"课堂圆图",@"失物圆图",@"校圈圆图",@"生活圆图",@"社团圆图",@"校办圆图"];
    
    //水平间距
    int marginWidth = (APPLICATION_WIDTH/columns - buttonWH) / 2;
    //起始XY坐标
    int oneX = marginWidth;
    int oneY = marginHeight;
    
    int xx = APPLICATION_WIDTH/columns;
    
    for (int i = 0; i < array.count; i++)
    {
        //行
        int row = i / columns;
        //列
        int column = i % columns;
        //        int x = oneX + (buttonWH + marginWidth) * column;
        int x = oneX + xx*column;
        int y = oneY + 80 * row;
        
      
//        ShareButton * button = [[ShareButton alloc] initWithFrame:CGRectMake(x, y, buttonWH, buttonWH) andType:array[i]];
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [button setBackgroundImage:[UIImage imageNamed:imageAry[i]] forState:UIControlStateNormal];
        
        [button setTitle:array[i] forState:UIControlStateNormal];
        
        [button setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
        
        button.frame = CGRectMake(x, y, buttonWH, buttonWH);
        
        button.backgroundColor = [UIColor whiteColor];
        
        [button addTarget:self action:@selector(shareButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        
//        button.backgroundColor = [UIColor colorWithHexString:@"#FAFAFA"];//RGBA_COLOR(249, 249, 249, 1);
        button.layer.masksToBounds = YES;
        
        button.layer.cornerRadius = buttonWH/2;
        
        [self addSubview:button];
    }
}
-(void)shareButtonClicked:(UIButton *)btn{
    if (self.delegate&&[self.delegate respondsToSelector:@selector(shareButtonClickedDelegate:) ]) {
        [self.delegate shareButtonClickedDelegate:btn.titleLabel.text];
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
