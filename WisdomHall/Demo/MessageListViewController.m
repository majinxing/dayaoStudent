/*
 Copyright (c) 2014-2015, GoBelieve
 All rights reserved.
 
 This source code is licensed under the BSD-style license found in the
 LICENSE file in the root directory of this source tree. An additional grant
 of patent rights can be found in the PATENTS file in the same directory.
 */

#import "MessageListViewController.h"
//#import <gobelieve/IMessage.h>
#import "IMessage.h"
//#import <gobelieve/IMService.h>
#import "IMService.h"
//#import <gobelieve/PeerMessageDB.h>
#import "PeerMessageDB.h"
//#import <gobelieve/GroupMessageDB.h>
#import "GroupMessageDB.h"
//#import <gobelieve/CustomerMessageDB.h>
#import "CustomerMessageDB.h"
//#import <gobelieve/PeerMessageViewController.h>
#import "PeerMessageViewController.h"
//#import <gobelieve/GroupMessageViewController.h>
#import "GroupMessageViewController.h"
//#import <gobelieve/CustomerMessageViewController.h>
#import "CustomerMessageViewController.h"

#import "PeerMessageHandler.h"
#import "GroupMessageHandler.h"
#import "CustomerMessageHandler.h"
#import "IMHttpAPI.h"
#import "SyncKeyHandler.h"

#import "MessageConversationCell.h"
#import "Conversation.h"

#import "NoticeViewController.h"

#import "GroupListViewController.h"

#import "CreateChatGroupView.h"

#import "SelectGroupPeopleViewController.h"
//RGB颜色
#define RGBCOLOR(r,g,b) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]
//RGB颜色和不透明度
#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f \
alpha:(a)]

#define APPID 7
#define KEFU_ID 54

#define kConversationCellHeight         60

@interface MessageListViewController()<UITableViewDelegate, UITableViewDataSource,
    TCPConnectionObserver, PeerMessageObserver, GroupMessageObserver,
    SystemMessageObserver, RTMessageObserver, MessageViewControllerUserDelegate,MessageListViewControllerGroupDelegate,CreateChatGroupViewDelegate>
@property (strong , nonatomic) NSMutableArray *conversations;
@property (strong , nonatomic) UITableView *tableview;
@property (nonatomic,strong)UserModel * user;
@property (nonatomic,strong)CreateChatGroupView * v;
@end

@implementation MessageListViewController

-(id)init {
    self = [super init];
    if (self) {
        self.conversations = [[NSMutableArray alloc] init];
    }
    return self;
}

-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

//聊天列表
- (void)viewDidLoad {
    [super viewDidLoad];
    
    _user = [[Appsetting sharedInstance] getUsetInfo];//i++
    
    NSString * str = [NSString stringWithFormat:@"%@%@",_user.school,_user.studentId];
    
    _currentUID = [str longLongValue];
    
    _groupDelegate = self;

    _userDelegate = self;

//    UIBarButtonItem *newBackButton = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(home:)];
//    self.navigationItem.leftBarButtonItem=newBackButton;
    
    CGRect rect = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    self.tableview = [[UITableView alloc]initWithFrame:rect style:UITableViewStylePlain];
  	self.tableview.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	self.tableview.delegate = self;
	self.tableview.dataSource = self;
	self.tableview.scrollEnabled = YES;
	self.tableview.showsVerticalScrollIndicator = NO;
	self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableview.backgroundColor = RGBACOLOR(235, 235, 237, 1);
    self.tableview.separatorColor = RGBCOLOR(208, 208, 208);
	[self.view addSubview:self.tableview];
    
    [[IMService instance] addPeerMessageObserver:self];
    [[IMService instance] addGroupMessageObserver:self];
    [[IMService instance] addConnectionObserver:self];
    [[IMService instance] addSystemMessageObserver:self];
    [[IMService instance] addRTMessageObserver:self];
    
    [[NSNotificationCenter defaultCenter] addObserver: self selector:@selector(newGroupMessage:) name:LATEST_GROUP_MESSAGE object:nil];
    [[NSNotificationCenter defaultCenter] addObserver: self selector:@selector(newMessage:) name:LATEST_PEER_MESSAGE object:nil];
    [[NSNotificationCenter defaultCenter] addObserver: self selector:@selector(newCustomerMessage:) name:LATEST_CUSTOMER_MESSAGE object:nil];
    
    
    [[NSNotificationCenter defaultCenter] addObserver: self selector:@selector(clearSinglePeerNewState:) name:CLEAR_PEER_NEW_MESSAGE object:nil];
    [[NSNotificationCenter defaultCenter] addObserver: self selector:@selector(clearSingleGroupNewState:) name:CLEAR_GROUP_NEW_MESSAGE object:nil];
    

    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appWillResignActive) name:UIApplicationWillResignActiveNotification object:nil];

    id<ConversationIterator> iterator =  [[PeerMessageDB instance] newConversationIterator];
    
    IMessage * msg = [iterator next];
    
    while (msg) {
        Conversation *c = [[Conversation alloc] init];
        c.message = msg;
        c.cid = (self.currentUID == msg.sender) ? msg.receiver : msg.sender;
        c.type = CONVERSATION_PEER;
        [self.conversations addObject:c];
        msg = [iterator next];
    }
    
    iterator = [[GroupMessageDB instance] newConversationIterator];
    msg = [iterator next];
    while (msg) {
        Conversation *c = [[Conversation alloc] init];
        c.message = msg;
        c.cid = msg.receiver;
        c.type = CONVERSATION_GROUP;
        [self.conversations addObject:c];
        msg = [iterator next];
    }
 
    for (Conversation *conv in self.conversations) {
        [self updateConversationName:conv];
        [self updateConversationDetail:conv];
    }
    
    id<IMessageIterator> iter = [[CustomerMessageDB instance] newMessageIterator:KEFU_ID];
    msg = nil;
    //返回第一条不是附件的消息
    while (YES) {
        msg = [iter next];
        if (msg == nil) {
            break;
        }
        if (msg.type != MESSAGE_ATTACHMENT) {
            break;
        }
    }
    if (!msg) {
        msg = [[ICustomerMessage alloc] init];
        ICustomerMessage *m = (ICustomerMessage*)msg;
        m.sender = 0;
        m.receiver = self.currentUID;
        m.storeID = KEFU_ID;
        m.sellerID = 0;
        m.customerID = self.currentUID;
        m.customerAppID = APPID;
        
        MessageTextContent *content = [[MessageTextContent alloc] initWithText:@"如果你在使用过程中有任何问题和建议，记得给我们发信反馈哦"];
        m.rawContent = content.raw;
        m.timestamp = (int)time(NULL);
    }

    Conversation *conv = [[Conversation alloc] init];
    conv.message = msg;
    conv.cid = ((ICustomerMessage*)msg).storeID;
    conv.type = CONVERSATION_CUSTOMER_SERVICE;
    conv.name = @"通知";
    
    [self updateConversationDetail:conv];
    
    Conversation *conv1 = [[Conversation alloc] init];
    conv1.message = msg;
    conv1.cid = ((ICustomerMessage*)msg).storeID;
    conv1.type = CONVERSATION_CUSTOMER_SERVICE;
    conv1.name = @"群组";
    
    [self updateConversationDetail:conv1];
