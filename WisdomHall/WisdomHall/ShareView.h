//
//  ShareView.h
//  WisdomHall
//
//  Created by XTU-TI on 2017/5/4.
//  Copyright © 2017年 majinxing. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol ShareViewDelegate <NSObject>
- (void)shareViewButtonClick:(NSString *)platform;

@end
@interface ShareView : UIView
@property (nonatomic, weak) id<ShareViewDelegate> delegate;
- (instancetype)initWithFrame:(CGRect)frame withType:(NSString *)type;
- (void)hide;
/**
 *  添加到视图
 *
 *  @param view 父视图
 */
- (void)showInView:(UIView *)view;

@end
