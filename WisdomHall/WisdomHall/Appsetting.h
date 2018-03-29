//
//  Appsetting.h
//  WisdomHall
//
//  Created by XTU-TI on 2017/7/1.
//  Copyright © 2017年 majinxing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserModel.h"
#import "DYHeader.h"
#import "SchoolModel.h"


@interface Appsetting : NSObject
@property NSUserDefaults * mySettingData;
+(Appsetting *)sharedInstance;
-(void)sevaUserInfoWithDict:(NSDictionary *)dict withStr:(NSString *)p;
-(UserModel *)getUsetInfo;
-(BOOL)isLogin;
-(NSString *)getUserPhone;
-(void)getOut;
//获取其他的个人信息
-(void)saveUserOtherInfo:(NSDictionary *)dict;
//背景图片
-(void)saveImage:(NSString *)str;
-(NSString *)getImage;
//存储主题颜色
-(void)setThemeColor:(UIColor *)color;
//获取主题颜色
-(UIColor *)getThemeColor;
// 颜色 转字符串（16进制）
-(NSString*)toStrByUIColor:(UIColor*)color;
//改变切图颜色
-(UIImage*)grayscale:(UIImage*)anImage;
//获取学校数据
-(SchoolModel *)getUserSchool;
//存储学校数据
-(void)saveUserSchool:(SchoolModel *)school;
@end