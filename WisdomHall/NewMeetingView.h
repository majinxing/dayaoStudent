//
//  NewMeetingView.h
//  WisdomHall
//
//  Created by XTU-TI on 2018/7/4.
//  Copyright © 2018年 majinxing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MeetingModel.h"
#import "ClassModel.h"

@protocol NewMeetingViewDelegate<NSObject>
-(void)intoMeetingBtnPressedDelegate:(MeetingModel *)meetingModel;
-(void)intoClassBtnPressedDelegate:(ClassModel *)classModel;

@end
@interface NewMeetingView : UIView

@property (nonatomic,weak)id<NewMeetingViewDelegate>delegate;

-(void)addContentView:(MeetingModel *)meetingModel;
-(void)addContentClassView:(ClassModel *)classModel;

@end
