//
//  ChatHelper.h
//  WisdomHall
//
//  Created by XTU-TI on 2017/5/18.
//  Copyright © 2017年 majinxing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Hyphenate/Hyphenate.h>

@interface ChatHelper : NSObject
@property (nonatomic,copy) NSString * outOrIn;
+ (instancetype)shareHelper;
-(EMMessage *)sendTextMessage:(NSString *)text withReceiver:(NSString *)receiver;//发送文字消息
-(EMMessage *)sendTextMessageToPeople:(NSString *)text withReceiver:(NSString *)receiver;//对单个人发送消息
-(float)returnMessageInfoHeight:(EMMessage *)message;//提前计算信息高度
-(void)getOut;
@end
