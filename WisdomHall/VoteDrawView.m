//
//  VoteDrawView.m
//  WisdomHall
//
//  Created by XTU-TI on 2017/6/8.
//  Copyright © 2017年 majinxing. All rights reserved.
//

#import "VoteDrawView.h"
#import "DYHeader.h"

// 颜色RGB
#define zzColor(r, g, b)  [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
#define zzColorRGBA(r, g, b, a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:a]
// 随机色
#define zzRandomColor  zzColor(arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256))
#define origin 10
#define originH 50
#define withVote 25
@implementation VoteDrawView

-(void)drawZB:(NSArray *)x withAllPeople:(NSString *)peopleNumber{
    
    CAShapeLayer * layer = [CAShapeLayer layer];
    UIBezierPath * path = [UIBezierPath bezierPath];
    
    //坐标原点
    CGPoint  rPoint = CGPointMake(origin, originH);
    
    //画x轴
    [path moveToPoint:rPoint];
    
    [path addLineToPoint:CGPointMake(origin, self.frame.size.height-120)];
    
    //画x箭头
    [path moveToPoint:CGPointMake(origin, self.frame.size.height-120)];
    
    [path addLineToPoint:CGPointMake(origin-5, self.frame.size.height-120-5)];
    
    [path moveToPoint:CGPointMake(origin, self.frame.size.height-120)];
    
    [path addLineToPoint:CGPointMake(origin+5, self.frame.size.height-120-5)];
    
    //画y轴
    [path moveToPoint:rPoint];
    
    [path addLineToPoint:CGPointMake(APPLICATION_WIDTH-50, originH)];
    
    //画y轴箭头
    [path moveToPoint:CGPointMake(APPLICATION_WIDTH-50, originH)];
    [path addLineToPoint:CGPointMake(APPLICATION_WIDTH-50-5, originH-5)];
    [path moveToPoint:CGPointMake(APPLICATION_WIDTH-50,originH)];
    [path addLineToPoint:CGPointMake(APPLICATION_WIDTH-50-5, originH+5)];
    
    
    //画y轴标注
    for (int i = 0; i<11; i++) {
        [path moveToPoint:CGPointMake(origin+withVote*i,originH)];
        [path addLineToPoint:CGPointMake(origin+withVote*i,originH+3)];
    }
    //画x轴标注
    for (int i = 0; i<x.count; i++) {
        [path moveToPoint:CGPointMake(origin,originH+30*i)];
        [path addLineToPoint:CGPointMake(origin+3,originH+30*i)];
    }
    
    layer.path = path.CGPath;
    
    layer.fillColor = [UIColor clearColor].CGColor;
    
    layer.strokeColor = [UIColor grayColor].CGColor;
    
    layer.lineWidth = 2.0;
    
    [self.layer addSublayer:layer];
//
//    long n = peopleNumber.length;
//    
//    double m = [peopleNumber intValue];
//    
//    if (n==1) {
//        n=2;
//        
//    }
//    int aa = pow(10, (n-1));
//    
//    m = m/aa;
//    
//    if (m==0) {
//        m = 1;
//    }
//    //给y轴加标注
//    for (int i = 0; i<11;i++) {
//        UILabel * lab = [[UILabel alloc] initWithFrame:CGRectMake(origin+withVote*i-12.5, originH-20, withVote, 20)];
//        lab.text = [NSString stringWithFormat:@"%.1f",(int)(pow(10, (n-2))*i)*m];
//        lab.textColor = [UIColor blackColor];
//        lab.font = [UIFont boldSystemFontOfSize:9];
//        lab.textAlignment = NSTextAlignmentCenter;
//        lab.alpha = 0.5;
//        [self addSubview:lab];
//    }
//    
}
-(void)drawZhuZhuangtu:(NSArray *)x and:(NSArray *)y withAllPeople:(NSString *)people{
    
    [self initDrawView];
    
    [self drawZB:x withAllPeople:people];
    // 画柱状图
    for (int i=0; i<x.count; i++) {
        
        UIBezierPath * path = [UIBezierPath bezierPathWithRect:CGRectMake(origin,originH+30*(2*i+1),[y[i] floatValue]/[people floatValue]*250,30)];
        
        CAShapeLayer * layer = [CAShapeLayer layer];
        
        layer.path = path.CGPath;
        
        layer.fillColor = zzRandomColor.CGColor;
        
        layer.strokeColor = [UIColor clearColor].CGColor;
        
        [self.layer addSublayer:layer];
        
    }
    //给x轴加标注
    for (int i = 0; i<x.count; i++) {
        UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake([y[i] floatValue]/[people floatValue]*250+25,originH+30*(2*i+1),APPLICATION_WIDTH - ([y[i] floatValue]/[people floatValue]*250+25), 20)];
        
        lab.text = [NSString stringWithFormat:@"%@票%@",y[i],x[i]];
        
        lab.font = [UIFont systemFontOfSize:9];
        
        [self addSubview:lab];
        
    }
    
}
- (void)initDrawView{
    
    [self.layer.sublayers makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
    
    //    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
