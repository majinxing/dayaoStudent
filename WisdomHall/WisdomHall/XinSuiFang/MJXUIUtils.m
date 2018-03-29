//
//  MJXUIUtils.m
//  XinSuiFang
//
//  Created by majinxing on 16/8/15.
//  Copyright © 2016年 majinxing. All rights reserved.
//

#import "MJXUIUtils.h"

@implementation MJXUIUtils
+(UILabel *)setUIlableFrame:(CGRect)frame withText:(NSString *)text withTitleColor:(UIColor *)color withFont:(UIFont *)font{
    UILabel *lable=[[UILabel alloc] initWithFrame:frame];
    lable.text=text;
    lable.textColor=color;
    lable.font=font;
    return lable;
}
+(UIView *)setLineWithFrame:(CGRect)frame{
    UIView *lineOne = [[UIView alloc] initWithFrame:frame];
    lineOne.backgroundColor = [UIColor colorWithHexString:@"#e5e5e5"];
    return lineOne;
}
+(UITextField *)setTextFieldLabelWithFrame:(CGRect)frame withPlaceholder:(NSString *)str{
    UITextField *userPhone = [[UITextField alloc] initWithFrame:frame];
    userPhone.placeholder = str;
    userPhone.font = [UIFont systemFontOfSize:14];
    return userPhone;
}
+(void)addNavigationWithView:(UIView *)view withTitle:(NSString *)str{
    
    UIView *navigation = [[UIView alloc] initWithFrame:CGRectMake(0, 0,APPLICATION_WIDTH, 65)];
    navigation.backgroundColor=[UIColor whiteColor];
    [view addSubview:navigation];
    UILabel *title=[[UILabel alloc] initWithFrame:CGRectMake(APPLICATION_WIDTH/2.0-100,34,200, 20)];
    title.text=str;
    title.textColor=[UIColor colorWithHexString:@"#333333"];
    title.font=[UIFont systemFontOfSize:17];
    title.textAlignment=NSTextAlignmentCenter;
    UIView *line=[[UIView alloc] initWithFrame:CGRectMake(0, 64, APPLICATION_WIDTH, 1)];
    line.backgroundColor=[UIColor colorWithHexString:@"#e5e5e5"];
    [view addSubview:line];
    [view addSubview:title];
}
//电话正则表达式
+(BOOL)isSimplePhone:(NSString *)phone{
    NSString *phoneRegex = @"^1[0-9]\\d{9}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
    return [phoneTest evaluateWithObject:phone];
}
+(void)show404WithDelegate:(id)delegate{
    UIAlertView *alertView = [[UIAlertView alloc]
                              initWithTitle:@"网络连接失败"
                              message:nil
                              delegate:delegate
                              cancelButtonTitle:nil
                              otherButtonTitles:@"我知道了", nil];
    [alertView show];
    
}
+(UIImage *)scaleImage:(UIImage *)image toScale:(float)scaleSize{
    
    UIGraphicsBeginImageContext(CGSizeMake(image.size.width *scaleSize, image.size.height * scaleSize));
    [image drawInRect:CGRectMake(0, 0, image.size.width * scaleSize, image.size.height * scaleSize)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}
@end
