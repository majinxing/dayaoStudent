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
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, APPLICATION_HEIGHT/2, APPLICATION_WIDTH, APPLICATION_HEIGHT/2)];
    
    _scrollView.delegate = self;
    
    _scrollView.showsVerticalScrollIndicator = NO;
    
    _scrollView.pagingEnabled = YES;
    
    _scrollView.backgroundColor = [UIColor whiteColor];
    
    [self addSubview:_scrollView];
    
    int m = APPLICATION_WIDTH/40;
    
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
            btn.frame = CGRectMake(40*j+5, i*40+5, 36, 36);
            [btn setTitle:[NSString stringWithFormat:@"%d",(m*i)+j+1] forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor colorWithHexString:@"#29a7e1"] forState:UIControlStateNormal];
            btn.layer.masksToBounds = YES;
            btn.layer.cornerRadius = 18;
            btn.layer.borderColor = [UIColor colorWithHexString:@"#29a7e1"].CGColor;
            btn.layer.borderWidth = 1;
            btn.tag = (m*i)+j+1;
            
            [btn addTarget:self action:@selector(selectEd:) forControlEvents:UIControlEventTouchUpInside];
            
            [_scrollView addSubview:btn];
        }
    }
    if ((40*z)>(APPLICATION_HEIGHT/2)) {
            _scrollView.contentSize =CGSizeMake(APPLICATION_WIDTH,40*z);
    }else{
        _scrollView.contentSize =CGSizeMake(APPLICATION_WIDTH,APPLICATION_HEIGHT/2);
    }
}
-(void)selectEd:(UIButton *)btn{
    if (self.delegate&&[self.delegate respondsToSelector:@selector(selectEdDelegate:)]) {
        [self.delegate selectEdDelegate:btn];
    }
}
-(void)outView{
    if (self.delegate&&[self.delegate respondsToSelector:@selector(outViewDelegate)]) {
        [self.delegate outViewDelegate];
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
