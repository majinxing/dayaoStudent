//
//  ChooseTopicView.h
//  WisdomHall
//
//  Created by XTU-TI on 2018/5/2.
//  Copyright © 2018年 majinxing. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ChooseTopicViewDelegate <NSObject>

-(void)chooseDelegateSelectTopic:(UIButton *)btn;
-(void)chooseDelegateOutOfChooseTopicView;

@end
@interface ChooseTopicView : UIView

@property (nonatomic,weak)id<ChooseTopicViewDelegate>delegate;
@end