//    [self.conversations addObject:conv];
    
    //todo 从本地数据库加载最新的系统消息
    NSArray *sortedArray = [self.conversations sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        Conversation *c1 = obj1;
        Conversation *c2 = obj2;
        
        int t1 = c1.timestamp;
        int t2 = c2.timestamp;
        
        if (t1 < t2) {
            return NSOrderedDescending;
        } else if (t1 == t2) {
            return NSOrderedSame;
        } else {
            return NSOrderedAscending;
        }
    }];
    
    self.conversations = [NSMutableArray arrayWithArray:sortedArray];
    
    [self.conversations insertObject:conv1 atIndex:0];

    [self.conversations insertObject:conv atIndex:1];


    self.navigationItem.title = @"对话";
    if ([[IMService instance] connectState] == STATE_CONNECTING) {
        self.navigationItem.title = @"连接中...";
    }
    [self setNavigationTitle];
}

-(void)setNavigationTitle{
    //    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
    if ([_type isEqualToString:@"enableCreate"]) {
        UIBarButtonItem *myButton = [[UIBarButtonItem alloc] initWithTitle:@"创建群组" style:UIBarButtonItemStylePlain target:self action:@selector(createGroup)];
        self.navigationItem.rightBarButtonItem = myButton;
    }
    
    
    
    //
    //    UIBarButtonItem * selection = [[UIBarButtonItem alloc] initWithTitle:@"搜索" style:UIBarButtonItemStylePlain target:self action:@selector(selectionBtnPressed)];
    //    self.navigationItem.leftBarButtonItem = selection;
}
-(void)createGroup{
    if (!_v) {
        _v = [[CreateChatGroupView alloc] initWithFrame:CGRectMake(0, 0, APPLICATION_WIDTH, APPLICATION_HEIGHT)];
        [_v addContentViewWithAry:nil];
        _v.delegate = self;
        [self.view addSubview:_v];
    }
    
//    [IMHttpAPI createGroup:@"群" master:501112233 members:@[@"5012012551321",@"5012012551319",@"5012012551322",@"501112233",@"5012012551320"] success:^(NSDictionary *groupId) {
//        NSLog(@"");
//        [_tableview reloadData];
//    } fail:^(NSString *error) {
//        NSLog(@"%@",error);
//    }];
}
- (void)updateConversationDetail:(Conversation*)conv {
    conv.timestamp = conv.message.timestamp;
    if (conv.message.type == MESSAGE_IMAGE) {
        conv.detail = @"一张图片";
    }else if(conv.message.type == MESSAGE_TEXT){
        MessageTextContent *content = conv.message.textContent;
        conv.detail = content.text;
    }else if(conv.message.type == MESSAGE_LOCATION){
        conv.detail = @"一个地理位置";
    }else if (conv.message.type == MESSAGE_AUDIO){
        conv.detail = @"一个音频";
    } else if (conv.message.type == MESSAGE_GROUP_NOTIFICATION) {
        [self updateNotificationDesc:conv];
    }
}

