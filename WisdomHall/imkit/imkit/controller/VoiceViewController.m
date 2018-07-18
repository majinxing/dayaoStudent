//
//  VoiceViewController.m
//  WisdomHall
//
//  Created by XTU-TI on 2018/7/17.
//  Copyright © 2018年 majinxing. All rights reserved.
//

#import "VoiceViewController.h"
#import "FileCache.h"
#import "AudioDownloader.h"
#import "DraftDB.h"
#import "IMessage.h"
#import "PeerMessageDB.h"
#import "DraftDB.h"
#import "PeerOutbox.h"
#import "UIImage+Resize.h"
#import "SDImageCache.h"
#import "IPeerMessageDB.h"

#import "NSDate+Format.h"

#import "EaseRecordView.h"

@interface VoiceViewController ()
@property(strong, nonatomic) EaseRecordView *recordView;
@end

@implementation VoiceViewController

- (void)dealloc {
    NSLog(@"peermessageviewcontroller dealloc");
}

- (void)viewDidLoad {
    IPeerMessageDB *db = [[IPeerMessageDB alloc] init];
    db.currentUID = self.currentUID;
    db.peerUID = self.peerUID;
    self.messageDB = db;
    
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    if (self.peerName.length > 0) {
        self.navigationItem.title = self.peerName;
    } else {
        IUser *u = [self getUser:self.peerUID];
        if (u.name.length > 0) {
            self.navigationItem.title = u.name;
        } else {
            self.navigationItem.title = u.identifier;
            [self asyncGetUser:self.peerUID cb:^(IUser *u) {
                if (u.name.length > 0) {
                    self.navigationItem.title = u.name;
                }
            }];
        }
    }
//    _recordView = [[EaseRecordView alloc] initWithFrame:CGRectMake(90, 130, 140, 140)];
    
    UIButton * btn = self.chatToolbar.recordButton;//[UIButton buttonWithType:UIButtonTypeCustom];
    btn.hidden = NO;
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setTitle:@"按住抢答" forState:UIControlStateNormal];
    [btn setTitle:@"上滑取消" forState:UIControlStateHighlighted];
    btn.frame = CGRectMake(0, APPLICATION_HEIGHT-45, APPLICATION_WIDTH, 45);
    [btn setBackgroundImage:[UIImage imageNamed:@"Rectangle3"] forState:UIControlStateNormal];
    [self.view addSubview:btn];
//    [btn addTarget:self action:@selector(recordButtonTouchDown) forControlEvents:UIControlEventTouchDown];
//    [btn addTarget:self action:@selector(recordButtonTouchUpOutside) forControlEvents:UIControlEventTouchUpOutside];
//    [btn addTarget:self action:@selector(recordButtonTouchUpInside) forControlEvents:UIControlEventTouchUpInside];
//    [btn addTarget:self action:@selector(recordDragOutside) forControlEvents:UIControlEventTouchDragExit];
//    [btn addTarget:self action:@selector(recordDragInside) forControlEvents:UIControlEventTouchDragEnter];
}
//- (void)recordButtonTouchDown
//{
//
//}
//
//- (void)recordButtonTouchUpOutside
//{
//
//}
//
//- (void)recordButtonTouchUpInside
//{
//
//}
//
//- (void)recordDragOutside
//{
//
//}
//- (void)recordDragInside
//{
//
//}
-(void)initTableViewData {
    NSMutableArray *newMessages = [NSMutableArray array];
    NSDate *lastDate = nil;
    
    NSInteger count = [self.messages count];
    if (count == 0) {
        return;
    }
    
    for (NSInteger i = 0; i < count; i++) {
        IMessage *msg = [self.messages objectAtIndex:i];
        if (msg.type == MESSAGE_TIME_BASE) {
            continue;
        }
        
        if (lastDate == nil || msg.timestamp - lastDate.timeIntervalSince1970 > 1*60) {
            MessageTimeBaseContent *tb = [[MessageTimeBaseContent alloc] initWithTimestamp:msg.timestamp];
            
            tb.notificationDesc = [[NSDate dateWithTimeIntervalSince1970:tb.timestamp] formatSectionTime];
            
            IMessage *m = [[IMessage alloc] init];
            
            m.content = tb;
            //剔除其他数据保留语音
            if (msg.type == MESSAGE_AUDIO) {
                [newMessages addObject:m];
                
                lastDate = [NSDate dateWithTimeIntervalSince1970:msg.timestamp];
            }
            
        }
        if (msg.type == MESSAGE_AUDIO) {
            [newMessages addObject:msg];
        }
    }
    
    self.messages = newMessages;
}
-(void)addObserver {
    [super addObserver];
    [[PeerOutbox instance] addBoxObserver:self];
    [[IMService instance] addConnectionObserver:self];
    [[IMService instance] addPeerMessageObserver:self];
}

