//
//  SynchronousCourseView.h
//  WisdomHall
//
//  Created by XTU-TI on 2018/3/23.
//  Copyright © 2018年 majinxing. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol SynchronousCourseViewDelegate<NSObject>
-(void)outViewDelegate;
-(void)submitDelegateWithAccount:(NSString *)count withPassword:(NSString *)password;
@end

@interface SynchronousCourseView : UIView
@property (nonatomic,weak)id<SynchronousCourseViewDelegate>delegate;
@end
