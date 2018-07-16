//
//  UIUtils.m
//  WisdomHall
//
//  Created by XTU-TI on 2017/4/26.
//  Copyright © 2017年 majinxing. All rights reserved.
//

#import "UIUtils.h"
#import <SystemConfiguration/CaptiveNetwork.h>
#import "DYHeader.h"
#import "ClassRoomModel.h"
#import "SignPeople.h"
#import "FMDBTool.h"
#import "DYTabBarViewController.h"
#import "ChatHelper.h"
//#import "TheLoginViewController.h"
#import <UIKit/UIKit.h>
#import <arpa/inet.h>
#import "sys/utsname.h"
#import "WorkingLoginViewController.h"
#import "ClassModel.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <CommonCrypto/CommonDigest.h>


@interface UIUtils()

@property (nonatomic,strong)FMDatabase * db;

@end
@implementation UIUtils
+(void)addNavigationWithView:(UIView *)view withTitle:(NSString *)str{
    //    UIView *navigation = [[UIView alloc] initWithFrame:CGRectMake(0, 0,APPLICATION_WIDTH, 65)];
    //    navigation.backgroundColor=[UIColor whiteColor];
    //    [view addSubview:navigation];
    //    UILabel *title=[[UILabel alloc] initWithFrame:CGRectMake(APPLICATION_WIDTH/2.0-100,34,200, 20)];
    //    title.text=str;
    //    title.textColor=[UIColor colorWithHexString:@"#333333"];
    //    title.font=[UIFont systemFontOfSize:17];
    //    title.textAlignment=NSTextAlignmentCenter;
    //    UIView *line=[[UIView alloc] initWithFrame:CGRectMake(0, 64, APPLICATION_WIDTH, 1)];
    //    line.backgroundColor=[UIColor colorWithHexString:@"#e5e5e5"];
    //    [view addSubview:line];
    //    [view addSubview:title];
}
/**
 *  获取当地日期
 */
+(NSString *)getCurrentDate
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    int unit = NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    
    //获得当前时间的年月日时分
    NSDateComponents *nowCmps = [calendar components:unit fromDate:[NSDate date]];
    NSString *nowDate = [NSString stringWithFormat:@"%ld-%ld-%ld %ld:%ld:%ld",(long)nowCmps.year,(long)nowCmps.month,(long)nowCmps.day,(long)nowCmps.hour,(long)nowCmps.minute,(long)nowCmps.second];
    return nowDate;
}

+(BOOL)testCellPhoneNumber:(NSString *)mobileNum{
    if (mobileNum.length != 11)
    {
        return NO;
    }
    /**
     * 手机号码:
     * 13[0-9], 14[5,7], 15[0, 1, 2, 3, 5, 6, 7, 8, 9], 17[6, 7, 8], 18[0-9], 170[0-9]
     * 移动号段: 134,135,136,137,138,139,150,151,152,157,158,159,182,183,184,187,188,147,178,1705
     * 联通号段: 130,131,132,155,156,185,186,145,176,1709
     * 电信号段: 133,153,180,181,189,177,1700
     */
    NSString *MOBILE = @"^1(3[0-9]|4[57]|5[0-35-9]|8[0-9]|7[0678])\\d{8}$";
    /**
     * 中国移动：China Mobile
     * 134,135,136,137,138,139,150,151,152,157,158,159,182,183,184,187,188,147,178,1705
     */
    NSString *CM = @"(^1(3[4-9]|4[7]|5[0-27-9]|7[8]|8[2-478])\\d{8}$)|(^1705\\d{7}$)";
    /**
     * 中国联通：China Unicom
     * 130,131,132,155,156,185,186,145,176,1709
     */
    NSString *CU = @"(^1(3[0-2]|4[5]|5[56]|7[6]|8[56])\\d{8}$)|(^1709\\d{7}$)";
    /**
     * 中国电信：China Telecom
     * 133,153,180,181,189,177,1700
     */
    NSString *CT = @"(^1(33|53|77|8[019])\\d{8}$)|(^1700\\d{7}$)";
    
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    if (([regextestmobile evaluateWithObject:mobileNum] == YES)
        || ([regextestcm evaluateWithObject:mobileNum] == YES)
        || ([regextestct evaluateWithObject:mobileNum] == YES)
        || ([regextestcu evaluateWithObject:mobileNum] == YES))
    {
        return YES;
    }
    else
    {
        return NO;
    }
}
//判断字符串是否为空
+(BOOL)isBlankString:(NSString *)string
{
    if (string == nil)
    {
        return YES;
    }else if (string == NULL)
    {
        return YES;
    }else if (![string isKindOfClass:[NSString class]]){
        return YES;
    }else if ([string isEqualToString:@"(null)"]) {
        return YES;
    }else if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }else if([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
        
        return YES;
        
    }
    return NO;
}
//电话正则表达式
+(BOOL)isSimplePhone:(NSString *)phone{
    NSString *phoneRegex = @"^1[0-9]\\d{9}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
    return [phoneTest evaluateWithObject:phone];
}
+(NSString *)getTime{
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    int unit = NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    
    //获得当前时间的年月日时分
    NSDateComponents *nowCmps = [calendar components:unit fromDate:[NSDate date]];
    NSString *month;
    if (nowCmps.month<10) {
        month = [NSString stringWithFormat:@"0%ld",(long)nowCmps.month];
    }else{
        month = [NSString stringWithFormat:@"%ld",(long)nowCmps.month];
    }
    NSString * day;
    if (nowCmps.day<10) {
        day = [NSString stringWithFormat:@"0%ld",(long)nowCmps.day];
    }else{
        day = [NSString stringWithFormat:@"%ld",(long)nowCmps.day];
    }
    NSString *nowDate = [NSString stringWithFormat:@"%ld-%@-%@",(long)nowCmps.year,month,day];
    
    return nowDate;
}
+(NSString *)getMonth{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    int unit = NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    
    //获得当前时间的年月日时分
    NSDateComponents *nowCmps = [calendar components:unit fromDate:[NSDate date]];
    NSString *month;
    if (nowCmps.month<10) {
        month = [NSString stringWithFormat:@"0%ld",(long)nowCmps.month];
    }else{
        month = [NSString stringWithFormat:@"%ld",(long)nowCmps.month];
    }
    NSString *nowDate = [NSString stringWithFormat:@"%@月",month];
    
    return nowDate;
}
+(NSString *)getMoreMonthTime{
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    int unit = NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    
    //获得当前时间的年月日时分
    NSDateComponents *nowCmps = [calendar components:unit fromDate:[NSDate date]];
    NSString *month;
    if (nowCmps.month<10) {
        month = [NSString stringWithFormat:@"0%ld",(long)nowCmps.month];
    }else{
        month = [NSString stringWithFormat:@"%ld",(long)nowCmps.month];
    }
    NSString * day;
    if (nowCmps.day<9) {
        day = [NSString stringWithFormat:@"0%ld",(long)nowCmps.day+1];
    }else{
        day = [NSString stringWithFormat:@"%ld",(long)nowCmps.day+1];
    }
    NSString *nowDate = [NSString stringWithFormat:@"%ld-%@-%@",(long)nowCmps.year,month,day];
    
    return nowDate;
}
//获取当前的无线信号

+(NSMutableDictionary *)getWifiName

{
    NSMutableDictionary * dict = [[NSMutableDictionary alloc] init];
    
    NSString *wifiName = nil;
    
    
    
    CFArrayRef wifiInterfaces = CNCopySupportedInterfaces();
    
    
    
    if (!wifiInterfaces) {
        
        return dict;
        
    }
    
    NSArray *interfaces = (__bridge NSArray *)wifiInterfaces;
    
    
    for (NSString *interfaceName in interfaces) {
        
        CFDictionaryRef dictRef = CNCopyCurrentNetworkInfo((__bridge CFStringRef)(interfaceName));
        
        
        
        if (dictRef) {
            
            NSDictionary *networkInfo = (__bridge NSDictionary *)dictRef;
            
            // NSLog(@"network info -> %@", networkInfo);
            dict = networkInfo;
            wifiName = [networkInfo objectForKey:(__bridge NSString*)kCNNetworkInfoKeySSID];
            
            CFRelease(dictRef);
            
        }
        
    }
    
    CFRelease(wifiInterfaces);
    
    return dict;
    
}

+(NSString *)specificationMCKAddress:(NSString *)str{
    NSMutableString * bssid = [NSMutableString stringWithString:[NSString stringWithFormat:@"%@",str]];
    
    NSArray * ary = [bssid componentsSeparatedByString:@":"];
    
    NSString * str1 = [[NSString alloc] init];
    for (int i = 0; i<ary.count; i++) {
        NSString * s = [NSString stringWithFormat:@"%@",ary[i]];
        if (s.length==2) {
            str1 = [NSString stringWithFormat:@"%@%@",str1,s];
        }else{
            str1 = [NSString stringWithFormat:@"%@0%@",str1,s];
        }
    }
    
    //            bssid = [bssid stringByReplacingOccurrencesOfString:@":" withString:@""];
    
    bssid = [str1 uppercaseString];
    return bssid;
}

