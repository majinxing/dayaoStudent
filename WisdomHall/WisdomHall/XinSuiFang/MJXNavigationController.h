//
//  MJXNavigationController.h
//  XinSuiFang
//
//  Created by majinxing on 16/8/9.
//  Copyright © 2016年 majinxing. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol MJXNavigationControllerDelegate <NSObject>
@optional
-(void)onViewPopup: (nullable UIViewController *)popView;
@end

@interface MJXNavigationController : UINavigationController<UINavigationControllerDelegate,UIGestureRecognizerDelegate>
@property (nonatomic, weak, nullable) id <MJXNavigationControllerDelegate> MJXNavdelegate;
@end
