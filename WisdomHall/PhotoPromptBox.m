//
//  PhotoPromptBox.m
//  WisdomHall
//
//  Created by XTU-TI on 2018/1/2.
//  Copyright © 2018年 majinxing. All rights reserved.
//

#import "PhotoPromptBox.h"
#import "DYHeader.h"

@interface PhotoPromptBox()
@property (nonatomic,copy)void(^backViewBlack)(NSString *);
@property (nonatomic,copy)void(^tackPictureBlack)(NSString *);
@end
@implementation PhotoPromptBox

- (instancetype)initWithBlack:(void(^)(NSString *))backViewBlack WithTakePictureBlack:(void(^)(NSString *))tackPictureBlack
{
    self = [super init];
    if (self) {
        self.backViewBlack = backViewBlack;
        self.tackPictureBlack = tackPictureBlack;
        [self addCotentView];
    }
    return self;
}
-(instancetype)init{
    self = [super init];
    if (self) {
//        self.backViewBlack = backViewBlack;
//        self.tackPictureBlack = tackPictureBlack;
        [self addCotentView];
    }
    return self;
    
}
-(void)addCotentView{
    UIButton * blackView = [UIButton buttonWithType:UIButtonTypeCustom];
    blackView.frame = CGRectMake(0, 0,APPLICATION_WIDTH, APPLICATION_HEIGHT);
    blackView.backgroundColor = [UIColor blackColor];
    blackView.alpha = 0.4;
    [blackView addTarget:self action:@selector(outView) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:blackView];
    
    UIView * white = [[UIView alloc] initWithFrame: CGRectMake(APPLICATION_WIDTH/2-140, 200, 280, 200)];
    white.backgroundColor = [UIColor whiteColor];
    [self addSubview:white];
    
    UIImageView * signComplete = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"signSuccess"]];
    signComplete.frame = CGRectMake(280/2-30, 10, 60, 60);
    [white addSubview:signComplete];
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(280/2-30, CGRectGetMaxY(signComplete.frame)+15, 60, 20)];
    label.text = @"签到完成";
    label.textColor = RGBA_COLOR(92, 156, 130, 1);
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:14];
    [white addSubview:label];
    
    UIButton * picture = [UIButton buttonWithType:UIButtonTypeCustom];
    picture.frame = CGRectMake(280/2-100, CGRectGetMaxY(label.frame)+15, 200, 40);
    [picture setTitle:@"拍摄本人照片" forState:UIControlStateNormal];
    [picture addTarget:self action:@selector(takePictureBtn) forControlEvents:UIControlEventTouchUpInside];
    picture.backgroundColor = [UIColor colorWithHexString:@"#29a7e1"];
    [white addSubview:picture];
    
    UILabel * reminder = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(picture.frame)+15, 280, 20)];
    reminder.textAlignment = NSTextAlignmentCenter;
    reminder.textColor = [UIColor redColor];
    reminder.text = @"注意：必须拍摄以教室为背景的本人照片";
    reminder.font = [UIFont systemFontOfSize:14];
    [white addSubview:reminder];
    
    UIButton * outViewBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    outViewBtn.frame = CGRectMake(240, 0, 40, 40);
    [outViewBtn setTitle:@"×" forState:UIControlStateNormal];
    [outViewBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [outViewBtn addTarget:self action:@selector(outView) forControlEvents:UIControlEventTouchUpInside];
    [white addSubview:outViewBtn];
}

-(void)outView{
    self.backViewBlack(@"outView");
}
-(void)takePictureBtn{
    self.tackPictureBlack(@"tackPicture");
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
