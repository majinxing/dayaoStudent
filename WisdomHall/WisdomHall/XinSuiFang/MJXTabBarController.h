//
//  MJXTabBarController.h
//  XinSuiFang
//
//  Created by majinxing on 16/9/29.
//  Copyright © 2016年 majinxing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <RongIMLib/RongIMLib.h>

@interface MJXTabBarController : UITabBarController
@property (nonatomic,strong)RCMessage * message;
+ (MJXTabBarController *)sharedInstance;

@end
