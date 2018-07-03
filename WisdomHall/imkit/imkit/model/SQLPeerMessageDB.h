/*
 Copyright (c) 2014-2015, GoBelieve
 All rights reserved.
 
 This source code is licensed under the BSD-style license found in the
 LICENSE file in the root directory of this source tree. An additional grant
 of patent rights can be found in the PATENTS file in the same directory.
 */

#import <Foundation/Foundation.h>
#import "IMessage.h"
#import "MessageDB.h"
#import "ConversationIterator.h"
#import "IMessageIterator.h"
#import "FMDB.h"
//#import <FMDB/FMDB.h>

@interface SQLPeerMessageDB : NSObject

+(SQLPeerMessageDB*)instance;

@property(nonatomic, strong) FMDatabase *db;

-(id<IMessageIterator>)newMessageIterator:(int64_t)uid;
//下拉刷新
-(id<IMessageIterator>)newMessageIterator:(int64_t)uid last:(int)lastMsgID;

-(id<IMessageIterator>)newMiddleMessageIterator:(int64_t)uid messageID:(int)messageID;

//上拉刷新
-(id<IMessageIterator>)newBackwardMessageIterator:(int64_t)uid messageID:(int)messageID;
-(id<ConversationIterator>)newConversationIterator;

-(IMessage*)getMessage:(int64_t)msgID;
-(BOOL)insertMessage:(IMessage*)msg uid:(int64_t)uid;
-(BOOL)removeMessage:(int)msgLocalID uid:(int64_t)uid;
-(BOOL)clearConversation:(int64_t)uid;
-(BOOL)clear;
-(NSArray*)search:(NSString*)key;
-(BOOL)updateMessageContent:(int)msgLocalID content:(NSString*)content;
-(BOOL)acknowledgeMessage:(int)msgLocalID uid:(int64_t)uid;
-(BOOL)markMessageFailure:(int)msgLocalID uid:(int64_t)uid;
-(BOOL)markMesageListened:(int)msgLocalID uid:(int64_t)uid;
-(BOOL)eraseMessageFailure:(int)msgLocalID uid:(int64_t)uid;
@end
