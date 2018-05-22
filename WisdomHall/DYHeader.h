//
//  DYHeader.h
//  WisdomHall
//
//  Created by XTU-TI on 2017/4/25.
//  Copyright © 2017年 majinxing. All rights reserved.
//

#ifndef DYHeader_h
#define DYHeader_h

//#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 80000 // 当前Xcode支持iOS8及以上
//#define SCREEN_WIDTH ([[UIScreen mainScreen] respondsToSelector:@selector(nativeBounds)]?[UIScreen mainScreen].nativeBounds.size.width/[UIScreen mainScreen].nativeScale:[UIScreen mainScreen].bounds.size.width)
//#define SCREENH_HEIGHT ([[UIScreen mainScreen] respondsToSelector:@selector(nativeBounds)]?[UIScreen mainScreen].nativeBounds.size.height/[UIScreen mainScreen].nativeScale:[UIScreen mainScreen].bounds.size.height)
//#define SCREEN_SIZE ([[UIScreen mainScreen] respondsToSelector:@selector(nativeBounds)]?CGSizeMake([UIScreen mainScreen].nativeBounds.size.width/[UIScreen mainScreen].nativeScale,[UIScreen mainScreen].nativeBounds.size.height/[UIScreen mainScreen].nativeScale):[UIScreen mainScreen].bounds.size)
//#else #define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width #define SCREENH_HEIGHT [UIScreen mainScreen].bounds.size.height
//#define SCREEN_SIZE [UIScreen mainScreen].bounds.size
//#endif
#define ScreenWidth [[UIScreen mainScreen] bounds].size.width
#define ScreenHeight [[UIScreen mainScreen] bounds].size.height
#define Is_Iphone (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define Is_Iphone_X (Is_Iphone && ScreenHeight == 812.0)
#define NaviHeight Is_Iphone_X ? 88 : 64
#define TabbarHeight Is_Iphone_X ? 83 : 49
#define BottomHeight Is_Iphone_X ? 34 : 0

#define ScrollViewW [[UIScreen mainScreen] bounds].size.width - 20
#define ScrollViewH 70
//屏幕
#define APPLICATION_WIDTH [UIScreen mainScreen].bounds.size.width

#define APPLICATION_HEIGHT ([UIScreen mainScreen].bounds.size.height)
//navigationBar
#define SafeAreaTopHeight (APPLICATION_HEIGHT == 812.0 ? 88 : 64)

#define MAIN_SCREEN_FRAME     [[UIScreen mainScreen] bounds]

#define RGBA_COLOR(R, G, B, A) [UIColor colorWithRed:((R) / 255.0f) green:((G) / 255.0f) blue:((B) / 255.0f) alpha:A]

#define YELLOW                  RGBA_COLOR(230, 185, 90, 1)
#define PINK                    RGBA_COLOR(222, 135, 141, 1)
#define GRASS                   RGBA_COLOR(125, 200, 71, 1)
#define PURPLE                  RGBA_COLOR(113, 147, 228, 1)
#define BULE                    RGBA_COLOR(77, 174, 224, 1)
#define GREEN                   RGBA_COLOR(135, 217, 183, 1)
#define LightBlue               RGBA_COLOR(0, 210, 235, 1)
#define RED                     RGBA_COLOR(228, 0, 63, 1)
#define GrayG                   RGBA_COLOR(41, 176, 162, 1)
#define Warm                    RGBA_COLOR(255, 129, 0, 1)
#define DeepBlue                RGBA_COLOR(0, 39, 74, 1)
#define ORANGE                  RGBA_COLOR(255, 162, 42, 1)
#define LB                      RGBA_COLOR(0, 73, 111, 1)
#define FENSE                   RGBA_COLOR(252, 0, 163, 1)
#define ZI                      RGBA_COLOR(181, 33, 141, 1)
#define HUANG                   RGBA_COLOR(252, 199, 45, 1)
#define LUSE                    RGBA_COLOR(0, 111, 45, 1)
#define FENFEN                  RGBA_COLOR(255, 100, 101, 1)
#define HUANG1                  RGBA_COLOR(255, 153, 42, 1)
#define FEN1                    RGBA_COLOR(255, 56, 119, 1)


#ifdef __OBJC__
@import UIKit;
@import Foundation;
#endif

