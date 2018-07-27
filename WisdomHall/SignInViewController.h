//
//  SignInViewController.h
//  WisdomHall
//
//  Created by XTU-TI on 2017/4/24.
//  Copyright © 2017年 majinxing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SignInViewController : UIViewController
@property (nonatomic,strong)UIViewController * selfNavigationVC;

@property (nonatomic,copy)NSString * monthStr;

@property (nonatomic,strong)NSDictionary * dictDay;

@property (nonatomic,strong)NSMutableArray * weekDayTime;

@end
