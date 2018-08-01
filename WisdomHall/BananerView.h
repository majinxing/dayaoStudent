//
//  BananerView.h
//  WisdomHall
//
//  Created by XTU-TI on 2018/7/4.
//  Copyright © 2018年 majinxing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CollectionHeadView.h"

@interface BananerView : UIView
@property (nonatomic,strong)CollectionHeadView *collectionHeadView;

-(void)addContentView;
@end
