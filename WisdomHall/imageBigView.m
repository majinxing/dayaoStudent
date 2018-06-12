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
        self.backgroundColor = [UIColor  blackColor];
        
        _backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, APPLICATION_WIDTH, APPLICATION_HEIGHT)];
        
        _backView.backgroundColor = [UIColor clearColor];
        
        [self addSubview:_backView];
        // 缩放手势
        _imageview = [[UIImageView alloc] init];
        
        self.imageview.userInteractionEnabled = YES;
        _backView.userInteractionEnabled = YES;
        
        UIPinchGestureRecognizer *pinchGestureRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchView:)];
        
        [_backView addGestureRecognizer:pinchGestureRecognizer];
        
        // 移动手势
        
        UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panView:)];
        
        [_backView addGestureRecognizer:panGestureRecognizer];
        
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapGesture:)];
        [_backView addGestureRecognizer:singleTap];
    }
    return self;
}
#pragma mark - 手势识别响应方法

// 单击手势
- (void)singleTapGesture:(UITapGestureRecognizer *)gesture {
    
    [self outView];
}
// 处理缩放手势

- (void) pinchView:(UIPinchGestureRecognizer *)pinchGestureRecognizer

{
    
    UIView *view = pinchGestureRecognizer.view;
//    UIView * view1 = [[UIView alloc] initWithFrame:view.frame];
    
    if (pinchGestureRecognizer.state == UIGestureRecognizerStateBegan || pinchGestureRecognizer.state == UIGestureRecognizerStateChanged)
        
    {
        if (view.frame.size.width*pinchGestureRecognizer.scale>APPLICATION_WIDTH) {
            
            view.transform = CGAffineTransformScale(view.transform, pinchGestureRecognizer.scale, pinchGestureRecognizer.scale);
            if (view.frame.origin.x>0) {
                view.frame = CGRectMake(0, view.frame.origin.y, view.frame.size.width, view.frame.size.height);
            }
            if (view.frame.origin.y>0) {
                view.frame = CGRectMake(view.frame.origin.x, 0, view.frame.size.width, view.frame.size.height);
            }
            if ((view.frame.origin.x+view.frame.size.width)<APPLICATION_WIDTH) {
                view.frame = CGRectMake(APPLICATION_WIDTH-view.frame.size.width, view.frame.origin.y, view.frame.size.width, view.frame.size.height);
            }
            if ((view.frame.origin.y+view.frame.size.height)<APPLICATION_HEIGHT) {
                view.frame = CGRectMake(view.frame.origin.x, APPLICATION_HEIGHT-view.frame.size.height, view.frame.size.width, view.frame.size.height);
            }
            pinchGestureRecognizer.scale = 1;
            
        }else if (pinchGestureRecognizer.scale>1){
            view.transform = CGAffineTransformScale(view.transform, pinchGestureRecognizer.scale, pinchGestureRecognizer.scale);
            
            pinchGestureRecognizer.scale = 1;
        }
    }
}
// 处理拖拉手势

- (void) panView:(UIPanGestureRecognizer *)panGestureRecognizer

{
    
    UIView *view = panGestureRecognizer.view;
    
    if (panGestureRecognizer.state == UIGestureRecognizerStateBegan || panGestureRecognizer.state == UIGestureRecognizerStateChanged)
        
    {
        
        CGPoint translation = [panGestureRecognizer translationInView:view.superview];
        
        if ((view.frame.origin.x + translation.x*1.2+view.frame.size.width)>APPLICATION_WIDTH&&(view.frame.origin.y + translation.y*1.2+view.frame.size.height)>APPLICATION_HEIGHT) {
            
            if ((view.frame.origin.x + translation.x*1.2)<=0&&(view.frame.origin.y + translation.y*1.2)<=0) {
                
                [view setCenter:(CGPoint){view.center.x + translation.x*1.2, view.center.y + translation.y*1.2}];
                
                [panGestureRecognizer setTranslation:CGPointZero inView:view.superview];
            }
            
        }
    }
}

-(void)addImageView:(NSString *)str{
    
    UserModel * user = [[Appsetting sharedInstance] getUsetInfo];
    
    NSString * baseUrl = user.host;
    
//    _imageview = [[UIImageView alloc] init];//WithFrame:CGRectMake(10,40, APPLICATION_WIDTH-20, self.frame.size.height- 80)];

    [_imageview sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@?resourceId=%@",baseUrl,FileDownload,str]] placeholderImage:[UIImage imageNamed:@"addImage"]];
    
    double n = (double)_imageview.image.size.height/(double)_imageview.image.size.width;
    if (n<1) {
        _imageview.frame = CGRectMake(10, _backView.frame.size.height/2-(APPLICATION_WIDTH-20)*n/2, APPLICATION_WIDTH-20, (APPLICATION_WIDTH-20)*n);
    }else if (n == 1){
        _imageview.frame = CGRectMake(10, 40, APPLICATION_WIDTH-20, APPLICATION_WIDTH-20);
    }else{
        _imageview.frame = CGRectMake(APPLICATION_WIDTH/2-(self.frame.size.height- 140)/n/2, 20, (self.frame.size.height- 140)/n, self.frame.size.height- 140);
    }
//    _imageview.frame = CGRectMake(10, _backView.frame.size.height/2-(APPLICATION_WIDTH-20)*n/2, APPLICATION_WIDTH-20, (APPLICATION_WIDTH-20)*n);
    
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    btn.frame = CGRectMake(self.frame.size.width-40, 0,40, 40);
    
    [btn setBackgroundImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
    
    [btn addTarget:self action:@selector(outView) forControlEvents:UIControlEventTouchUpInside];
    
    [_backView addSubview:_imageview];
    
//    [self addSubview:btn];
}
-(void)addImageViewWithImage:(UIImage  *)image1{
    
//    _imageview = [[UIImageView alloc] init];//WithFrame:CGRectMake(10,40, APPLICATION_WIDTH-20, self.frame.size.height- 80)];
    if (!image1) {
        _imageview.image = [UIImage imageNamed:@"addImage"];
    }else{
        _imageview.image = image1;
    }
    
    double n = _imageview.image.size.height/_imageview.image.size.width;
    if (n<1) {
       _imageview.frame = CGRectMake(10, _backView.frame.size.height/2-(APPLICATION_WIDTH-20)*n/2, APPLICATION_WIDTH-20, (APPLICATION_WIDTH-20)*n);
    }else if (n == 1){
        _imageview.frame = CGRectMake(10, _backView.frame.size.height/2-(APPLICATION_WIDTH-20)*n/2, APPLICATION_WIDTH-20, APPLICATION_WIDTH-20);
    }else{
        _imageview.frame = CGRectMake(APPLICATION_WIDTH/2-(self.frame.size.height- 140)/n/2,10, (self.frame.size.height- 140)/n, self.frame.size.height- 140);
    }
    
    
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    btn.frame = CGRectMake(self.frame.size.width-40, 0,40, 40);
    
    [btn addTarget:self action:@selector(outView) forControlEvents:UIControlEventTouchUpInside];
    
    [btn setBackgroundImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
    

    [_backView addSubview:_imageview];
    
    [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];

//    [self addSubview:btn];
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
