//
//  AlterView.m
//  WisdomHall
//
//  Created by XTU-TI on 2017/8/2.
//  Copyright © 2017年 majinxing. All rights reserved.
//

#import "AlterView.h"
#import "DYHeader.h"

@implementation AlterView
-(instancetype)initWithFrame:(CGRect)frame withLabelText:(NSString *)textStr{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self addContentViewWithLabelText:textStr];
    }
    return self;
}
-(instancetype)initWithFrame:(CGRect)frame withAlterStr:(NSString *)str{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.userInteractionEnabled = YES;
        
        self.layer.masksToBounds = YES;
        self.layer.borderWidth = 0.5;
        self.layer.borderColor = [UIColor blackColor].CGColor;
        self.layer.cornerRadius = 5;

        [self alterView:str];
    }
    return self;
}
-(void)addContentViewWithLabelText:(NSString *)textStr{
    UILabel * text = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height-40)];
    text.textAlignment = NSTextAlignmentCenter;
    text.font = [UIFont systemFontOfSize:20];
    text.text = textStr;
    text.textColor = [UIColor blackColor];
    [self addSubview:text];
    
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, CGRectGetMaxY(text.frame),self.frame.size.width, 40);
    [btn setTitle:@"确定" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor colorWithHexString:@"#29a7e1"] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:15];
    [btn addTarget:self action:@selector(removeSubView) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btn];
}
-(void)removeSubView{
    if (self.delegate&&[self.delegate respondsToSelector:@selector(alterViewDeleageRemove)]) {
        [self.delegate alterViewDeleageRemove];
    }
}
-(void)alterView:(NSString *)alterStr{
    UIView * witheat = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    witheat.backgroundColor = [UIColor whiteColor];
    [self addSubview:witheat];
    
    UILabel * alter1 = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, 200, 20)];
    alter1.text = @"急速签到失败";
    alter1.font = [UIFont systemFontOfSize:15];
    alter1.textColor = [UIColor redColor];
    alter1.userInteractionEnabled = YES;
    [witheat addSubview:alter1];
    
    UILabel * alter2 = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(alter1.frame)+20, 280, 20)];
    alter2.text = [NSString stringWithFormat:@"%@",alterStr];
    alter2.font = [UIFont systemFontOfSize:13];
    alter2.alpha = 0.5;
    alter2.userInteractionEnabled = YES;
    [witheat addSubview:alter2];
    
    UIButton * back = [UIButton buttonWithType:UIButtonTypeCustom];
    back.frame = CGRectMake(self.frame.size.width-40, 0,40,40);
    [back setTitle:@"×" forState:UIControlStateNormal];
    [back addTarget:self action:@selector(removeSubView) forControlEvents:UIControlEventTouchUpInside];
    [back setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    back.userInteractionEnabled = YES;
    [witheat addSubview:back];
    
  
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
