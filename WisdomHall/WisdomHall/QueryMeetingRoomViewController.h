//
//  QueryMeetingRoomViewController.h
//  WisdomHall
//
//  Created by XTU-TI on 2017/8/11.
//  Copyright © 2017年 majinxing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SeatIngModel.h"

typedef void (^ReturnTextBlock)(SeatIngModel *returnText);

@interface QueryMeetingRoomViewController : UIViewController

@property (nonatomic, copy) ReturnTextBlock returnTextBlock;

- (void)returnText:(ReturnTextBlock)block;

@end
