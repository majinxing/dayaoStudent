//
//  DYTabBarViewController.h
//  WisdomHall
//
//  Created by XTU-TI on 2017/4/24.
//  Copyright © 2017年 majinxing. All rights reserved.
//

#import <UIKit/UIKit.h>

static dispatch_once_t predicate;

@interface DYTabBarViewController : UITabBarController

+ (DYTabBarViewController *)sharedInstance;
-(void)attempDealloc;
@end
