//
//  ChatHelper.m
//  WisdomHall
//
//  Created by XTU-TI on 2017/5/18.
//  Copyright © 2017年 majinxing. All rights reserved.
//

#import "ChatHelper.h"
#import <Hyphenate/Hyphenate.h>
#import "ConversationVC.h"
#import "DYHeader.h"
#import "FMDBTool.h"

// 引入JPush功能所需头文件
#import "JPUSHService.h"
// iOS10注册APNs所需头文件
#ifdef NSFoundationVersionNumber_iOS_9_x_Max

#import <UserNotifications/UserNotifications.h>

#endif

// 如果需要使用idfa功能所需要引入的头文件（可选）
#import <AdSupport/AdSupport.h>


static ChatHelper *helper = nil;
static dispatch_once_t onceToken;

@interface ChatHelper ()<EMClientDelegate,EMChatManagerDelegate,EMContactManagerDelegate,EMGroupManagerDelegate,EMChatroomManagerDelegate,EMCallManagerDelegate>
@property (nonatomic,strong)FMDatabase * db;


@end
@implementation ChatHelper
+ (instancetype)shareHelper
{
    dispatch_once(&onceToken, ^{
        helper = [[ChatHelper alloc] init];
    });
    return helper;
}
-(void)getOut{
    onceToken = 0;
    helper = nil;
    [[EMClient sharedClient] removeDelegate:self];
    [[EMClient sharedClient].groupManager removeDelegate:self];
    [[EMClient sharedClient].contactManager removeDelegate:self];
    [[EMClient sharedClient].roomManager removeDelegate:self];
    [[EMClient sharedClient].chatManager removeDelegate:self];
    [[EMClient sharedClient].callManager removeDelegate:self];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    UserModel * user = [[Appsetting sharedInstance] getUsetInfo];
    [JPUSHService setAlias:[NSString stringWithFormat:@"%@%@",user.school,user.studentId] callbackSelector:nil object:self];
    
    EMError *error = [[EMClient sharedClient] logout:YES];
    if (!error) {
        NSLog(@"退出成功");
    }
}

- (void)dealloc
{
    [[EMClient sharedClient] removeDelegate:self];
    [[EMClient sharedClient].groupManager removeDelegate:self];
    [[EMClient sharedClient].contactManager removeDelegate:self];
    [[EMClient sharedClient].roomManager removeDelegate:self];
    [[EMClient sharedClient].chatManager removeDelegate:self];
    [[EMClient sharedClient].callManager removeDelegate:self];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}

- (id)init
{
    self = [super init];
    if (self) {
        [self initHelper];
        _outOrIn = @"In";
    }
    return self;
}
- (void)initHelper
{
    [self Hyregistered];
    
    //注册代理
    [[EMClient sharedClient] addDelegate:self delegateQueue:nil];
    [[EMClient sharedClient].groupManager addDelegate:self delegateQueue:nil];
    [[EMClient sharedClient].callManager addDelegate:self delegateQueue:nil];
    [[EMClient sharedClient].contactManager addDelegate:self delegateQueue:nil];
    [[EMClient sharedClient].roomManager addDelegate:self delegateQueue:nil];
    [[EMClient sharedClient].chatManager addDelegate:self delegateQueue:nil];
    
}
-(void)Hyregistered{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //环信注册
        EMOptions  * options = [EMOptions optionsWithAppkey:@"1137170815115624#smartclassroom"];
        
        [[EMClient sharedClient] initializeSDKWithOptions:options];
        
        UserModel * user = [[Appsetting sharedInstance] getUsetInfo];
        
        EMError *error = [[EMClient sharedClient] registerWithUsername:[NSString stringWithFormat:@"%@%@",user.school,user.studentId] password:[NSString stringWithFormat:@"%@",user.studentId]];
        
        [JPUSHService setAlias:[NSString stringWithFormat:@"%@%@",user.school,user.studentId] completion:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {
            
        } seq:0];
        
        if (error==nil) {
            NSLog(@"注册成功");
        }
        
        EMError *error2 = [[EMClient sharedClient] loginWithUsername:[NSString stringWithFormat:@"%@%@",user.school,user.studentId] password:[NSString stringWithFormat:@"%@",user.studentId]];
        
        if (!error2) {
            NSLog(@"登录成功");
            [[EMClient sharedClient].options setIsAutoLogin:YES];
        }else{
            NSLog(@"环信登录失败%@",error);
        }
    });
    
}
-(void)tagsAliasCallback:(int)iResCode tags:(NSSet*)tags alias:(NSString*)alias {
    
    NSLog(@"rescode: %d, \ntags: %@, \nalias: %@\n", iResCode, tags , alias);
    
}
- (void)didJoinedGroup:(EMGroup *)aGroup
               inviter:(NSString *)aInviter
               message:(NSString *)aMessage{
    EMError *error = nil;
    UserModel * user = [[Appsetting sharedInstance] getUsetInfo];
    NSArray * a = [[NSArray alloc] initWithObjects:[NSString stringWithFormat:@"%@%@",user.school,user.studentId], nil];
    [[EMClient sharedClient].groupManager addOccupants:a toGroup:aGroup.groupId welcomeMessage:@"message" error:&error];
    
}
/*!
 @method
 @brief 接收到一条及以上非cmd消息
 */