/**
 *  判断当前时间是否处于某个时间段内
 *
 *  @param startTime        开始时间
 *  @param expireTime       结束时间
 */

+(BOOL)validateWithStartTime:(NSString *)startTime withExpireTime:(NSString *)expireTime {
    
    NSArray *ary = [startTime componentsSeparatedByString:@" "];
    expireTime = ary[1];
    NSMutableArray * ary1 = [expireTime componentsSeparatedByString:@":"];
    expireTime = ary1[0];
    NSString * mm = ary1[1];
    
    startTime = [NSString stringWithFormat:@"%@ %@:%@",ary[0],ary1[0],ary1[1]];
    
    long n = [expireTime integerValue];
    long m = [mm integerValue];
    if (m>=10) {
        startTime = [NSString stringWithFormat:@"%@ %@:%ld",ary[0],ary1[0],m-10];
    }else{
        startTime = [NSString stringWithFormat:@"%@ %ld:%ld",ary[0],n-1,m-10+60];
    }
    
    if (m>=30) {
        if (n == 24) {
            n = 1;
            m = m + 30 - 60;
            ary1[0] = [NSString stringWithFormat:@"%ld",n];
            ary1[1] = [NSString stringWithFormat:@"%ld",m];
            
        }else {
            n = n+1;
            m = m + 30 - 60;
            
            ary1[0] = [NSString stringWithFormat:@"%ld",n];
            ary1[1] = [NSString stringWithFormat:@"%ld",m];
            
        }
    }else{
        m = m + 30;
        ary1[1] = [NSString stringWithFormat:@"%ld",m];
        
    }
    
    
    expireTime = [NSString stringWithFormat:@"%@ %@:%@",ary[0],ary1[0],ary1[1]];
    
//    NSDate *today = [UIUtils getInternetDate];
//    if (today == nil) {
    
    NSDate * today = [NSDate date];

    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    // 时间格式,此处遇到过坑,建议时间HH大写,手机24小时进制和12小时禁止都可以完美格式化
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm"];
//    dateFormat.timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];//东八区时间
    NSDate *start = [dateFormat dateFromString:startTime];// dateByAddingTimeInterval:60*60*8];
    NSDate *expire = [dateFormat dateFromString:expireTime];// dateByAddingTimeInterval:60*60*8];
    
    if ([today compare:start] == NSOrderedDescending && [today compare:expire] == NSOrderedAscending) {
        return YES;
    }
    return NO;
}

/**
 
 * 开始到结束的时间差
 
 */

+ (BOOL)dateTimeDifferenceWithStartTime:(NSString *)startTime withTime:(int)time{
    
    NSDateFormatter *date = [[NSDateFormatter alloc]init];
    
    [date setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSDate *startD  = [date dateFromString:startTime];
    
    NSDate *endD = [NSDate date];//[date dateFromString:endTime];
    
    NSTimeInterval start = [startD timeIntervalSince1970]*1;
    
    NSTimeInterval end = [endD timeIntervalSince1970]*1;
    
    NSTimeInterval value = end - start;
    // 当前日历
    NSCalendar *calendar = [NSCalendar currentCalendar];
    // 需要对比的时间数据
    NSCalendarUnit unit = NSCalendarUnitYear | NSCalendarUnitMonth
    | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    // 对比时间差
    NSDateComponents *dateCom = [calendar components:unit fromDate:startD toDate:endD options:0];
    
    NSInteger year = [[[Appsetting sharedInstance].mySettingData objectForKey:@"year"] integerValue];
    NSInteger month = [[[Appsetting sharedInstance].mySettingData objectForKey:@"month"] integerValue];
    NSInteger day = [[[   Appsetting sharedInstance].mySettingData objectForKey:@"day"] integerValue];
    NSInteger hour = [[[Appsetting sharedInstance].mySettingData objectForKey:@"hour"] integerValue];
    NSInteger minute = [[[Appsetting sharedInstance].mySettingData objectForKey:@"minute"] integerValue];
    NSInteger second = [[[Appsetting sharedInstance].mySettingData objectForKey:@"second"] integerValue];
    if (abs((int)dateCom.year+(int)year)>0) {
        return NO;
    }
    if (abs((int)dateCom.month+(int)month)>0){
        return NO;
    }
    if (abs((int)dateCom.day+(int)day)>0) {
        return NO;
    }
    if (abs((int)dateCom.hour+(int)hour)>0) {
        return NO;
    }
    if (abs((int)dateCom.minute+(int)minute)>0) {
        return NO;
    }
    if (abs((int)dateCom.second+(int)second)<time) {
        return YES;
    }
    return NO;
}
/**
 
 * 距离签到时间的差值
 
 */

+(NSString *)dateTimeDifferenceWithStartTime:(NSString *)startTime{
    
    startTime = [UIUtils timeSubtractTenMin:startTime];
    
    NSDateFormatter *date = [[NSDateFormatter alloc]init];
    
    [date setDateFormat:@"yyyy-MM-dd HH:mm"];
    
    NSDate *startD  = [date dateFromString:startTime];
    
    NSDate *endD = [NSDate date];//[date dateFromString:endTime];
    
    NSTimeInterval start = [startD timeIntervalSince1970]*1;
    
    NSTimeInterval end = [endD timeIntervalSince1970]*1;
    
    NSTimeInterval value = end - start;
    // 当前日历
    NSCalendar *calendar = [NSCalendar currentCalendar];
    // 需要对比的时间数据
    NSCalendarUnit unit = NSCalendarUnitYear | NSCalendarUnitMonth
    | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    // 对比时间差
    NSDateComponents *dateCom = [calendar components:unit fromDate:endD toDate:startD options:0];
    
    NSInteger year = [[[Appsetting sharedInstance].mySettingData objectForKey:@"year"] integerValue];
    NSInteger month = [[[Appsetting sharedInstance].mySettingData objectForKey:@"month"] integerValue];
    NSInteger day = [[[   Appsetting sharedInstance].mySettingData objectForKey:@"day"] integerValue];
    NSInteger hour = [[[Appsetting sharedInstance].mySettingData objectForKey:@"hour"] integerValue];
    NSInteger minute = [[[Appsetting sharedInstance].mySettingData objectForKey:@"minute"] integerValue];
    NSInteger second = [[[Appsetting sharedInstance].mySettingData objectForKey:@"second"] integerValue];
    NSString * str = [[NSString alloc] init];
    
    if (abs((int)dateCom.year+(int)year)>0) {
        if (((int)dateCom.year+(int)year)>0) {
            str = [str stringByAppendingString:[NSString stringWithFormat:@"%d年",(int)dateCom.year+(int)year]];
        }
    }
    if (abs((int)dateCom.month+(int)month)>0){
        if (((int)dateCom.month+(int)month)>0) {
            str = [str stringByAppendingString:[NSString stringWithFormat:@"%d个月",(int)dateCom.month+(int)month]];
        }
    }
    if (abs((int)dateCom.day+(int)day)>0) {
        if (((int)dateCom.day+(int)day)>0) {
            str = [str stringByAppendingString:[NSString stringWithFormat:@"%d天",(int)dateCom.day+(int)day]];
        }
    }
    if (abs((int)dateCom.hour+(int)hour)>0) {
        if (((int)dateCom.hour+(int)hour)>0) {
            str = [str stringByAppendingString:[NSString stringWithFormat:@" %d小时",(int)dateCom.hour+(int)hour]];
        }
    }
    if (abs((int)dateCom.minute+(int)minute)>0) {
        if (((int)dateCom.minute+(int)minute)>0) {
            str = [str stringByAppendingString:[NSString stringWithFormat:@"%d分钟",(int)dateCom.minute+(int)minute]];
        }
    }
    if (abs((int)dateCom.second+(int)second)>0) {
        if (((int)dateCom.second+(int)second)>0) {
            str = [str stringByAppendingString:[NSString stringWithFormat:@"%d秒",(int)dateCom.second+(int)second]];
        }
    }
    return str;
}
//获取网路时间与本地时间的差值
+(NSDate *)getInternetDate
{
   
    NSString *urlString = @"http://m.baidu.com";
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString: urlString]];
    [request setCachePolicy:NSURLRequestReloadIgnoringCacheData];
    [request setTimeoutInterval: 2];
    [request setHTTPShouldHandleCookies:FALSE];
    [request setHTTPMethod:@"GET"];
    NSHTTPURLResponse *response;
    [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
    
    NSString *date = [[response allHeaderFields] objectForKey:@"Date"];
    date = [date substringFromIndex:5];
    date = [date substringToIndex:[date length]-4];
    NSDateFormatter *dMatter = [[NSDateFormatter alloc] init];
    dMatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    [dMatter setDateFormat:@"dd MMM yyyy HH:mm:ss"];
    NSDate *netDate = [[dMatter dateFromString:date] dateByAddingTimeInterval:60*60*8];
    
    NSTimeZone *zone = [NSTimeZone timeZoneWithName:@"Asia/Beijing"];
    NSInteger interval = [zone secondsFromGMTForDate: netDate];
    NSDate *localeDate = [netDate  dateByAddingTimeInterval: interval];
    
    NSDate *endD = [NSDate date];//[date dateFromString:endTime];
    
    NSString*timeSp = [NSString stringWithFormat:@"%ld", (long)[endD timeIntervalSince1970]];
    
    NSTimeZone *zone1 = [NSTimeZone timeZoneWithName:@"Asia/Beijing"];
    
    NSInteger interval1 = [zone1 secondsFromGMTForDate:endD];
    
    NSDate * localeDate1 = [endD dateByAddingTimeInterval:interval1];
    
//    NSTimeInterval start = [localeDate timeIntervalSince1970]*1;
    
//    NSTimeInterval end = [endD timeIntervalSince1970]*1;
    
//    NSTimeInterval value = end - start;
    // 当前日历
    NSCalendar *calendar = [NSCalendar currentCalendar];
    // 需要对比的时间数据
    NSCalendarUnit unit = NSCalendarUnitYear | NSCalendarUnitMonth
    | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    // 对比时间差
    NSDateComponents *dateCom = [calendar components:unit fromDate:localeDate1 toDate:localeDate options:0];
    [[Appsetting sharedInstance].mySettingData setValue:[NSString stringWithFormat:@"%ld",(long)dateCom.year] forKey:@"year"];
    [[Appsetting sharedInstance].mySettingData setValue:[NSString stringWithFormat:@"%ld",(long)dateCom.month] forKey:@"month"];
    [[Appsetting sharedInstance].mySettingData setValue:[NSString stringWithFormat:@"%ld",(long)dateCom.day] forKey:@"day"];
    [[Appsetting sharedInstance].mySettingData setValue:[NSString stringWithFormat:@"%ld",(long)dateCom.minute] forKey:@"minute"];
    [[Appsetting sharedInstance].mySettingData setValue:[NSString stringWithFormat:@"%ld",(long)dateCom.second] forKey:@"second"];
    [[Appsetting sharedInstance].mySettingData synchronize];

    return localeDate;

}

