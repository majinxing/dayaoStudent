//
//  imageBigView.m
//  WisdomHall
//
//  Created by XTU-TI on 2018/3/24.
//  Copyright © 2018年 majinxing. All rights reserved.
//

#import "imageBigView.h"
#import "DYHeader.h"
#import "UIImageView+WebCache.h"

@implementation imageBigView
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}
-(void)addImageView:(NSString *)str{
    UIImageView * image = [[UIImageView alloc] initWithFrame:CGRectMake(10,80, APPLICATION_WIDTH-20, APPLICATION_HEIGHT-64-20)];
    
    UserModel * user = [[Appsetting sharedInstance] getUsetInfo];
    
    NSString * baseUrl = user.host;
    
    [image sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@?resourceId=%@",baseUrl,FileDownload,str]] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
    
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 64, APPLICATION_WIDTH, APPLICATION_HEIGHT);
    [btn addTarget:self action:@selector(outView) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:image];
    
    [self addSubview:btn];
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
