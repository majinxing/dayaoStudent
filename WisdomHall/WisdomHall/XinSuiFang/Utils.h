//
//  Utils.h
//  XinSuiFang
//
//  Created by majinxing on 16/8/12.
//  Copyright © 2016年 majinxing. All rights reserved.
//

#ifndef Utils_h
#define Utils_h


#endif /* Utils_h */
// 其他
#define SYSTEM_SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SYSTEM_SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
#define APPFRAME_WIDTH ([UIScreen mainScreen].applicationFrame.size.width)
#define APP_FRAME ([UIScreen mainScreen].applicationFrame)

//屏幕
#define APPLICATION_WIDTH [UIScreen mainScreen].bounds.size.width

#define APPLICATION_HEIGHT ([UIScreen mainScreen].bounds.size.height)
#define MAIN_SCREEN_FRAME     [[UIScreen mainScreen] bounds]

// check字符串
#define CHECK_STRING_VALID(targetString)				\
(targetString != nil && [targetString isKindOfClass:[NSString class]] && [targetString length] > 0)

#define CHECK_STRING_INVALID(targetString)              \
(targetString == nil || ![targetString isKindOfClass:[NSString class]] || [targetString length] == 0)

//接口 http://www.funcx.cn/xsfServer/app/ping
#define MJXBaseURL  @"http://www.funcx.cn/xsfServer/app"
#define MJXoffline   @"http://192.168.31.153:80/xsfServer/app"
//数据库表名字
#define SQLITE_NAME         @"xinsuifang"
//数据表名
#define TABLE_NAME          @"localDraft" //本地图片数据库表名字

#define TABLE_NAME_PATIENTS @"AllpatientsInfoDraft" // 所有患者信息表

#define TABLE_NAME_COURSE_OF_DISEASE @"courseOfDiseaseDraft" //病程表名字
#define TABLE_NAME_COURSE_Of_SMALL_CLASS "courseOfSmallClassDraft" //病程小类的表名字
#define TABLE_NAME_RECENT_CONSULTING @"recentConsultingDraft" //最近咨询的表名字

#define TABLE_NAME_GROUP_NAME @"groupNameDraft"//分组名字






