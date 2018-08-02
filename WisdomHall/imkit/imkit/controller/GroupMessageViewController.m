/*                                                                            
 Copyright (c) 2014-2015, GoBelieve
 All rights reserved.
 
 This source code is licensed under the BSD-style license found in the
 LICENSE file in the root directory of this source tree. An additional grant
 of patent rights can be found in the PATENTS file in the same directory.
 */

#import "GroupMessageViewController.h"
#import "ClassManagementViewController.h"
#import "FileCache.h"
#import "GroupOutbox.h"
#import "AudioDownloader.h"
#import "DraftDB.h"
#import "IMessage.h"
#import "GroupMessageDB.h"
#import "DraftDB.h"
#import "UIImage+Resize.h"
#import "SDImageCache.h"
#import "IGroupMessageDB.h"
#import "SignPeople.h"

#define PAGE_COUNT 10

@interface GroupMessageViewController ()

@end

@implementation GroupMessageViewController

- (void)viewDidLoad {
    IGroupMessageDB *db = [[IGroupMessageDB alloc] init];
    db.groupID = self.groupID;
    db.currentUID = self.currentUID;
    self.messageDB = db;
    
    [super viewDidLoad];
    
    [self setNavigationTitle];
    
    
    self.tableView.frame = CGRectMake(0, 64, APPLICATION_WIDTH, APPLICATION_HEIGHT-64- [EaseChatToolbar defaultHeight]);
//    self.navigationItem.title = [UIUtils getGroupName:str1];
}

-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = YES; //设置隐藏
}
-(void)viewWillDisappear:(BOOL)animated{
    self.navigationController.navigationBarHidden = NO; //设置隐藏
    
}
-(void)setNavigationTitle{
    //    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    UIView * navigationBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, APPLICATION_WIDTH, 64)];
    
    navigationBar.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:navigationBar];
    
    NSMutableString * str1 = [NSMutableString stringWithFormat:@"%@",self.groupName];
    
    [str1 deleteCharactersInRange:NSMakeRange(0, 6)];
    
    UILabel * titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(APPLICATION_WIDTH/2-40, 25, 80, 20)];
    titleLabel.text = [UIUtils getGroupName:str1];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.font = [UIFont systemFontOfSize:18];
    [self.view addSubview:titleLabel];
    
    UILabel * titleLabelId = [[UILabel alloc] initWithFrame:CGRectMake(APPLICATION_WIDTH/2-40, 45, 80, 20)];
    titleLabelId.text = [NSString stringWithFormat:@"邀请码：%lld",self.groupID];
    titleLabelId.textAlignment = NSTextAlignmentCenter;
    titleLabelId.textColor = [UIColor blackColor];
    titleLabelId.font = [UIFont systemFontOfSize:11];
    [self.view addSubview:titleLabelId];
    
    
    UIImageView * b = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ic_arrow_left"]];
    b.frame = CGRectMake(3, 30, 25, 20);
    [self.view addSubview:b];
    
    UIButton * backBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    backBtn.frame = CGRectMake(13,18, 60, 44);
    [backBtn setTitle:@"返回" forState:UIControlStateNormal];
    [backBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    backBtn.titleLabel.font = [UIFont systemFontOfSize:17];//[UIFont fontWithName:@"Helvetica-Bold" size:17];
    
    backBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:backBtn];
    [backBtn addTarget:self action:@selector(onBack) forControlEvents:UIControlEventTouchUpInside];
  
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
    UIImageView * image = [[UIImageView alloc] initWithFrame:CGRectMake(APPLICATION_WIDTH-30,34, 20, 20)];
    image.image = [UIImage imageNamed:@"群组成员"];
    [self.view addSubview:image];
    
    UIButton * createBtn = [UIButton buttonWithType:UIButtonTypeCustom];

    createBtn.frame = CGRectMake(APPLICATION_WIDTH-100,18, 100, 44);

//    [createBtn setTitle:@"加入群组" forState:UIControlStateNormal];
//    [createBtn setImage:[UIImage imageNamed:@"群组成员"] forState:UIControlStateNormal];
    
    [createBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];

    createBtn.titleLabel.font = [UIFont systemFontOfSize:17];//[UIFont fontWithName:@"Helvetica-Bold" size:17];

    createBtn.titleLabel.textAlignment = NSTextAlignmentRight;

    [self.view addSubview:createBtn];

    [createBtn addTarget:self action:@selector(queryGroupPeople) forControlEvents:UIControlEventTouchUpInside];
    
    
    
}
-(void)queryGroupPeople{
    [self getDataWithGruop:[NSString stringWithFormat:@"%lld",self.groupID]];
}