-(void)updateConversationName:(Conversation*)conversation {
    if (conversation.type == CONVERSATION_PEER) {
        IUser *u = [self.userDelegate getUser:conversation.cid];
        if (u.name.length > 0) {
            conversation.name = u.name;
            conversation.avatarURL = u.avatarURL;
        } else {
            conversation.name = u.identifier;
            conversation.avatarURL = u.avatarURL;
            
            [self.userDelegate asyncGetUser:conversation.cid cb:^(IUser *u) {
                conversation.name = u.name;
                conversation.avatarURL = u.avatarURL;
            }];
        }
    } else if (conversation.type == CONVERSATION_GROUP) {
        IGroup *g = [self.groupDelegate getGroup:conversation.cid];
        if (g.name.length > 0) {
            conversation.name = g.name;
            conversation.avatarURL = g.avatarURL;
        } else {
            conversation.name = g.identifier;
            conversation.avatarURL = g.avatarURL;
            
            [self.groupDelegate asyncGetGroup:conversation.cid cb:^(IGroup *g) {
                conversation.name = g.name;
                conversation.avatarURL = g.avatarURL;
            }];
        }
    }
}

-(void)home:(UIBarButtonItem *)sender {
    [[IMService instance] removePeerMessageObserver:self];
    [[IMService instance] removeGroupMessageObserver:self];
    [[IMService instance] removeConnectionObserver:self];
    [[IMService instance] removeSystemMessageObserver:self];
    [[IMService instance] removeRTMessageObserver:self];
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)updateNotificationDesc:(Conversation*)conv {
    IMessage *message = conv.message;
    if (message.type == MESSAGE_GROUP_NOTIFICATION) {
        MessageGroupNotificationContent *notification = message.notificationContent;
        int type = notification.notificationType;
        if (type == NOTIFICATION_GROUP_CREATED) {
            if (self.currentUID == notification.master) {
                NSString *desc = [NSString stringWithFormat:@"您创建了\"%@\"群组", notification.groupName];
                notification.notificationDesc = desc;
                conv.detail = notification.notificationDesc;
            } else {
                NSString *desc = [NSString stringWithFormat:@"您加入了\"%@\"群组", notification.groupName];
                notification.notificationDesc = desc;
                conv.detail = notification.notificationDesc;
            }
        } else if (type == NOTIFICATION_GROUP_DISBANDED) {
            notification.notificationDesc = @"群组已解散";
            conv.detail = notification.notificationDesc;
        } else if (type == NOTIFICATION_GROUP_MEMBER_ADDED) {
            IUser *u = [self.userDelegate getUser:notification.member];
            if (u.name.length > 0) {
                NSString *name = u.name;
                NSString *desc = [NSString stringWithFormat:@"%@加入群", name];
                notification.notificationDesc = desc;
                conv.detail = notification.notificationDesc;
            } else {
                NSString *name = u.identifier;
                NSString *desc = [NSString stringWithFormat:@"%@加入群", name];
                notification.notificationDesc = desc;
                conv.detail = notification.notificationDesc;
                [self.userDelegate asyncGetUser:notification.member cb:^(IUser *u) {
                    NSString *desc = [NSString stringWithFormat:@"%@加入群", u.name];
                    notification.notificationDesc = desc;
                    //会话的最新消息未改变
                    if (conv.message == message) {
                        conv.detail = notification.notificationDesc;
                    }
                }];
            }
        } else if (type == NOTIFICATION_GROUP_MEMBER_LEAVED) {
            IUser *u = [self.userDelegate getUser:notification.member];
            if (u.name.length > 0) {
                NSString *name = u.name;
                NSString *desc = [NSString stringWithFormat:@"%@离开群", name];
                notification.notificationDesc = desc;
                conv.detail = notification.notificationDesc;
            } else {
                NSString *name = u.identifier;
                NSString *desc = [NSString stringWithFormat:@"%@离开群", name];
                notification.notificationDesc = desc;
                conv.detail = notification.notificationDesc;
                [self.userDelegate asyncGetUser:notification.member cb:^(IUser *u) {
                    NSString *desc = [NSString stringWithFormat:@"%@离开群", u.name];
                    notification.notificationDesc = desc;
                    //会话的最新消息未改变
                    if (conv.message == message) {
                        conv.detail = notification.notificationDesc;
                    }
                }];
            }
        } else if (type == NOTIFICATION_GROUP_NAME_UPDATED) {
            NSString *desc = [NSString stringWithFormat:@"群组更名为%@", notification.groupName];
            notification.notificationDesc = desc;
            conv.detail = notification.notificationDesc;
        }
    }
}