- (void)messagesDidReceive:(NSArray *)aMessages{
    
    NSMutableDictionary * dict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:aMessages,@"messageAry", nil];
    
    // 2.创建通知
    NSNotification *notification =[NSNotification notificationWithName:@"InfoNotification" object:nil userInfo:dict];
    // 3.通过 通知中心 发送 通知
    
    [[NSNotificationCenter defaultCenter] postNotification:notification];
    
    [self addLocalNotificationWith:aMessages];
    
}
// 发送本地通知通知
- (void)addLocalNotificationWith:(NSArray *)aMessage {
    for (int i = 0; i<aMessage.count; i++) {
        EMMessage * message = aMessage[i];
        EMTextMessageBody *textBody = (EMTextMessageBody *)message.body;
        // 1.创建一个本地通知
        UILocalNotification *localNote = [[UILocalNotification alloc] init];
        
        // 1.1.设置通知发出的时间
        localNote.fireDate = [NSDate dateWithTimeIntervalSinceNow:0];
        
        if ([textBody.text rangeOfString:@"LvDongKeTang"].location !=NSNotFound) {
            
            
            NSMutableString *strUrl = [NSMutableString stringWithFormat:@"%@",textBody.text];
            
            [strUrl deleteCharactersInRange:NSMakeRange(0, 81)];
            strUrl = [NSMutableString stringWithFormat:@"%@",[strUrl substringToIndex:[strUrl length] - 2]];
            // 1.3.设置锁屏时,字体下方显示的一个文字
            localNote.alertAction = @"";
            
            localNote.hasAction = YES;
            // 1.2.设置通知内容
            localNote.alertBody = strUrl;
            
            // 1.4.设置启动图片(通过通知打开的)
            //  localNote.alertLaunchImage = @"../Documents/IMG_0024.jpg";
            
            // 1.5.设置通过到来的声音
            // localNote.soundName = UILocalNotificationDefaultSoundName;
            
            // 1.6.设置应用图标左上角显示的数字
            // localNote.applicationIconBadgeNumber = 999;
            
            // 1.7.设置一些额外的信息
            // localNote.userInfo = @{@"qq" : @"704711253", @"msg" : @"success"};
            
            // 2.执行通知
            [[UIApplication sharedApplication] scheduleLocalNotification:localNote];
            
            if ([self.outOrIn isEqualToString:@"In"]) {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:strUrl message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                [alertView show];
            }
            NSString * time = [UIUtils getTime];
            [self insertedIntoNoticeTable:time noticeContent:strUrl];
            
        }
    }
}
/*!
 @method
 @brief 接收到一条及以上cmd消息
 */
