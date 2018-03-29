//
//  TTUtil.m
//  Guitar
//
//  Created by Yuan Li on 9/8/14.
//  Copyright (c) 2014 Eric Yuan. All rights reserved.
//

#include <CommonCrypto/CommonDigest.h>
#include <CommonCrypto/CommonHMAC.h>
#import <CommonCrypto/CommonCryptor.h>
#import "TTUtil.h"
#import "AFNetworking.h"
#import "NSDate+Utilities.h"
@implementation TTUtil

+ (NSString *)md5StringForString:(NSString *)string {
    const char *str = [string UTF8String];
    unsigned char r[CC_MD5_DIGEST_LENGTH];
    CC_MD5(str, (unsigned int)strlen(str), r);
    return [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            r[0], r[1], r[2], r[3], r[4], r[5], r[6], r[7], r[8], r[9], r[10], r[11], r[12], r[13], r[14], r[15]];
}

+ (BOOL)courseFileExist:(NSString*)courseID
{
    BOOL isDir;
    BOOL ret = [[NSFileManager defaultManager] fileExistsAtPath:[TTUtil courseFilePath:courseID] isDirectory:&isDir];
    return ret && isDir;
}

+ (NSString*)courseFilePath:(NSString *)courseID
{
    // 规则：MD5(courseID+tantan)为文件夹名
#ifndef kDemoCourseID
#define kDemoCourseID 40
#endif
    if (courseID.intValue == kDemoCourseID) {
        return [NSBundle mainBundle].bundlePath;
    }
    
    NSString *coursePath = [[TTUtil cachePath] stringByAppendingPathComponent:
                           [TTUtil md5StringForString:[NSString stringWithFormat:@"%@%@", courseID, @"tantan"]]];
#ifdef __DBG__
    DLog(@"courseID: %@, path: %@", courseID, coursePath);
#endif
    return coursePath;
}

+ (NSString*)cachePath
{
   NSArray *cachePath = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    return cachePath[0];
}

+ (BOOL)isCourseDownloaded:(NSString*)courseID
{
    return (courseID.intValue == kDemoCourseID) ||
    ([TTUtil courseFileExist:courseID] &&
    [[NSFileManager defaultManager] fileExistsAtPath:
     [[TTUtil courseFilePath:courseID] stringByAppendingPathComponent:@"info.json"]]);
}
//转换时间戳的方法
+ (NSString *)calDaysBefore:(NSString *)aTime
{
    NSDate *creatDate = [NSDate dateWithTimeIntervalSince1970:[aTime doubleValue]];
    NSDate *curDate = [NSDate date];
    NSInteger days = [creatDate daysBeforeDate:curDate];
    if (days != 0)
    {
        return [NSString stringWithFormat:@"%ld天前",days];
    }
    else
    {
        NSInteger hours = [creatDate hoursBeforeDate:curDate];
        if (hours == 0)
        {
            return [NSString stringWithFormat:@"刚刚"];
        }
        return [NSString stringWithFormat:@"%ld小时前",hours];
    }
}

@end
