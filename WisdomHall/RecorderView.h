//
//  RecorderView.h
//  Recorder
//
//  Created by Japho on 15/10/15.
//  Copyright © 2015年 Japho. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RecorderView : UIView

@property (nonatomic, strong) NSString *myNewPath;//判断录音时间大于一秒的可用语音存储路径
@property (nonatomic, assign) int recordSecond;//录音时长
@property (nonatomic, assign) int index;
@property (nonatomic, strong) NSString *audioName;

- (void)showInView:(UIView *)view;
- (void)hide;

@end