- (void)cmdMessagesDidReceive:(NSArray *)aCmdMessages{
    //    NSLog(@"%s",__func__);
    //    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"新信息" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
    //    [alertView show];
    //
}
//接收语音聊天 mjx
-(void)callDidReceive:(EMCallSession *)aSession{
    
    //    NSLog(@"%s",__func__);
    //    ConversationVC * c  = [[ConversationVC alloc] init];
    //    c.callSession = aSession;
    //    [UIApplication sharedApplication].keyWindow.rootViewController = [[UINavigationController alloc]initWithRootViewController:c];
    //    //    调用:
    //    EMError *error = nil;
    
    NSDictionary * dict = [[NSDictionary alloc] initWithObjectsAndKeys:aSession,@"session", nil];
    // 2.创建通知
    NSNotification *notification =[NSNotification notificationWithName:@"VoiceCalls" object:nil userInfo:dict];
    // 3.通过 通知中心 发送 通知
    
    [[NSNotificationCenter defaultCenter] postNotification:notification];
}
-(EMMessage *)sendTextMessage:(NSString *)text withReceiver:(NSString *)receiver{
    
    EMTextMessageBody *body = [[EMTextMessageBody alloc] initWithText:text];
    
    NSString * from = [[EMClient sharedClient] currentUsername];
    
    EMMessage * message = [[EMMessage alloc] initWithConversationID:receiver from:from to:receiver body:body ext:@{@"em_apns_ext":@{@"em_push_title":text}}];
    
    message.chatType =  EMChatTypeGroupChat;
    
    UserModel * user = [[Appsetting sharedInstance] getUsetInfo];
    
    NSDictionary * dict = [[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%@",user.userName],@"name",[NSString stringWithFormat:@"%@",user.userHeadImageId],@"headImage", nil];
    message.ext = dict;
    
    [[EMClient sharedClient].chatManager sendMessage:message progress:^(int progress) {
        
    } completion:^(EMMessage *message, EMError *error) {
        if (!error) {
            NSLog(@"成功");
        }else{
            NSLog(@"失败");
        }
    }];
    
    return message;
}
-(EMMessage *)sendTextMessageToPeople:(NSString *)text withReceiver:(NSString *)receiver{
    
    EMTextMessageBody *body = [[EMTextMessageBody alloc] initWithText:text];
    
    NSString * from = [[EMClient sharedClient] currentUsername];
    
    EMMessage * message = [[EMMessage alloc] initWithConversationID:receiver from:from to:receiver body:body ext:@{@"em_apns_ext":@{@"em_push_title":text}}];
    
    message.chatType =  EMChatTypeChat;
    
    [[EMClient sharedClient].chatManager sendMessage:message progress:^(int progress) {
        
    } completion:^(EMMessage *message, EMError *error) {
        if (!error) {
            //            NSLog(@"成功");
        }else{
            //            NSLog(@"失败");
        }
    }];
    
    return message;
}

-(float)returnMessageInfoHeight:(EMMessage *)message{
    switch (message.body.type) {
        case EMMessageBodyTypeText: //文字
        {
            EMTextMessageBody *textBody = (EMTextMessageBody *)message.body;
            float h = [self computingTextHeight:textBody.text];
            return h;
        }
            break;
        case EMMessageBodyTypeImage://图片
            
            break;
        case EMMessageBodyTypeVideo://视频
            
            break;
        case EMMessageBodyTypeVoice://语音
            break;
            
        default:
            break;
    }
    
    return 0;
}
-(float)computingTextHeight:(NSString *)text{
    //---- 计算高度 ---- //
    CGSize size = CGSizeMake( 200, CGFLOAT_MAX);
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:13],NSFontAttributeName, nil];
    CGFloat curheight = [text boundingRectWithSize:size
                                           options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                        attributes:dic
                                           context:nil].size.height;
    return curheight;
}

-(void)insertedIntoNoticeTable:(NSString *)noticeTime noticeContent:(NSString *)content{
    
    _db = [FMDBTool createDBWithName:SQLITE_NAME];
    
    [self creatTextTable:NOTICE_TABLE_NAME];
    
    if ([_db open]) {
        NSString * sql = [NSString stringWithFormat:@"insert into %@ (noticeTime, noticeContent) values ('%@', '%@')",NOTICE_TABLE_NAME,noticeTime,content];
        
        BOOL rs = [FMDBTool insertWithDB:_db tableName:NOTICE_TABLE_NAME withSqlStr:sql];
        
        if (!rs) {
            NSLog(@"失败");
        }
        
    }
    [_db close];
}
-(void)creatTextTable:(NSString *)tableName{
    if ([_db open]) {
        BOOL result = [FMDBTool createTableWithDB:_db tableName:tableName
                                       parameters:@{
                                                    @"noticeTime" : @"text",
                                                    @"noticeContent" : @"text",
                                                    }];
        if (result)
        {
            NSLog(@"建表成功");
        }
        else
        {
            NSLog(@"建表失败");
        }
    }
    [_db close];
}

@end
