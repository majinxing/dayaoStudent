//
//  MJXUserLoginView.h
//  XinSuiFang
//
//  Created by majinxing on 16/8/12.
//  Copyright © 2016年 majinxing. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MJXUserLoginViewDeleate <NSObject>
-(void)userLoginViewLoginButtonPressed;
-(void)userLoginViewRegisteredButtonPressed;
-(void)userLoginViewForgetPasswordButtonPresssed;

@end
//NS_ASSUME_NONNULL_BEGIN
@interface MJXUserLoginView : UIView
@property (nonatomic,weak) id <MJXUserLoginViewDeleate> delegate;

@property (nonatomic,strong)UITextField *a;
@property (nonatomic,strong)UITextField *userPhone;
@property (nonatomic,strong)UITextField *passWord;
@property (nonatomic,strong)UITextField * name;
@end