#endif /* DYHeader_h */
#import "UIColor+HexString.h"
#import "UIUtils.h"
#import "UIViewController+HUD.h"
#import "NetworkRequest.h"
#import "Appsetting.h"
#import "UserModel.h"
#import "ThemeTool.h"


#define Collection_height 120

#define CodeEffectiveTime 10

#define WifiEffectiveTime 60;

#define ShareType_Weixin_Friend     @"微信好友"
#define ShareType_Weixin_Circle     @"朋友圈"
#define ShareType_QQ_Friend         @"QQ好友"
#define ShareType_QQ_Zone           @"QQ空间"
#define ShareType_Weibo             @"新浪微博"
#define ShareType_Message           @"短信"
#define ShareType_Email             @"Email"
#define ShareType_Copy              @"复制链接"

#define InteractionType_Test        @"测验"
#define InteractionType_Discuss     @"讨论"
#define InteractionType_Vote        @"投票"
#define InteractionType_Responder   @"抢答"
#define InteractionType_Data        @"文件"
#define InteractionType_Add         @"更多"
#define InteractionType_Sit         @"座次"
#define InteractionType_Picture     @"问答"
#define InteractionType_Homework    @"作业"

#define Vote_delecate               @"删除"
#define Vote_Modify                 @"修改"
#define Vote_Stare                  @"开始"
#define Vote_Stop                   @"结束"

#define Test_Scores_Query           @"查询成绩"

#define Meeting                     @"会议"
#define Announcement                @"通知"
#define Leave                       @"请假"
#define Business                    @"出差"
#define Lotus                       @"审批"
#define Group                       @"群组"
#define Statistical                 @"统计"

#define CourseCloud                 @"课程云"
#define SecondHand                  @"二手市场"
#define CampusLife                  @"校园生活"
#define SchoolCommunity             @"校圈"
#define AroundSchool                @"学校周边"
#define Community                   @"社团"
#define SchoolRun                   @"校办"

#define ThemeColorChangeNotification @"ThemeColorChangeNotification"//更改主题的通知

#define InApp                  @"InApp"                            //app是否在前台通知

#define OutApp                 @"OutApp"                           //app是否在前台通知
//数据库的名字
#define SQLITE_NAME            @"Dayao"

#define TEXT_TABLE_NAME        @"textTable"                         //试卷表名字

#define QUESTIONS_TABLE_NAME   @"questionsTable"                    //题目表

#define CONTACT_TABLE_NAME     @"contactTable"                      //试卷和题目联系的表格

#define NOTICE_TABLE_NAME      @"noticeTable"                       //通知表

#define TOKENTIME_TABLE_NAME   @"tokenTimeTable"                    //记录token有效期的

#define DAILYCHECK_TABLE_NAME  @"dailyCheck"                        //日常签到统计表

//接口 192.168.1.81:8080 api.dayaokeji.com xtu.api.dayaokeji.com
//#define BaseURL                 @"http://192.168.1.103:8080/"

#define Login                   @"course/user/login"                //登录

#define SchoolList              @"http://www.dayaokeji.com/ldxy_serverlist.html" //   获取学校数据

#define Register                @"course/user/register"             //注册

#define ResetPassword           @"course/user/modify"               //重置密码

#define SchoolDepartMent        @"course/department/list"           //院系列表

#define QueryClassRoom          @"course/classroom/select"          //查询教室

#define QueryCourse             @"course/course/select"             //查询课堂

#define CreateClass             @"course/course/create"             //创建教室

#define QuertyClassNumber       @"course/course/maxnum"             //查询教室节数

#define CreateCoures            @"course/course/create/cycle"       //创建课堂

#define CreateTemporaryCourse   @"course/course/create/once"        //创建临时课堂

#define QueryCourseMemBer       @"course/course/member"             //查询课堂成员

#define DelecateCourse          @"course/course/delete"             //删除课程

#define QueryMeeting            @"course/meeting/select/user"       //查询会议(参与者)

#define QueryMeetingSelfCreate  @"course/meeting/select"            //查询自己创建的会议

#define MeetingSign             @"course/meeting/sign"              //会议签到

#define MeetingDelect           @"course/meeting/delete"            //会议删除

#define MeetingDetailIdDelect   @"course/meeting/detail/delete"     //会议detail删除

#define ClassSign               @"course/course/sign"               //课程签到

#define ClassSign               @"course/course/sign"               //课程签到

#define QueryPeople             @"course/user/list"                 //人员条件查询

#define QuerySelfInfo           @"course/user/detail"               //查询个人信息