+(NSString *)compareTimeStartTime:(NSString *)startTime withExpireTime:(NSString *)expireTime {
    
    NSArray *ary = [startTime componentsSeparatedByString:@" "];
    NSString * str = ary[1];
    NSArray * ary1 = [str componentsSeparatedByString:@":"];
    startTime = [NSString stringWithFormat:@"%@ %@:%@",ary[0],ary1[0],ary1[1]];
    
    NSArray *aryX = [expireTime componentsSeparatedByString:@" "];
    NSString * strX = aryX[1];
    NSArray * aryX1 = [strX componentsSeparatedByString:@":"];
    expireTime = [NSString stringWithFormat:@"%@ %@:%@",aryX[0],aryX1[0],aryX1[1]];
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    // 时间格式,此处遇到过坑,建议时间HH大写,手机24小时进制和12小时禁止都可以完美格式化
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm"];
    
    NSDate *start = [dateFormat dateFromString:startTime];
    NSDate *expire = [dateFormat dateFromString:expireTime];
    NSComparisonResult result = [start compare:expire];
    NSString * ci;
    switch (result)
    {
            //date02比date01大
        case NSOrderedAscending:
            ci=@"1"; break;
            //date02比date01小
        case NSOrderedDescending:
            ci=@"-1"; break;
            //date02=date01
        case NSOrderedSame:
            ci=@"0"; break;
        default:
            break;
    }
    return ci;
}
+(NSMutableDictionary *)createTemporaryCourseWith:(NSMutableArray *)ary ClassRoom:(ClassRoomModel *)c joinClassPeople:(NSMutableArray *)joinPeopleAry week:(int)week class1:(int)class1 class2:(int)class2{
    
    NSMutableDictionary * dict = [[NSMutableDictionary alloc] init];
    for (int i = 1; i<ary.count; i++) {
        if ([UIUtils isBlankString:ary[i]]) {
            return dict;
            break;
        }
    }
    [dict setObject:ary[1] forKey:@"name"];
    
    UserModel * users = [[Appsetting sharedInstance] getUsetInfo];
    
    [dict setObject:[NSString stringWithFormat:@"%@",users.peopleId] forKey:@"teacherId"];
    
    [dict setObject:@"1" forKey:@"signWay"];
    
    [dict setObject:[NSString stringWithFormat:@"%@",c.classRoomId] forKey:@"roomId"];
    
    NSMutableArray * userList = [NSMutableArray arrayWithCapacity:1];
    for (int i = 0; i<joinPeopleAry.count; i++) {
        SignPeople * s = joinPeopleAry[i];
        if (![[NSString stringWithFormat:@"%@",s.userId] isEqualToString:[NSString stringWithFormat:@"%@",users.peopleId]]) {
            [userList addObject:s.userId];
        }
    }
    
    [dict setObject:userList forKey:@"userList"];
    
    [dict setObject:@"0" forKey:@"pictureId"];
    
    [dict setObject:users.school forKey:@"universityId"];
    
    [dict setObject:ary[7] forKey:@"startTime"];
    
    [dict setObject:[NSString stringWithFormat:@"%d",class1+1] forKey:@"startTh"];
    
    [dict setObject:[NSString stringWithFormat:@"%d",class2+1] forKey:@"endTh"];
    
    return dict;
}

