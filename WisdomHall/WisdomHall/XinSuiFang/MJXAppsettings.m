//
//  MJXAppsettings.m
//  XinSuiFang
//
//  Created by majinxing on 16/8/11.
//  Copyright © 2016年 majinxing. All rights reserved.
//

#import "MJXAppsettings.h"
#import "Utils.h"
@implementation MJXAppsettings
+ (MJXAppsettings *)sharedInstance
{
    static MJXAppsettings *sharedInstance = nil;
    if (sharedInstance == nil)
    {
        sharedInstance = [[MJXAppsettings alloc] init];
    }
    
    return sharedInstance;
}
//本地化初始化
-(instancetype)init
{
    self = [super init];
    if(self)
    {
        _mySettingData = [NSUserDefaults standardUserDefaults];//本地化处理
    }
    
    return self;
}
//判断是否登录
-(BOOL)isLogin
{
    NSString *isLogin = [_mySettingData objectForKey:@"is_Login"];
    if(CHECK_STRING_VALID(isLogin) && [isLogin isEqualToString:@"1"])
    {
        return YES;
    }
    
    return NO;
}
-(BOOL)saveUserInfoWithName:(NSString *)name Phone:(NSString *)phone Hospital:(NSString *)hospital Department:(NSString *)department Position:(NSString *)position introduction:(NSString *)introduction Token:(NSString *)token
{
    [_mySettingData setValue:@"1" forKey:@"is_Login"];
    [_mySettingData setValue:name forKey:@"user_name"];
    [_mySettingData setValue:phone forKey:@"user_phone"];
    [_mySettingData setValue:department forKey:@"user_department"];
    [_mySettingData setValue:position forKey:@"user_position"];
    if (CHECK_STRING_VALID(introduction)) {
        [_mySettingData setValue:introduction forKey:@"user_introduction"];
    }else{
        [_mySettingData setValue:introduction forKey:@""];
    }
    [_mySettingData synchronize];
    
    return YES;
}
-(void)saveUserInfoWithPhone:(NSString *)phone withToken:(NSString *)token{
    [_mySettingData setValue:@"1" forKey:@"is_Login"];
    [_mySettingData setValue:phone forKey:@"user_phone"];
    [_mySettingData setValue:token forKey:@"new_token"];
    [_mySettingData synchronize];
}
-(void)sevaUserInfoWithDict:(NSDictionary *)dict{
    [_mySettingData setValue:[dict objectForKey:@"name"] forKey:@"user_name"];
    [_mySettingData setValue:[dict objectForKey:@"phone"] forKey:@"user_phone"];
    [_mySettingData setValue:[dict objectForKey:@"departmentid"] forKey:@"user_department"];
    [_mySettingData setValue:[dict objectForKey:@"titleid"] forKey:@"user_position"];
    [_mySettingData setValue:[dict objectForKey:@"headimg"] forKey:@"user_headimg"];
    [_mySettingData setValue:[dict objectForKey:@"hospital"] forKey:@"user_hospital"];
    [_mySettingData setValue:[dict objectForKey:@"qrcodeimg"] forKey:@"qrcodeimg"];
    if (CHECK_STRING_VALID([dict objectForKey:@"docintro"])) {
        [_mySettingData setValue:[dict objectForKey:@"docintro"] forKey:@"user_introduction"];
    }else{
        [_mySettingData setValue:@"" forKey:@"user_introduction"];
    }
    [_mySettingData synchronize];
}
-(MJXUserModel *)getUserInfo{
    MJXUserModel *userInfo = [[MJXUserModel alloc] init];
    if ([_mySettingData objectForKey:@"user_phone"]!=nil) {
        userInfo.userPhone = [_mySettingData objectForKey:@"user_phone"];
    }else{
        userInfo.userPhone = @"";
    }
    if ([_mySettingData objectForKey:@"user_name"]!=nil) {
        userInfo.userName = [_mySettingData objectForKey:@"user_name"];
    }else{
        userInfo.userName = @"";
    }
    if ([_mySettingData objectForKey:@"user_department"]!=nil) {
        userInfo.department = [_mySettingData objectForKey:@"user_department"];
    }else{
        userInfo.department = @"";
    }
    
    if ([_mySettingData objectForKey:@"user_position"] != nil) {
        userInfo.position = [_mySettingData objectForKey:@"user_position"];
    }else{
        userInfo.position = @"";
    }
    if ([_mySettingData objectForKey:@"user_headimg"] !=nil) {
        userInfo.headimg = [_mySettingData objectForKey:@"user_headimg"];
    }else{
        userInfo.headimg = @"";
    }
    
    if ([_mySettingData objectForKey:@"user_introduction"]==nil) {
        userInfo.introduction = @"";
    }else{
        userInfo.introduction = [_mySettingData objectForKey:@"user_introduction"];
    }
    if ([_mySettingData objectForKey:@"user_hospital"]==nil) {
        userInfo.hospital = @"";
    }else{
        userInfo.hospital = [_mySettingData objectForKey:@"user_hospital"];
    }
    if ([_mySettingData objectForKey:@"qrcodeimg"]==nil) {
        userInfo.qrcodeimg = @"";
    }else{
        userInfo.qrcodeimg = [_mySettingData objectForKey:@"qrcodeimg"];
    }
    return userInfo;
}
-(void)logOut{
    [_mySettingData setValue:@"0" forKey:@"is_Login"];
    [_mySettingData setValue:@"" forKey:@"user_name"];
    [_mySettingData setValue:@"" forKey:@"user_department"];
    [_mySettingData setValue:@"" forKey:@"user_position"];
    [_mySettingData setValue:@"" forKey:@"user_introduction"];
    [_mySettingData setValue:@"" forKey:@"user_name"];
    //[_mySettingData setValue:@"" forKey:@"user_phone"];
    [_mySettingData setValue:@"" forKey:@"user_department"];
    [_mySettingData setValue:@"" forKey:@"user_position"];
    [_mySettingData setValue:@"" forKey:@"user_headimg"];
    [_mySettingData setValue:@"" forKey:@"user_hospital"];
    [_mySettingData setValue:@"" forKey:@"user_introduction"];
    [_mySettingData setValue:@"" forKey:@"qrcodeimg"];
    [_mySettingData setObject:@"" forKey:@"user_chatToken"];
    [_mySettingData synchronize];
    
}

-(NSString *)getNewToken
{
    if ([_mySettingData objectForKey:@"new_token"] == nil)
    {
        [_mySettingData setObject:@"" forKey:@"new_token"];
    }
    [_mySettingData synchronize];
    return [_mySettingData objectForKey:@"new_token"];
}
-(void)setUserPhone:(NSString *)Phone{
    [_mySettingData setObject:Phone forKey:@"user_phone"];
    [_mySettingData synchronize];
}

-(NSString *)getUserPhone{
    return [_mySettingData objectForKey:@"user_phone"];
}
-(void)setChatToken:(NSString *)token{
    [_mySettingData setObject:token forKey:@"user_chatToken"];
    [_mySettingData synchronize];
}
-(NSString *)getChatToken{
 return [_mySettingData objectForKey:@"user_chatToken"];
}
@end
