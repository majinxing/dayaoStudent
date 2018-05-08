//
//  ChooseTopicView.m
//  WisdomHall
//
//  Created by XTU-TI on 2018/5/2.
//  Copyright © 2018年 majinxing. All rights reserved.
//

#import "ChooseTopicView.h"
#import "DYHeader.h"

@implementation ChooseTopicView
-(instancetype)init{
    self = [super init];
    if (self) {
        
        [self addContentView];
    }
    return self;
}
-(void)addContentView{
    UIButton * backBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    backBtn.frame =  CGRectMake(0, 0, APPLICATION_WIDTH, APPLICATION_HEIGHT-64);
    [backBtn setBackgroundColor:[UIColor blackColor]];
    backBtn.alpha = 0.3;
    [backBtn addTarget:self action:@selector(outOfChooseTopicView) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:backBtn];
    
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(APPLICATION_WIDTH/2-90, 100, APPLICATION_WIDTH-180, 220)];
    v.backgroundColor = [UIColor whiteColor];
    NSArray * ary = @[@"创建单选题",@"创建多选题",@"创建判断题",@"创建问答题",@"创建填空题"];
    
    for (int i = 0; i<5; i++) {
        
        UIButton * btn = [UIButton buttonWithType:UIButtonTypeSystem];
        
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        [btn setTitle:ary[i] forState:UIControlStateNormal];
        
        btn.frame = CGRectMake(40, 40*i, APPLICATION_WIDTH-180-40, 40);
        
        btn.tag = 100+i;
        
        [btn addTarget:self action:@selector(selectTopic:) forControlEvents:UIControlEventTouchUpInside];
        
        [v addSubview:btn];
    }
    [self addSubview:v];
}
-(void)selectTopic:(UIButton *)btn{
    if (self.delegate&&[self.delegate respondsToSelector:@selector(chooseDelegateSelectTopic:)]) {
        [self.delegate chooseDelegateSelectTopic:btn];
    }
}
-(void)outOfChooseTopicView{
    if (self.delegate&&[self.delegate respondsToSelector:@selector(chooseDelegateOutOfChooseTopicView)]) {
        [self.delegate chooseDelegateOutOfChooseTopicView];
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
