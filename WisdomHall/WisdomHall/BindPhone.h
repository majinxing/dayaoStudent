//
//  BindPhone.h
//  WisdomHall
//
//  Created by XTU-TI on 2017/10/14.
//  Copyright © 2017年 majinxing. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BindPhoneDelegate <NSObject>

-(void)bindPhoneBtnDelegate:(UIButton *)btn;
-(void)bindDelegate:(UIButton *)btn;
@end
@interface BindPhone : UIView
@property (nonatomic,weak)id<BindPhoneDelegate>delegate;
@property (nonatomic,copy)NSString * workNo;
@property (nonatomic,strong)UITextField * courseNumber;
-(void)addSecondContentView;
@end
