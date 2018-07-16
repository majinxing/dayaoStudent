//
//  CalendarViewController.h
//  WisdomHall
//
//  Created by XTU-TI on 2018/1/17.
//  Copyright © 2018年 majinxing. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^returnTextBlock)(NSString * str);
@interface CalendarViewController : UIViewController
@property (nonatomic,copy)returnTextBlock returnTextBlock;
-(void)returnText:(returnTextBlock)block;
@end
