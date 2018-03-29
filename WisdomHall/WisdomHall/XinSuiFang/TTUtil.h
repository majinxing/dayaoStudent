//
//  TTUtil.h
//  Guitar
//
//  Created by Yuan Li on 9/8/14.
//  Copyright (c) 2014 Eric Yuan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TTUtil : NSObject

/**
 *  MD5
 *
 *  @param string
 *
 *  @return MD5(string)
 */
+ (NSString *)md5StringForString:(NSString *)string;

/**
 *  判断课程文件是否存在
 *
 *  @param courseID 课程 ID
 *
 *  @return
 */
+ (BOOL)courseFileExist:(NSString*)courseID;

/**
 *  课程文件夹路径
 *
 *  @param courseID 课程 ID
 *
 *  @return
 */
+ (NSString*)courseFilePath:(NSString*)courseID;

/**
 *  cache file path
 *
 *  @return
 */
+ (NSString*)cachePath;

/**
 *  检测课程是否已经被下载
 *
 *  @param courseID
 *
 *  @return
 */
+ (BOOL)isCourseDownloaded:(NSString*)courseID;
/**
 *  转换时间戳
 */
+ (NSString *)calDaysBefore:(NSString *)aTime;

@end
