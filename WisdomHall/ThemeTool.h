//
//  ThemeTool.h
//  WisdomHall
//
//  Created by XTU-TI on 2018/3/14.
//  Copyright © 2018年 majinxing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DYHeader.h"

@interface ThemeTool : NSObject
+(id)shareInstance;
//设置主题色
-(void)setThemeColor:(UIColor *)color;
//获取主题色
-(UIColor *)getThemeColor;
@end
