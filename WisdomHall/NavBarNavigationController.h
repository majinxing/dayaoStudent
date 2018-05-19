//
//  NavBarNavigationController.h
//  WisdomHall
//
//  Created by XTU-TI on 2018/3/14.
//  Copyright © 2018年 majinxing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NavBarNavigationController : UINavigationController

@property (nonatomic,strong)NSTimer *showTimer;

+(NavBarNavigationController *)sharedInstance;

-(void)handleMaxShowTimer:(NSTimer *)theTimer;

-(void)outApp;
@end
