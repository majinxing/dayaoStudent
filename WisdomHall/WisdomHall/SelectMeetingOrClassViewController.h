//
//  SelectMeetingOrClassViewController.h
//  WisdomHall
//
//  Created by XTU-TI on 2017/7/4.
//  Copyright © 2017年 majinxing. All rights reserved.
//

#import <UIKit/UIKit.h>


/**
 *  查询数据的类型
 **/
typedef enum {
    SelectMeeting,
    SelectClass,
}SelectMeetOrClass;
@interface SelectMeetingOrClassViewController : UIViewController
@property (nonatomic,assign) SelectMeetOrClass selectType;
@end
