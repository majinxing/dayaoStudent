//
//  InteractiveView.h
//  WisdomHall
//
//  Created by XTU-TI on 2017/5/4.
//  Copyright © 2017年 majinxing. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol InteractiveViewdDelegate <NSObject>
-(void)interactiveViewDelegateOutViewBtnPressed;


@end
@interface InteractiveView : UIView
@property (nonatomic,weak) id<InteractiveViewdDelegate> delegate;
@end
