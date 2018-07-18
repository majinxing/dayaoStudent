//
//  CreateChatGroupView.m
//  WisdomHall
//
//  Created by XTU-TI on 2018/7/18.
//  Copyright © 2018年 majinxing. All rights reserved.
//

#import "CreateChatGroupView.h"

@implementation CreateChatGroupView
-(instancetype)init{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}
-(void)addContentView{
    UIView * blackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, APPLICATION_WIDTH, APPLICATION_HEIGHT)];
    blackView.backgroundColor = [UIColor blackColor];
    blackView.alpha = 0.5;
    [self addSubview:blackView];
    
    UIView * whiteView = [[UIView alloc] initWithFrame:CGRectMake(0, 125, APPLICATION_WIDTH, APPLICATION_HEIGHT-125)];
    whiteView.backgroundColor = [UIColor whiteColor];
    [self addSubview:whiteView];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