-(void)getDataWithGruop:(NSString *)groupId{
    NSDictionary * dict = [[NSDictionary alloc] initWithObjectsAndKeys:groupId,@"groupId", nil];
    [[NetworkRequest sharedInstance] GET:GroupPeople dict:dict succeed:^(id data) {
        NSString * str = [[data objectForKey:@"header"] objectForKey:@"code"];
        if ([str isEqualToString:@"0000"]) {
            NSArray * ary = [data objectForKey:@"body"];
            NSMutableArray * signAry = [NSMutableArray arrayWithCapacity:1];
            for (int i = 0; i<ary.count; i++) {
                SignPeople * s = [[SignPeople alloc] init];
                [s setInfoWithDict:ary[i]];
                [signAry addObject:s];
            }
            ClassManagementViewController * classManegeVC = [[ClassManagementViewController alloc] init];
            self.hidesBottomBarWhenPushed = YES;
            classManegeVC.manage = ClassManageType;
            classManegeVC.signAry = [NSMutableArray arrayWithCapacity:1];
            classManegeVC.signAry = signAry;
            classManegeVC.groupId = [NSString stringWithFormat:@"%lld",self.groupID];
            [self.navigationController pushViewController:classManegeVC animated:YES];
        }else{
            [UIUtils showInfoMessage:@"获取数据失败" withVC:self];
        }
    } failure:^(NSError *error) {
        [UIUtils showInfoMessage:@"获取数据失败，请检查网络" withVC:self];
    }];
}
-(void)addObserver {
    [super addObserver];
    [[GroupOutbox instance] addBoxObserver:self];
    [[IMService instance] addConnectionObserver:self];
    [[IMService instance] addGroupMessageObserver:self];
}

-(void)removeObserver {
    [super removeObserver];
    [[GroupOutbox instance] removeBoxObserver:self];
    [[IMService instance] removeGroupMessageObserver:self];
    [[IMService instance] removeConnectionObserver:self];
}

-(void)onBack {
    [super onBack];
    NSNotification* notification = [[NSNotification alloc] initWithName:CLEAR_GROUP_NEW_MESSAGE
                                                                 object:[NSNumber numberWithLongLong:self.groupID]
                                                               userInfo:nil];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
    [self.navigationController popViewControllerAnimated:YES];
}

//同IM服务器连接的状态变更通知
-(void)onConnectState:(int)state{
    if(state == STATE_CONNECTED){
        [self enableSend];
    } else {
        [self disableSend];
    }
}



#pragma mark - MessageObserver
-(void)onGroupMessage:(IMMessage*)im {
    if (im.receiver != self.groupID) {
        return;
    }
    
    IMessage *m = [[IMessage alloc] init];
    m.sender = im.sender;
    m.receiver = im.receiver;
    m.msgLocalID = im.msgLocalID;
    m.rawContent = im.content;
    m.timestamp = im.timestamp;
    m.isOutgoing = (im.sender == self.currentUID);
    if (im.sender == self.currentUID) {
        m.flags = m.flags | MESSAGE_FLAG_ACK;
    }
    if (m.uuid.length > 0 && [self getMessageWithUUID:m.uuid]) {
        NSLog(@"receive repeat group msg:%@", m.uuid);
        return;
    }
    
    NSLog(@"receive group msg");
    int now = (int)time(NULL);
    if (now - self.lastReceivedTimestamp > 1) {
        [[self class] playMessageReceivedSound];
        self.lastReceivedTimestamp = now;
    }
    
    [self downloadMessageContent:m];
    [self loadSenderInfo:m];
    [self insertMessage:m];
}

-(void)onGroupMessageACK:(int)msgLocalID gid:(int64_t)gid {
    if (gid != self.groupID) {
        return;
    }
    IMessage *msg = [self getMessageWithID:msgLocalID];
    msg.flags = msg.flags|MESSAGE_FLAG_ACK;
}

-(void)onGroupMessageFailure:(int)msgLocalID gid:(int64_t)gid {
    if (gid != self.groupID) {
        return;
    }
    IMessage *msg = [self getMessageWithID:msgLocalID];
    msg.flags = msg.flags|MESSAGE_FLAG_FAILURE;
}


-(void)onGroupNotification:(NSString *)text {
    MessageGroupNotificationContent *notification = [[MessageGroupNotificationContent alloc] initWithNotification:text];
    int64_t groupID = notification.groupID;
    if (groupID != self.groupID) {
        return;
    }
    
    IMessage *msg = [[IMessage alloc] init];
    msg.sender = 0;
    msg.receiver = groupID;
    if (notification.timestamp > 0) {
        msg.timestamp = notification.timestamp;
    } else {
        msg.timestamp = (int)time(NULL);
    }
    msg.rawContent = notification.raw;
    
    [self updateNotificationDesc:msg];
    
    [self insertMessage:msg];
}


- (void)sendMessage:(IMessage*)message {
    if (message.type == MESSAGE_AUDIO) {
        message.uploading = YES;
        [[GroupOutbox instance] uploadAudio:message];
    } else if (message.type == MESSAGE_IMAGE) {
        message.uploading = YES;
        [[GroupOutbox instance] uploadImage:message];
    } else {
        IMMessage *im = [[IMMessage alloc] init];
        im.sender = message.sender;
        im.receiver = message.receiver;
        im.msgLocalID = message.msgLocalID;
        im.content = message.rawContent;
        [[IMService instance] sendGroupMessage:im];
    }
    
    NSNotification* notification = [[NSNotification alloc] initWithName:LATEST_GROUP_MESSAGE
                                                                 object:message userInfo:nil];
    
    [[NSNotificationCenter defaultCenter] postNotification:notification];
}

- (void)sendMessage:(IMessage *)msg withImage:(UIImage*)image {
    msg.uploading = YES;
    [[GroupOutbox instance] uploadImage:msg withImage:image];
    
    NSNotification* notification = [[NSNotification alloc] initWithName:LATEST_GROUP_MESSAGE
                                                                 object:msg userInfo:nil];
    
    [[NSNotificationCenter defaultCenter] postNotification:notification];
}


@end