+(NSMutableDictionary *)createCourseWith:(NSMutableArray *)ary ClassRoom:(ClassRoomModel *)c joinClassPeople:(NSMutableArray *)joinPeopleAry m1:(int)m1 m2:(int)m2 m3:(int)m3 week:(int)week class1:(int)class1 class2:(int)class2{
    
    NSMutableDictionary * dict = [[NSMutableDictionary alloc] init];
    for (int i = 1; i<ary.count; i++) {
        if ([UIUtils isBlankString:ary[i]]) {
            return dict;
            break;
        }
    }
    [dict setObject:ary[1] forKey:@"name"];
    UserModel * users = [[Appsetting sharedInstance] getUsetInfo];
    [dict setObject:[NSString stringWithFormat:@"%@",users.peopleId] forKey:@"teacherId"];
    
    NSMutableArray * userList = [NSMutableArray arrayWithCapacity:1];
    for (int i = 0; i<joinPeopleAry.count; i++) {
        SignPeople * s = joinPeopleAry[i];
        if (![[NSString stringWithFormat:@"%@",s.userId] isEqualToString:[NSString stringWithFormat:@"%@",users.peopleId]]) {
            [userList addObject:s.userId];
        }
    }
    
    [dict setObject:userList forKey:@"userList"];
    
    [dict setObject:@"0" forKey:@"pictureId"];
    [dict setObject:[NSString stringWithFormat:@"%d",[UIUtils getTermId]] forKey:@"termId"];
    [dict setObject:ary[7] forKey:@"firstDay"];
    
    if (m3 == 0) {
        NSArray * aryT = [[NSArray alloc] initWithObjects:@{@"startWeek":[NSString stringWithFormat:@"%d",m1+1],@"endWeek":[NSString stringWithFormat:@"%d",m2+1]}, nil];
        [dict setObject:aryT forKey:@"courseWeekList"];
        
    }else if (m3 == 1){
        NSMutableArray * aryT1 = [NSMutableArray arrayWithCapacity:1];
        if (m1%2==0) {
            for (int i = m1+1; i<=m2; i=i+2) {
                NSDictionary * d = [[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%d",i],@"startWeek",[NSString stringWithFormat:@"%d",i],@"endWeek", nil];
                
                [aryT1 addObject:d];
            }
            
        }else{
            for (int i = m1; i<=m2; i= i+2) {
                NSDictionary * d = [[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%d",i],@"startWeek",[NSString stringWithFormat:@"%d",i],@"endWeek", nil];
                
                [aryT1 addObject:d];
            }
        }
        [dict setObject:aryT1 forKey:@"courseWeekList"];
        
    }else if (m3 == 2){
        NSMutableArray * aryT1 = [NSMutableArray arrayWithCapacity:1];
        if (m1%2==0) {
            for (int i = m1; i<=m2; i=i+2) {
                NSDictionary * d = [[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%d",i],@"startWeek",[NSString stringWithFormat:@"%d",i],@"endWeek", nil];
                [aryT1 addObject:d];
            }
            
        }else{
            for (int i = m1+1; i<=m2; i=i+2) {
                NSDictionary * d = [[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%d",i],@"startWeek",[NSString stringWithFormat:@"%d",i],@"endWeek", nil];
                [aryT1 addObject:d];
            }
        }
        [dict setObject:aryT1 forKey:@"courseWeekList"];
    }
    [dict setObject:users.school forKey:@"universityId"];
    
    if (week == 6) {
        week = 1;
    }else{
        week = week + 2;
    }
    
    [dict setObject:@"1" forKey:@"signWay"];
    [dict setObject:[NSString stringWithFormat:@"%@",c.classRoomId] forKey:@"roomId"];
    
    NSDictionary * w = [[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%d",week],@"weekDay",[NSString stringWithFormat:@"%d",class1+1],@"startTh",[NSString stringWithFormat:@"%d",class2+1],@"endTh",nil];
    
    NSArray * aa = [[NSArray alloc] initWithObjects:w, nil];
    [dict setObject:aa forKey:@"courseTimeList"];
    
    return dict;
}

+(int)getTermId{
    NSString * time = [UIUtils getTime];
    NSString * year = [time substringWithRange:NSMakeRange(0, 4)];
    NSString * month = [time substringWithRange:NSMakeRange(5, 2)];
    NSInteger y = [year integerValue];
    NSInteger m = [month integerValue];
    NSInteger  n = 0;
    n = (y-2017)*2;
    if (m<2) {
        n = n - 1;
    }else if (m>=8) {
        n = n + 1;
    }else{
        n = n + 0;
    }
    return (int)n;
}
+(BOOL)isPureInt:(NSString *)string{
    
    NSScanner* scan = [NSScanner scannerWithString:string];
    int val;
    return [scan scanInt:&val] && [scan isAtEnd];
    
}

+(NSMutableArray *)returnAry:(UserModel *)user{
    NSMutableArray * ary = [NSMutableArray arrayWithCapacity:1];
    [ary addObject:[NSString stringWithFormat:@"%@",user.userName]];
    [ary addObject:[NSString stringWithFormat:@"%@",user.studentId]];
    [ary addObject:[NSString stringWithFormat:@"%@",user.schoolName]];
    [ary addObject:[NSString stringWithFormat:@"%@",user.departmentsName]];
    [ary addObject:[NSString stringWithFormat:@"%@",user.professionalName]];
    [ary addObject:[NSString stringWithFormat:@"%@",user.userPhone]];
    
    if ([UIUtils isBlankString:[NSString stringWithFormat:@"%@",user.email]]) {
        [ary addObject:[NSString stringWithFormat:@""]];
        
    }else{
        [ary addObject:[NSString stringWithFormat:@"%@",user.email]];
    }
    if ([UIUtils isBlankString:[NSString stringWithFormat:@"%@",user.region]]) {
        [ary addObject:[NSString stringWithFormat:@""]];
        
    }else{
        [ary addObject:[NSString stringWithFormat:@"%@",user.region]];
    }
    
    if ([UIUtils isBlankString:[NSString stringWithFormat:@"%@",user.sex]]) {
        [ary addObject:[NSString stringWithFormat:@""]];
        
    }else{
        if ([[NSString stringWithFormat:@"%@",user.sex] isEqualToString:@"1"]) {
            [ary addObject:[NSString stringWithFormat:@"男"]];
        }else if([[NSString stringWithFormat:@"%@",user.sex] isEqualToString:@"2"]){
            [ary addObject:[NSString stringWithFormat:@"女"]];
        }else{
            [ary addObject:[NSString stringWithFormat:@" "]];
        }
    }
    
    if ([UIUtils isBlankString:[NSString stringWithFormat:@"%@",user.birthday]]) {
        [ary addObject:[NSString stringWithFormat:@""]];
        
    }else{
        [ary addObject:[NSString stringWithFormat:@"%@",user.birthday]];
    }
    
    if ([UIUtils isBlankString:[NSString stringWithFormat:@"%@",user.sign]]) {
        [ary addObject:[NSString stringWithFormat:@""]];
        
    }else{
        [ary addObject:[NSString stringWithFormat:@"%@",user.sign]];
    }
    
    return ary;
}
+ (NSString*)weekdayStringFromDate:(NSString *)startTime {
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    // 时间格式,此处遇到过坑,建议时间HH大写,手机24小时进制和12小时禁止都可以完美格式化
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    
    NSDate *inputDate = [dateFormat dateFromString:startTime];
    
    NSArray *weekdays = [NSArray arrayWithObjects: [NSNull null], @"星期天", @"星期一", @"星期二", @"星期三", @"星期四", @"星期五", @"星期六",nil];
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    NSTimeZone *timeZone = [[NSTimeZone alloc] initWithName:@"Asia/Shanghai"];
    
    [calendar setTimeZone: timeZone];
    
    NSCalendarUnit calendarUnit = NSCalendarUnitWeekday;
    
    NSDateComponents *theComponents = [calendar components:calendarUnit fromDate:inputDate];
    
    return [weekdays objectAtIndex:theComponents.weekday];
}
+(BOOL)compareTheVersionNumber:(NSString *)netVersion withLocal:(NSString *)localVersion{
    NSArray *netAry = [netVersion componentsSeparatedByString:@"."];
    NSArray *localAry = [localVersion componentsSeparatedByString:@"."];
    if (netAry.count == localAry.count) {
        for (int i = 0; i<netAry.count; i++) {
            int n = [netAry[i] intValue];
            int m = [localAry[i] intValue];
            if (m<n) {
                return YES;
            }
        }
    }
    return NO;
}
+(void)tokenThePeriodOfValidity{
    FMDatabase * db = [FMDBTool createDBWithName:SQLITE_NAME];
    if ([db open]) {
        NSString * sql = [NSString stringWithFormat:@"select * from %@",TOKENTIME_TABLE_NAME];
        FMResultSet * rs = [FMDBTool queryWithDB:db withSqlStr:sql];
        while (rs.next) {
            
            NSString * tokenTime = [rs stringForColumn:@"tokenTime"];
            NSString * todayTime = [UIUtils getTime];
            
            NSDateFormatter *dateFomatter = [[NSDateFormatter alloc] init];
            dateFomatter.dateFormat = @"yyyy-MM-dd";
            
            NSDate * tokenStr = [dateFomatter dateFromString:tokenTime];
            NSDate * todayStr = [dateFomatter dateFromString:todayTime];
            // 当前日历
            NSCalendar *calendar = [NSCalendar currentCalendar]; // 需要对比的时间数据
            
            NSCalendarUnit unit = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
            
            // 对比时间差
            NSDateComponents *dateCom = [calendar components:unit fromDate:tokenStr toDate:todayStr options:0];
            if (dateCom.day>=6) {
                
                [[Appsetting sharedInstance] getOut];
                DYTabBarViewController *rootVC = [DYTabBarViewController sharedInstance];
                rootVC = nil;
                ChatHelper * c =[ChatHelper shareHelper];
                [c getOut];
                WorkingLoginViewController * userLogin = [[WorkingLoginViewController alloc] init];
                [UIApplication sharedApplication].keyWindow.rootViewController =[[UINavigationController alloc] initWithRootViewController:userLogin];
                UIAlertView * alter = [[UIAlertView alloc] initWithTitle:nil message:@"登录过期请重新登录" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                [alter show];
                return ;
            }
        }
    }
    [db close];
}
+(void)accountWasUnderTheRoof{
    
    [[Appsetting sharedInstance] getOut];
    DYTabBarViewController *rootVC = [DYTabBarViewController sharedInstance];
    rootVC = nil;
    ChatHelper * c =[ChatHelper shareHelper];
    [c getOut];
    WorkingLoginViewController * userLogin = [[WorkingLoginViewController alloc] init];
    [UIApplication sharedApplication].keyWindow.rootViewController =[[UINavigationController alloc] initWithRootViewController:userLogin];
    [UIUtils showInfoMessage:@"账号在另一台设备登录，请重新登录或修改密码" withVC:userLogin];

    return ;
    
}

+(NSMutableDictionary *)seatingArrangements:(NSString *)seating withNumberPeople:(NSString *)numberPeople{
    
    NSMutableDictionary * dict = [[NSMutableDictionary alloc] init];
    
    if (![UIUtils isBlankString:seating]) {
        
        NSMutableString * str = [NSMutableString stringWithFormat:@"%@",seating];
        
        NSMutableArray * seatAry = [[NSMutableArray alloc] initWithArray:[str componentsSeparatedByString:@"\n"]];
        
        int all = 1;//记录一共选了多少座次
        
        NSMutableArray * seatNmber = [NSMutableArray arrayWithCapacity:1];//记录座次号几排几座
        
        for (int j = 0; j<seatAry.count; j++) {
            int n = 1;
            for(int i =0; i < [seatAry[j] length]; i++)
            {
                NSString * newStr = seatAry[j];
                
                NSString * temp = [newStr substringWithRange:NSMakeRange(i,1)];
                
                if ([temp isEqualToString:@"@"]) {
                    
                    if (all<=[numberPeople intValue]) {
                        
                        [seatNmber addObject:[NSString stringWithFormat:@"%d排%d座",j+1,n]];
                        
                        n++;
                        
                        temp = [newStr stringByReplacingCharactersInRange:NSMakeRange(i, 1) withString:@"E"];
                        
                        [seatAry setObject:temp atIndexedSubscript:j];
                        
                        all++;
                        
                    }else{
                        
                        break;
                        
                    }
                }
                
            }
            if (all>[numberPeople intValue]) {
                
                break;
                
            }
        }
        
        NSString * newStr = [[NSString alloc] init];
        for (int i = 0; i<seatAry.count; i++) {
            if (i == 0) {
                newStr = [NSString stringWithFormat:@"%@",seatAry[i]];
            }else{
                newStr = [NSString stringWithFormat:@"%@\n%@",newStr,seatAry[i]];
            }
        }
        [dict setObject:newStr forKey:@"newSeat"];
        
        [dict setObject:seatNmber forKey:@"seatAry"];
    }
    
    return dict;
}

+(NSDictionary *)seatWithPeople:(NSMutableArray *)peopleAry withSeat:(NSMutableArray *)seatAry{
    
    NSMutableArray * ary = [NSMutableArray arrayWithCapacity:1];
    
    NSMutableArray * seatPeo = [NSMutableArray arrayWithCapacity:1];
    
    for (int i = 0; i<seatAry.count&&i<peopleAry.count; i++) {
        
        SignPeople * s = peopleAry[i];
        
        s.seat = seatAry[i];
        
        NSDictionary * dict = [[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%@",s.userId],@"userId",seatAry[i],@"seat", nil];
        
        [ary addObject:dict];
        
        [seatPeo addObject:s];
    }
    NSDictionary * dict = [[NSDictionary alloc] initWithObjectsAndKeys:ary,@"peopleWithSeat",seatPeo,@"seatPeople", nil];
    
    return dict;
}
+(void)sendMeetingInfo:(NSDictionary *)dict{
    
    NSMutableArray * seatAry = [dict objectForKey:@"seatPeople"];
    
    ChatHelper * c = [ChatHelper shareHelper];
    
    UserModel * user = [[Appsetting sharedInstance] getUsetInfo];
    
    for (int i = 0; i<seatAry.count; i++) {
        
        SignPeople * s = seatAry[i];
        
        NSString * str = [NSString stringWithFormat:@"{\"Project\":\"LvDongKeTang\",\"MessageType\":\"Notification\",\"From\":\"Admin\",\"Content\":\"会议通知：主题：%@，地址：%@，时间：%@，您的座次：%@\"}",[dict objectForKey:@"name"],[dict objectForKey:@"address"],[dict objectForKey:@"time"],s.seat];
        
        [c sendTextMessageToPeople:str withReceiver:[NSString stringWithFormat:@"%@%@",user.school,s.workNo]];
    }
    
}

+(void)showInfoMessage:(NSString *)str withVC:(UIViewController *)vc{
    //显示提示框
    //过时
    //    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Title" message:@"message" delegate:self cancelButtonTitle:@"cancel" otherButtonTitles:@"ok", nil];
    //    [alert show];
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"提示"
                                                                   message:str
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    
    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * action) {
                                                             //响应事件
                                                         }];
    
    [alert addAction:cancelAction];
    
    [vc presentViewController:alert animated:YES completion:nil];
}
//时间戳化时间
+(NSString *)getTheTimeStamp:(NSString *)time{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"]; // ----------设置你想要的格式,hh与      HH的区别:分别表示12小时制,24小时制
    
    //设置时区,这个对于时间的处理有时很重要
    //例如你在国内发布信息,用户在国外的另一个时区,你想让用户看到正确的发布时间就得注意时区设置,时间的换算.
    //例如你发布的时间为2010-01-26 17:40:50,那么在英国爱尔兰那边用户看到的时间应该是多少呢?
    //他们与我们有7个小时的时差,所以他们那还没到这个时间呢...那就是把未来的事做了
    
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [formatter setTimeZone:timeZone];
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:[time doubleValue]];
    
    NSString *dateTime = [formatter stringFromDate:confromTimesp];
    return dateTime;
}

//时间戳转化为时间NSDate

+(NSString *)timeWithTimeIntervalString:(NSString *)timeString
{
    // 格式化时间
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    formatter.timeZone = [NSTimeZone timeZoneWithName:@"北京"];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    
    // 毫秒值转化为秒
    NSDate* date = [NSDate dateWithTimeIntervalSince1970:[timeString doubleValue]/ 1000.0];
    NSString* dateString = [formatter stringFromDate:date];
    return dateString;
}
+(NSString *)returnMac:(NSMutableArray *)ary{
    NSString * mac;
    for (int i = 0; i<ary.count; i++) {
        NSString * str = ary[i];
        NSString * s = [str substringWithRange:NSMakeRange(str.length-4, 4)];
        s = [NSString stringWithFormat:@"DAYAO_%@",s];
        if (i==0) {
            mac = [NSString stringWithFormat:@"%@",s];
        }else{
            mac = [NSString stringWithFormat:@"%@或%@",mac,s];
        }
        
    }
    
    return mac;
}
+(BOOL)returnMckIsHave:(NSMutableArray *)localAry withAccept:(NSArray *)acceptAry{
    for (int i = 0; i<localAry.count; i++) {
        NSString * local = [NSString stringWithFormat:@"%@",localAry[i]];
        for (int j = 0; j<acceptAry.count; j++) {
            NSString * accept = [NSString stringWithFormat:@"%@",acceptAry[j]];
            if ([local isEqualToString:accept]) {
                return YES;
            }
        }
    }
    return NO;
}
+(BOOL)matchingMacWith:(NSMutableArray *)ary withMac:(NSString *)mac{
    for (int i = 0; i<ary.count; i++) {
        NSString *str = [NSString stringWithFormat:@"%@",ary[i]];
        if ([str isEqualToString:mac]) {
            return YES;
        }
    }
    return NO;
}
#pragma mark - socket相关
/// 服务器可达返回true
+(BOOL)socketReachabilityTest {
    // 客户端 AF_INET:ipv4  SOCK_STREAM:TCP链接
    int socketNumber = socket(AF_INET, SOCK_STREAM, 0);
    
    // 配置服务器端套接字
    struct sockaddr_in serverAddress;
    // 设置服务器ipv4
    serverAddress.sin_family = AF_INET;
    // 百度的ip
    serverAddress.sin_addr.s_addr = inet_addr("202.108.22.5");
    // 设置端口号，HTTP默认80端口
    serverAddress.sin_port = htons(80);
    
    if (connect(socketNumber, (const struct sockaddr *)&serverAddress, sizeof(serverAddress)) == 0) {
        close(socketNumber);
        return true;
    }
    close(socketNumber);;
    return false;
}

+(NSString*)deviceVersion
{
    // 需要#import "sys/utsname.h"
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString * deviceString = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    //iPhone
    if ([deviceString isEqualToString:@"iPhone1,1"])    return @"iPhone 1G";
    if ([deviceString isEqualToString:@"iPhone1,2"])    return @"iPhone 3G";
    if ([deviceString isEqualToString:@"iPhone2,1"])    return @"iPhone 3GS";
    if ([deviceString isEqualToString:@"iPhone3,1"])    return @"iPhone 4";
    if ([deviceString isEqualToString:@"iPhone3,2"])    return @"Verizon iPhone 4";
    if ([deviceString isEqualToString:@"iPhone4,1"])    return @"iPhone 4S";
    if ([deviceString isEqualToString:@"iPhone5,1"])    return @"iPhone 5";
    if ([deviceString isEqualToString:@"iPhone5,2"])    return @"iPhone 5";
    if ([deviceString isEqualToString:@"iPhone5,3"])    return @"iPhone 5C";
    if ([deviceString isEqualToString:@"iPhone5,4"])    return @"iPhone 5C";
    if ([deviceString isEqualToString:@"iPhone6,1"])    return @"iPhone 5S";
    if ([deviceString isEqualToString:@"iPhone6,2"])    return @"iPhone 5S";
    if ([deviceString isEqualToString:@"iPhone7,1"])    return @"iPhone 6 Plus";
    if ([deviceString isEqualToString:@"iPhone7,2"])    return @"iPhone 6";
    if ([deviceString isEqualToString:@"iPhone8,1"])    return @"iPhone 6s";
    if ([deviceString isEqualToString:@"iPhone8,2"])    return @"iPhone 6s Plus";
    if ([deviceString isEqualToString:@"iPhone8,4"]) return @"iPhone SE";
    
    if ([deviceString isEqualToString:@"iPhone9,1"]) return @"iPhone 7";
    
    if ([deviceString isEqualToString:@"iPhone9,2"]) return @"iPhone 7 Plus";
    
    if ([deviceString isEqualToString:@"iPod1,1"])   return @"iPod Touch 1G";
    
    if ([deviceString isEqualToString:@"iPod2,1"])   return @"iPod Touch 2G";
    
    if ([deviceString isEqualToString:@"iPod3,1"])   return @"iPod Touch 3G";
    
    if ([deviceString isEqualToString:@"iPod4,1"])   return @"iPod Touch 4G";
    
    if ([deviceString isEqualToString:@"iPod5,1"])   return @"iPod Touch 5G";
    
    if ([deviceString isEqualToString:@"iPad1,1"])   return @"iPad 1G";
    
    if ([deviceString isEqualToString:@"iPad2,1"])   return @"iPad 2";
    
    if ([deviceString isEqualToString:@"iPad2,2"])   return @"iPad 2";
    
    if ([deviceString isEqualToString:@"iPad2,3"])   return @"iPad 2";
    
    if ([deviceString isEqualToString:@"iPad2,4"])   return @"iPad 2";
    
    if ([deviceString isEqualToString:@"iPad2,5"])   return @"iPad Mini 1G";
    
    if ([deviceString isEqualToString:@"iPad2,6"])   return @"iPad Mini 1G";
    
    if ([deviceString isEqualToString:@"iPad2,7"])   return @"iPad Mini 1G";
    
    if ([deviceString isEqualToString:@"iPad3,1"])   return @"iPad 3";
    
    if ([deviceString isEqualToString:@"iPad3,2"])   return @"iPad 3";
    
    if ([deviceString isEqualToString:@"iPad3,3"])   return @"iPad 3";
    
    if ([deviceString isEqualToString:@"iPad3,4"])   return @"iPad 4";
    
    if ([deviceString isEqualToString:@"iPad3,5"])   return @"iPad 4";
    
    if ([deviceString isEqualToString:@"iPad3,6"])   return @"iPad 4";
    
    if ([deviceString isEqualToString:@"iPad4,1"])   return @"iPad Air";
    
    if ([deviceString isEqualToString:@"iPad4,2"])   return @"iPad Air";
    
    if ([deviceString isEqualToString:@"iPad4,3"])   return @"iPad Air";
    
    if ([deviceString isEqualToString:@"iPad4,4"])   return @"iPad Mini 2G";
    
    if ([deviceString isEqualToString:@"iPad4,5"])   return @"iPad Mini 2G";
    
    if ([deviceString isEqualToString:@"iPad4,6"])   return @"iPad Mini 2G";
    
    if ([deviceString isEqualToString:@"i386"])      return @"iPhone Simulator";
    
    if ([deviceString isEqualToString:@"x86_64"])
        return @"iPhone Simulator";
    
    return @"未识别";
}

/**
 * 日常签到
 **/
+(void)dailyCheck{
//    [UIUtils creatDailyCheckTable:DAILYCHECK_TABLE_NAME];
//    FMDatabase * db = [FMDBTool createDBWithName:SQLITE_NAME];
//    if ([db open]) {
//        NSString * sql = [NSString stringWithFormat:@"select * from %@",DAILYCHECK_TABLE_NAME];
//        FMResultSet * rs = [FMDBTool queryWithDB:db withSqlStr:sql];
//        int n = 0;
//        int m = 0;
//        while (rs.next) {
//            NSString * date = [rs stringForColumn:@"date"];
//            NSString * today = [UIUtils getTime];
//            if ([today isEqualToString:date]) {
//                n = 1;
//                NSString * signIn = [rs stringForColumn:@"signIn"];
//
//                if ([UIUtils isBlankString:signIn]) {
//                    m = 1;
//                }
//                NSString * signBack = [rs stringForColumn:@"signBack"];
//                if ([UIUtils isBlankString:signBack]) {
//                    m = 2;
//                }
//                break;
//            }
//        }
//        [db close];
//
//        if (n == 0) {
//            [UIUtils insertedDailyCheck];
//        }else if(n == 1){
//            if (m == 1||m == 2) {
//                [UIUtils upadteDailyCheck:m];
//            }
//        }
//    }
}
+(void)creatDailyCheckTable:(NSString *)tableName{
    FMDatabase * db = [FMDBTool createDBWithName:SQLITE_NAME];
    
    if ([db open]) {
        BOOL result = [FMDBTool createTableWithDB:db tableName:tableName
                                       parameters:@{
                                                    @"userID" : @"text",
                                                    @"signIn" : @"text",
                                                    @"signBack" : @"text",
                                                    @"signInState" : @"text",
                                                    @"signBackState": @"text",
                                                    @"date" : @"text"
                                                    }];
        if (result)
        {
            //            NSLog(@"建表成功");
        }
        else
        {
            //            NSLog(@"建表失败");
        }
    }
    [db close];
}
+(NSString *)signState{
    NSString * b = [UIUtils compareTimeStartTime:[UIUtils getCurrentDate] withExpireTime:[NSString stringWithFormat:@"%@ 9:00:00",[UIUtils getTime]]];
    NSString * B = [UIUtils compareTimeStartTime:[UIUtils getCurrentDate] withExpireTime:[NSString stringWithFormat:@"%@ 17:00:00",[UIUtils getTime]]];
    if ([b isEqualToString:@"1"]||[b isEqualToString:@"0"]) {
        return @"签到正常";
    }else{
        NSString * a = [UIUtils compareTimeStartTime:[UIUtils getCurrentDate] withExpireTime:[NSString stringWithFormat:@"%@ 12:00:00",[UIUtils getTime]]];
        if ([a isEqualToString:@"1"]) {
            return @"签到迟到";
        }
    }
    if ([B isEqualToString:@"-1"]||[B isEqualToString:@"0"]) {
        return @"签退正常";
    }else{
        NSString * a = [UIUtils compareTimeStartTime:[UIUtils getCurrentDate] withExpireTime:[NSString stringWithFormat:@"%@ 12:00:00",[UIUtils getTime]]];
        if ([a isEqualToString:@"-1"]) {
            return @"签退早退";
        }
    }
    return @"a";
    
}
+(void)insertedDailyCheck{
//    FMDatabase * db = [FMDBTool createDBWithName:SQLITE_NAME];
//    NSString * str  = [UIUtils signState];
//    if ([db open]) {
//        UserModel * user = [[Appsetting sharedInstance] getUsetInfo];
//        if ([str isEqualToString:@"签到正常"]) {
//            NSString * sql = [NSString stringWithFormat:@"insert into %@ (userID,signIn,signInState,date) values ('%@','%@','%@','%@')",DAILYCHECK_TABLE_NAME,[NSString stringWithFormat:@"%@",user.peopleId],[UIUtils getCurrentDate],[NSString stringWithFormat:@"正常"],[UIUtils getTime]];
//            BOOL rs = [FMDBTool insertWithDB:db tableName:DAILYCHECK_TABLE_NAME withSqlStr:sql];
//            
//            if (!rs) {
//                NSLog(@"失败");
//            }
//        }else if([str isEqualToString:@"签到迟到"]){
//            NSString * sql = [NSString stringWithFormat:@"insert into %@ (userID,signIn,signInState,date) values ('%@','%@','%@','%@')",DAILYCHECK_TABLE_NAME,[NSString stringWithFormat:@"%@",user.peopleId],[UIUtils getCurrentDate],[NSString stringWithFormat:@"迟到"],[UIUtils getTime]];
//            BOOL rs = [FMDBTool insertWithDB:db tableName:DAILYCHECK_TABLE_NAME withSqlStr:sql];
//            
//            if (!rs) {
//                NSLog(@"失败");
//            }
//        }else if ([str isEqualToString:@"签退正常"]) {
//            NSString * sql = [NSString stringWithFormat:@"insert into %@ (userID,signBack,signBackState,date) values ('%@','%@','%@','%@')",DAILYCHECK_TABLE_NAME,[NSString stringWithFormat:@"%@",user.peopleId],[UIUtils getCurrentDate],[NSString stringWithFormat:@"正常"],[UIUtils getTime]];
//            BOOL rs = [FMDBTool insertWithDB:db tableName:DAILYCHECK_TABLE_NAME withSqlStr:sql];
//            
//            if (!rs) {
//                NSLog(@"失败");
//            }
//        }else if ([str isEqualToString:@"签退早退"]){
//            NSString * sql = [NSString stringWithFormat:@"insert into %@ (userID,signBack,signBackState,date) values ('%@','%@','%@','%@')",DAILYCHECK_TABLE_NAME,[NSString stringWithFormat:@"%@",user.peopleId],[UIUtils getCurrentDate],[NSString stringWithFormat:@"早退"],[UIUtils getTime]];
//            BOOL rs = [FMDBTool insertWithDB:db tableName:DAILYCHECK_TABLE_NAME withSqlStr:sql];
//            
//            if (!rs) {
//                NSLog(@"失败");
//            }
//        }
//    }
//    [db close];
}
+(void)upadteDailyCheck:(int)m{
    FMDatabase * db = [FMDBTool createDBWithName:SQLITE_NAME];
    NSString * str  = [UIUtils signState];
    UserModel * user = [[Appsetting sharedInstance] getUsetInfo];
    if ([db open]) {
        if (m==1) {
            if ([str isEqualToString:@"签到正常"]) {
                NSString * sql = [NSString stringWithFormat:@"update %@ set userID = '%@' , signIn = '%@' , signInState = '%@' where date = '%@';",DAILYCHECK_TABLE_NAME,[NSString stringWithFormat:@"%@",user.peopleId],[UIUtils getCurrentDate],[NSString stringWithFormat:@"正常"],[UIUtils getTime]];
                BOOL rs = [FMDBTool updateWithDB:db withSqlStr:sql];
                
                if (!rs) {
                    NSLog(@"失败");
                }
            }else if([str isEqualToString:@"签到迟到"]){
                NSString * sql = [NSString stringWithFormat:@"update %@ set userID = '%@' , signIn = '%@' , signInState = '%@' where date = '%@'",DAILYCHECK_TABLE_NAME,[NSString stringWithFormat:@"%@",user.peopleId],[UIUtils getCurrentDate],[NSString stringWithFormat:@"迟到"],[UIUtils getTime]];
                BOOL rs = [FMDBTool updateWithDB:db withSqlStr:sql];
                
                if (!rs) {
                    NSLog(@"失败");
                }
            }
        }else if(m == 2){
            
            if ([str isEqualToString:@"签退正常"]) {
                NSString * sql = [NSString stringWithFormat:@"update %@ set userID ='%@' , signBack = '%@' , signBackState = '%@' where date = '%@'",DAILYCHECK_TABLE_NAME,[NSString stringWithFormat:@"%@",user.peopleId],[UIUtils getCurrentDate],[NSString stringWithFormat:@"正常"],[UIUtils getTime]];
                BOOL rs = [FMDBTool updateWithDB:db withSqlStr:sql];
                
                if (!rs) {
                    NSLog(@"失败");
                }
            }else if ([str isEqualToString:@"签退早退"]){
                NSString * sql = [NSString stringWithFormat:@"update %@ set userID ='%@' , signBack = '%@' , signBackState = '%@' where date = '%@'",DAILYCHECK_TABLE_NAME,[NSString stringWithFormat:@"%@",user.peopleId],[UIUtils getCurrentDate],[NSString stringWithFormat:@"早退"],[UIUtils getTime]];
                BOOL rs = [FMDBTool updateWithDB:db withSqlStr:sql];
                
                if (!rs) {
                    NSLog(@"失败");
                }
            }
        }
    }
    [db close];
    
}
+(NSDictionary *)getWeekTimeWithType:(NSString *)type
{
    NSDate *nowDate = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *comp = [calendar components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit | NSDayCalendarUnit fromDate:nowDate];
    // 获取今天是周几
    NSInteger weekDay = [comp weekday];
    // 获取几天是几号
    NSInteger day = [comp day];
   // NSLog(@"%d----%d",weekDay,day);
    
    // 计算当前日期和本周的星期一和星期天相差天数
    long firstDiff,lastDiff;
    //    weekDay = 1;
    if (weekDay == 1)
    {
        firstDiff = -6;
        lastDiff = 0;
    }
    else
    {
        firstDiff = [calendar firstWeekday] - weekDay + 1;
        lastDiff = 8 - weekDay;
    }
   // NSLog(@"firstDiff: %ld   lastDiff: %ld",firstDiff,lastDiff);
    
    // 在当前日期(去掉时分秒)基础上加上差的天数
    NSDateComponents *firstDayComp = [calendar components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit  fromDate:nowDate];
    
    [firstDayComp setDay:day + firstDiff];
    
    NSDate *firstDayOfWeek = [calendar dateFromComponents:firstDayComp];
    
    NSDateComponents *lastDayComp = [calendar components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit   fromDate:nowDate];
    [lastDayComp setDay:day + lastDiff];
    
    NSDate *lastDayOfWeek = [calendar dateFromComponents:lastDayComp];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    
    NSString *firstDay = [formatter stringFromDate:firstDayOfWeek];
    NSString *lastDay = [formatter stringFromDate:lastDayOfWeek];
    NSLog(@"%@=======%@",firstDay,lastDay);
    
//    NSString *dateStr = [NSString stringWithFormat:@"%@-%@",firstDay,lastDay];
    NSDictionary * dict = [[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%@",firstDay],@"firstDay",[NSString stringWithFormat:@"%@",lastDay],@"lastDay", nil];
    return dict;
}
+(NSArray *)getWeekAllTimeWithType:(NSString *)type
{
    NSDate *nowDate = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *comp = [calendar components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit | NSDayCalendarUnit fromDate:nowDate];
    // 获取今天是周几
    NSInteger weekDay = [comp weekday];
    // 获取几天是几号
    NSInteger day = [comp day];
    // NSLog(@"%d----%d",weekDay,day);
    
    // 计算当前日期和本周的星期一和星期天相差天数
    long firstDiff,lastDiff;
    //    weekDay = 1;
    if (weekDay == 1)
    {
        firstDiff = -6;
        lastDiff = 0;
    }
    else
    {
        firstDiff = [calendar firstWeekday] - weekDay + 1;
        lastDiff = 8 - weekDay;
    }
    NSMutableArray * ary = [NSMutableArray arrayWithCapacity:1];
    for (int i = 0; i<labs(firstDiff); i++) {
        // 在当前日期(去掉时分秒)基础上加上差的天数
        NSDateComponents *firstDayComp = [calendar components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit  fromDate:nowDate];
        
        [firstDayComp setDay:day + firstDiff+i];
        
        NSDate *firstDayOfWeek = [calendar dateFromComponents:firstDayComp];
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"dd"];
        
        NSString *firstDay = [formatter stringFromDate:firstDayOfWeek];
        [ary addObject:firstDay];
    }
    for (int i = 0; i<=labs(lastDiff); i++) {
        NSDateComponents *lastDayComp = [calendar components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit   fromDate:nowDate];
        [lastDayComp setDay:day + i];
        
        NSDate *lastDayOfWeek = [calendar dateFromComponents:lastDayComp];
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"dd"];
        
        NSString *lastDay = [formatter stringFromDate:lastDayOfWeek];
        [ary addObject:lastDay];
    }
    return ary;
}
+(NSMutableDictionary *)CurriculumGroup:(NSMutableArray *)classAry{
    NSMutableDictionary * dict = [[NSMutableDictionary alloc] init];
    NSMutableArray * bColock = [[NSMutableArray alloc] initWithObjects:YELLOW,PINK,GRASS,PURPLE,BULE,GREEN,LightBlue,RED,GrayG,Warm,DeepBlue,ORANGE,LB,FENSE,ZI,HUANG,LUSE,FENFEN,HUANG1,FEN1, nil];
    NSMutableDictionary * dictColock = [[NSMutableDictionary alloc] init];
    //预先设置课程数组
    for ( int i = 1; i<7; i++) {
        NSMutableArray * ary = [NSMutableArray arrayWithCapacity:1];
        [dict setObject:ary forKey:[NSString stringWithFormat:@"%d",i]];
    }
    
    for(int i = 0;i<classAry.count;i++)
    {
        ClassModel * c = classAry[i];
        if ([c.startTh intValue]%2==0&&[c.startTh intValue]!=0) {
            c.startTh = [NSString stringWithFormat:@"%d",[c.startTh intValue]-1];
        }
        if ([c.endTh intValue]%2==1) {
            c.endTh = [NSString stringWithFormat:@"%d",[c.endTh intValue]+1];
        }
        int n = [UIUtils classNumber:c.startTh];
        int m = ([c.endTh intValue]-[c.startTh intValue]+1)/2;
        if (dictColock.allKeys.count>0) {
            for (int i = 0; i<dictColock.allKeys.count; i++) {
                NSString * str = dictColock.allKeys[i];
                if ([c.name isEqualToString:str]) {
                    c.backColock = [dictColock objectForKey:c.name];
                    break;
                }else if (i==dictColock.allKeys.count-1){
                    if (bColock.count>0) {
                        [dictColock setObject:bColock[0] forKey:c.name];
                        c.backColock = bColock[0];
                        [bColock removeObjectAtIndex:0];
                    }else{
                        
                        int r = arc4random()%225;
                        int g = arc4random()%225;
                        int b = arc4random()%225;
                        c.backColock = RGBA_COLOR(r, g, b, 1);
                        //预设颜色不足时候用随机颜色
                        [dictColock setObject:RGBA_COLOR(r, g, b, 1) forKey:c.name];
                    }
                }
            }
        }else{
            if (bColock.count>0) {
                [dictColock setObject:bColock[0] forKey:c.name];
                c.backColock = bColock[0];
                [bColock removeObjectAtIndex:0];
            }
        }
        
        
        for (int j = 0; j<m; j++) {
            NSMutableArray * ary = [dict objectForKey:[NSString stringWithFormat:@"%d",n+j]];
            [ary addObject:c];
            [dict setObject:ary forKey:[NSString stringWithFormat:@"%d",n+j]];
        }
    }
    return dict;
}
+(int)classNumber:(NSString *)str{
    str = [NSString stringWithFormat:@"%@",str];
    if ([str isEqualToString:@"1"]) {
        return 1;
    }else if ([str isEqualToString:@"3"]) {
        return 2;
    }else if ([str isEqualToString:@"5"]) {
        return 3;
    }else if ([str isEqualToString:@"7"]) {
        return 4;
    }else if ([str isEqualToString:@"9"]) {
        return 5;
    }else if ([str isEqualToString:@"11"]) {
        return 6;
    }
    return 0;
}
//json格式字符串转字典：

+(NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    
    if (jsonString == nil) {
        [UIUtils showInfoMessage:@"扫描二维码有误，请重新扫描或者连接指定WiFi签到" withVC:self];
        return nil;
        
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    
    NSError *err;
    
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                         
                                                        options:NSJSONReadingMutableContainers
                         
                                                          error:&err];
    
    if(err) {
        
        NSLog(@"json解析失败：%@",err);
        [UIUtils showInfoMessage:@"扫描二维码失效，请重新扫描或者连接指定WiFi签到" withVC:self];
        return nil;
        
    }
    
    return dic;
    
}
//获取当前时间戳
+ (NSString*)getCurrentTime {
    
    NSString *urlString = @"http://m.baidu.com";
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString: urlString]];
    [request setCachePolicy:NSURLRequestReloadIgnoringCacheData];
    [request setTimeoutInterval: 2];
    [request setHTTPShouldHandleCookies:FALSE];
    [request setHTTPMethod:@"GET"];
    NSHTTPURLResponse *response;
    [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
    
    NSString *date = [[response allHeaderFields] objectForKey:@"Date"];
    date = [date substringFromIndex:5];
    date = [date substringToIndex:[date length]-4];
    NSDateFormatter *dMatter = [[NSDateFormatter alloc] init];
    dMatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    [dMatter setDateFormat:@"dd MMM yyyy HH:mm:ss"];
    NSDate *netDate = [[dMatter dateFromString:date] dateByAddingTimeInterval:60*60*8];
    
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate: netDate];
    NSDate *localeDate = [netDate  dateByAddingTimeInterval: interval];
    
    NSString*timeSp = [NSString stringWithFormat:@"%ld", (long)[localeDate timeIntervalSince1970]];
    if (localeDate!=nil) {
        return timeSp;
    }
    NSDate*datenow = [NSDate date];
    
//    NSString*timeSp = [NSString stringWithFormat:@"%ld", (long)[datenow timeIntervalSince1970]];
    
    NSTimeZone*zone1 = [NSTimeZone timeZoneWithName:@"Asia/Beijing"];
    
    NSInteger interval1 = [zone1 secondsFromGMTForDate:datenow];

    NSDate*localeDate1 = [datenow dateByAddingTimeInterval:interval1];
    
    NSString*timeSpp = [NSString stringWithFormat:@"%ld", (long)[localeDate1 timeIntervalSince1970]];
    
    return timeSpp;
}
/**
 * 加文字随意@param logoImage 需要加文字的图片@param watemarkText 文字描述@returns 加好文字的图片
 */
+ (UIImage *)addWatemarkTextAfteriOS7_WithLogoImage:(UIImage *)logoImage watemarkText:(NSString *)watemarkText{
    int w = logoImage.size.width;
    int h = logoImage.size.height;
    UIGraphicsBeginImageContext(logoImage.size);
    [[UIColor whiteColor] set];
    [logoImage drawInRect:CGRectMake(0, 0, w, h)];
    UIFont * font = [UIFont systemFontOfSize:18.0];
    [watemarkText drawInRect:CGRectMake(0, h-30, w, 30) withAttributes:@{NSFontAttributeName:font,NSForegroundColorAttributeName:[UIColor whiteColor]}];
    UIImage * newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}
//修改屏幕亮度

+(BOOL)didUserPressLockButton{
    
    CGFloat screenBrightness = [[UIScreen mainScreen] brightness];
    if (screenBrightness > 0) {
        // Home事件
        NSLog(@"Home事件");
        return NO;
    } else {
        // 锁屏事件
        NSLog(@"锁屏事件");
        return YES;
    }
    return NO;
//    //获取屏幕亮度
//    CGFloat oldBrightness = [UIScreen mainScreen].brightness;
//    //以较小的数量改变屏幕亮度
//    [UIScreen mainScreen].brightness = oldBrightness + (oldBrightness <= 0.01 ? (0.01) : (-0.01));
//
//    CGFloat newBrightness = [UIScreen mainScreen].brightness;
//    //恢复屏幕亮度
//    [UIScreen mainScreen].brightness = oldBrightness;
//    //判断屏幕亮度是否能够被改变
//    return oldBrightness != newBrightness;
    
}
+(NSString *)md5:(NSString *)str
{
    const char *cStr = [str UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, strlen(cStr), digest );
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return output;
}
+(NSString *)timeAddTenMin:(NSString *)time{
    
    NSArray *ary = [time componentsSeparatedByString:@" "];
    NSString * expireTime = ary[1];
    NSMutableArray * ary1 = [expireTime componentsSeparatedByString:@":"];
    expireTime = ary1[0];
    NSString * mm = ary1[1];
    
    
    
    long n = [expireTime integerValue];
    long m = [mm integerValue];

    
    if (m>=50) {
        if (n == 24) {
            n = 1;
            m = m + 10 - 60;
            ary1[0] = [NSString stringWithFormat:@"%ld",n];
            ary1[1] = [NSString stringWithFormat:@"%ld",m];
            
        }else {
            n = n+1;
            m = m + 10 - 60;
            
            ary1[0] = [NSString stringWithFormat:@"%ld",n];
            ary1[1] = [NSString stringWithFormat:@"%ld",m];
            
        }
    }else{
        m = m + 10;
        ary1[1] = [NSString stringWithFormat:@"%ld",m];
        
    }
    
    
    expireTime = [NSString stringWithFormat:@"%@ %@:%@",ary[0],ary1[0],ary1[1]];
    
    return expireTime;
}
//减10分钟
+(NSString *)timeSubtractTenMin:(NSString *)time{
    
    NSArray *ary = [time componentsSeparatedByString:@" "];
    NSString * expireTime = ary[1];
    NSMutableArray * ary1 = [expireTime componentsSeparatedByString:@":"];
    expireTime = ary1[0];
    NSString * mm = ary1[1];
    
    
    
    long n = [expireTime integerValue];
    long m = [mm integerValue];
    
    
    if (m<10) {
        if (n == 24) {
            n = 23;
            m = m - 10 + 60;
            ary1[0] = [NSString stringWithFormat:@"%ld",n];
            ary1[1] = [NSString stringWithFormat:@"%ld",m];
            
        }else {
            n = n-1;
            m = m - 10 + 60;
            
            ary1[0] = [NSString stringWithFormat:@"%ld",n];
            ary1[1] = [NSString stringWithFormat:@"%ld",m];
            
        }
    }else{
        m = m - 10;
        ary1[1] = [NSString stringWithFormat:@"%ld",m];
        
    }
    
    
    expireTime = [NSString stringWithFormat:@"%@ %@:%@",ary[0],ary1[0],ary1[1]];
    
    return expireTime;
}
//使用AFN框架来检测网络状态的改变
+(void)AFNReachability
{
    //1.创建网络监听管理者
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    
    //2.监听网络状态的改变
    /*
     AFNetworkReachabilityStatusUnknown     = 未知
     AFNetworkReachabilityStatusNotReachable   = 没有网络
     AFNetworkReachabilityStatusReachableViaWWAN = 3G
     AFNetworkReachabilityStatusReachableViaWiFi = WIFI
     */
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
                NSLog(@"未知");
                break;
            case AFNetworkReachabilityStatusNotReachable:
                NSLog(@"没有网络");
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
                NSLog(@"数据流量");
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
                NSLog(@"WIFI");
                break;
                
            default:
                break;
        }
    }];
    
    //3.开始监听
    [manager startMonitoring];
}
//对缓存wifi进行判断
+(BOOL)determineWifiAndtimeCorrect:(NSMutableArray *)macAry{
 
    NSDictionary * dict = [[Appsetting sharedInstance] getWifiMacAndTime];
    NSString * mac = [dict objectForKey:@"WIFI_mac"];
    NSString * time = [dict objectForKey:@"WIFI_time"];
    if ([UIUtils isBlankString:mac]) {
        return NO;
    }else{
        if ([UIUtils matchingMacWith:macAry withMac:mac]) {
            if ([UIUtils isBlankString:time]) {
                return NO;
            }else{
                if([UIUtils dateTimeDifferenceWithStartTime:time withTime:60]) {
                    return YES;
                }else{
                    return NO;
                }
                
            }
        }else{
            return NO;
        }
    }
    return NO;
    
}
+(NSString *)returnFileType:(NSString *)typeStr{
    //    [string rangeOfString:opt.index].location == NSNotFound
    
    NSString * str = @"xls,xlsx,xlsm,xlt,xltx,xltm";
    NSString * wordStr = @"doc,docx";
    NSString * pngStr = @"png,jpg";
    if ([str rangeOfString:typeStr].location != NSNotFound) {
        return @"excel";
    }else if ([typeStr isEqualToString:@"ai"]){
        return @"ai";
    }else if([wordStr rangeOfString:typeStr].location != NSNotFound){
        return @"word";
    }else if ([typeStr isEqualToString:@"fla"]){
        return @"fla";
    }else if ([typeStr isEqualToString:@"html"]){
        return @"html";
    }else if ([typeStr isEqualToString:@"mp3"]){
        return @"mp3";
    }else if ([typeStr isEqualToString:@"pdf"]){
        return @"pdf";
    }else if ([pngStr rangeOfString:typeStr].location != NSNotFound){
        return @"png";
    }else if ([typeStr isEqualToString:@"ppt"]){
        return @"ppt";
    }else if ([typeStr isEqualToString:@"psd"]){
        return @"psd";
    }else if ([typeStr isEqualToString:@"txt"]){
        return @"txt";
    }else if ([typeStr isEqualToString:@"xd"]){
        return @"xd";
    }else if ([typeStr isEqualToString:@"zip"]){
        return @"zip";
    }else{
        return @"other";
    }
    return @"s";
}
@end





























