//
//  UIColor+HexString.h
//  XinSuiFang
//
//  Created by majinxing on 16/8/10.
//  Copyright © 2016年 majinxing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (HexString)
+ (UIColor *)colorWithHexString:(NSString *)hexString;
+ (UIColor *)colorWithHexString:(NSString *)hexString alpha:(CGFloat)alpha;

- (UIColor *)colorWithBrightness:(CGFloat)brightnessComponent;
@end
