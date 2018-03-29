//
//  MJXUIUtils.h
//  XinSuiFang
//
//  Created by majinxing on 16/8/15.
//  Copyright © 2016年 majinxing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MJXUIUtils : NSObject
+(UILabel *)setUIlableFrame:(CGRect) frame withText:(NSString *)text withTitleColor:(UIColor *)color withFont:(UIFont *)font;
+(UIView *)setLineWithFrame:(CGRect)frame;
+(UITextField *)setTextFieldLabelWithFrame:(CGRect)frame withPlaceholder:(NSString *)str;
+(void)addNavigationWithView:(UIView *)view withTitle:(NSString *)str;
+(BOOL)isSimplePhone:(NSString *)phone;
/**
 * 网络连接失败
 */
+(void)show404WithDelegate:(id)delegate;
/**
 * 图片缩小
 **/
+(UIImage *)scaleImage:(UIImage *)image toScale:(float)scaleSize;
@end
