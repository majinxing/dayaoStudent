//
//  UIUtils.h
//  WisdomHall
//
//  Created by XTU-TI on 2017/4/26.
//  Copyright © 2017年 majinxing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DYHeader.h"
#import "ClassRoomModel.h"
#import "UserModel.h"
@interface UIUtils : NSObject
+(void)addNavigationWithView:(UIView *)view withTitle:(NSString *)str;
//判断电话号码是否正确
+(BOOL)testCellPhoneNumber:(NSString *)mobileNum;
/**
 *  获取当地日期
 */
+(NSString *)getCurrentDate;
/**
 * 判断字符串是否为空
 **/
+(BOOL)isBlankString:(NSString *)string;
/**
*  判断电话是否是11位数字
**/

+(BOOL)isSimplePhone:(NSString *)phone;
/**
 * 判断是否全是数字
 **/
+(BOOL)isPureInt:(NSString *)string;
/**
 * 获取当前时间
 **/
+(NSString *)getTime;
/**
 *  获取当前月份
 **/
+(NSString *)getMonth;
+(NSString *)getMoreMonthTime;
/**
 * 获取当前的无线信号
 **/
+(NSMutableDictionary *)getWifiName;
/**
 * 规范路由器地址
 **/
+(NSString *)specificationMCKAddress:(NSString *)str;
//判断今天是否在这个时间段内
+(BOOL)validateWithStartTime:(NSString *)startTime withExpireTime:(NSString *)expireTime;
//比较两个时间的早晚
+(NSString *)compareTimeStartTime:(NSString *)startTime withExpireTime:(NSString *)expireTime;
//获取学期数
+(int)getTermId;
//创建课程
+(NSMutableDictionary *)createCourseWith:(NSMutableArray *)ary ClassRoom:(ClassRoomModel *)c joinClassPeople:(NSMutableArray *)joinPeopleAry m1:(int)m1 m2:(int)m2 m3:(int)m3 week:(int)week class1:(int)class1 class2:(int)class2;
//创建临时课程
+(NSMutableDictionary *)createTemporaryCourseWith:(NSMutableArray *)ary ClassRoom:(ClassRoomModel *)c joinClassPeople:(NSMutableArray *)joinPeopleAry week:(int)week class1:(int)class1 class2:(int)class2;
//返回个人信息数组
+(NSMutableArray *)returnAry:(UserModel *)user;
//查询是否是周一
+ (NSString*)weekdayStringFromDate:(NSString *)startTime;
//版本号比较
+(BOOL)compareTheVersionNumber:(NSString *)netVersion withLocal:(NSString *)localVersion;
//显示token是否过期
+(void)tokenThePeriodOfValidity;
//账号被顶下
+(void)accountWasUnderTheRoof;

//会场顺序选座
+(NSMutableDictionary *)seatingArrangements:(NSString *)seating withNumberPeople:(NSString *)numberPeople;
//与会人员与座位匹配
+(NSDictionary *)seatWithPeople:(NSMutableArray *)peopleAry withSeat:(NSMutableArray *)seatAry roomId:(NSString *)roomId;
//发送群体会议通知
+(void)sendMeetingInfo:(NSDictionary *)dict;
//显示信息
+(void)showInfoMessage:(NSString *)str;

+(NSString *)timeWithTimeIntervalString:(NSString *)timeString;
//转换显示出mac
+(NSString *)returnMac:(NSMutableArray *)ary;
//比较mac地址
+(BOOL)matchingMacWith:(NSMutableArray *)ary withMac:(NSString *)mac;
/// 服务器可达返回true
+(BOOL)socketReachabilityTest;
//返回手机型号
+(NSString*)deviceVersion;

/**
 * 日常签到
 **/
+(void)dailyCheck;
//返回本周周一周日日期
+(NSDictionary *)getWeekTimeWithType:(NSString *)type;
//课程分组
+(NSMutableDictionary *)CurriculumGroup:(NSMutableArray *)classAry;

+(NSArray *)getWeekAllTimeWithType:(NSString *)type;
/**
 
 * 开始到结束的时间差
 
 */
+ (BOOL)dateTimeDifferenceWithStartTime:(NSString *)startTime;
//获取当前时间戳
+ (NSString*)getCurrentTime;
//json格式字符串转字典：

+(NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;
//时间戳化时间
+(NSString *)getTheTimeStamp:(NSString *)time;
/**
 *  判断二维码数组是否与接口数组有重叠数据
 **/
+(BOOL)returnMckIsHave:(NSMutableArray *)localAry withAccept:(NSArray *)acceptAry;
//获取网络时间
+(NSDate *)getInternetDate;
//打水印
+(UIImage *)addWatemarkTextAfteriOS7_WithLogoImage:(UIImage *)logoImage watemarkText:(NSString *)watemarkText;
//周期会议时间处理
+(NSMutableArray *)returnAry:(NSString *)startTime withEndTime:(NSString *)endTime room:(NSString *)roomId meetingsFacilitatorList:(NSString *)nameHost monthOrWeek:(NSString *)mRw;
@end


