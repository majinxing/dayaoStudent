//
//  CorrectAnswer.m
//  WisdomHall
//
//  Created by XTU-TI on 2018/5/7.
//  Copyright © 2018年 majinxing. All rights reserved.
//

#import "CorrectAnswer.h"
#import "DYHeader.h"

@implementation CorrectAnswer
-(instancetype)init{
    self = [super init];
    if (self) {
        _textView = [[UITextView alloc] init];
        
        _textView.backgroundColor = [UIColor clearColor];
        
        _scoreLabel = [[UILabel alloc] init];
        
        UIView * b = [[UIView alloc ] initWithFrame:CGRectMake(0, 0, APPLICATION_WIDTH, APPLICATION_HEIGHT)];
        
        b.backgroundColor = [UIColor blackColor];
        
        b.alpha = 0.5;
        
        [self addSubview:b];
        
        [self addSubview:_textView];
        
        [self addSubview:_scoreLabel];
        
    }
    return self;
}
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView *hitView = nil;
    return hitView;

//    NSLog(@"进入B_View---hitTest withEvent ---");
//    UIView * view = [super hitTest:point withEvent:event];
//    NSLog(@"离开B_View---hitTest withEvent ---hitTestView:%@",view);
//    if (!self.isUserInteractionEnabled || self.isHidden || self.alpha <= 0.01)
//    {
//        return nil;
//
//    }
//    if ([self pointInside:point withEvent:event])
//    {
//        for (UIView *subview in [self.subviews reverseObjectEnumerator]) {
//
//        CGPoint convertedPoint = [subview convertPoint:point fromView:self];
//
//        UIView *hitTestView = [subview hitTest:convertedPoint withEvent:event];
//
//        if (hitTestView) {
//
//            return hitTestView;
//
//        }
//
//    }
//        return self;
//
//    }
//    return nil;
//
//
//    return view;
}

- (BOOL)pointInside:(CGPoint)point withEvent:(nullable UIEvent *)event {
    NSLog(@"B_view---pointInside withEvent ---");
    BOOL isInside = [super pointInside:point withEvent:event];
    NSLog(@"B_view---pointInside withEvent --- isInside:%d",isInside);
    return isInside;
}
-(void)addContentView:(NSString *)correctAnswer withScore:(NSString *)score{
    
    float h = [self returnTextHeight:correctAnswer];
    
    _textView.frame = CGRectMake(10, 20, APPLICATION_WIDTH-20, h);
    
    _textView.textAlignment = NSTextAlignmentCenter;
    
    _textView.textColor = [UIColor colorWithHexString:@"#01ff1b"];
    
//    if (![UIUtils isBlankString:correctAnswer]) {
    _textView.text = [NSString stringWithFormat:@"正确答案：%@",correctAnswer];;
//    }
    _textView.scrollEnabled = NO;
    
    _textView.font = [UIFont systemFontOfSize:30];
    
    
    _scoreLabel.frame = CGRectMake(0, CGRectGetMaxY(_textView.frame)+10, APPLICATION_WIDTH, 20);
    
    _scoreLabel.textAlignment = NSTextAlignmentCenter;
    
    _scoreLabel.text = [NSString stringWithFormat:@"得分：%@",score];
    
    [_scoreLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:25]];
    
    _scoreLabel.font = [UIFont systemFontOfSize:30];
    
    _scoreLabel.textColor = [UIColor colorWithHexString:@"#FF0033"];
    
}
-(float)returnTextHeight:(NSString *)str{
    UITextView * textView = [[UITextView alloc] init];
    
    textView.text = str;
    
    CGSize size = CGSizeMake( APPLICATION_WIDTH-10-10, CGFLOAT_MAX);
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:30],NSFontAttributeName, nil];
    
    CGFloat curheight = [textView.text boundingRectWithSize:size
                                                    options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                                 attributes:dic
                                                    context:nil].size.height;
    
    if (curheight<50) {
        return 50;
    }
    return curheight+20;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
