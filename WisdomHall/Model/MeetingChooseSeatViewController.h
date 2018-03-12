//
//  MeetingChooseSeatViewController.h
//  WisdomHall
//
//  Created by XTU-TI on 2017/8/12.
//  Copyright © 2017年 majinxing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MeetingChooseSeatViewController : UIViewController
@property (nonatomic,copy)NSString * seatTable;//座次表
@property (nonatomic,copy)NSString * seat;//座位号
@property (nonatomic,assign)int allPeopleNumber;//参加会议的人数
@end
