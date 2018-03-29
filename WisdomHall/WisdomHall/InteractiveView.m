//
//  InteractiveView.m
//  WisdomHall
//
//  Created by XTU-TI on 2017/5/4.
//  Copyright © 2017年 majinxing. All rights reserved.
//

#import "InteractiveView.h"
#import "DYHeader.h"
@implementation InteractiveView
- (instancetype) initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self addButton];
    }
    return self;
}
-(void)addButton{
    UIButton * outViewbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    outViewbtn.frame = CGRectMake(0, 0, APPLICATION_WIDTH, APPLICATION_HEIGHT);
    [outViewbtn addTarget:self action:@selector(outViewBtnPressed) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:outViewbtn];
    

}

#pragma mark InteractiveViewDelegate
-(void)outViewBtnPressed{
    if (self.delegate&&[self.delegate respondsToSelector:@selector(interactiveViewDelegateOutViewBtnPressed)]) {
        [self.delegate interactiveViewDelegateOutViewBtnPressed];
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
