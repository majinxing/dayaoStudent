//
//  VoiceViewController.h
//  WisdomHall
//
//  Created by XTU-TI on 2018/7/17.
//  Copyright © 2018年 majinxing. All rights reserved.
//

#import "MessageViewController.h"
#import "TextMessageViewController.h"

//最近发出的消息
#define LATEST_PEER_MESSAGE        @"latest_peer_message"

//清空会话的未读消息数
#define CLEAR_PEER_NEW_MESSAGE @"clear_peer_single_conv_new_message_notify"

@interface VoiceViewController : MessageViewController<PeerMessageObserver, TCPConnectionObserver>
+(VoiceViewController *)sharedInstance;
@property(nonatomic, assign) int64_t peerUID;
@property(nonatomic, copy) NSString *peerName;
@property(nonatomic, copy) NSString *peerAvatar;
@property(nonatomic, copy) NSString *backType;
@property(nonatomic, copy) NSString *type;
@end
