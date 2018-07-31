//
//  BananerView.m
//  WisdomHall
//
//  Created by XTU-TI on 2018/7/4.
//  Copyright © 2018年 majinxing. All rights reserved.
//

#import "BananerView.h"
#import "CollectionHeadView.h"

@interface BananerView()
@property (nonatomic,strong)CollectionHeadView *collectionHeadView;

@end

@implementation BananerView
-(instancetype)init{
    self = [super init];
    if (self) {
        
    }
    return self;
}
-(void)addContentView{
    _collectionHeadView = [[CollectionHeadView alloc] init];
    _collectionHeadView.frame = CGRectMake(0,0, APPLICATION_WIDTH,APPLICATION_HEIGHT/4);
    
    [_collectionHeadView getBananerViewData];
    
    [self addSubview:_collectionHeadView];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
