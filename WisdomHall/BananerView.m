//
//  BananerView.m
//  WisdomHall
//
//  Created by XTU-TI on 2018/7/4.
//  Copyright © 2018年 majinxing. All rights reserved.
//

#import "BananerView.h"


@interface BananerView()
@end

@implementation BananerView
-(instancetype)init{
    self = [super init];
    if (self) {
        
    }
    return self;
}
-(void)addContentView{
    UIImageView * image = [[UIImageView alloc] initWithFrame:self.frame];
    image.image = [UIImage imageNamed:@"banner"];
    [self addSubview:image];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