#define ChangeSelfInfo          @"course/user/update"               //修改个人信息

#define QueryApp                @"course/app/select"                //查询版本号

#define QueryMeetingPeople      @"course/meeting/member"            //查询与会者信息

#define QueryAdvertising        @"course/resource/select"           //查询广告

#define FeedBack                @"course/feedback/create"           //意见反馈

#define QueryMeetingRoom        @"course/meetingroom/select"        //查询会议室

#define CreateMeeting           @"course/meeting/create"            //创建会议

#define JoinCourse              @"course/course/addMember"          //个人加入课程

#define JoinMeeting             @"course/meeting/addMember"         //个人加入会议

#define FileUpload              @"course/resource/upload"           //上传资料

#define FileDownload            @"course/resource/download"         //资料下载

#define FileList                @"course/resource/select"           //资料列表

#define FileDelegate            @"course/resource/delete"           //删除

#define CreateVote              @"course/vote/create"               //创建投票

#define QueryVote               @"course/vote/list"                 //查询投票

#define QueryListOption         @"course/vote/listOption"           //查询投票选项

#define PeopleVote              @"course/vote/vote"                 //用户投票接口

#define VoteEditor              @"course/vote/update"               //修改投票主题，包含投票状态

#define VoteDelect              @"course/vote/delete"               //删除投票

#define QueryVoteResult         @"course/vote/listOption"           //查询投票结果

#define QueryTest               @"course/exam/queryTestExamAll"     //查询考试列表

#define CreateLib               @"course/exam/createLib"            //创建题库

#define QueryLibList            @"course/exam/qureyLib"             //查询题库

#define QueryTextList           @"course/exam/queryExamQuestion"    //查询试题列表

#define QueryQuestionList       @"course/exam/queryExamQuestion"    //查询试卷题目

#define HandIn                  @"course/exam/commitExam"           //交卷

#define StartText               @"course/exam/ExamUnderway"         //开始考试

#define StopText                @"course/exam/ExamCompleted"        //结束考试

#define DelecateText            @"course/exam/deleteExam"           //删除考试

#define QuertyTestScores        @"course/exam/queryExamGradeTeacher"//查询考试成绩

#define StudentStart            @"course/exam/startExam"            //学生开始考试

#define QuertyQusetionBank      @"course/exam/qureyLib"             //查询题库列表

#define CreateQuestion          @"course/exam/createQuestion"       //创建题目

#define QuertyBankQuestionList  @"course/exam/queryQuestion"        //查询题库题目列表

#define CreateText              @"course/exam/createExam"           //创建考试

#define Update                  @"course/user/password/update"      //修改密码

#define QueryGroupList          @"course/group/select"              //查询群组列表

#define JoinGroup               @"course/group/addGroupUser"        //加入群组

#define GroupPeople             @"course/group/member"              //查询群组成员

#define QueryNotice             @"course/message/qurey"             //查询通知消息

#define BindPhoe                @"course/user/bindPhone"            //绑定手机号

#define QueryRoomSeat           @"course/course/getRoomSeat"        //查询课堂空座

#define UpdateSeat              @"course/course/updateSeat"         //更新座次

#define NoticeReceive           @"course/message/update"            //消息回执

#define Noticedelect            @"course/message/delete"            //删除消息

#define PhotoSign               @"course/course/photoSign"          //拍照签到

#define QuertyStatistics        @"course/course/statistics"         //按照部门查询

#define QuertyClass             @"course/course/statisticsByCourse" //按照课程查询

#define StatisticsSelf          @"course/course/statistics/by/user" //查询学生自己信息

#define SyncCourse              @"course/sync/course"               //同步课程信息

#define CourseWorkList          @"course/classwork/list"            //作业列表

#define CreateHomework          @"course/classwork/create"          //创建作业

#define DeleteHomework          @"course/classwork/delete"          //删除作业

#define ChangeAppState          @"course/user/changeAppState"       //app状态改变

#define UploadTemp              @"course/resource/uploadTemp"       //上传临时文件

#define QueryStudentAnswer      @"course/exam/queryStudentAnswerInfo"//查询作答详情

#define ClassResponder          @"course/course/collect"             //课堂抢答统计

#define MeetingResponder        @"course/meeting/collect"            //会议抢答统计

#define SmsSend                 @"course/sms/send"                   //发送短信

#define SmsValidate             @"course/sms/validate"               //验证短信








