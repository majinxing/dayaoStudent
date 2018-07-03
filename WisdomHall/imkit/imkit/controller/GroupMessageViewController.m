/*                                                                            
  Copyright (c) 2014-2015, GoBelieve     
    All rights reserved.		    				     			
 
  This source code is licensed under the BSD-style license found in the
  LICENSE file in the root directory of this source tree. An additional grant
  of patent rights can be found in the PATENTS file in the same directory.
*/

#import "GroupMessageViewController.h"

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
    
    self.navigationItem.title = self.groupName;
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
