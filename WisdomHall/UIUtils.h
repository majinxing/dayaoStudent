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

+(id)shareInstance;

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
//时间戳化时间
+(NSString *)getTheTimeStamp:(NSString *)time;
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
+(NSDictionary *)seatWithPeople:(NSMutableArray *)peopleAry withSeat:(NSMutableArray *)seatAry;
//发送群体会议通知
+(void)sendMeetingInfo:(NSDictionary *)dict;
//显示信息
+(void)showInfoMessage:(NSString *)str withVC:(UIViewController *)vc;

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
//jason 字符串转化成字典
+(NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;

/**
 
 * 开始到结束的时间差
 
 */
+ (BOOL)dateTimeDifferenceWithStartTime:(NSString *)startTime withTime:(int)time;
/**
 *  判断二维码数组是否与接口数组有重叠数据
 **/
+(BOOL)returnMckIsHave:(NSMutableArray *)localAry withAccept:(NSArray *)acceptAry;
//获取当前时间戳
+ (NSString*)getCurrentTime;
//获取网路时间
+(NSDate *)getInternetDate;
/**
 * 加文字随意@param logoImage 需要加文字的图片@param watemarkText 文字描述@returns 加好文字的图片
 */
+ (UIImage *)addWatemarkTextAfteriOS7_WithLogoImage:(UIImage *)logoImage watemarkText:(NSString *)watemarkText;
//修改屏幕亮度

+(BOOL)didUserPressLockButton;
//md5
+(NSString *)md5:(NSString *)str;
//时间加10分钟
+(NSString *)timeAddTenMin:(NSString *)time;
//减10分钟
+(NSString *)timeSubtractTenMin:(NSString *)time;

//网络状态监听
+(void)AFNReachability;
//对缓存的wifi进行判断
+(BOOL)determineWifiAndtimeCorrect:(NSMutableArray *)macAry;
/**
 
 * 距离签到时间的差值
 
 */

+(NSString *)dateTimeDifferenceWithStartTime:(NSString *)startTime;
/**
 * 返回文件类型对应的图片
 **/
+(NSString *)returnFileType:(NSString *)typeStr;

+(void)getGroupData;
//根据id获取groupname
+(NSString *)getGroupName:(NSString *)groupId;
//根据id获取名字
+(NSString *)getGPeopleName:(NSString *)peopleId;
//获取缓存的头像数据
+(NSString *)getGPeoplePictureId:(NSString *)peopleId;
@end