-(void)removeObserver {
    [super removeObserver];
    [[PeerOutbox instance] removeBoxObserver:self];
    [[IMService instance] removeConnectionObserver:self];
    [[IMService instance] removePeerMessageObserver:self];
}

-(void)onBack {
    [super onBack];
    NSNotification* notification = [[NSNotification alloc] initWithName:CLEAR_PEER_NEW_MESSAGE
                                                                 object:[NSNumber numberWithLongLong:self.peerUID]
                                                               userInfo:nil];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
}

#pragma mark - MessageObserver
- (void)onPeerMessage:(IMMessage*)im {
    if (im.sender != self.peerUID && im.receiver != self.peerUID) {
        return;
    }
    NSLog(@"receive msg:%@",im);
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
    //判断消息是否重复
    if (m.uuid.length > 0 && [self getMessageWithUUID:m.uuid]) {
        return;
    }
    
    int now = (int)time(NULL);
    if (now - self.lastReceivedTimestamp > 1) {
        [[self class] playMessageReceivedSound];
        self.lastReceivedTimestamp = now;
    }
    
    [self loadSenderInfo:m];
    [self downloadMessageContent:m];
    
    [self insertMessage:m];
}

//服务器ack
- (void)onPeerMessageACK:(int)msgLocalID uid:(int64_t)uid {
    if (uid != self.peerUID) {
        return;
    }
    IMessage *msg = [self getMessageWithID:msgLocalID];
    msg.flags = msg.flags|MESSAGE_FLAG_ACK;
}

- (void)onPeerMessageFailure:(int)msgLocalID uid:(int64_t)uid {
    if (uid != self.peerUID) {
        return;
    }
    IMessage *msg = [self getMessageWithID:msgLocalID];
    msg.flags = msg.flags|MESSAGE_FLAG_FAILURE;
}


//同IM服务器连接的状态变更通知
-(void)onConnectState:(int)state{
    if(state == STATE_CONNECTED){
        [self enableSend];
    } else {
        [self disableSend];
    }
}


- (void)sendMessage:(IMessage *)msg withImage:(UIImage*)image {
    msg.uploading = YES;
    [[PeerOutbox instance] uploadImage:msg withImage:image];
    NSNotification* notification = [[NSNotification alloc] initWithName:LATEST_PEER_MESSAGE object:msg userInfo:nil];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
}

- (void)sendMessage:(IMessage*)message {
    if (message.type == MESSAGE_AUDIO) {
        message.uploading = YES;
        [[PeerOutbox instance] uploadAudio:message];
    } else if (message.type == MESSAGE_IMAGE) {
        message.uploading = YES;
        [[PeerOutbox instance] uploadImage:message];
    } else {
        IMMessage *im = [[IMMessage alloc] init];
        im.sender = message.sender;
        im.receiver = message.receiver;
        im.msgLocalID = message.msgLocalID;
        im.content = message.rawContent;
        [[IMService instance] sendPeerMessage:im];
    }
    
    NSNotification* notification = [[NSNotification alloc] initWithName:LATEST_PEER_MESSAGE object:message userInfo:nil];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