+ (NSString *)getConversationTimeString:(NSDate *)date{
    NSMutableString *outStr;
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [gregorian components:NSUIntegerMax fromDate:date];
    NSDateComponents *todayComponents = [gregorian components:NSIntegerMax fromDate:[NSDate date]];
    
    if (components.year == todayComponents.year &&
        components.day == todayComponents.day &&
        components.month == todayComponents.month) {
        NSString *format = @"HH:mm";
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
        [formatter setDateFormat:format];
        [formatter setTimeZone:[NSTimeZone systemTimeZone]];
        
        NSString *timeStr = [formatter stringFromDate:date];
        
        if (components.hour > 11) {
            outStr = [NSMutableString stringWithFormat:@"%@ %@",@"下午",timeStr];
        } else {
            outStr = [NSMutableString stringWithFormat:@"%@ %@",@"上午",timeStr];
        }
        return outStr;
    } else {
        NSString *format = @"MM-dd HH:mm";
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
        [formatter setDateFormat:format];
        [formatter setTimeZone:[NSTimeZone systemTimeZone]];
        
        return [formatter stringFromDate:date];
    }
}
#pragma mark - CreateChatGroupViewDelegate
-(void)addPeopleBtnPressedDelegae{
    SelectGroupPeopleViewController * vc = [[SelectGroupPeopleViewController alloc] init];
    vc.dataAry = [NSMutableArray arrayWithArray:_peopleAry];
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
//    __weak SelectGroupPeopleViewController * weakSelf = vc;
    [vc returnSelectPeopleAry:^(NSMutableArray *selectAry) {
        NSLog(@"%@",selectAry);
        [_v.peopleListView addGroupContentView:selectAry];
//        [_v addContentViewWithAry:selectAry];
    }];
}
-(void)outSelfViewDelegate{
    [_v removeFromSuperview];
    _v = nil;
}
-(void)endEditeDelegate{
    [self.view endEditing:YES];
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.conversations count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kConversationCellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MessageConversationCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MessageConversationCell"];
    
    if (cell == nil) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"MessageConversationCell" owner:self options:nil] lastObject];
    }
    Conversation * conv = nil;
    
    conv = (Conversation*)[self.conversations objectAtIndex:(indexPath.row)];
    
    [cell setConversation:conv];

    return cell;
    
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.tableview) {
        return YES;
    }
    return NO;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //add code here for when you hit delete
        Conversation *con = [self.conversations objectAtIndex:indexPath.row];
        if (con.type == CONVERSATION_PEER) {
            [[PeerMessageDB instance] clearConversation:con.cid];
        } else if (con.type == CONVERSATION_GROUP){
            [[GroupMessageDB instance] clearConversation:con.cid];
        }
        [self.conversations removeObject:con];
        
        /*IOS8中删除最后一个cell的时，报一个错误
         [RemindersCell _setDeleteAnimationInProgress:]: message sent to deallocated instance
         在重新刷新tableView的时候延迟一下*/
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.tableview reloadData];
        });
    }
}




#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    if (indexPath.row==1) {
        NoticeViewController * noticeVC = [[NoticeViewController alloc] init];
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:noticeVC animated:YES];
        self.hidesBottomBarWhenPushed = NO;
        return;
    }else if (indexPath.row == 0){
        GroupListViewController * g = [[GroupListViewController alloc] init];
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:g animated:YES];
        self.hidesBottomBarWhenPushed = NO;
        return;
    }
    Conversation *con = [self.conversations objectAtIndex:indexPath.row];
    if (con.type == CONVERSATION_PEER) {
        PeerMessageViewController* msgController = [[PeerMessageViewController alloc] init];
        msgController.userDelegate = self.userDelegate;
        msgController.peerUID = con.cid;
        msgController.peerName = con.name;
        msgController.currentUID = self.currentUID;
        msgController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:msgController animated:YES];
    } else if (con.type == CONVERSATION_GROUP) {
        GroupMessageViewController* msgController = [[GroupMessageViewController alloc] init];
        msgController.isShowUserName = YES;
        msgController.userDelegate = self.userDelegate;
        
        msgController.groupID = con.cid;
        msgController.groupName = con.name;
        msgController.currentUID = self.currentUID;
        msgController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:msgController animated:YES];
    } else if (con.type == CONVERSATION_CUSTOMER_SERVICE) {
        CustomerMessageViewController *msgController = [[CustomerMessageViewController alloc] init];
        msgController.userDelegate = self.userDelegate;

        msgController.appID = APPID;
        if (con.cid == 0) {
            msgController.storeID = KEFU_ID;
        } else {
            msgController.storeID = con.cid;
        }
        msgController.peerName = con.name;
        msgController.currentUID = self.currentUID;
        msgController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:msgController animated:YES];
    }
    
}


- (void)newGroupMessage:(NSNotification*)notification {
    IMessage *m = notification.object;
    NSLog(@"new message:%lld, %lld", m.sender, m.receiver);
    [self onNewGroupMessage:m cid:m.receiver];
}

- (void)newMessage:(NSNotification*) notification {
    IMessage *m = notification.object;
    NSLog(@"new message:%lld, %lld", m.sender, m.receiver);
    [self onNewMessage:m cid:m.receiver];
}

- (void)newCustomerMessage:(NSNotification*) notification {
    ICustomerMessage *m = notification.object;
    NSLog(@"new message:%lld, %lld", m.sender, m.receiver);
    [self onNewCustomerMessage:m cid:m.receiver];
}

- (void)clearSinglePeerNewState:(NSNotification*) notification {
    int64_t usrid = [(NSNumber*)notification.object longLongValue];
    for (int index = 0 ; index < [self.conversations count] ; index++) {
        Conversation *conv = [self.conversations objectAtIndex:index];
        if (conv.type == CONVERSATION_PEER && conv.cid == usrid) {
            if (conv.newMsgCount > 0) {
                conv.newMsgCount = 0;
                [self resetConversationsViewControllerNewState];
            }
        }
    }
}

