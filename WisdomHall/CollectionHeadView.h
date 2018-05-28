//
//  CollectionHeadView.h
//  WisdomHall
//
//  Created by XTU-TI on 2017/6/1.
//  Copyright © 2017年 majinxing. All rights reserved.
//collect 的头部视图

#import <UIKit/UIKit.h>
#import "NoticeModel.h"

@protocol CollectionHeadViewDelegate <NSObject>
-(void)noticeBtnPressedDelegate:(NoticeModel *)notice;
@end
@interface CollectionHeadView : UIView
@property (nonatomic,weak)id<CollectionHeadViewDelegate>delegate;
+(CollectionHeadView *)sharedInstance;
-(void)getData;
-(void)onceSetNil;
@end
