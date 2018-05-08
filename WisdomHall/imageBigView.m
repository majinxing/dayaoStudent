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
        _imageview = [[UIImageView alloc] initWithFrame:CGRectMake(10,40, APPLICATION_WIDTH-20, self.frame.size.height- 80)];
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}
-(void)addImageView:(NSString *)str{
    
    UserModel * user = [[Appsetting sharedInstance] getUsetInfo];
    
    NSString * baseUrl = user.host;
    
    [_imageview sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@?resourceId=%@",baseUrl,FileDownload,str]] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
    
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 64, APPLICATION_WIDTH, APPLICATION_HEIGHT);
    [btn addTarget:self action:@selector(outView) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:_imageview];
    
    [self addSubview:btn];
}
-(void)addImageViewWithImage:(UIImage  *)image1{
    
    
    _imageview.image = image1;
    
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 64, APPLICATION_WIDTH, APPLICATION_HEIGHT);
    [btn addTarget:self action:@selector(outView) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:_imageview];
    
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