- (void)clearSingleGroupNewState:(NSNotification*) notification{
    int64_t groupID = [(NSNumber*)notification.object longLongValue];
    for (int index = 0 ; index < [self.conversations count] ; index++) {
        Conversation *conv = [self.conversations objectAtIndex:index];
        if (conv.type == CONVERSATION_GROUP && conv.cid == groupID) {
            if (conv.newMsgCount > 0) {
                conv.newMsgCount = 0;
                [self resetConversationsViewControllerNewState];
            }
        }
    }
}

-(void)onNewGroupMessage:(IMessage*)msg cid:(int64_t)cid{
    int index = -1;
    for (int i = 0; i < [self.conversations count]; i++) {
        Conversation *con = [self.conversations objectAtIndex:i];
        if (con.type == CONVERSATION_GROUP && con.cid == cid) {
            index = i;
            break;
        }
    }
    
    if (index != -1) {
        Conversation *con = [self.conversations objectAtIndex:index];
        con.message = msg;
        
        [self updateConversationDetail:con];
        if (self.currentUID != msg.sender) {
            con.newMsgCount += 1;
            [self setNewOnTabBar];
        }
        
        if (index != 0) {
            //置顶
            [self.conversations removeObjectAtIndex:index];
            if (self.conversations.count>=2) {
                [self.conversations insertObject:con atIndex:2];
            }else{
                [self.conversations insertObject:con atIndex:0];
            }
//            [self.conversations insertObject:con atIndex:0];
            [self.tableview reloadData];
        }
    } else {
        Conversation *con = [[Conversation alloc] init];
        con.message = msg;
        [self updateConversationDetail:con];
        
        if (self.currentUID != msg.sender) {
            con.newMsgCount += 1;
            [self setNewOnTabBar];
        }
        
        con.type = CONVERSATION_GROUP;
        con.cid = cid;
        [self updateConversationName:con];
        
        if (self.conversations.count>=2) {
            [self.conversations insertObject:con atIndex:2];
        }else{
            [self.conversations insertObject:con atIndex:0];
        }
//        [self.conversations insertObject:con atIndex:0];
        NSIndexPath *path = [NSIndexPath indexPathForRow:2 inSection:0];
        NSArray *array = [NSArray arrayWithObject:path];
        [self.tableview insertRowsAtIndexPaths:array withRowAnimation:UITableViewRowAnimationMiddle];
    }
}


-(void)onNewMessage:(IMessage*)msg cid:(int64_t)cid{
    int index = -1;
    for (int i = 0; i < [self.conversations count]; i++) {
        Conversation *con = [self.conversations objectAtIndex:i];
        if (con.type == CONVERSATION_PEER && con.cid == cid) {
            index = i;
            break;
        }
    }
    
    if (index != -1) {
        Conversation *con = [self.conversations objectAtIndex:index];
        con.message = msg;
        
        [self updateConversationDetail:con];
        
        if (self.currentUID == msg.receiver) {
            con.newMsgCount += 1;
            [self setNewOnTabBar];
        }
        
        if (index != 0) {
            //置顶 修改位置chat
            [self.conversations removeObjectAtIndex:index];
            if (self.conversations.count>=2) {
                [self.conversations insertObject:con atIndex:2];
            }else{
                [self.conversations insertObject:con atIndex:0];
            }
            [self.tableview reloadData];
        }
    } else {
        Conversation *con = [[Conversation alloc] init];
        con.type = CONVERSATION_PEER;
        con.cid = cid;
        con.message = msg;
        
        [self updateConversationName:con];
        [self updateConversationDetail:con];
        
        if (self.currentUID == msg.receiver) {
            con.newMsgCount += 1;
            [self setNewOnTabBar];
        }
        if (self.conversations.count>=2) {
            [self.conversations insertObject:con atIndex:2];
        }else{
            [self.conversations insertObject:con atIndex:0];
        }

//        [self.conversations insertObject:con atIndex:0];
        NSIndexPath *path = [NSIndexPath indexPathForRow:2 inSection:0];
        NSArray *array = [NSArray arrayWithObject:path];
        [self.tableview insertRowsAtIndexPaths:array withRowAnimation:UITableViewRowAnimationMiddle];
    }
}


