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
                        Announcement,
                        SchoolCommunity,
                        CampusLife,
                        Community,
                        SchoolRun
                        ];
    
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
        
      
        ShareButton * button = [[ShareButton alloc] initWithFrame:CGRectMake(x, y, buttonWH, buttonWH) andType:array[i]];
        button.backgroundColor = [UIColor whiteColor];
        
        [button addTarget:self action:@selector(shareButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        button.backgroundColor = [UIColor colorWithHexString:@"#FAFAFA"];//RGBA_COLOR(249, 249, 249, 1);
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
