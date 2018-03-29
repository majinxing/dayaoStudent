//
//  MJXRegionalViewController.h
//  XinSuiFang
//
//  Created by majinxing on 16/8/24.
//  Copyright © 2016年 majinxing. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, MJXLoginType)
{
    EUserCity = 0,
    EUserHospital = 1,
    EUserdepartment = 2,
    EUserPosition =3
};
typedef void (^ReturnTextBlock)(NSString *returnText);
@interface MJXRegionalViewController : UIViewController
@property (nonatomic,copy)NSString *type;
@property (nonatomic,strong)NSString *str;
@property (nonatomic, copy) ReturnTextBlock returnTextBlock;
- (void)returnText:(ReturnTextBlock)block;
//-(instancetype)initWithString:(NSString *)str;
@end