-(void)onNewCustomerMessage:(ICustomerMessage*)msg cid:(int64_t)cid{
    int index = -1;
    for (int i = 0; i < [self.conversations count]; i++) {
        Conversation *con = [self.conversations objectAtIndex:i];
        if (con.type == CONVERSATION_CUSTOMER_SERVICE && con.cid == cid) {
            index = i;
            break;
        }
    }
    
    if (index != -1) {
        Conversation *con = [self.conversations objectAtIndex:index];
        con.message = msg;
        
        [self updateConversationDetail:con];
        
        if (self.currentUID == msg.receiver) {
            con.newMsgCount += 1;
            [self setNewOnTabBar];
        }
        
        if (index != 0) {
            //置顶
            
            [self.conversations removeObjectAtIndex:index];
            if (self.conversations.count>=2) {
                [self.conversations insertObject:con atIndex:2];
            }else{
                [self.conversations insertObject:con atIndex:0];
            }
//            [self.conversations insertObject:con atIndex:0];
            [self.tableview reloadData];
        }
    } else {
        Conversation *con = [[Conversation alloc] init];
        con.type = CONVERSATION_CUSTOMER_SERVICE;
        con.cid = cid;
        con.message = msg;
        
        [self updateConversationName:con];
        [self updateConversationDetail:con];
        
        if (self.currentUID == msg.receiver) {
            con.newMsgCount += 1;
            [self setNewOnTabBar];
        }
        if (self.conversations.count>=2) {
            [self.conversations insertObject:con atIndex:2];
        }else{
            [self.conversations insertObject:con atIndex:0];
        }
//        [self.conversations insertObject:con atIndex:0];
        NSIndexPath *path = [NSIndexPath indexPathForRow:2 inSection:0];
        NSArray *array = [NSArray arrayWithObject:path];
        [self.tableview insertRowsAtIndexPaths:array withRowAnimation:UITableViewRowAnimationMiddle];
    }
}


-(void)onPeerMessage:(IMMessage*)im {
    IMessage *m = [[IMessage alloc] init];
    m.sender = im.sender;
    m.receiver = im.receiver;
    m.msgLocalID = im.msgLocalID;
    m.rawContent = im.content;
    m.timestamp = im.timestamp;

    int64_t cid;
    if (self.currentUID == m.sender) {
        cid = m.receiver;
    } else {
        cid = m.sender;
    }
    
    [self onNewMessage:m cid:cid];
}

-(void)onGroupMessage:(IMMessage *)im {
    IMessage *m = [[IMessage alloc] init];
    m.sender = im.sender;
    m.receiver = im.receiver;
    m.msgLocalID = im.msgLocalID;
    m.rawContent = im.content;
    m.timestamp = im.timestamp;

    [self onNewGroupMessage:m cid:m.receiver];
}

-(void)onGroupNotification:(NSString*)text {
    MessageGroupNotificationContent *notification = [[MessageGroupNotificationContent alloc] initWithNotification:text];
    int64_t groupID = notification.groupID;
    
    IMessage *msg = [[IMessage alloc] init];
    msg.sender = 0;
    msg.receiver = groupID;
    if (notification.timestamp > 0) {
        msg.timestamp = notification.timestamp;
    } else {
        msg.timestamp = (int)time(NULL);
    }
    msg.rawContent = notification.raw;
    
    [self onNewGroupMessage:msg cid:msg.receiver];
}


//同IM服务器连接的状态变更通知
-(void)onConnectState:(int)state {
    if (state == STATE_CONNECTING) {
        self.navigationItem.title = @"连接中...";
    } else if (state == STATE_CONNECTED) {
        self.navigationItem.title = @"对话";
    } else if (state == STATE_CONNECTFAIL) {
        
    } else if (state == STATE_UNCONNECTED) {
        
    }
}

-(void) onSystemMessage:(NSString *)sm {
    NSLog(@"system message:%@", sm);
    NSUInteger index = [self.conversations indexOfObjectPassingTest:^BOOL(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        Conversation *conv = obj;
        return conv.type == CONVERSATION_SYSTEM;
    }];
    if (index == NSNotFound) {
        Conversation *conv = [[Conversation alloc] init];
        //todo maybe 从系统消息体中获取时间
        conv.timestamp = (int)time(NULL);
        //todo 解析系统消息格式
        conv.detail = sm;
        
        conv.name = @"新朋友";
        
        conv.type = CONVERSATION_SYSTEM;
        conv.cid = 0;
        if (self.conversations.count>=2) {
            [self.conversations insertObject:conv atIndex:2];
        }else{
            [self.conversations insertObject:conv atIndex:0];
        }
//        [self.conversations insertObject:conv atIndex:0];
        
        NSIndexPath *path = [NSIndexPath indexPathForRow:2 inSection:0];
        NSArray *array = [NSArray arrayWithObject:path];
        [self.tableview insertRowsAtIndexPaths:array withRowAnimation:UITableViewRowAnimationMiddle];
    } else {
        Conversation *conv = [self.conversations objectAtIndex:index];
        
        conv.detail = sm;
        conv.timestamp = (int)time(NULL);
        
        if (index != 0) {
            //置顶
            [self.conversations removeObjectAtIndex:index];
            if (self.conversations.count>=2) {
                [self.conversations insertObject:conv atIndex:2];
            }else{
                [self.conversations insertObject:conv atIndex:0];
            }
//            [self.conversations insertObject:conv atIndex:0];
            [self.tableview reloadData];
        }
    }
}

-(void)onRTMessage:(RTMessage*)rt {
    NSLog(@"rt message:%lld %lld %@", rt.sender, rt.receiver, rt.content);
}

-(NSString*)getDocumentPath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    return basePath;
}


-(BOOL)mkdir:(NSString*)path {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:path]) {
        NSError *err;
        BOOL r = [fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&err];
        
        if (!r) {
            NSLog(@"mkdir err:%@", err);
        }
        return r;
    }
    
    return YES;
}

