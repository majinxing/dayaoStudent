//
//  HomeButtonView.h
//  WisdomHall
//
//  Created by XTU-TI on 2018/7/4.
//  Copyright © 2018年 majinxing. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HomeButtonViewDelegate<NSObject>
-(void)shareButtonClickedDelegate:(NSString *)str;
@end
@interface HomeButtonView : UIView
@property (nonatomic,weak)id<HomeButtonViewDelegate>delegate;
-(void)addContentView;
@end
