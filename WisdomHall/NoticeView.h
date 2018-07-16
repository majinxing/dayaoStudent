//
//  NoticeView.h
//  WisdomHall
//
//  Created by XTU-TI on 2018/7/4.
//  Copyright © 2018年 majinxing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NoticeModel.h"

@protocol NoticeViewDelegate<NSObject>
-(void)shareButtonClickedDelegate:(NSString *)str;
@end
@interface NoticeView : UIView
@property (nonatomic,weak)id<NoticeViewDelegate>delegate;
-(void)addContentView:(NoticeModel *)noticeModel;
@end