- (void)actionChat {
//    if (!tfSender.text.length) {
//        NSLog(@"invalid input");
//        return;
//    }
    [self.view endEditing:YES];
    
//    self.chatButton.userInteractionEnabled = NO;
//    long long sender = [tfSender.text longLongValue];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *token = [self login:1];
        
        dispatch_async(dispatch_get_main_queue(), ^{
//            self.chatButton.userInteractionEnabled = YES;
            
            if (token.length == 0) {
                NSLog(@"login fail");
                return;
            }
            
            NSLog(@"login success");
            
            
            
#ifdef FILE_ENGINE_DB
            NSString *path = [self getDocumentPath];
            NSString *dbPath = [NSString stringWithFormat:@"%@/%lld", path, [@"1" longLongValue]];
            [self mkdir:dbPath];
            
#elif defined SQL_ENGINE_DB
            NSString *path = [self getDocumentPath];
            NSString *dbPath = [NSString stringWithFormat:@"%@/gobelieve_%lld.db", path, [tfSender.text longLongValue]];
            
            //检查数据库文件是否已经存在
            NSFileManager *fileManager = [NSFileManager defaultManager];
            if (![fileManager fileExistsAtPath:dbPath]) {
                NSString *p = [[NSBundle mainBundle] pathForResource:@"gobelieve" ofType:@"db"];
                [fileManager copyItemAtPath:p toPath:dbPath error:nil];
            }
            FMDatabase *db = [[FMDatabase alloc] initWithPath:dbPath];
            BOOL r = [db openWithFlags:SQLITE_OPEN_READWRITE|SQLITE_OPEN_WAL vfs:nil];
            if (!r) {
                NSLog(@"open database error:%@", [db lastError]);
                db = nil;
                NSAssert(NO, @"");
            }
#else
#error dd
#endif
            
            
            
#ifdef FILE_ENGINE_DB
            [PeerMessageDB instance].dbPath = [NSString stringWithFormat:@"%@/peer", dbPath];
            [GroupMessageDB instance].dbPath = [NSString stringWithFormat:@"%@/group", dbPath];
            [CustomerMessageDB instance].dbPath = [NSString stringWithFormat:@"%@/customer", dbPath];
#elif defined SQL_ENGINE_DB
            [PeerMessageDB instance].db = db;
            [GroupMessageDB instance].db = db;
            [CustomerMessageDB instance].db = db;
#else
            
#endif
            
            [PeerMessageHandler instance].uid = [@"1" longLongValue];
            [GroupMessageHandler instance].uid = [@"1" longLongValue];
            [CustomerMessageHandler instance].uid = [@"1" longLongValue];
            
            [IMHttpAPI instance].accessToken = token;
            [IMService instance].token = token;
            
            
            path = [self getDocumentPath];
            dbPath = [NSString stringWithFormat:@"%@/%lld", path, [@"1" longLongValue]];
            [self mkdir:dbPath];
            
            NSString *fileName = [NSString stringWithFormat:@"%@/synckey", dbPath];
            
            SyncKeyHandler *handler = [[SyncKeyHandler alloc] initWithFileName:fileName];
            [IMService instance].syncKeyHandler = handler;
            
            [IMService instance].syncKey = [handler syncKey];
            NSLog(@"sync key:%lld", [handler syncKey]);
            
            [[IMService instance] clearSuperGroupSyncKey];
            NSDictionary *groups = [handler superGroupSyncKeys];
            for (NSNumber *k in groups) {
                NSNumber *v = [groups objectForKey:k];
                NSLog(@"group id:%@ sync key:%@", k, v);
                [[IMService instance] addSuperGroupSyncKey:[v longLongValue] gid:[k longLongValue]];
            }
            
            [[IMService instance] start];
            
            if (self.deviceToken.length > 0) {
                
                [IMHttpAPI bindDeviceToken:self.deviceToken
                                   success:^{
                                       NSLog(@"bind device token success");
                                   }
                                      fail:^{
                                          NSLog(@"bind device token fail");
                                      }];
            }
            
//            if (tfReceiver.text.length > 0) {
//                PeerMessageViewController *msgController = [[PeerMessageViewController alloc] init];
//                msgController.currentUID = [tfSender.text longLongValue];
//                msgController.peerUID = [tfReceiver.text longLongValue];
//                msgController.peerName = @"测试";
//                msgController.userDelegate = self;
//                self.navigationController.navigationBarHidden = NO;
//                [self.navigationController pushViewController:msgController animated:YES];
//            } else {
//                MessageListViewController *ctrl = [[MessageListViewController alloc] init];
//                ctrl.currentUID = [tfSender.text longLongValue];
//                ctrl.userDelegate = self;
//                ctrl.groupDelegate = self;
//                self.navigationController.navigationBarHidden = NO;
//                [self.navigationController pushViewController:ctrl animated:YES];
//            }
        });
    });
}
//生成token
-(NSString*)login:(long long)uid {
    //调用app自身的服务器获取连接im服务必须的access token
    //    NSString *url = @"http://demo.gobelieve.io/auth/token";
    NSString * url = [NSString stringWithFormat:@"%@/%@",IMAPIURL,IMToken];//@"http://192.168.1.100:8010/course-im/auth/grant";
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]
                                                              cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                          timeoutInterval:60];
    
    
    [urlRequest setHTTPMethod:@"POST"];
    
    NSMutableDictionary *headers = [NSMutableDictionary dictionaryWithObject:@"application/json" forKey:@"Content-Type"];
    
    NSString * auth = [NSString stringWithFormat:@"Basic Nzo0NDk3NjBiMTIwNjEwYWMwYjNhYmRiZDk1NTI1NGVlMA=="];
    
    [headers setObject:auth forKey:@"Authorization"];
    
    [urlRequest setAllHTTPHeaderFields:headers];
    
    
    
