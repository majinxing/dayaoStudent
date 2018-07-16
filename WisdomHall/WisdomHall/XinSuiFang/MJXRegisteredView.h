//
//  MJXRegisteredView.h
//  XinSuiFang
//
//  Created by majinxing on 16/8/15.
//  Copyright © 2016年 majinxing. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol MJXRegisteredViewDelegate <NSObject>
-(void)registeredViewVerificationCodeButtonPressed;
-(void)registeredViewNextbuttonPressed;

@end

@interface MJXRegisteredView : UIView
@property (nonatomic,strong) UITextField *userPhone;
@property (nonatomic,strong) UITextField *VerificationCode;
@property (nonatomic,strong) UITextField *password;
@property (nonatomic,strong) UIButton *VerificationCodeButton;
@property (nonatomic,strong) UITextField * name;

@property (nonatomic,weak) id <MJXRegisteredViewDelegate>delegate;

@end
