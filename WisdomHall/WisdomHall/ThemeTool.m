//
//  ThemeTool.m
//  WisdomHall
//
//  Created by XTU-TI on 2018/3/14.
//  Copyright © 2018年 majinxing. All rights reserved.
//

#import "ThemeTool.h"
#import "DYHeader.h"

@implementation ThemeTool
+(id)shareInstance{
    static dispatch_once_t onceToken;
    static ThemeTool *obj = nil;
    dispatch_once(&onceToken, ^{
        obj = [[ThemeTool alloc] init];
    });
    return obj;
}
//存取颜色的具体方法放在了 appseting.h
-(void)setThemeColor:(UIColor *)color{
    [[Appsetting sharedInstance] setThemeColor:color];
}
-(UIColor *)getThemeColor{
    UIColor * color = [[Appsetting sharedInstance] getThemeColor];
    return color;
}
@end














