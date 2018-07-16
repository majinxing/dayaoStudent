//
//  MJXAppsettings.h
//  XinSuiFang
//
//  Created by majinxing on 16/8/11.
//  Copyright © 2016年 majinxing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJXUserModel.h"
@interface MJXAppsettings : NSObject
@property NSUserDefaults *mySettingData;

+(MJXAppsettings *)sharedInstance;
-(BOOL)isLogin;

-(BOOL)saveUserInfoWithName:(NSString *)name Phone:(NSString *)phone Hospital:(NSString *)hospital Department:(NSString *)department Position:(NSString *)position introduction:(NSString *)introduction Token:(NSString *)token;

-(void)sevaUserInfoWithDict:(NSDictionary *)dict;

-(MJXUserModel *)getUserInfo;

-(NSString *)getNewToken;

-(void)logOut;

-(void)saveUserInfoWithPhone:(NSString *)phone withToken:(NSString *)token;-(void)setUserPhone:(NSString *)Phone;

-(NSString *)getUserPhone;
-(void)setChatToken:(NSString *)token;
-(NSString *)getChatToken;
//-(void)sevaUserInfoWithDict:(NSDictionary *)dict;
@end
