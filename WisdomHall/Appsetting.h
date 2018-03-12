//
//  Appsetting.h
//  WisdomHall
//
//  Created by XTU-TI on 2017/7/1.
//  Copyright © 2017年 majinxing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserModel.h"

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
@end
