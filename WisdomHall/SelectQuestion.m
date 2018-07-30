//
//  SelectQuestion.m
//  WisdomHall
//
//  Created by XTU-TI on 2017/9/4.
//  Copyright © 2017年 majinxing. All rights reserved.
//

#import "SelectQuestion.h"
#import "DYHeader.h"

@interface SelectQuestion()<UIScrollViewDelegate>
@property(nonatomic,strong)UIScrollView * scrollView;
@property (nonatomic,strong)UIView * whiteView;
@end
@implementation SelectQuestion
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        UIButton * v = [UIButton buttonWithType:UIButtonTypeCustom];
        v.frame = CGRectMake(0, 0, APPLICATION_WIDTH, APPLICATION_HEIGHT);
        v.backgroundColor = [UIColor blackColor];
        v.alpha = 0.3;
        [v addTarget:self action:@selector(outView) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:v];
    }
    return self;
}
-(void)addScrollViewWithBtnNumber:(int)n{
    if (!_whiteView) {
        _whiteView = [[UIView alloc] initWithFrame:CGRectMake(0, APPLICATION_HEIGHT/3*2, APPLICATION_WIDTH, APPLICATION_HEIGHT/3)];
    }
    _whiteView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_whiteView];
    
    UILabel * titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 20, 80, 20)];
    titleLabel.text = @"题目列表";
    [_whiteView addSubview:titleLabel];
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 44, APPLICATION_WIDTH, APPLICATION_HEIGHT/3-44)];
    
    _scrollView.delegate = self;
    
    _scrollView.showsVerticalScrollIndicator = NO;
    
    _scrollView.pagingEnabled = YES;
    
    _scrollView.backgroundColor = [UIColor whiteColor];
    
    [_whiteView addSubview:_scrollView];
    
    int m = (APPLICATION_WIDTH-40)/40;
    
    int z = n/m;
    
    if (z==0) {
        z=1;
    }
    
    for (int i = 0; i<z; i++) {
        int  x ;
        if (n-m*(i+1)>0) {
            x = m;
        }else{
            x = n - m*i;
        }
        for (int j = 0; j<x; j++) {
            UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(40*j+20, i*40+5, 30, 30);
            [btn setTitle:[NSString stringWithFormat:@"%d",(m*i)+j+1] forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [btn setBackgroundColor:RGBA_COLOR(149, 160, 160, 1)];
            btn.layer.masksToBounds = YES;
            btn.layer.cornerRadius = 15;
            btn.tag = (m*i)+j+1;
            
            [btn addTarget:self action:@selector(selectEd:) forControlEvents:UIControlEventTouchUpInside];
            
            [_scrollView addSubview:btn];
        }
    }
    if ((40*z)>(APPLICATION_HEIGHT/3-44)) {
            _scrollView.contentSize =CGSizeMake(APPLICATION_WIDTH,40*z);
    }else{
        _scrollView.contentSize =CGSizeMake(APPLICATION_WIDTH,APPLICATION_HEIGHT/3-44);
    }
}
-(void)selectEd:(UIButton *)btn{
    if (self.delegate&&[self.delegate respondsToSelector:@selector(selectEdDelegate:)]) {
        [self.delegate selectEdDelegate:btn];
    }
}
-(void)outView{
    if (self.delegate&&[self.delegate respondsToSelector:@selector(selectQViewOutViewDelegate)]) {
        [self.delegate selectQViewOutViewDelegate];
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