#if TARGET_IPHONE_SIMULATOR
    NSString *deviceID = @"7C8A8F5B-E5F4-4797-8758-05367D2A4D61";
    NSLog(@"device id:%@", @"7C8A8F5B-E5F4-4797-8758-05367D2A4D61");
#else
    NSString *deviceID = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    NSLog(@"device id:%@", [[[UIDevice currentDevice] identifierForVendor] UUIDString]);
#endif
    
    
    NSMutableDictionary *obj = [NSMutableDictionary dictionary];
    [obj setObject:[NSNumber numberWithLongLong:uid] forKey:@"uid"];
    [obj setObject:[NSString stringWithFormat:@"测试用户%lld", uid] forKey:@"user_name"];
    [obj setObject:[NSNumber numberWithInt:PLATFORM_IOS] forKey:@"platform_id"];
    [obj setObject:deviceID forKey:@"device_id"];
    
    NSData *postBody = [NSJSONSerialization dataWithJSONObject:obj options:0 error:nil];
    
    [urlRequest setHTTPBody:postBody];
    
    NSURLResponse *response = nil;
    
    NSError *error = nil;
    
    NSData *data = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&response error:&error];
    if (error != nil) {
        NSLog(@"error:%@", error);
        return nil;
    }
    NSHTTPURLResponse *httpResp = (NSHTTPURLResponse*)response;
    if (httpResp.statusCode != 200) {
        return nil;
    }
    NSDictionary *e = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
    return [NSString stringWithFormat:@"%@", [e objectForKey:@"token"]];
    //    return [NSString stringWithFormat:@"%@",[[e objectForKey:@"body"] objectForKey:@"token"]];
}


- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (viewController == self) {
        [[IMService instance] stop];
        
        if (self.deviceToken.length > 0) {
            
            [IMHttpAPI unbindDeviceToken:self.deviceToken
                                 success:^{
                                     NSLog(@"unbind device token success");
                                 }
                                    fail:^{
                                        NSLog(@"unbind device token fail");
                                    }];
        }
    }
}

#pragma mark - MessageViewControllerUserDelegate
//从本地获取用户信息, IUser的name字段为空时，显示identifier字段
- (IUser*)getUser:(int64_t)uid {
    IUser *u = [[IUser alloc] init];
    u.uid = uid;
    u.name = @"";
    u.avatarURL = @"http://api.gobelieve.io/images/e837c4c84f706a7988d43d62d190e2a1.png";
    u.identifier = [NSString stringWithFormat:@"uid:%lld", uid];
    return u;
}
//从服务器获取用户信息
- (void)asyncGetUser:(int64_t)uid cb:(void(^)(IUser*))cb {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        IUser *u = [[IUser alloc] init];
        u.uid = uid;
        u.name = [NSString stringWithFormat:@"name:%lld", uid];
        u.avatarURL = @"http://api.gobelieve.io/images/e837c4c84f706a7988d43d62d190e2a1.png";
        u.identifier = [NSString stringWithFormat:@"uid:%lld", uid];
        dispatch_async(dispatch_get_main_queue(), ^{
            cb(u);
        });
    });
}
#pragma mark - MessageListViewControllerGroupDelegate
//从本地获取群组信息
- (IGroup*)getGroup:(int64_t)gid {
    IGroup *g = [[IGroup alloc] init];
    g.gid = gid;
    g.name = @"";
    g.avatarURL = @"";
    g.identifier = [NSString stringWithFormat:@"gid:%lld", gid];
    return g;
}

//从服务器获取用户信息
- (void)asyncGetGroup:(int64_t)gid cb:(void(^)(IGroup*))cb {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        IGroup *g = [[IGroup alloc] init];
        g.gid = gid;
        g.name = [NSString stringWithFormat:@"gname:%lld", gid];
        g.avatarURL = @"";
        g.identifier = [NSString stringWithFormat:@"gid:%lld", gid];
        dispatch_async(dispatch_get_main_queue(), ^{
            cb(g);
        });
    });
}
#pragma mark - function
-(void) resetConversationsViewControllerNewState{
    BOOL shouldClearNewCount = YES;
    for (Conversation *conv in self.conversations) {
        if (conv.newMsgCount > 0) {
            shouldClearNewCount = NO;
            break;
        }
    }
    
    if (shouldClearNewCount) {
        [self clearNewOnTarBar];
    }

}

- (void)setNewOnTabBar {

}

- (void)clearNewOnTarBar {

}

- (void)appWillResignActive {
    NSLog(@"app will resign active");
    int c = 0;
    for (Conversation *conv in self.conversations) {
        c += conv.newMsgCount;
    }
    NSLog(@"unread count:%d", c);
    [[IMService instance] sendUnreadCount:c];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:c];
}

@end
